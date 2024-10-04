page 52178746 "FIN-Receipts Line Posted UP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "FIN-Receipt Line q";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        RecPayTypes.RESET;
                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                        IF RecPayTypes.FIND('-') THEN BEGIN
                            IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                                "Account No.Editable" := FALSE;
                            END
                            ELSE BEGIN
                                "Account No.Editable" := TRUE;
                            END;
                        END;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = "Account No.Editable";
                    ApplicationArea = All;

                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Cheque/Deposit Slip Type"; Rec."Cheque/Deposit Slip Type")
                {
                    ApplicationArea = All;
                }
                field("Cheque/Deposit Slip Date"; Rec."Cheque/Deposit Slip Date")
                {
                    ApplicationArea = All;
                }
                field("Cheque/Deposit Slip No"; Rec."Cheque/Deposit Slip No")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount Exclusive VAT';
                    ApplicationArea = All;
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    DrillDown = true;
                    Lookup = true;
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        /*Check if the amount is greater than zero*/
                        IF Rec.Amount <= 0 THEN BEGIN
                            ERROR('Please ensure amount receipted is greater than zero');
                        END;
                        /*Apply the entries for the receipt*/
                        //JACK:ApplyEntry."Apply to Receipts"(Rec);
                        /*Check if the type of  the account is customer*/
                        IF (Rec."Account Type" = Rec."Account Type"::Customer) OR (Rec."Account Type" = Rec."Account Type"::Vendor) THEN BEGIN
                            Rec."Apply to ID" := Rec.No;
                        END;

                    end;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                
               
                
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Posted THEN
                        ERROR('The transaction has already been posted.');

                    IF Rec."Transaction Name" = '' THEN
                        ERROR('Please enter the transaction description under transaction name.');

                    IF Rec.Amount = 0 THEN
                        ERROR('Please enter amount.');

                    IF Rec.Amount < 0 THEN
                        ERROR('Amount cannot be less than zero.');

                    IF Rec."Global Dimension 1 Code" = '' THEN
                        ERROR('Please enter the Function code');

                    // IF Rec."Shortcut Dimension 2 Code" = '' THEN
                    //     ERROR('Please enter the source of funds.');

                    /*
                    CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
                    IF CashierLinks.FIND('-') THEN BEGIN
                    END
                    ELSE BEGIN
                    ERROR('Please link the user/cashier to a collection account before proceeding.');
                    END;
                    */

                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Rec.No);
                    GenJnlLine.DELETEALL;

                    IF DefaultBatch.GET('CASH RECEI', Rec.No) THEN
                        DefaultBatch.DELETE;

                    DefaultBatch.RESET;
                    DefaultBatch."Journal Template Name" := 'CASH RECEI';
                    DefaultBatch.Name := Rec.No;
                    DefaultBatch.INSERT;

                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10000;
                    GenJnlLine."Account Type" := Rec."Account Type";
                    GenJnlLine."Account No." := Rec."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := -Rec."Total Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);

                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := Rec."Apply to";
                    //GenJnlLine."Bal. Account No.":=CashierLinks."Bank Account No";
                    IF Rec."Bank Code" = '' THEN
                        ERROR('Select the Bank Code');


                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;


                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10001;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No." := Rec."Bank Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := Rec."Total Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);




                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Dest Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Dest Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;

                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Rec.No);
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Rec.No);
                    IF GenJnlLine.FIND('-') THEN
                        EXIT;

                    Rec.Posted := TRUE;
                    Rec."Date Posted" := TODAY;
                    Rec."Time Posted" := TIME;
                    Rec."Posted By" := USERID;
                    Rec.MODIFY;

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                
               
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Posted = FALSE THEN
                        ERROR('Post the receipt before printing.');
                    Rec.RESET;
                    Rec.SETFILTER(No, Rec.No);
                    REPORT.RUN(52015, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
            action("Direct Printing")
            {
                Caption = 'Direct Printing';
                
               
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Posted = FALSE THEN
                        ERROR('Post the receipt before printing.');
                    Rec.RESET;
                    Rec.SETFILTER(No, Rec.No);
                    REPORT.RUN(52015, FALSE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        {Display the captions for the dimensions that the user selected}
        DimName1:=DimName.getDimensionName("Global Dimension 1 Code",1);
        DImName2:=DimName.getDimensionName("Shortcut Dimension 2 Code",2);
        rdimname1:=DimName.getDimensionName("Dest Global Dimension 1 Code",1);
        rdimname2:=DimName.getDimensionName("Dest Shortcut Dimension 2 Code",2);
        */

    end;

    trigger OnInit()
    begin
        "Account No.Editable" := TRUE;
    end;

    var
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        //CashierLinks: Record "61720";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        DimName1: Text[100];
        rdimname1: Text[100];
        rdimname2: Text[100];
        DImName2: Text[100];
        // Custledger: Record "21";
        // CustLedger1: Record "21";
        // ApplyEntry: Codeunit "401";
        // CustEntries: Record "21";
        // AppliedEntries: Record "61728";
        LineNo: Integer;
        [InDataSet]
        "Account No.Editable": Boolean;
}