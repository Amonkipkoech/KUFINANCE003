page 52178731 "FIN-Posted Payment Header UP"
{
    Caption = 'Posted Payment Voucher';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "FIN-Payments Header";

    layout
    {
        area(content)
        {
            group(_____________________)
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
                field("Apply to Document Type"; Rec."Apply to Document Type")
                {
                    ApplicationArea = All;
                }
                field("Apply to Document No"; Rec."Apply to Document No")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = ShortcutDimension2CodeEditable;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    Editable = "Pay ModeEditable";
                    ApplicationArea = All;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = "Currency CodeEditable";
                    ApplicationArea = All;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    Editable = "Paying Bank AccountEditable";
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    Caption = 'Payment to';
                    Editable = PayeeEditable;
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    Editable = "Payment NarrationEditable";
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Imprest No."; Rec."Imprest No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Type"; Rec."Cheque Type")
                {
                    Editable = "Cheque TypeEditable";
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check" THEN
                            "Cheque No.Editable" := FALSE
                        ELSE
                            "Cheque No.Editable" := TRUE;
                    end;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    Editable = "Invoice Currency CodeEditable";
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                // field("Total Payment Amount"; Rec."Total Payment Amount")
                // {
                // }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Retention Amount"; Rec."Total Retention Amount")
                {
                    ApplicationArea = All;
                }
                field("Total PAYE Amount"; Rec."Total PAYE Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                // field("Total Payment Amount"-(Rec."Total Witholding Tax Amount" + Rec."Total Retention Amount" + Rec."Total PAYE Amount")+ Rec."Total Payment Amount" -(Rec."Total Witholding Tax Amount"+Rec."Total Retention Amount" + Rec."Total PAYE Amount"))
                // {
                //     Caption = 'Total Net Amount';
                // }
                // field("Total Payment Amount"-(Rec."Total Witholding Tax Amount" + Rec."Total Retention Amount" + Rec."Total PAYE Amount")+ Rec."Total Payment Amount"-(Rec."Total Witholding Tax Amount"+Rec."Total Retention Amount" + Rec."Total PAYE Amount"))
                // {
                //     Caption = 'Total Net Amount LCY';
                //     Editable = false;
                // }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    Editable = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //check if the cheque has been inserted
                        Rec.TESTFIELD("Paying Bank Account");
                        /*
                        PVHead.RESET;
                        PVHead.SETRANGE(PVHead."Paying Bank Account","Paying Bank Account");
                        PVHead.SETRANGE(PVHead."Pay Mode",PVHead."Pay Mode"::Cheque);
                        IF PVHead.FINDFIRST THEN
                          BEGIN
                            REPEAT
                              IF PVHead."Cheque No."="Cheque No." THEN
                                BEGIN
                                  IF PVHead."No."<>"No." THEN
                                    BEGIN
                                      ERROR('The Cheque Number has already been utilised');
                                    END;
                                END;
                            UNTIL PVHead.NEXT=0;
                          END;
                         */

                    end;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Editable = "Payment Release DateEditable";
                    ApplicationArea = All;
                }
                field("Cheque Printed"; Rec."Cheque Printed")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Financial Period"; Rec."Financial Period")
                {
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Expenditure"; Rec."Actual Expenditure")
                {
                    ApplicationArea = All;
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = All;
                }
                field("Budget Balance"; Rec."Budget Balance")
                {
                    ApplicationArea = All;
                }
            }
            part(PVLines; "FIN-Payment Lines")
            {
                ApplicationArea = All;
                SubPageLink = No = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print/Preview';
                Image = ConfirmAndPrint;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // /* IF Status<>Status::Approved THEN
                    //     ERROR('You can only print a Payment Voucher after it is fully Approved');

                    //        */

                    // //IF Status=Status::Pending THEN
                    // //ERROR('You cannot Print until the document is released for approval');
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178740, TRUE, TRUE, Rec);
                    Rec.RESET;

                    CurrPage.UPDATE;
                    CurrPage.SAVERECORD;

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
        /*DateEditable := TRUE;
        PayeeEditable := TRUE;
        ShortcutDimension2CodeEditable := TRUE;
        "Payment NarrationEditable" := TRUE;
        GlobalDimension1CodeEditable := TRUE;
        "Cheque TypeEditable" := TRUE;
        "Pay ModeEditable" := TRUE;
        "Paying Bank AccountEditable" := TRUE;
        "Payment Release DateEditable" := TRUE;
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Payment Type" := Rec."Payment Type"::Normal;

        Rcpt.RESET;
        Rcpt.SETRANGE(Rcpt.Posted, FALSE);
        Rcpt.SETRANGE(Rcpt.Cashier, USERID);
        IF Rcpt.COUNT > 0 THEN BEGIN
            IF CONFIRM('There are still some unposted payments. Continue?', FALSE) = FALSE THEN BEGIN
                ERROR('There are still some unposted payments. Please utilise them first');
            END;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(USERID, 1);
        Rec.VALIDATE("Global Dimension 1 Code");
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(USERID, 2);
        Rec.VALIDATE("Shortcut Dimension 2 Code");
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(USERID, 3);
        Rec.VALIDATE("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(USERID, 4);
        Rec.VALIDATE("Shortcut Dimension 4 Code");
        Rec."Responsibility Center" := 'MAIN';
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;


        //UpdateControls;
    end;

    var
        Text001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: Label 'Do you want to Void Check No %1';
        Text002: Label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
        Rcpt: Record "FIN-Payments Header";
        PayLine: Record "FIN-Payment Line";
        PVUsers: Record "FIN-CshMgt PV Steps Users";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "FIN-Payments Header";
        //RecPayTypes: Record "61129";
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
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record "FIN-Cash Office User Template";
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        DocPrint: Codeunit 229;
        CheckLedger: Record 272;
        CheckManagement: Codeunit 367;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit 407;
        BankPayment: Record "FIN-Bank Payments";
        VBank: Record 288;
        ImprestHeader: Record "FIN-Imprest Header";
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
    //ApprovalEntries: Page "658";

    //[Scope('Internal')]
    procedure PostPaymentVoucher()
    begin

        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
        IF GenJnlLine.FIND('+') THEN BEGIN
            LineNo := GenJnlLine."Line No." + 1000;
        END
        ELSE BEGIN
            LineNo := 1000;
        END;
        GenJnlLine.DELETEALL;
        GenJnlLine.RESET;

        Payments.RESET;
        Payments.SETRANGE(Payments."No.", Rec."No.");
        IF Payments.FIND('-') THEN BEGIN
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No, Payments."No.");
            IF PayLine.FIND('-') THEN BEGIN
                REPEAT
                    PostHeader(Payments);
                UNTIL PayLine.NEXT = 0;
            END;

            //Post:=FALSE;
            //Post:=JournlPosted.PostedSuccessfully();
            //IF Post THEN  BEGIN
            Rec.Posted := TRUE;
            Rec.Status := Payments.Status::Posted;
            Rec."Posted By" := USERID;
            Rec."Date Posted" := TODAY;
            Rec."Time Posted" := TIME;
            Rec.MODIFY;

            //Post Reversal Entries for Commitments
            Doc_Type := Doc_Type::"Payment Voucher";
            CheckBudgetAvail.ReverseEntries(Doc_Type, Rec."No.");

            IF ImprestHeader.GET(Rec."Apply to Document No") THEN BEGIN
                ImprestHeader.Posted := TRUE;
                ImprestHeader."Date Posted" := TODAY;
                ImprestHeader."Time Posted" := TIME;
                ImprestHeader."Posted By" := USERID;
                ImprestHeader."Cheque No." := Rec."Cheque No.";
                ImprestHeader.MODIFY;
            END;
            IF PVHead.GET(Rec."Apply to Document No") THEN BEGIN
                PVHead.Posted := TRUE;
                PVHead."Date Posted" := TODAY;
                PVHead."Time Posted" := TIME;
                PVHead."Posted By" := USERID;
                PVHead.MODIFY;
            END;
        END;
        //END;
    end;

    //[Scope('Internal')]
    procedure PostHeader(var Payment: Record "FIN-Payments Header")
    begin

        //IF (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Check") THEN
        //  ERROR('Cheque type has to be specified');

        IF Payments."Pay Mode" = Payments."Pay Mode"::Cheque THEN BEGIN
            IF (Payments."Cheque No." = '') AND (Rec."Cheque Type" = Rec."Cheque Type"::"Manual Check") THEN BEGIN
                ERROR('Please ensure that the cheque number is inserted');
            END;
        END;

        IF Payments."Pay Mode" = Payments."Pay Mode"::EFT THEN BEGIN
            IF Payments."Cheque No." = '' THEN;
        END;

        IF Payments."Pay Mode" = Payments."Pay Mode"::"Letter of Credit" THEN BEGIN
            IF Payments."Cheque No." = '' THEN BEGIN
                ERROR('Please ensure that the Letter of Credit ref no. is entered.');
            END;
        END;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);

        IF GenJnlLine.FIND('+') THEN BEGIN
            LineNo := GenJnlLine."Line No." + 1000;
        END
        ELSE BEGIN
            LineNo := 1000;
        END;


        LineNo := LineNo + 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Payment."Payment Release Date";
        IF CustomerPayLinesExist THEN
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
        ELSE
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Payments."No.";
        GenJnlLine."External Document No." := Payments."Cheque No.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Payments."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");

        GenJnlLine."Currency Code" := Payments."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        Payments.CALCFIELDS(Payments."Total Net Amount");
        GenJnlLine.Amount := -(Payments."Total Net Amount");
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';

        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        GenJnlLine.Description := COPYSTR('Pay To:' + Payments.Payee, 1, 50);
        GenJnlLine.VALIDATE(GenJnlLine.Description);

        IF Rec."Pay Mode" <> Rec."Pay Mode"::Cheque THEN BEGIN
            GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "
        END ELSE BEGIN
            IF Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check" THEN
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check"
            ELSE
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" "

        END;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        //Post Other Payment Journal Entries
        PostPV(Payments);
    end;

    //[Scope('Internal')]
    procedure GetAppliedEntries(var LineNo: Integer) InvText: Text[100]
    var
        Appl: Record "FIN-CshMgt Application";
    begin

        InvText := '';
        Appl.RESET;
        Appl.SETRANGE(Appl."Document Type", Appl."Document Type"::PV);
        Appl.SETRANGE(Appl."Document No.", Rec."No.");
        Appl.SETRANGE(Appl."Line No.", LineNo);
        IF Appl.FINDFIRST THEN BEGIN
            REPEAT
                InvText := COPYSTR(InvText + ',' + Appl."Appl. Doc. No", 1, 50);
            UNTIL Appl.NEXT = 0;
        END;
    end;

    //[Scope('Internal')]
    procedure InsertApproval()
    var
        Appl: Record "FIN-CshMgt Approvals";
        LineNo: Integer;
    begin
        LineNo := 0;
        Appl.RESET;
        IF Appl.FINDLAST THEN BEGIN
            LineNo := Appl."Line No.";
        END;

        LineNo := LineNo + 1;

        Appl.RESET;
        Appl.INIT;
        Appl."Line No." := LineNo;
        Appl."Document Type" := Appl."Document Type"::PV;
        Appl."Document No." := Rec."No.";
        Appl."Document Date" := Rec.Date;
        Appl."Process Date" := TODAY;
        Appl."Process Time" := TIME;
        Appl."Process User ID" := USERID;
        Appl."Process Name" := Rec."Current Status";
        //Appl."Process Machine":=ENVIRON('COMPUTERNAME');
        Appl.INSERT;
    end;

    //[Scope('Internal')]
    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCSetup: Record "FIN-Budgetary Control Setup";
    begin
        IF BCSetup.GET() THEN BEGIN
            IF NOT BCSetup.Mandatory THEN BEGIN
                Exists := FALSE;
                EXIT;
            END;
        END ELSE BEGIN
            Exists := FALSE;
            EXIT;
        END;
        Exists := FALSE;
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        PayLine.SETRANGE(PayLine.Committed, FALSE);
        PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
        IF PayLine.FIND('-') THEN
            Exists := TRUE;
    end;

    //[Scope('Internal')]
    procedure CheckPVRequiredItems()
    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
        IF PayLine.FIND('-') THEN BEGIN
            PayLine.TESTFIELD(PayLine.Committed, TRUE);
        END;

        IF Rec.Posted THEN BEGIN
            ERROR('The Document has already been posted');
        END;

        Rec.TESTFIELD(Status, Rec.Status::Approved);
        Rec.TESTFIELD("Paying Bank Account");
        Rec.TESTFIELD("Pay Mode");
        Rec.TESTFIELD("Payment Release Date");
        //Confirm whether Bank Has the Cash
        IF Rec."Pay Mode" = Rec."Pay Mode"::Cash THEN
            // CheckBudgetAvail.CheckFundsAvailability(Rec);

            /*Check if the user has selected all the relevant fields*/
        Temp.RESET;
        IF Temp.GET(USERID) THEN BEGIN
            Temp.TESTFIELD(Temp."Payment Journal Template");
            Temp.TESTFIELD(Temp."Payment Journal Batch");
            JTemplate := Temp."Payment Journal Template";
            JBatch := Temp."Payment Journal Batch";
        END;
        IF JTemplate = '' THEN BEGIN
            ERROR('Ensure the PV Template is set up in cash office setup1 ');
            IF JBatch = '' THEN BEGIN
                ERROR('Ensure the Batch Template is set up in cash office setup1 ');
            END;
        END;

        IF (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) AND (Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check") THEN BEGIN
            IF NOT CONFIRM(Text002, FALSE) THEN
                ERROR('You have selected to Abort PV Posting');
        END;
        //Check whether there is any printed cheques and lines not posted
        CheckLedger.RESET;
        CheckLedger.SETRANGE(CheckLedger."Document No.", Rec."No.");
        CheckLedger.SETRANGE(CheckLedger."Entry Status", CheckLedger."Entry Status"::Printed);
        IF CheckLedger.FIND('-') THEN BEGIN
            //Ask whether to void the printed cheque
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.FINDFIRST;
            IF CONFIRM(Text000, FALSE, CheckLedger."Check No.") THEN
                CheckManagement.VoidCheck(GenJnlLine)
            ELSE
                ERROR(Text001, Rec."No.", CheckLedger."Check No.");
        END;

    end;

    //[Scope('Internal')]
    procedure PostPV(var Payment: Record "FIN-Payments Header")
    begin

        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Payments."No.");
        IF PayLine.FIND('-') THEN BEGIN

            REPEAT
                strText := GetAppliedEntries(PayLine."Line No.");
                Payment.TESTFIELD(Payment.Payee);
                PayLine.TESTFIELD(PayLine.Amount);
                PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                IF PayLine."Pay Mode" = PayLine."Pay Mode"::Cash THEN BEGIN
                    CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID, USERID);
                END;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document No." := PayLine.No;
                IF PayLine."Account Type" = PayLine."Account Type"::Customer THEN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                ELSE
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine.Description := COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee, 1, 50);
                //    GenJnlLine.Payee:=Payment.Payee;
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                IF PayLine."VAT Code" = '' THEN BEGIN
                    GenJnlLine.Amount := PayLine."Net Amount";
                END
                ELSE BEGIN
                    GenJnlLine.Amount := PayLine."Net Amount";
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";

                IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;

                //Post VAT to GL[VAT GL]
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code, PayLine."VAT Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."VAT Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"), 1, 50);
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;
                END;

                //POST W/TAX to Respective W/TAX GL Account
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code, PayLine."Withholding Tax Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."Withholding Tax Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := COPYSTR('W/Tax:' + FORMAT(PayLine."Account Name") + '::' + strText, 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                END;

                //Post PAYE to GL[PAYE GL] -----JOSEH
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code, PayLine."PAYE Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."PAYE Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := COPYSTR('PAYE:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"), 1, 50);
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;
                END;


                //Post VAT Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                IF PayLine."VAT Code" = '' THEN BEGIN
                    GenJnlLine.Amount := 0;
                END
                ELSE BEGIN
                    GenJnlLine.Amount := PayLine."VAT Amount";
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"), 1, 50);
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

                //Post W/TAX Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."Withholding Tax Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := COPYSTR('W/Tax:' + strText, 1, 50);
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

                //EFT
                IF Payments."Pay Mode" = Payments."Pay Mode"::EFT THEN BEGIN
                    IF PayLine."Account No." <> '' THEN BEGIN
                        BankPayment.RESET;
                        BankPayment.SETRANGE(BankPayment."Doc No", Rec."No.");
                        IF BankPayment.FIND('-') THEN BankPayment.DELETE;
                        PayLine.TESTFIELD(PayLine."Vendor Bank Account");
                        BankPayment.INIT;
                        BankPayment."Doc No" := Rec."No.";
                        BankPayment.Payee := PayLine."Account No.";
                        BankPayment.Amount := Rec."Total Payment Amount" - (Rec."Total Witholding Tax Amount" + Rec."Total Retention Amount" + Rec."Total VAT Amount");
                        BankPayment."Bank A/C No" := PayLine."Vendor Bank Account";
                        VBank.RESET;
                        VBank.SETRANGE(VBank."Vendor No.", PayLine."Account No.");
                        VBank.SETRANGE(VBank.Code, PayLine."Vendor Bank Account");
                        IF VBank.FIND('-') THEN BEGIN
                            VBank.TESTFIELD(VBank."Bank Branch No.");
                            VBank.TESTFIELD(VBank."Bank Account No.");
                            BankPayment."Bank A/C No" := FORMAT(VBank."Bank Account No.");
                            BankPayment."Bank Branch No" := FORMAT(VBank."Bank Branch No.");
                            BankPayment."Bank Code" := FORMAT(VBank.Code);
                            BankPayment."Bank A/C Name" := VBank.Name
                        END;
                        BankPayment.Date := TODAY;
                        BankPayment.INSERT;
                    END;
                END;

                //Post PAYE Balancing Entry Goes to Vendor(Lecturer)----JLL
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."PAYE Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := COPYSTR('PAYE:' + strText, 1, 50);
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;


            UNTIL PayLine.NEXT = 0;

            COMMIT;
            //Post the Journal Lines
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.RUN(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances


            //Before posting if paymode is cheque print the cheque
            IF (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) AND (Rec."Cheque Type" = Rec."Cheque Type"::"Computer Check") THEN BEGIN
                DocPrint.PrintCheck(GenJnlLine);
                CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance", GenJnlLine);
                //Confirm Cheque printed //Not necessary.
            END;

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            Post := FALSE;
            Post := JournlPosted.PostedSuccessfully();
            IF Post THEN BEGIN
                IF PayLine.FINDFIRST THEN BEGIN
                    REPEAT
                        PayLine."Date Posted" := TODAY;
                        PayLine."Time Posted" := TIME;
                        PayLine."Posted By" := USERID;
                        PayLine.Status := PayLine.Status::Posted;
                        PayLine.MODIFY;
                    UNTIL PayLine.NEXT = 0;
                END;
            END;

        END;
        /*
        IF PayLine."Document Type"=PayLine."Document Type"::Imprest
        THEN BEGIN
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.",PayLine."Document No");
        IF ImprestHeader.FIND('-') THEN BEGIN
        ImprestHeader."Payment Voucher No":=PayLine.No;
        ImprestHeader.Posted:=TRUE;
        ImprestHeader."Date Posted":=TODAY;
        ImprestHeader."Time Posted":=TIME;
        ImprestHeader."Posted By":=USERID;
        ImprestHeader.MODIFY;
        END;
        END;
        
        IF PayLine."Document Type"=PayLine."Document Type"::Claim
        THEN BEGIN
        Payments.RESET;
        Payments.SETRANGE(Payments."No.",PayLine."Document No");
        IF Payments.FIND('-') THEN BEGIN
        Payments.Posted:=TRUE;
        Payments."Date Posted":=TODAY;
        Payments."Time Posted":=TIME;
        Payments."Posted By":=USERID;
        Payments.MODIFY;
        END;
        END;
         */

    end;

    //[Scope('Internal')]
    procedure UpdateControls()
    begin
        /*IF Status<>Status::Approved THEN BEGIN
          "Payment Release DateEditable" :=FALSE;
          "Paying Bank AccountEditable" :=FALSE;
          "Pay ModeEditable" :=FALSE;
          "Currency CodeEditable" :=TRUE;
          "Cheque No.Editable" :=FALSE;
          "Cheque TypeEditable" :=FALSE;
          "Invoice Currency CodeEditable" :=TRUE;
        //  CurrForm.UPDATECONTROLS();
          END ELSE BEGIN
          "Payment Release DateEditable" :=TRUE;
          "Paying Bank AccountEditable" :=TRUE;
          "Pay ModeEditable" :=TRUE;
          IF "Pay Mode"="Pay Mode"::Cheque THEN
            "Cheque TypeEditable" :=TRUE;
          //CurrForm."Currency Code".EDITABLE:=FALSE;
          IF "Cheque Type"<>"Cheque Type"::"Computer Check" THEN
              "Cheque No.Editable" :=TRUE;
          "Invoice Currency CodeEditable" :=FALSE;
         // CurrForm.UPDATECONTROLS();
          END;

          IF Status=Status::Pending THEN BEGIN
          "Currency CodeEditable" :=TRUE;
          GlobalDimension1CodeEditable :=TRUE;
          "Payment NarrationEditable" :=TRUE;
          ShortcutDimension2CodeEditable :=TRUE;
          PayeeEditable :=TRUE;
         // CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         // CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
          DateEditable :=TRUE;
         // CurrForm."Serial No".EDITABLE:=TRUE;
         // CurrForm.UPDATECONTROLS();
          END ELSE BEGIN
          "Currency CodeEditable" :=FALSE;
          GlobalDimension1CodeEditable :=FALSE;
          "Payment NarrationEditable" :=FALSE;
          ShortcutDimension2CodeEditable :=TRUE;
          PayeeEditable :=TRUE;
         // CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         // CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
          DateEditable :=FALSE;
        //  CurrForm."Serial No".EDITABLE:=FALSE;
          //CurrForm.UPDATECONTROLS();
             END
            */

    end;

    //[Scope('Internal')]
    procedure LinesExists(): Boolean
    var
        PayLines: Record "FIN-Payment Line";
    begin
        HasLines := FALSE;
        PayLines.RESET;
        PayLines.SETRANGE(PayLines.No, Rec."No.");
        IF PayLines.FIND('-') THEN BEGIN
            HasLines := TRUE;
            EXIT(HasLines);
        END;
    end;

    //[Scope('Internal')]
    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "FIN-Payment Line";
    begin
        AllKeyFieldsEntered := TRUE;
        PayLines.RESET;
        PayLines.SETRANGE(PayLines.No, Rec."No.");
        IF PayLines.FIND('-') THEN BEGIN
            REPEAT
                IF (PayLines."Account No." = '') OR (PayLines.Amount <= 0) THEN
                    AllKeyFieldsEntered := FALSE;
            UNTIL PayLines.NEXT = 0;
            EXIT(AllKeyFieldsEntered);
        END;
    end;

    //[Scope('Internal')]
    procedure CustomerPayLinesExist(): Boolean
    var
        PayLine: Record "FIN-Payment Line";
    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        PayLine.SETRANGE(PayLine."Account Type", PayLine."Account Type"::Customer);
        EXIT(PayLine.FINDFIRST);
    end;

    //[Scope('Internal')]
    procedure PopulateCheckJournal(var Payment: Record "FIN-Payments Header")
    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        IF PayLine.FIND('-') THEN BEGIN

            REPEAT
                //  strText:=GetAppliedEntries(PayLine."Line No.");
                Payment.TESTFIELD(Payment.Payee);
                PayLine.TESTFIELD(PayLine.Amount);
                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                IF PayLine."Pay Mode" <> PayLine."Pay Mode"::Cheque THEN;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Payment Release Date";
                GenJnlLine."Document No." := PayLine.No;
                IF PayLine."Account Type" = PayLine."Account Type"::Customer THEN
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "
                ELSE
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Rec."Cheque No.";

                GenJnlLine."Currency Code" := Rec."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                IF PayLine."VAT Code" = '' THEN BEGIN
                    GenJnlLine.Amount := PayLine."Net Amount";
                END
                ELSE BEGIN
                    GenJnlLine.Amount := PayLine."Net Amount";
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";
                GenJnlLine.Description := Rec.Payee;
                ///GenJnlLine."Received By":=Payee;
                IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;


            UNTIL PayLine.NEXT = 0;

        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}