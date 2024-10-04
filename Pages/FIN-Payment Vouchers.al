page 52178723 "FIN-Payment Vouchers"
{
    CardPageID = "FIN-Payment Header";
    Editable = false;
    PageType = List;
    SourceTable = "FIN-Payments Header";
    SourceTableView = WHERE(Posted = filter(false),
                            "Payment Type" = CONST(Normal),
                            Status = FILTER(Pending | Open | 'Pending Approval' | Released | Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = All;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Cancellation Remarks"; Rec."Cancellation Remarks")
                {
                    ApplicationArea = All;
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
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


            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Approvalentries: Page "Approval Entries";
                begin
                    Approvalentries.Setfilters(DATABASE::"FIN-Payments Header", 6, Rec."No.");
                    Approvalentries.RUN;
                end;
            }

            separator(__________)
            {

            }

            separator(_______________________)
            {

            }
            action(Print)
            {
                Caption = 'Print/Preview';
                Image = ConfirmAndPrint;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /* IF Status<>Status::Approved THEN
                        ERROR('You can only print a Payment Voucher after it is fully Approved');

                           */

                    //IF Status=Status::Pending THEN
                    //ERROR('You cannot Print until the document is released for approval');
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178892, TRUE, TRUE, Rec);
                    Rec.RESET;

                    CurrPage.UPDATE;
                    CurrPage.SAVERECORD;

                end;
            }
            // action(Bank_Letter)
            // {
            //     Caption = 'Bank Letter';

            //     trigger OnAction()
            //     var
            //         FilterbyPayline: Record "61497";
            //     begin
            //         /*IF Status=Status::Pending THEN
            //            ERROR('You cannot Print until the document is released for approval');
            //         FilterbyPayline.RESET;
            //         FilterbyPayline.SETFILTER(FilterbyPayline.No,"No.");
            //         //REPORT.RUN(39006007,TRUE,TRUE,FilterbyPayline);
            //         RESET;*/

            //     end;
            // }
            separator(______________________________)
            {

            }


        }
    }

    var
        GLEntry: Record 17;
        //rcpt: Record "FIN-Payments Header";
        PayLine: Record "FIN-Payment Line";
        //PVUsers: Record "61711";
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
        Commitments: Record "FIN-Committment";
        UserMgt: Codeunit "User Setup Management";
        JournlPosted: Codeunit "Journal Post Successful";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        DocPrint: Codeunit 229;
        CheckLedger: Record 272;
        CheckManagement: Codeunit 367;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit 407;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
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
        PVLinesEditable: Boolean;
        PayingBankAccountEditable: Boolean;
        //ImprestHeader: Record "61704";
        PaymodeEditable: Boolean;
        //PurchInvHeader: Record "122";
        //ApprovalEntries: Page "658";
        Text001: Label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: Label 'Do you want to Void Check No %1';
        Text002: Label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        FINPaymentLine: Record "FIN-Payment Line";

    //[Scope('Internal')]
    procedure PostPaymentVoucher(rec: Record "FIN-Payments Header")
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

            Post := FALSE;
            Post := JournlPosted.PostedSuccessfully();
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", Rec."No.");
            IF GLEntry.FIND('-') THEN
                Post := TRUE ELSE
                Post := FALSE;
            IF Post = TRUE THEN BEGIN
                Rec.Posted := TRUE;
                Rec.Status := Payments.Status::Posted;
                Rec."Posted By" := USERID;
                Rec."Date Posted" := TODAY;
                Rec."Time Posted" := TIME;
                Rec.MODIFY;

                //Post Reversal Entries for Commitments
                Doc_Type := Doc_Type::"Payment Voucher";
                CheckBudgetAvail.ReverseEntries(Doc_Type, Rec."No.");
            END;
        END;
    end;

    //[Scope('Internal')]
    procedure PostHeader(var Payment: Record "FIN-Payments Header")
    begin

        IF (Payments."Pay Mode" = Payments."Pay Mode"::Cheque) AND (Rec."Cheque Type" = Rec."Cheque Type"::" ") THEN
            ERROR('Cheque type has to be specified');

        IF Payments."Pay Mode" = Payments."Pay Mode"::Cheque THEN BEGIN
            IF (Payments."Cheque No." = '') AND (Rec."Cheque Type" = Rec."Cheque Type"::"Manual Check") THEN BEGIN
                ERROR('Please ensure that the cheque number is inserted');
            END;
        END;

        IF Payments."Pay Mode" = Payments."Pay Mode"::EFT THEN BEGIN
            IF Payments."Cheque No." = '' THEN BEGIN
                ERROR('Please ensure that the EFT number is inserted');
            END;
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
        /*IF CustomerPayLinesExist THEN
         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        ELSE
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment; */
        GenJnlLine."Document No." := Payments."No.";
        GenJnlLine."External Document No." := Payments."Cheque No.";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Payments."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");

        GenJnlLine."Currency Code" := Payments."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        //CurrFactor
        GenJnlLine."Currency Factor" := Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");

        Payments.CALCFIELDS(Payments."Total Net Amount", Payments."Total VAT Amount");
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
    // procedure InsertApproval()
    // var
    //     Appl: Record "61729";
    //     LineNo: Integer;
    // begin
    //     LineNo := 0;
    //     Appl.RESET;
    //     IF Appl.FINDLAST THEN BEGIN
    //         LineNo := Appl."Line No.";
    //     END;

    //     LineNo := LineNo + 1;

    //     Appl.RESET;
    //     Appl.INIT;
    //     Appl."Line No." := LineNo;
    //     Appl."Document Type" := Appl."Document Type"::PV;
    //     Appl."Document No." := Rec."No.";
    //     Appl."Document Date" := Rec.Date;
    //     Appl."Process Date" := TODAY;
    //     Appl."Process Time" := TIME;
    //     Appl."Process User ID" := USERID;
    //     Appl."Process Name" := Rec."Current Status";
    //     //Appl."Process Machine":=ENVIRON('COMPUTERNAME');
    //     Appl.INSERT;
    // end;

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
    procedure CheckPVRequiredItems(rec: Record "FIN-Payments Header")
    begin
        IF Rec.Posted THEN BEGIN
            ERROR('The Document has already been posted');
        END;

        Rec.TESTFIELD(Rec.Status, Rec.Status::Approved);
        Rec.TESTFIELD(Rec."Paying Bank Account");
        Rec.TESTFIELD(Rec."Pay Mode");
        Rec.TESTFIELD(Rec."Payment Release Date");
        //Confirm whether Bank Has the Cash
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
         CheckBudgetAvail.CheckFundsAvailability(Rec);*/

        //Confirm Payment Release Date is today);
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
          TESTFIELD("Payment Release Date",WORKDATE);*/

        /*Check if the user has selected all the relevant fields*/
        Temp.GET(USERID);

        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        IF JTemplate = '' THEN BEGIN
            ERROR('Ensure the PV Template is set up in Cash Office Setup');
        END;
        IF JBatch = '' THEN BEGIN
            ERROR('Ensure the PV Batch is set up in the Cash Office Setup')
        END;
        IF (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) AND (Rec."Cheque No." = '') THEN
            ERROR('Kindly specify the Cheque No');
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
    var
        StaffClaim: Record "FIN-Staff Claims Header";
        PayReqHeader: Record "FIN-Payments Header";
        FINReceiptsandPaymentTypes: Record "FIN-Receipts and Payment Types";
        FINTariffCodes: Record "FIN-Tariff Codes";
    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Payments."No.");
        IF PayLine.FIND('-') THEN BEGIN

            REPEAT
                strText := GetAppliedEntries(PayLine."Line No.");
                Payment.TESTFIELD(Payment.Payee);
                PayLine.TESTFIELD(PayLine.Amount);
                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

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
                /*IF PayLine."Account Type"=PayLine."Account Type"::Customer THEN
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                ELSE
                  GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;*/
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine.Description := COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee, 1, 50);
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
                //JEFF
                IF PayLine."Account Type" = PayLine."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost"
                END;
                //JEFF

                IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;
                /*
                //Post VAT to GL[VAT GL]
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."VAT Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=Payment."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PayLine.No;
                GenJnlLine."External Document No.":=Payments."Cheque No.";
                GenJnlLine."Account Type":=TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No.":=TarriffCodes."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code":=Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

                GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group":='';
                GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount:=-PayLine."VAT Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No.":='';
                GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
                END;
                 */

                //Post VAT Withheld
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code, PayLine."VAT Withheld Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    //CurrFactor
                    GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    GenJnlLine.VALIDATE("Currency Factor");

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
                    GenJnlLine.Amount := -PayLine."VAT Withheld Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := COPYSTR('VAT Withheld:' + FORMAT(PayLine."Account Name") + '::' + strText, 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                END;

                //POST W/TAX to Respective W/TAX GL Account
                TarriffCodes.RESET;
                TarriffCodes.SETRANGE(TarriffCodes.Code, PayLine."Withholding Tax Code");
                IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Payment."Payment Release Date";
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Payments."Cheque No.";
                    GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    //CurrFactor
                    GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    GenJnlLine.VALIDATE("Currency Factor");

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

                //////////////////////////////////////////////////////////////////////////////////////
                //POST Retension to the Retension Account
                //Get Retension Code Here
                IF PayLine."Retention  Amount" <> 0 THEN BEGIN
                    FINReceiptsandPaymentTypes.RESET;
                    FINReceiptsandPaymentTypes.SETRANGE(Code, PayLine.Type);
                    IF FINReceiptsandPaymentTypes.FIND('-') THEN
                        FINReceiptsandPaymentTypes.TESTFIELD("Retention Code")
                    ELSE
                        ERROR('Retensions/Code Not Specified');
                    // get the retension Acount Here
                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(Code, FINReceiptsandPaymentTypes."Retention Code");
                    IF TarriffCodes.FIND('-') THEN
                        TarriffCodes.TESTFIELD("G/L Account")
                    ELSE
                        ERROR('Retension Code Not Defined');
                    // TarriffCodes.RESET;
                    // TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Withholding Tax Code");
                    IF TarriffCodes.FIND('-') THEN BEGIN
                        TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Payment."Payment Release Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := TarriffCodes."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");

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
                        GenJnlLine.Amount := -PayLine."Retention  Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine.Description := COPYSTR('Retension ' + FORMAT(PayLine."Account Name") + '::' + strText, 1, 50);
                        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        //Post Retension Balancing Account
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Payment."Payment Release Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := PayLine."Account Type";
                        GenJnlLine."Account No." := PayLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");

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
                        GenJnlLine.Amount := PayLine."Retention  Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := COPYSTR('Retension Balancing-' + Payments.Payee, 1, 50);
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

                    END;
                END;
                //////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////
                //POST PAYE to the PAYE Account
                //Get PAYE Code Here
                IF PayLine."PAYE Amount" <> 0 THEN BEGIN
                    FINReceiptsandPaymentTypes.RESET;
                    FINReceiptsandPaymentTypes.SETRANGE(Code, PayLine.Type);
                    IF FINReceiptsandPaymentTypes.FIND('-') THEN
                        FINReceiptsandPaymentTypes.TESTFIELD("PAYE Tax Code")
                    ELSE
                        ERROR('PAYE Code Not Specified');
                    // get the PAYE Acount Here
                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(Code, FINReceiptsandPaymentTypes."PAYE Tax Code");
                    IF TarriffCodes.FIND('-') THEN
                        TarriffCodes.TESTFIELD("G/L Account")
                    ELSE
                        ERROR('PAYE Code Not Defined');
                    IF TarriffCodes.FIND('-') THEN BEGIN
                        TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Payment."Payment Release Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := TarriffCodes."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");

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
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine.Description := COPYSTR('PAYE ' + FORMAT(PayLine."Account Name") + '::' + strText, 1, 50);
                        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        //Post PAYE Balancing Account
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Payment."Payment Release Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Payments."Cheque No.";
                        GenJnlLine."Account Type" := PayLine."Account Type";
                        GenJnlLine."Account No." := PayLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");

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
                        GenJnlLine.Description := COPYSTR('PAYE Balancing-' + Payments.Payee, 1, 50);
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

                    END;
                END;
                //////////////////////////////////////////////////////////////////////////////////////




                // // // // //    //POST P.A.Y.E to Respective P.A.Y.E GL Account
                // // // // //    TarriffCodes.RESET;
                // // // // //    TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."PAYE Code");
                // // // // //    IF TarriffCodes.FIND('-') THEN BEGIN
                // // // // //    TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
                // // // // //    LineNo:=LineNo+1000;
                // // // // //    GenJnlLine.INIT;
                // // // // //    GenJnlLine."Journal Template Name":=JTemplate;
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                // // // // //    GenJnlLine."Journal Batch Name":=JBatch;
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                // // // // //    GenJnlLine."Source Code":='PAYMENTJNL';
                // // // // //    GenJnlLine."Line No.":=LineNo;
                // // // // //    GenJnlLine."Posting Date":=Payment."Payment Release Date";
                // // // // //    GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
                // // // // //    GenJnlLine."Document No.":=PayLine.No;
                // // // // //    GenJnlLine."External Document No.":=Payments."Cheque No.";
                // // // // //    GenJnlLine."Account Type":=TarriffCodes."Account Type";//GenJnlLine."Account Type"::"G/L Account";
                // // // // //    GenJnlLine."Account No.":=TarriffCodes."Account No.";
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                // // // // //    GenJnlLine."Currency Code":=Payments."Currency Code";
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                // // // // //    //CurrFactor
                // // // // //    GenJnlLine."Currency Factor":=Payments."Currency Factor";
                // // // // //    GenJnlLine.VALIDATE("Currency Factor");
                // // // // //
                // // // // //    GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                // // // // //    GenJnlLine."Gen. Bus. Posting Group":='';
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                // // // // //    GenJnlLine."Gen. Prod. Posting Group":='';
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                // // // // //    GenJnlLine."VAT Bus. Posting Group":='';
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                // // // // //    GenJnlLine."VAT Prod. Posting Group":='';
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                // // // // //    GenJnlLine.Amount:=-PayLine."PAYE Amount";
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                // // // // //    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                // // // // //    GenJnlLine."Bal. Account No.":='';
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                // // // // //    GenJnlLine.Description:=COPYSTR('P.A.Y.E:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
                // // // // //    GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                // // // // //    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                // // // // //    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                // // // // //    GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                // // // // //    GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                // // // // //
                // // // // //    IF GenJnlLine.Amount<>0 THEN
                // // // // //    GenJnlLine.INSERT;
                // // // // //    END;

                /*
                //Post VAT Balancing Entry Goes to Vendor
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=Payment."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PayLine.No;
                GenJnlLine."External Document No.":=Payments."Cheque No.";
                GenJnlLine."Account Type":=PayLine."Account Type";
                GenJnlLine."Account No.":=PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code":=Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

                IF PayLine."VAT Code"='' THEN
                  BEGIN
                    GenJnlLine.Amount:=0;
                  END
                ELSE
                  BEGIN
                    GenJnlLine.Amount:=PayLine."VAT Amount";
                  END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No.":='';
                GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50) ;
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
                IF GenJnlLine.Amount<>0 THEN
                GenJnlLine.INSERT;
                 */
                //Post VAt WithHeld Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Payment."Payment Release Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

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
                GenJnlLine.Amount := PayLine."VAT Withheld Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := COPYSTR(Payments.Payee, 1, 50);
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
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Payments."Cheque No.";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");

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
                GenJnlLine.Description := COPYSTR('W/Tax Balancing-' + Payments.Payee, 1, 50);
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

    end;

    //[Scope('Internal')]
    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            PayingBankAccountEditable := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrForm."Pay Mode".EDITABLE:=FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Currency CodeEditable" := FALSE;
            "Cheque No.Editable" := FALSE;
            "Cheque TypeEditable" := FALSE;
            PaymodeEditable := FALSE;
            "Invoice Currency CodeEditable" := TRUE;
        END ELSE BEGIN
            "Payment Release DateEditable" := TRUE;
            PaymodeEditable := TRUE;
            PayingBankAccountEditable := TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrForm."Pay Mode".EDITABLE:=TRUE;
            IF Rec."Pay Mode" = Rec."Pay Mode"::Cheque THEN
                "Cheque TypeEditable" := TRUE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            IF Rec."Cheque Type" <> Rec."Cheque Type"::"Computer Check" THEN
                "Cheque No.Editable" := TRUE;
            "Invoice Currency CodeEditable" := FALSE;


        END;


        IF Rec.Status = Rec.Status::Pending THEN BEGIN
            "Currency CodeEditable" := FALSE;
            GlobalDimension1CodeEditable := TRUE;
            "Payment NarrationEditable" := TRUE;
            ShortcutDimension2CodeEditable := TRUE;
            PayeeEditable := TRUE;
            ShortcutDimension3CodeEditable := TRUE;
            ShortcutDimension4CodeEditable := TRUE;
            DateEditable := TRUE;
            PVLinesEditable := TRUE;


        END ELSE BEGIN
            "Currency CodeEditable" := FALSE;
            GlobalDimension1CodeEditable := FALSE;
            "Payment NarrationEditable" := FALSE;
            ShortcutDimension2CodeEditable := FALSE;
            PayeeEditable := FALSE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            PVLinesEditable := FALSE;



        END
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

    local procedure CommitBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."PV Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINPaymentLine.RESET;
        FINPaymentLine.SETRANGE(No, Rec."No.");
        FINPaymentLine.SETRANGE("Account Type", FINPaymentLine."Account Type"::"G/L Account");
        IF FINPaymentLine.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Check if budget exists
                FINPaymentLine.TESTFIELD("Account No.");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINPaymentLine."Account No.");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                FINBudgetEntries.RESET;
                FINBudgetEntries.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                FINBudgetEntries.SETRANGE("G/L Account No.", FINPaymentLine."Account No.");
                FINBudgetEntries.SETRANGE("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                /* FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense, FINBudgetEntries."Transaction Type"::Commitment
                , FINBudgetEntries."Transaction Type"::Allocation);
                FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2',
                FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::Commitment); */
                FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense,
                 FINBudgetEntries."Transaction Type"::Commitment, FINBudgetEntries."Transaction Type"::Allocation);
                FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2|%3', FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::"Commited/Posted",
               FINBudgetEntries."Commitment Status"::Commitment);

                FINBudgetEntries.SETFILTER(Date, PostBudgetEnties.GetBudgetStartAndEndDates(Rec.Date));
                IF FINBudgetEntries.FIND('-') THEN BEGIN
                    IF FINBudgetEntries.CALCSUMS(Amount) THEN BEGIN
                        IF FINBudgetEntries.Amount > 0 THEN BEGIN
                            IF (FINPaymentLine.Amount > FINBudgetEntries.Amount) THEN ERROR('Less Funds, Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                            // Commit Budget Here
                            PostBudgetEnties.CheckBudgetAvailability(FINPaymentLine."Account No.", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                            FINPaymentLine.Amount, FINPaymentLine."Account Name", 'PV', Rec."No." + FINPaymentLine."Account No.", Rec.Payee);
                        END ELSE
                            ERROR('No allocation for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                    END;
                END ELSE
                    IF PostBudgetEnties.checkBudgetControl(FINPaymentLine."Account No.") THEN ERROR('Missing Budget for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
            END;
            UNTIL FINPaymentLine.NEXT = 0;
        END;
    end;

    local procedure ExpenseBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."PV Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINPaymentLine.SETRANGE(No, Rec."No.");
        FINPaymentLine.SETRANGE("Account Type", FINPaymentLine."Account Type"::"G/L Account");
        IF FINPaymentLine.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINPaymentLine.TESTFIELD("Account No.");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINPaymentLine."Account No.");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINPaymentLine.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(FINPaymentLine."Account No.", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINPaymentLine.Amount, FINPaymentLine."Account Name", USERID, TODAY, 'PV', Rec."No." + FINPaymentLine."Account No.", Rec.Payee);
                END;
            END;
            UNTIL FINPaymentLine.NEXT = 0;
        END;
    end;

    local procedure CancelCommitment()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."PV Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINPaymentLine.SETRANGE(No, Rec."No.");
        FINPaymentLine.SETRANGE("Account Type", FINPaymentLine."Account Type"::"G/L Account");
        IF FINPaymentLine.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINPaymentLine.TESTFIELD("Account No.");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINPaymentLine."Account No.");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINPaymentLine.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.CancelBudgetCommitment(FINPaymentLine."Account No.", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINPaymentLine.Amount, FINPaymentLine."Account Name", USERID, 'PV', Rec."No." + FINPaymentLine."Account No.", Rec.Payee);
                END;
            END;
            UNTIL FINPaymentLine.NEXT = 0;
        END;
    end;
}
