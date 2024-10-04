page 52178714 "FIN-Posted Imprest Req. UP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "FIN-Imprest Header";
    SourceTableView = WHERE(Posted = filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = ShortcutDimension2CodeEditable;
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Editable = ShortcutDimension3CodeEditable;
                    ApplicationArea = All;
                }
                field(Dim3; Rec.Dim3)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Editable = ShortcutDimension4CodeEditable;
                    ApplicationArea = All;
                }
                field(Dim4; Rec.Dim4)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = "Account No.Editable";
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    Editable = PayeeEditable;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = "Currency CodeEditable";
                    ApplicationArea = All;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Requestor ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Posting Date';
                    Editable = "Payment Release DateEditable";
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    Editable = "Pay ModeEditable";
                    ApplicationArea = All;
                }
                field("Payment Voucher No"; Rec."Payment Voucher No")
                {
                    ApplicationArea = All;

                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
            }
            part(PVLines; "FIN-Imprest Details UP")
            {
                Editable = false;
                SubPageLink = No = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Payment")
            {
                Caption = 'Post Payment';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CheckImprestRequiredItems;
                    PostImprest;
                end;
            }
            separator(________________)
            {

            }
           
     
            /* action("Print/Preview")
            {
                ApplicationArea = All;
                Caption = 'Print/Preview';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // IF Status<>Status::Approved THEN
                    //    ERROR('You can only print after the document is released for approval');
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178702, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            } */

            // action("Print/Preview")
            // {
            //     Caption = 'Print/Preview';
            //     Visible = false;

            //     trigger OnAction()
            //     begin
            //         Rec.RESET;
            //         Rec.SETFILTER("No.", Rec."No.");
            //         REPORT.RUN(39005984, TRUE, TRUE, Rec);
            //         Rec.RESET;
            //     end;
            // }
            action("Print Accounting Request")
            {
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178739, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Account No.Editable" := TRUE;
        DateEditable := TRUE;
        ShortcutDimension4CodeEditable := TRUE;
        ShortcutDimension3CodeEditable := TRUE;
        PayeeEditable := TRUE;
        ShortcutDimension2CodeEditable := TRUE;
        GlobalDimension1CodeEditable := TRUE;
        "Currency CodeEditable" := TRUE;
        "Pay ModeEditable" := TRUE;
        "Payment Release DateEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Payment Type" := Rec."Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Customer;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //OnAfterGetCurrRecord;
    end;

    var
        PayLine: Record "FIN-Payment Line";
        PVUsers: Record "FIN-CshMgt PV Steps Users";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "FIN-Payments Header";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        TarriffCodes: Record "FIN-Tariff Codes";
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        CashierLinks: Record "FIN-Cash Office User Template";
        LineNo: Integer;
        Temp: Record "FIN-Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        //PCheck: Codeunit "50110";
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "FIN-Payments Header";
        BankAcc: Record "Bank Account";
        ApprovalMgt: Codeunit 439;
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record "FIN-Committment";
        UserMgt: Codeunit "User Setup Management";
        JournlPosted: Codeunit "Journal Post Successful";
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;

    //[Scope('Internal')]
    procedure LinesCommitmentStatus() Exists: Boolean
    begin
        Exists := FALSE;
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        PayLine.SETRANGE(PayLine.Committed, FALSE);
        PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
        IF PayLine.FIND('-') THEN
            Exists := TRUE;
    end;

    //[Scope('Internal')]
    procedure PostImprest()
    begin

        IF Temp.GET(USERID) THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DELETEALL;
        END;

        LineNo := LineNo + 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        Rec.CALCFIELDS("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.Description := 'Imprest: ' + Rec."Account No." + ':' + Rec.Payee;
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;


        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        Post := FALSE;
        Post := JournlPosted.PostedSuccessfully();
        IF Post THEN BEGIN
            Rec.Posted := TRUE;
            Rec."Date Posted" := TODAY;
            Rec."Time Posted" := TIME;
            Rec."Posted By" := USERID;
            Rec.Status := Rec.Status::Posted;
            Rec.MODIFY;
        END;
    end;

    //[Scope('Internal')]
    procedure CheckImprestRequiredItems()
    begin

        Rec.TESTFIELD("Payment Release Date");
        Rec.TESTFIELD("Paying Bank Account");
        Rec.TESTFIELD("Account No.");
        Rec.TESTFIELD("Account Type", Rec."Account Type"::Customer);

        IF Rec.Posted THEN BEGIN
            ERROR('The Document has already been posted');
        END;

        Rec.TESTFIELD(Status, Rec.Status::Approved);

        /*Check if the user has selected all the relevant fields*/

        Temp.GET(USERID);
        JTemplate := Temp."Imprest Template";
        JBatch := Temp."Imprest  Batch";

        IF JTemplate = '' THEN BEGIN
            ERROR('Ensure the Imprest Template is set up in Cash Office Setup');
        END;

        IF JBatch = '' THEN BEGIN
            ERROR('Ensure the Imprest Batch is set up in the Cash Office Setup')
        END;

    end;

    //[Scope('Internal')]
    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            "Pay ModeEditable" := FALSE;
            "Currency CodeEditable" := FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            "Payment Release DateEditable" := TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            "Pay ModeEditable" := TRUE;
            "Currency CodeEditable" := TRUE;
            // CurrPage.UpdateControls();
        END;

        IF Rec.Status = Rec.Status::Pending THEN BEGIN
            GlobalDimension1CodeEditable := TRUE;
            ShortcutDimension2CodeEditable := TRUE;
            PayeeEditable := TRUE;
            ShortcutDimension3CodeEditable := TRUE;
            ShortcutDimension4CodeEditable := TRUE;
            DateEditable := TRUE;
            "Account No.Editable" := TRUE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            GlobalDimension1CodeEditable := FALSE;
            ShortcutDimension2CodeEditable := FALSE;
            PayeeEditable := FALSE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            "Account No.Editable" := FALSE;
            //CurrPage.UpdateControls();
        END
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}
