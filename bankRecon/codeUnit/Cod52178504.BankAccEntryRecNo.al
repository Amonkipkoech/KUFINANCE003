/// <summary>
/// Codeunit Bank Acc Entry Rec No (ID 52178504).
/// </summary>
codeunit 52178808 "Bank Acc Entry Rec No"
{
    Permissions = TableData "Bank Account Ledger Entry" = rm,
                  TableData "Check Ledger Entry" = rm;

    trigger OnRun()
    begin
    end;

    var
        CheckLedgEntry: Record "Check Ledger Entry";
        LineCount: Integer;
        LineNumber: Integer;
        AppliedAmount: Decimal;
        UninitializedLineCountTxt: Label 'Uninitialized line count.', Locked = true;
        UnexpectedLineNumberTxt: Label 'Unexpected line number.', Locked = true;
        CategoryTxt: Label 'Reconciliation', Locked = true;
        BankAccountLedgerEntryInvalidStateErr: Label 'Cannot apply the statement line to bank account ledger entry %1 because its statement status is %2. Choose another bank account ledger entry.', Comment = '%1 - Ledger entry number; %2 - Statement status, option caption';
        CheckLedgerEntryInvalidStateErr: Label 'Cannot apply the statement line to check ledger entry %1 because its statement status is %2. Choose another check ledger entry.', Comment = '%1 - Ledger entry number; %2 - Statement status, option caption';
        BankAccountLedgerEntryInvalidStateQst: Label 'No statement lines have been applied to bank account ledger entry %1, but its statement status is %2. Do you want to apply the statement line to it?', Comment = '%1 - Ledger entry number; %2 - Statement status, option caption';
        CheckLedgerEntryInvalidStateQst: Label 'No statement lines have been applied to check ledger entry %1, but its statement status is %2. Do you want to apply the statement line to it?', Comment = '%1 - Ledger entry number; %2 - Statement status, option caption';

    procedure ApplyEntries(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many","Many-to-One"): Boolean
    var
        BankAccRecMatchBuffer: Record "Bank Acc. Rec. Match Buffer";
        NextMatchID: Integer;
        RemainigAmount: Decimal;
    begin
        OnBeforeApplyEntries(BankAccReconLine, BankAccLedgEntry, Relation);

        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        BankAccReconLine.LockTable();
        BankAccReconLine.Find();

        case Relation of
            Relation::"One-to-One":
                begin
                    if BankAccReconLine."Applied Entries" > 0 then
                        exit(false);
                    if BankAccLedgEntry.IsApplied() then
                        exit(false);

                    BankAccReconLine.TestField(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
                    BankAccReconLine."Ready for Application" := true;
                    SetReconNo(BankAccLedgEntry, BankAccReconLine);
                    BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";
                    BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
                    BankAccReconLine.Validate("Statement Amount");
                    ModifyBankAccReconLine(BankAccReconLine);
                end;
            Relation::"One-to-Many":
                begin
                    if BankAccLedgEntry.IsApplied() then
                        exit(false);

                    BankAccReconLine.TestField(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
                    BankAccReconLine."Ready for Application" := true;
                    SetReconNo(BankAccLedgEntry, BankAccReconLine);
                    BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";
                    BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
                    BankAccReconLine.Validate("Statement Amount");
                    ModifyBankAccReconLine(BankAccReconLine);
                end;
            Relation::"Many-to-One":
                begin
                    if (BankAccReconLine."Applied Entries" > 0) then
                        exit(false); //Many-to-many is not supported

                    if LineCount = 0 then begin
                        Session.LogMessage('0000GQE', UninitializedLineCountTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', CategoryTxt);
                        exit(false);
                    end;

                    LineNumber += 1;
                    if LineNumber > LineCount then begin
                        Session.LogMessage('0000GQF', UnexpectedLineNumberTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', CategoryTxt);
                        exit(false);
                    end;

                    NextMatchID := GetNextMatchID(BankAccReconLine, BankAccLedgEntry);
                    BankAccRecMatchBuffer.Init();
                    BankAccRecMatchBuffer."Ledger Entry No." := BankAccLedgEntry."Entry No.";
                    BankAccRecMatchBuffer."Statement No." := BankAccReconLine."Statement No.";
                    BankAccRecMatchBuffer."Statement Line No." := BankAccReconLine."Statement Line No.";
                    BankAccRecMatchBuffer."Bank Account No." := BankAccReconLine."Bank Account No.";
                    BankAccRecMatchBuffer."Match ID" := NextMatchID;
                    BankAccRecMatchBuffer.Insert();

                    BankAccReconLine.TestField(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
                    BankAccReconLine."Ready for Application" := true;
                    if BankAccLedgEntry."Statement Line No." <> -1 then begin
                        SetReconNo(BankAccLedgEntry, BankAccReconLine);
                        BankAccLedgEntry."Statement Line No." := -1;
                        BankAccLedgEntry.Modify();
                    end;

                    if LineNumber < LineCount then begin
                        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
                        AppliedAmount += BankAccReconLine."Applied Amount";
                    end else begin
                        RemainigAmount := BankAccLedgEntry."Remaining Amount" - AppliedAmount;
                        BankAccReconLine."Applied Amount" := RemainigAmount;
                    end;

                    BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
                    BankAccReconLine.Validate("Statement Amount");
                    ModifyBankAccReconLine(BankAccReconLine);
                end;
        end;

        exit(true);
    end;

    procedure SetLineCount(NewLineCount: Integer)
    begin
        LineCount := NewLineCount;
    end;

    local procedure GetNextMatchID(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; BankAccLedgEntry: Record "Bank Account Ledger Entry"): Integer
    var
        BankAccRecMatchBuffer: Record "Bank Acc. Rec. Match Buffer";
    begin
        BankAccRecMatchBuffer.SetRange("Statement No.", BankAccReconLine."Statement No.");
        BankAccRecMatchBuffer.SetRange("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccRecMatchBuffer.SetRange("Ledger Entry No.", BankAccLedgEntry."Entry No.");
        if BankAccRecMatchBuffer.FindLast() then
            exit(BankAccRecMatchBuffer."Match ID");

        BankAccRecMatchBuffer.Reset();
        BankAccRecMatchBuffer.SetRange("Statement No.", BankAccReconLine."Statement No.");
        BankAccRecMatchBuffer.SetRange("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccRecMatchBuffer.SetCurrentKey("Match ID");
        BankAccRecMatchBuffer.Ascending(true);

        if BankAccRecMatchBuffer.FindLast() then
            exit(BankAccRecMatchBuffer."Match ID" + 1)
        else
            exit(1);
    end;

    local procedure RemoveManyToOneMatch(var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var
        BankAccRecMatchBuffer: Record "Bank Acc. Rec. Match Buffer";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccRecMatchBuffer.SetRange("Ledger Entry No.", BankAccLedgEntry."Entry No.");
        if BankAccRecMatchBuffer.FindSet() then
            repeat
                BankAccReconLine.SetRange("Statement Line No.", BankAccRecMatchBuffer."Statement Line No.");
                BankAccReconLine.SetRange("Statement No.", BankAccRecMatchBuffer."Statement No.");
                BankAccReconLine.SetRange("Bank Account No.", BankAccRecMatchBuffer."Bank Account No.");
                if BankAccReconLine.FindFirst() then
                    RemoveReconNo(BankAccLedgEntry, BankAccReconLine, false);

                BankAccReconLine."Applied Amount" := 0;
                BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
                BankAccReconLine.Validate("Statement Amount");
                ModifyBankAccReconLine(BankAccReconLine);
                DeletePaymentMatchDetails(BankAccReconLine);

            until BankAccRecMatchBuffer.Next() = 0;

        BankAccRecMatchBuffer.DeleteAll();
    end;

    procedure RemoveApplication(var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        OnBeforeRemoveApplication(BankAccLedgEntry);

        RemoveManyToOneMatch(BankAccLedgEntry);

        BankAccLedgEntry.LockTable();
        CheckLedgEntry.LockTable();
        BankAccReconLine.LockTable();

        if BankAccReconLine.Get(
             BankAccReconLine."Statement Type"::"Bank Reconciliation",
             BankAccLedgEntry."Bank Account No.",
             BankAccLedgEntry."Statement No.", BankAccLedgEntry."Statement Line No.")
        then begin
            BankAccReconLine.TestField("Statement Type", BankAccReconLine."Statement Type"::"Bank Reconciliation");
            BankAccReconLine.TestField(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
            RemoveReconNo(BankAccLedgEntry, BankAccReconLine, true);

            BankAccReconLine."Applied Amount" -= BankAccLedgEntry."Remaining Amount";
            BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
            BankAccReconLine.Validate("Statement Amount");
            ModifyBankAccReconLine(BankAccReconLine);
            DeletePaymentMatchDetails(BankAccReconLine);
        end;
    end;

    local procedure DeletePaymentMatchDetails(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        PaymentMatchingDetails: Record "Payment Matching Details";
    begin
        PaymentMatchingDetails.SetRange("Statement Type", BankAccReconciliationLine."Statement Type");
        PaymentMatchingDetails.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
        PaymentMatchingDetails.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
        PaymentMatchingDetails.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
        PaymentMatchingDetails.DeleteAll(true);
    end;

    local procedure ModifyBankAccReconLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        OnBeforeModifyBankAccReconLine(BankAccReconciliationLine);
        BankAccReconciliationLine.Modify();
    end;

    procedure SetReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccLedgEntry.TestField(Open, true);
        BankAccLedgEntry.TestField("Statement No.", '');
        BankAccLedgEntry.TestField("Statement Line No.", 0);
        BankAccLedgEntry.TestField("Bank Account No.", BankAccReconLine."Bank Account No.");
        if BankAccLedgEntry."Statement Status" = BankAccLedgEntry."Statement Status"::Closed then
            Error(BankAccountLedgerEntryInvalidStateErr, BankAccLedgEntry."Entry No.", Format(BankAccLedgEntry."Statement Status"));
        // this confirm is introduced because there can be ledger entries whose statement status is corrupt because of a bug with undo bank account statement
        if BankAccLedgEntry."Statement Status" <> BankAccLedgEntry."Statement Status"::Open then begin
            if not GuiAllowed then
                Error(BankAccountLedgerEntryInvalidStateErr, BankAccLedgEntry."Entry No.", Format(BankAccLedgEntry."Statement Status"));
            if not Confirm(StrSubstNo(BankAccountLedgerEntryInvalidStateQst, BankAccLedgEntry."Entry No.", Format(BankAccLedgEntry."Statement Status"))) then
                Error('');
        end;
        BankAccLedgEntry."Statement Status" :=
          BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        BankAccLedgEntry.Modify();

        CheckLedgEntry.Reset();
        CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
        CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SetRange(Open, true);
        if CheckLedgEntry.Find('-') then
            repeat
                CheckLedgEntry.TestField("Statement No.", '');
                CheckLedgEntry.TestField("Statement Line No.", 0);
                if CheckLedgEntry."Statement Status" = CheckLedgEntry."Statement Status"::Closed then
                    Error(CheckLedgerEntryInvalidStateErr, CheckLedgEntry."Entry No.", Format(CheckLedgEntry."Statement Status"));
                // this confirm is introduced because there can be ledger entries whose statement status is corrupt because of a bug with undo bank account statement
                if CheckLedgEntry."Statement Status" <> CheckLedgEntry."Statement Status"::Open then begin
                    if not GuiAllowed then
                        Error(CheckLedgerEntryInvalidStateErr, CheckLedgEntry."Entry No.", Format(CheckLedgEntry."Statement Status"));
                    if not Confirm(StrSubstNo(CheckLedgerEntryInvalidStateQst, CheckLedgEntry."Entry No.", Format(CheckLedgEntry."Statement Status"))) then
                        Error('');
                end;
                CheckLedgEntry."Statement Status" :=
                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.Modify();
            until CheckLedgEntry.Next() = 0;
    end;

    procedure RemoveReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; Test: Boolean)
    begin
        BankAccLedgEntry.TestField(Open, true);
        if Test then begin
            BankAccLedgEntry.TestField(
            "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
            BankAccLedgEntry.TestField("Statement No.", BankAccReconLine."Statement No.");
            BankAccLedgEntry.TestField("Statement Line No.", BankAccReconLine."Statement Line No.");
        end;
        BankAccLedgEntry.TestField("Bank Account No.", BankAccReconLine."Bank Account No.");

        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
        BankAccLedgEntry."Statement No." := '';
        BankAccLedgEntry."Statement Line No." := 0;
        BankAccLedgEntry.Modify();

        CheckLedgEntry.Reset();
        CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
        CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SetRange(Open, true);
        if CheckLedgEntry.Find('-') then
            repeat
                if Test then begin
                    CheckLedgEntry.TestField(
                      "Statement Status", CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                    CheckLedgEntry.TestField("Statement No.", '');
                    CheckLedgEntry.TestField("Statement Line No.", 0);
                end;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Open;
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.Modify();
            until CheckLedgEntry.Next() = 0;
    end;


    procedure ApplyEntries2(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many"): Boolean
    begin

        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;
        BankAccReconLine.FIND;

        //IF BankAccLedgEntry.IsApplied THEN
        //  EXIT(FALSE);

        IF (Relation = Relation::"One-to-One") AND (BankAccReconLine."Applied Entries" > 0) THEN
            EXIT(FALSE);

        BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        BankAccReconLine."Ready for Application" := TRUE;
        IF (BankAccReconLine.Difference < 0) AND (BankAccLedgEntry."Statement Difference" < 0) THEN BEGIN
            IF BankAccReconLine.Difference > BankAccLedgEntry."Statement Difference" THEN
                BankAccReconLine."Applied Amount" += BankAccReconLine.Difference
            //BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
            ELSE
                BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference";
        END
        ELSE
            IF (BankAccReconLine.Difference < 0) AND (BankAccLedgEntry."Statement Difference" > 0) THEN BEGIN
                IF -(BankAccReconLine.Difference) > BankAccLedgEntry."Statement Difference" THEN
                    BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
                ELSE
                    IF -(BankAccReconLine.Difference) < BankAccLedgEntry."Statement Difference" THEN
                        BankAccReconLine."Applied Amount" += BankAccReconLine.Difference
                    //BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
                    ELSE
                        IF -(BankAccReconLine.Difference) = BankAccLedgEntry."Statement Difference" THEN
                            BankAccReconLine."Applied Amount" -= BankAccReconLine.Difference;
                //BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
            END
            ELSE
                IF (BankAccReconLine.Difference > 0) AND (BankAccLedgEntry."Statement Difference" < 0) THEN BEGIN
                    IF BankAccReconLine.Difference < -(BankAccLedgEntry."Statement Difference") THEN
                        BankAccReconLine."Applied Amount" += BankAccReconLine.Difference
                    //BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
                    ELSE
                        IF BankAccReconLine.Difference > -(BankAccLedgEntry."Statement Difference") THEN
                            BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
                        ELSE
                            IF BankAccReconLine.Difference = -(BankAccLedgEntry."Statement Difference") THEN
                                BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference";
                END
                ELSE
                    IF (BankAccReconLine.Difference > 0) AND (BankAccLedgEntry."Statement Difference" > 0) THEN BEGIN
                        IF BankAccReconLine.Difference < BankAccLedgEntry."Statement Difference" THEN
                            BankAccReconLine."Applied Amount" += BankAccReconLine.Difference
                        //BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference"
                        ELSE
                            BankAccReconLine."Applied Amount" += BankAccLedgEntry."Statement Difference";
                    END;

        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        SetReconNo2(BankAccLedgEntry, BankAccReconLine);
        BankAccReconLine.VALIDATE("Statement Amount");
        BankAccReconLine.Reconciled := TRUE;
        BankAccReconLine.MODIFY;
        /*
        AppliedStatementEntry.INIT;
        AppliedStatementEntry."Entry No." := 0;
        AppliedStatementEntry."Bank Account No." := BankAccReconLine."Bank Account No.";
        AppliedStatementEntry."Statement No." := BankAccReconLine."Statement No.";
        AppliedStatementEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        AppliedStatementEntry."Ledger Entry No." := BankAccLedgEntry."Entry No.";
        AppliedStatementEntry.Amount := BankAccReconLine."Applied Amount";
        AppliedStatementEntry.INSERT(TRUE);
        */
        EXIT(TRUE);

    end;


    /// <summary>
    /// SetReconNo2.
    /// </summary>
    /// <param name="BankAccLedgEntry">VAR Record "Bank Account Ledger Entry".</param>
    /// <param name="BankAccReconLine">VAR Record "Bank Acc. Reconciliation Line".</param>
    procedure SetReconNo2(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    var
        AppliedStatementEntry: Record "Applied Bank Account Ledger2";
    begin
        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        //BankAccLedgEntry.TESTFIELD("Statement Status",BankAccLedgEntry."Statement Status"::Open);
        //BankAccLedgEntry.TESTFIELD("Statement No.",'');
        //BankAccLedgEntry.TESTFIELD("Statement Line No.",0);
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" :=
          BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        IF (BankAccLedgEntry."Amount Applied" < 0) AND (BankAccReconLine.Difference < 0) THEN BEGIN
            IF BankAccLedgEntry."Amount Applied" >= BankAccReconLine.Difference THEN
                BankAccLedgEntry."Amount Applied" -= BankAccLedgEntry."Amount Applied"
            ELSE
                BankAccLedgEntry."Amount Applied" -= BankAccReconLine.Difference;
            //BankAccLedgEntry."Statement Difference" -= BankAccLedgEntry."Statement Difference"
        END
        ELSE
            IF (BankAccLedgEntry."Amount Applied" > 0) AND (BankAccReconLine.Difference > 0) THEN BEGIN
                IF BankAccLedgEntry."Amount Applied" <= BankAccReconLine.Difference THEN
                    BankAccLedgEntry."Amount Applied" -= BankAccLedgEntry."Amount Applied"
                ELSE
                    BankAccLedgEntry."Amount Applied" -= BankAccReconLine.Difference;
                //BankAccLedgEntry."Statement Difference" -= BankAccLedgEntry."Statement Difference"
            END
            ELSE
                IF (BankAccLedgEntry."Amount Applied" > 0) AND (BankAccReconLine.Difference < 0) THEN BEGIN
                    IF BankAccLedgEntry."Amount Applied" > -(BankAccReconLine.Difference) THEN
                        BankAccLedgEntry."Amount Applied" -= BankAccReconLine.Difference
                    //BankAccLedgEntry."Statement Difference" -= BankAccLedgEntry."Statement Difference"
                    ELSE
                        BankAccLedgEntry."Amount Applied" -= BankAccLedgEntry."Amount Applied";
                END
                ELSE
                    IF (BankAccLedgEntry."Amount Applied" < 0) AND (BankAccReconLine.Difference > 0) THEN BEGIN
                        IF -(BankAccLedgEntry."Amount Applied") > BankAccReconLine.Difference THEN
                            BankAccLedgEntry."Amount Applied" -= BankAccReconLine.Difference
                        //BankAccLedgEntry."Statement Difference" -= BankAccLedgEntry."Statement Difference"
                        ELSE
                            IF -(BankAccLedgEntry."Amount Applied") < BankAccReconLine.Difference THEN
                                BankAccLedgEntry."Amount Applied" -= BankAccLedgEntry."Amount Applied"
                            ELSE
                                IF -(BankAccLedgEntry."Amount Applied") = BankAccReconLine.Difference THEN
                                    BankAccLedgEntry."Amount Applied" -= BankAccLedgEntry."Amount Applied";
                    END;

        BankAccLedgEntry.MODIFY;


        AppliedStatementEntry.INIT;
        AppliedStatementEntry."Entry No." := 0;
        AppliedStatementEntry."Bank Account No." := BankAccReconLine."Bank Account No.";
        AppliedStatementEntry."Statement No." := BankAccReconLine."Statement No.";
        AppliedStatementEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        AppliedStatementEntry."Ledger Entry No." := BankAccLedgEntry."Entry No.";
        AppliedStatementEntry.Amount := BankAccReconLine."Applied Amount";
        AppliedStatementEntry.INSERT(TRUE);
        ;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                CheckLedgEntry.TESTFIELD("Statement Status", CheckLedgEntry."Statement Status"::Open);
                CheckLedgEntry.TESTFIELD("Statement No.", '');
                CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                CheckLedgEntry."Statement Status" :=
                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    end;





    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyEntries(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var Relation: Option "One-to-One","One-to-Many")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyBankAccReconLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRemoveApplication(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
    end;
}
