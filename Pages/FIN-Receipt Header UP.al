page 52178745 "FIN-Receipt Header UP"
{
    Caption = 'Receipt';
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/Preview';
    PageType = Card;
    SourceTable = "FIN-Receipts Header";
    SourceTableView = WHERE(Posted = filter(false));
    layout
    {
        area(content)
        {
            group(general)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Date';
                    Editable = true;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Deposit Date';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FunctionName := '';
                        DimVal.RESET;
                        DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
                        DimVal.SETRANGE(DimVal.Code, Rec."Global Dimension 1 Code");
                        IF DimVal.FIND('-') THEN BEGIN
                            FunctionName := DimVal.Name;
                        END;
                    end;
                }
                field(FunctionName; FunctionName)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        BudgetCenterName := '';
                        DimVal.RESET;
                        DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
                        DimVal.SETRANGE(DimVal.Code, Rec."Shortcut Dimension 2 Code");
                        IF DimVal.FIND('-') THEN BEGIN
                            BudgetCenterName := DimVal.Name;
                        END;
                    end;
                }
                field(BudgetCenterName; BudgetCenterName)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Enabled = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }

                field("Received From Account Type"; Rec."Received From Account Type")
                {

                    ApplicationArea = All;
                }
                field(Grouping; Rec.Grouping)
                {

                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = All;
                }


                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    Caption = 'Received from';
                    ApplicationArea = All;
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Student/staff No"; Rec."Student/staff No")
                {
                    // ApplicationArea = All;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Imprest No"; Rec."Imprest No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;

                }
                field("Transaction Type Code"; Rec."Transaction Type Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Type Code field.';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;

                    ApplicationArea = All;
                }
                field("Is Scholarship"; Rec."Is Scholarship")
                {
                    ApplicationArea = All;
                }
            }
            part(ReceiptLine; "FIN-Receipts Line UP")
            {
                ApplicationArea = All;
                SubPageLink = No = FIELD("No."), "Bank Account" = field("Bank Code");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Category5;
                Image = SendApprovalRequest;

                trigger OnAction()
                var
                    AppMangt: Codeunit "Approval Mgmnt. Ext";
                begin

                    AppMangt.OnSendReceiptsForApproval(Rec);
                end;

            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Category5;
                Image = SendApprovalRequest;

                trigger OnAction()
                var
                    AppMangt: Codeunit "Approval Mgmnt. Ext";
                begin
                    AppMangt.OnCancelReceiptForApproval(Rec);
                end;

            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print/Preview';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;
                Visible = true;

                trigger OnAction()
                begin

                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178734, TRUE, TRUE, Rec);
                    Rec.RESET;
                    //52178741
                end;
            }

            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Check Post Dated
                    IF CheckPostDated THEN
                        ERROR('One of the Receipt Lines is Post Dated');

                    //Post the transaction into the database
                    PerformPost();

                    Rec.Cashier := USERID;
                    //"Bank Code":=USetup."Default Receipts Bank";
                    Rec.Posted := TRUE;
                    Rec."Date Posted" := TODAY;
                    Rec."Time Posted" := TIME;
                    Rec."Posted By" := USERID;
                    Rec.MODIFY;

                    IF Rec.Posted = TRUE THEN BEGIN
                        Rcpt.RESET;
                        Rcpt.SETFILTER(Rcpt."No.", Rec."No.");
                        //REPORT.RUN(51537, FALSE, TRUE, Rcpt);

                    END;
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        // OnAfterGetCurrRecord;
        Rec."Total Amount" := HeaderUpdate.GetTotalAmount(Rec."No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //********************************JACK**********************************//
        Rcpt.RESET;
        Rcpt.SETRANGE(Rcpt.Posted, FALSE);
        Rcpt.SETRANGE(Rcpt."Created By", USERID);
        IF Rcpt.COUNT > 0 THEN BEGIN
            IF CONFIRM('There are still some unposted receipts. Continue?', FALSE) = FALSE THEN BEGIN
                ERROR('There are still some unposted receipts. Please utilise them first');
            END;
        END;
        //********************************END **********************************//
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter();
        Rec.VALIDATE("Shortcut Dimension 4 Code");
        Rec.Date := TODAY;
        //Rec."Global Dimension 1 Code" := 'MAIN';
        //Rec."Responsibility Center" := 'MAIN';
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin

        UserSetup.RESET;

        IF UserSetup.GET(USERID) THEN BEGIN
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";
        END;
        IF (JTemplate = '') OR (JBatch = '') THEN BEGIN
            ERROR('Please contact the system administrator to be setup as a receipting user');
        END;
        IF UserSetup."Default Receipts Bank" = '' THEN;
        Rec.SETFILTER(Status, ' ');

        //***************************JACK***************************//
        // SETRANGE("Created By",USERID);
        /*
       IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
         FILTERGROUP(2);
         SETRANGE("Responsibility Center",UserMgt.GetSalesFilter());
         FILTERGROUP(0);
       END;
        */
        //***************************END ***************************//

    end;

    var
        GenJnlLine: Record 81;
        ReceiptLine: Record "FIN-Receipt Line q";
        tAmount: Decimal;
        DefaultBatch: Record 232;
        HeaderUpdate: Codeunit "Header Management";
        FunctionName: Text[100];
        BudgetCenterName: Text[100];
        BankName: Text[100];
        Rcpt: Record "FIN-Receipts Header";
        RcptNo: Code[20];
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        UserSetup: Record "FIN-Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record 81;
        LineNo: Integer;
        BAmount: Decimal;
        SRSetup: Record 311;
        //PCheck: Codeunit "50110";
        Post: Boolean;
        USetup: Record "FIN-Cash Office User Template";
        //RegMgt: Codeunit "50103";
        RegisterNumber: Integer;
        FromNumber: Integer;
        ToNumber: Integer;
        StrInvoices: Text[250];
        Appl: Record "FIN-CshMgt Application";
        UserMgt: Codeunit "User Setup Management";
        JournalPosted: Codeunit "Journal Post Successful";
        AdjustGenJnl: Codeunit 407;
        IsCashAccount: Boolean;


    procedure PerformPost()
    begin
        //get all the invoices that have been paid for using the receipt
        StrInvoices := '';
        Appl.RESET;
        Appl.SETRANGE(Appl."Document Type", Appl."Document Type"::Receipt);
        Appl.SETRANGE(Appl."Document No.", Rec."No.");
        IF Appl.FINDFIRST THEN BEGIN
            REPEAT
                StrInvoices := StrInvoices + ',' + Appl."Appl. Doc. No";
            UNTIL Appl.NEXT = 0;
        END;

        //Cater for Cash Accounts
        IsCashAccount := FALSE;
        BankAcc.RESET;
        IF BankAcc.GET(Rec."Bank Code") THEN BEGIN
            IF BankAcc."Bank Type" = BankAcc."Bank Type"::Cash THEN
                IsCashAccount := TRUE;
        END;

        IF IsCashAccount THEN
            Rec.TESTFIELD(Date, WORKDATE);
        //End Cater for Cash Account


        USetup.RESET;
        USetup.SETRANGE(USetup.UserID, USERID);
        IF USetup.FINDFIRST THEN BEGIN
            IF USetup."Receipt Journal Template" = '' THEN BEGIN
                ERROR('Please ensure that the Administrator sets you up as a cashier');
            END;
            IF USetup."Receipt Journal Batch" = '' THEN BEGIN
                ERROR('Please ensure that the Administrator sets you up as a cashier');
            END;
            IF USetup."Default Receipts Bank" = '' THEN;
        END
        ELSE BEGIN
            ERROR('Please ensure that the Administrator sets you up as a cashier');
        END;


        //check if the receipt has any post dated cheques.
        //check if the amounts are similar

        Rec.CALCFIELDS("Total Amount");
        IF Rec."Total Amount" <> Rec."Amount Recieved" THEN BEGIN
            Message('Total amount ', Format(Rec."Total Amount"));
            Message('Amount Received ', Format(Rec."Amount Recieved"));
            ERROR('Please note that the Total Amount and the Amount Received Must be the same');
        END;

        //if any then the amount to be posted must be less the post dated amount
        IF Rec.Posted = TRUE THEN BEGIN
            ERROR('A Transaction Posted cannot be posted again');
        END;

        //check if the person received from has been selected
        Rec.TESTFIELD(Date);
        Rec.TESTFIELD("Bank Code");
        Rec.TESTFIELD("Global Dimension 1 Code");
        //Rec.TESTFIELD("Shortcut Dimension 2 Code");
        Rec.TESTFIELD("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount := 0;

        //Check Bank
        CheckBnkCurrency(Rec."Bank Code", Rec."Currency Code");

        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine.No, Rec."No.");
        IF ReceiptLine.FIND('-') THEN BEGIN
            REPEAT
                IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::" " THEN
                    IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::"Deposit Slip" THEN BEGIN
                        IF ReceiptLine."Cheque/Deposit Slip No" = '' THEN BEGIN
                            ERROR('The Cheque/Deposit Slip No must be inserted');
                        END;
                        IF ReceiptLine."Cheque/Deposit Slip Date" = 0D THEN BEGIN
                            ERROR('The Cheque/Deposit Date must be inserted');
                        END;
                        IF ReceiptLine."Transaction No." = '' THEN BEGIN
                            ERROR('Please ensure that the Transaction Number is inserted');
                        END;
                        IF ReceiptLine.Type = '' THEN
                            ERROR('Please ensure that the Receipt Type is inserted');

                    END;

                IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque THEN BEGIN
                    IF ReceiptLine."Cheque/Deposit Slip No" = '' THEN BEGIN
                        ERROR('The Cheque/Deposit Slip No must be inserted');
                    END;
                    IF ReceiptLine."Cheque/Deposit Slip Date" = 0D THEN BEGIN
                        ERROR('The Cheque/Deposit Date must be inserted');
                    END;
                    IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque THEN BEGIN
                        IF STRLEN(ReceiptLine."Cheque/Deposit Slip No") <> 6 THEN BEGIN
                            ERROR('Invalid Cheque Number inserted');
                        END;
                    END;
                END;
                tAmount := tAmount + ReceiptLine.Amount;
            UNTIL ReceiptLine.NEXT = 0;
        END;



        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
        GenJnlLine.DELETEALL;

        IF DefaultBatch.GET(JTemplate, JBatch) THEN
            DefaultBatch.DELETE;

        DefaultBatch.RESET;
        DefaultBatch."Journal Template Name" := JTemplate;
        DefaultBatch.Name := JBatch;
        DefaultBatch.INSERT;

        /*Insert the bank transaction*/
        IF BAmount < tAmount THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := JTemplate;
            GenJnlLine."Journal Batch Name" := JBatch;
            GenJnlLine."Source Code" := 'CASHRECJNL';
            GenJnlLine."Line No." := 1;
            GenJnlLine."Posting Date" := Rec."Document Date";
            GenJnlLine."Document No." := Rec."No.";
            GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

            GenJnlLine."Account No." := Rec."Bank Code";//USetup."Default Receipts Bank";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code" := Rec."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine.Amount := (tAmount);
            GenJnlLine.VALIDATE(GenJnlLine.Amount);

            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            // GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            // GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            // GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
            // GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

            GenJnlLine.Description := Rec.Remarks;
            GenJnlLine.VALIDATE(GenJnlLine.Description);
            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;




            //insert the transaction lines into the database
            ReceiptLine.RESET;
            ReceiptLine.SETRANGE(ReceiptLine.No, Rec."No.");
            ReceiptLine.SETRANGE(ReceiptLine.Posted, FALSE);

            IF ReceiptLine.FIND('-') THEN BEGIN
                REPEAT
                    IF ReceiptLine.Amount = 0 THEN ERROR('Please enter amount.');

                    IF ReceiptLine.Amount < 0 THEN ERROR('Amount cannot be less than zero.');

                    ReceiptLine.TESTFIELD(ReceiptLine."Global Dimension 1 Code");

                    // ReceiptLine.TESTFIELD(ReceiptLine."Shortcut Dimension 2 Code");

                    //get the last line number from the general journal line
                    GLine.RESET;


                    GLine.SETRANGE(GLine."Journal Template Name", JTemplate);
                    GLine.SETRANGE(GLine."Journal Batch Name", JBatch);
                    LineNo := 0;
                    IF GLine.FIND('+') THEN BEGIN LineNo := GLine."Line No."; END;
                    LineNo := LineNo + 1;
                    IF ReceiptLine."Pay Mode" <> ReceiptLine."Pay Mode"::Cheque THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine."Source Code" := 'CASHRECJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Rec."Document Date";
                        GenJnlLine."Document No." := ReceiptLine.No;
                        GenJnlLine."Document Date" := Rec."Document Date";
                        IF ReceiptLine."Customer Payment On Account" THEN BEGIN
                            /*SRSetup.GET();
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";*/

                            GenJnlLine."Account Type" := ReceiptLine."Account Type";
                            GenJnlLine."Account No." := ReceiptLine."Account No.";

                        END
                        ELSE BEGIN
                            GenJnlLine."Account Type" := ReceiptLine."Account Type";
                            GenJnlLine."Account No." := ReceiptLine."Account No.";
                        END;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                        GenJnlLine."Currency Code" := Rec."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");

                        GenJnlLine.Amount := -ReceiptLine.Amount;
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);

                        IF ReceiptLine."Customer Payment On Account" = FALSE THEN BEGIN
                            //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                            GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                            GenJnlLine.VALIDATE("Applies-to Doc. No.");
                            GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                            GenJnlLine.VALIDATE(GenJnlLine."Applies-to ID");
                        END;

                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        // GenJnlLine.Description := COPYSTR(ReceiptLine."Account Name" + ':' + FORMAT(ReceiptLine."Pay Mode") +
                        //   ' Invoices:' + StrInvoices, 1, 50);
                        GenJnlLine.Description := Rec.Remarks;
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                        IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;
                    END
                    ELSE
                        IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque THEN BEGIN
                            IF ReceiptLine."Cheque/Deposit Slip Date" <= TODAY THEN BEGIN
                                GenJnlLine.INIT;
                                GenJnlLine."Journal Template Name" := JTemplate;
                                GenJnlLine."Journal Batch Name" := JBatch;
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Posting Date" := Rec."Document Date";
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := Rec."Document Date";
                                IF ReceiptLine."Customer Payment On Account" THEN BEGIN
                                    SRSetup.GET();
                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                    GenJnlLine."Account No." := SRSetup."Cash Sale Nos.";
                                END
                                ELSE BEGIN
                                    GenJnlLine."Account Type" := ReceiptLine."Account Type";
                                    GenJnlLine."Account No." := ReceiptLine."Account No.";
                                END;
                                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Currency Code");

                                GenJnlLine.Amount := -ReceiptLine.Amount;
                                GenJnlLine.VALIDATE(GenJnlLine.Amount);

                                IF ReceiptLine."Customer Payment On Account" = FALSE THEN BEGIN
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                                    GenJnlLine.VALIDATE("Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to ID");
                                END;
                                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                // GenJnlLine.Description := COPYSTR(ReceiptLine."Account Name" + ':' + FORMAT(ReceiptLine."Pay Mode")
                                // + ' Invoices:' + StrInvoices, 1, 50);
                                GenJnlLine.Description := Rec.Remarks;
                                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                                IF GenJnlLine.Amount <> 0 THEN GenJnlLine.INSERT;
                            END;
                        END;
                UNTIL ReceiptLine.NEXT = 0;
            END;

            /*Post the transactions*/
            Post := FALSE;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.RUN(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            IF JournalPosted.PostedSuccessfully THEN BEGIN
                //Update Header
                Rec.Cashier := USERID;
                //"Bank Code":=USetup."Default Receipts Bank";
                Rec.Posted := TRUE;
                Rec."Date Posted" := TODAY;
                Rec."Time Posted" := TIME;
                Rec."Posted By" := USERID;
                Rec.MODIFY;
                //Update Lines
                ReceiptLine.RESET;
                ReceiptLine.SETRANGE(ReceiptLine.No, Rec."No.");
                ReceiptLine.SETRANGE(ReceiptLine.Posted, FALSE);
                IF ReceiptLine.FIND('-') THEN BEGIN
                    REPEAT
                        ReceiptLine.Posted := TRUE;
                        ReceiptLine."Date Posted" := TODAY;
                        ReceiptLine."Time Posted" := TIME;
                        ReceiptLine."Posted By" := USERID;
                        ReceiptLine.MODIFY;
                    UNTIL ReceiptLine.NEXT = 0;
                END;

                MESSAGE('Receipt Posted Successfully');

            END;
        END;

    end;


    procedure PerformPostLine()
    begin
    end;


    procedure CheckPostDated() Exists: Boolean
    begin
        //get the sum total of the post dated cheques is any
        //reset the bank amount first
        Exists := FALSE;
        BAmount := 0;
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine.No, Rec."No.");
        ReceiptLine.SETRANGE(ReceiptLine."Pay Mode", ReceiptLine."Pay Mode"::Cheque);
        IF ReceiptLine.FIND('-') THEN BEGIN
            REPEAT
                IF ReceiptLine."Cheque/Deposit Slip Date" > TODAY THEN BEGIN
                    Exists := TRUE;
                    EXIT;
                    //cheque is post dated
                    // BAmount:=BAmount + ReceiptLine.Amount;
                END;
            UNTIL ReceiptLine.NEXT = 0;
        END;
    end;


    procedure CheckBnkCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
        BankAcct.RESET;
        BankAcct.SETRANGE(BankAcct."No.", BankAcc);
        IF BankAcct.FIND('-') THEN BEGIN
            IF BankAcct."Currency Code" <> CurrCode THEN BEGIN
                IF BankAcct."Currency Code" = '' THEN
                    ERROR('This bank [%1:- %2] can only transact in LOCAL Currency', BankAcct."No.", BankAcct.Name)
                ELSE
                    ERROR('This bank [%1:- %2] can only transact in %3', BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            END;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        FunctionName := '';
        DimVal.RESET;
        DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
        DimVal.SETRANGE(DimVal.Code, Rec."Global Dimension 1 Code");
        IF DimVal.FIND('-') THEN BEGIN
            FunctionName := DimVal.Name;
        END;
        BudgetCenterName := '';
        DimVal.RESET;
        DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
        DimVal.SETRANGE(DimVal.Code, Rec."Shortcut Dimension 2 Code");
        IF DimVal.FIND('-') THEN BEGIN
            BudgetCenterName := DimVal.Name;
        END;
        BankName := '';
        BankAcc.RESET;
        BankAcc.SETRANGE(BankAcc."No.", Rec."Bank Code");
        IF BankAcc.FIND('-') THEN BEGIN
            BankName := BankAcc.Name;
        END;
    end;
}