page 52178719 "FIN-Posted Interbank Trans2"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "FIN-InterBank Transfers";
    SourceTableView = WHERE(Posted = filter(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                label(_____________)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19025618;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Receiving Transfer Type"; Rec."Receiving Transfer Type")
                {
                    ApplicationArea = All;
                }
                field("Reciept Responsibility Center"; Rec."Reciept Responsibility Center")
                {
                    ApplicationArea = All;
                }
                label(_________)
                {
                    CaptionClass = Text19044997;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Receipt Resp Centre"; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = All;

                }
                field("Receiving Account"; Rec."Receiving Account")
                {

                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        ReceivingAccountOnAfterValidat;
                    end;
                }
                field("Receiving Bank Account Name"; Rec."Receiving Bank Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code Destination"; Rec."Currency Code Destination")
                {
                    ApplicationArea = All;
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    ApplicationArea = All;
                }
                field("Request Amt LCY"; Rec."Request Amt LCY")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Source Transfer Type"; Rec."Source Transfer Type")
                {
                    ApplicationArea = All;
                }
                field("Sending Responsibility Center"; Rec."Sending Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Sending Resp Centre"; Rec."Sending Resp Centre")
                {
                    ApplicationArea = All;
                }
                field("Paying Account"; Rec."Paying Account")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        PayingAccountOnAfterValidate;
                    end;
                }
                field("Paying  Bank Account Name"; Rec."Paying  Bank Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code Source"; Rec."Currency Code Source")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Pay Amt LCY"; Rec."Pay Amt LCY")
                {
                    ApplicationArea = All;
                }
                field("Exch. Rate Destination"; Rec."Exch. Rate Destination")
                {
                    Visible = "Exch. Rate DestinationVisible";
                    ApplicationArea = All;
                }
                field("Exch. Rate Source"; Rec."Exch. Rate Source")
                {
                    Visible = "Exch. Rate SourceVisible";
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Post")
            {
                Caption = '&Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD(Status, Rec.Status::Approved);

                    //Check whether the two LCY amounts are same
                    IF Rec."Request Amt LCY" <> Rec."Pay Amt LCY" THEN
                        ERROR('The [Requested Amount in LCY] should be same as the [Paid Amount in LCY]');
                    //get the source account balance from the database table
                    BankAcc.RESET;
                    BankAcc.SETRANGE(BankAcc."No.", Rec."Paying Account");
                    BankAcc.SETRANGE(BankAcc."Bank Type", BankAcc."Bank Type"::Cash);

                    IF BankAcc.FINDFIRST THEN BEGIN
                        BankAcc.CALCFIELDS(BankAcc."Balance (LCY)");
                        Rec."Current Source A/C Bal." := BankAcc."Balance (LCY)";
                        IF (Rec."Current Source A/C Bal." - Rec.Amount) < 0 THEN BEGIN
                            ERROR('The transaction will result in a negative balance in a CASH ACCOUNT.');
                        END;
                    END;
                    IF Rec.Amount = 0 THEN BEGIN
                        ERROR('Please ensure Amount to Transfer is entered');
                    END;
                    /*Check if the user's batch has any records within it*/
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Rec."Inter Bank Template Name");
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Rec."Inter Bank Journal Batch");
                    GenJnlLine.DELETEALL;

                    LineNo := 1000;
                    /*Insert the new lines to be updated*/
                    GenJnlLine.INIT;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    IF Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Intra-Company" THEN BEGIN
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    END
                    ELSE
                        IF Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Inter-Company" THEN BEGIN
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                        END;
                    GenJnlLine."Account No." := Rec."Receiving Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No);
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Receiving Depot Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Receiving Department Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code1");
                    GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code1");

                    GenJnlLine.Description := Rec.Remarks;
                    IF Rec.Remarks = '' THEN BEGIN GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No); END;
                    GenJnlLine."Currency Code" := Rec."Currency Code Destination";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    IF Rec."Currency Code Destination" <> '' THEN BEGIN
                        GenJnlLine."Currency Factor" := Rec."Reciprical 2";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                    END;
                    GenJnlLine.Amount := Rec."Amount 2";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine.INSERT;


                    GenJnlLine.INIT;
                    /*Insert the lines*/
                    GenJnlLine."Line No." := LineNo + 1;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                    GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    IF Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Intra-Company" THEN BEGIN
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    END
                    ELSE
                        IF Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Inter-Company" THEN BEGIN
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                        END;


                    GenJnlLine."Account No." := Rec."Paying Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Source Depot Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Source Department Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                    GenJnlLine.Description := Rec.Remarks;
                    IF Rec.Remarks = '' THEN BEGIN GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No); END;
                    GenJnlLine."Currency Code" := Rec."Currency Code Source";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    IF Rec."Currency Code Source" <> '' THEN BEGIN
                        GenJnlLine."Currency Factor" := Rec."Reciprical 1";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                    END;
                    GenJnlLine.Amount := -Rec.Amount;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine.INSERT;
                    Post := FALSE;
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    Post := JournalPostedSuccessfully.PostedSuccessfully();

                    IF Post THEN BEGIN
                        Rec.Posted := TRUE;
                        Rec."Date Posted" := TODAY;
                        Rec."Time Posted" := TIME;
                        Rec."Posted By" := USERID;
                        Rec.MODIFY;
                        MESSAGE('The Journal Has Been Posted Successfully');
                    END;

                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        DocumentType: Option Interbank;
                    begin
                        DocumentType := DocumentType::Interbank;
                        // ApprovalEntries.Setfilters(DATABASE::"FIN-InterBank Transfers", DocumentType, Rec.No);
                        // ApprovalEntries.RUN;
                    end;
                }
                separator(_____________________)
                {

                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.RESET;
                        Rec.SETRANGE(No, Rec.No);
                        REPORT.RUN(51293, TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Date := TODAY;
        Rec."Inter Bank Template Name" := JTemplate;
        Rec."Inter Bank Journal Batch" := JBatch;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Reciept Responsibility Center" := UserMgt.GetPurchasesFilter();
        //VALIDATE( "Reciept Responsibility Center");
        Rec.Status := Rec.Status::Pending;
        Rec."Created By" := USERID;

        UpdateControl;
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Reciept Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;


        TempBatch.RESET;

        TempBatch.SETRANGE(TempBatch.UserID, USERID);
        IF TempBatch.FIND('-') THEN BEGIN
            JTemplate := TempBatch."Inter Bank Template Name";
            JBatch := TempBatch."Inter Bank Batch Name";
        END;

        /*Check if the user has the batches selected*/
        IF (JTemplate = '') OR (JBatch = '') THEN BEGIN
            ERROR('Please ensure you are setup as an interbank transfer user');
        END;

        /*
       IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
         FILTERGROUP(2);
         SETRANGE("Reciept Responsibility Center" ,UserMgt.GetPurchasesFilter());
         FILTERGROUP(0);
       END;
          //Reciept Responsibility Center
          */

    end;

    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        TempBatch: Record "FIN-Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        //PCheck: Codeunit "50110";
        Post: Boolean;
        BankAcc: Record "Bank Account";
        RegNo: Integer;
        FromNo: Integer;
        ToNo: Integer;
        //RegMgt: Codeunit "50103";
        JournalPostedSuccessfully: Codeunit "Journal Post Successful";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        [InDataSet]
        "Exch. Rate DestinationVisible": Boolean;
        [InDataSet]
        "Exch. Rate SourceVisible": Boolean;
        Text19025618: Label 'Requesting Details';
        Text19044997: Label 'Source Details';
    //ApprovalEntries: Page "658";

    //[Scope('Internal')]
    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record 98;
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name := '';

        GLSetup.RESET;
        GLSetup.GET();

        DimVal.RESET;
        DimVal.SETRANGE(DimVal.Code, Code);

        IF DimNo = 1 THEN BEGIN
            DimVal.SETRANGE(DimVal."Dimension Code", GLSetup."Global Dimension 1 Code");
        END
        ELSE
            IF DimNo = 2 THEN BEGIN
                DimVal.SETRANGE(DimVal."Dimension Code", GLSetup."Global Dimension 2 Code");
            END;
        IF DimVal.FIND('-') THEN BEGIN
            Name := DimVal.Name;
        END;

    end;

    //[Scope('Internal')]
    procedure UpdateControl()
    begin
    end;

    local procedure ReceivingAccountOnAfterValidat()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate DestinationVisible" := FALSE;
        IF Rec."Currency Code Destination" <> '' THEN BEGIN
            "Exch. Rate DestinationVisible" := TRUE;
        END;
    end;

    local procedure PayingAccountOnAfterValidate()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate SourceVisible" := FALSE;
        IF Rec."Currency Code Source" <> '' THEN BEGIN
            "Exch. Rate SourceVisible" := TRUE;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        IF Rec."Currency Code Source" <> '' THEN BEGIN
            "Exch. Rate SourceVisible" := TRUE;
        END
        ELSE BEGIN
            "Exch. Rate SourceVisible" := FALSE;
        END;

        IF Rec."Currency Code Destination" <> '' THEN BEGIN
            "Exch. Rate DestinationVisible" := TRUE;
        END
        ELSE BEGIN
            "Exch. Rate DestinationVisible" := FALSE;
        END;

        UpdateControl;
    end;
}