page 52178751 "FIN-Posted Imprest Accounting"
{
    CardPageID = "FIN-Posted Travel Advs. Acc.";
    PageType = List;
    SourceTable = "FIN-Imprest Surr. Header";
    SourceTableView = WHERE(Status = FILTER(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = All;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                }
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field("Transaction Name"; Rec."Transaction Name")
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
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                }
                field("Cashier Bank Account"; Rec."Cashier Bank Account")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = All;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Type"; Rec."Bank Type")
                {
                    ApplicationArea = All;
                }
                field("PV Type"; Rec."PV Type")
                {
                    ApplicationArea = All;
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    ApplicationArea = All;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = All;
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    ApplicationArea = All;
                }
                field(Surrendered; Rec.Surrendered)
                {
                    ApplicationArea = All;
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    ApplicationArea = All;
                }
                field("Vote Book"; Rec."Vote Book")
                {
                    ApplicationArea = All;
                }
                field("Total Allocation"; Rec."Total Allocation")
                {
                    ApplicationArea = All;
                }
                field("Total Expenditure"; Rec."Total Expenditure")
                {
                    ApplicationArea = All;
                }
                field("Total Commitments"; Rec."Total Commitments")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field("Balance Less this Entry"; Rec."Balance Less this Entry")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash"; Rec."Petty Cash")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Issue Voucher Type"; Rec."Issue Voucher Type")
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
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = All;
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Amount Surrendered LCY"; Rec."Amount Surrendered LCY")
                {
                    ApplicationArea = All;
                }
                field("PV No"; Rec."PV No")
                {
                    ApplicationArea = All;
                }
                field("Print No."; Rec."Print No.")
                {
                    ApplicationArea = All;
                }
                field("Cash Surrender Amt"; Rec."Cash Surrender Amt")
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
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status <> Rec.Status::Pending THEN
                        ERROR('The document has already been processed.');

                    IF Rec.Amount < 0 THEN
                        ERROR('Amount cannot be less than zero.');

                    IF Rec.Amount = 0 THEN
                        ERROR('Please enter amount.');

                    IF CONFIRM('Are you sure you would like to approve the payment?', FALSE) = TRUE THEN BEGIN
                        Rec.Status := Rec.Status::"2nd Approval";
                        Rec.MODIFY;
                        MESSAGE('Document approved successfully.');
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
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::ImprestSurrender;
                        // ApprovalEntries.Setfilters(DATABASE::"FIN-Imprest Surr. Header", DocumentType, Rec.No);
                        // ApprovalEntries.RUN;
                    end;
                }
                separator(____________)
                {

                }
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit 439;
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        //First Check whether all amount entered tally
                        ImprestDetails.RESET;
                        ImprestDetails.SETRANGE(ImprestDetails."Surrender Doc No.", Rec.No);
                        IF ImprestDetails.FIND('-') THEN BEGIN
                            REPEAT
                                IF (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount THEN
                                    ERROR('Receipt Amount and Imprest Should be equal to Imprest Amount..');

                            UNTIL ImprestDetails.NEXT = 0;
                        END;

                        //Release the Imprest for Approval

                        State := State::Open;
                        IF Rec.Status <> Rec.Status::Pending THEN State := State::"Pending Approval";
                        DocType := DocType::ImprestSurrender;
                        CLEAR(tableNo);
                        tableNo := DATABASE::"FIN-Imprest Surr. Header";
                        //IF ApprovalMgt.SendApproval(tableNo, Rec.No, DocType, State, Rec."Responsibility Center", Rec.Amount) THEN;
                        //  IF ApprovalMgt.SendLeaveApprovalRequest(Rec) THEN;
                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit 439;
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        DocType := DocType::ImprestSurrender;
                        showmessage := TRUE;
                        ManualCancel := TRUE;
                        CLEAR(tableNo);
                        tableNo := DATABASE::"FIN-Imprest Surr. Header";
                        //IF ApprovalMgt.CancelApproval(tableNo, DocType, Rec.No, showmessage, ManualCancel) THEN;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                begin
                    ExpenseBudget;


                    Rec.TESTFIELD(Status, Rec.Status::Approved);

                    IF Rec.Posted THEN
                        ERROR('The transaction has already been posted.');

                    //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                    //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                    /*CALCFIELDS("Actual Spent");
                    IF "Actual Spent"=0 THEN
                        IF CONFIRM(Text000,TRUE) THEN
                          UpdateforNoActualSpent
                        ELSE
                           ERROR(Text001);
                     */
                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    IF GenledSetup.GET THEN BEGIN
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        GenJnlLine.DELETEALL;
                    END;

                    IF DefaultBatch.GET(GenledSetup."Surrender Template", GenledSetup."Surrender  Batch") THEN BEGIN
                        DefaultBatch.DELETE;
                    END;

                    DefaultBatch.RESET;
                    DefaultBatch."Journal Template Name" := GenledSetup."Surrender Template";
                    DefaultBatch.Name := GenledSetup."Surrender  Batch";
                    DefaultBatch.INSERT;
                    LineNo := 0;

                    ImprestDetails.RESET;
                    ImprestDetails.SETRANGE(ImprestDetails."Surrender Doc No.", Rec.No);
                    IF ImprestDetails.FIND('-') THEN BEGIN
                        REPEAT
                            //Post Surrender Journal
                            //Compare the amount issued =amount on cash reciecied.
                            //Created new field for zero spent
                            //

                            //ImprestDetails.TESTFIELD("Actual Spent");
                            //ImprestDetails.TESTFIELD("Actual Spent");
                            IF (ImprestDetails."Cash Receipt Amount" + ImprestDetails."Actual Spent") <> ImprestDetails.Amount THEN
                                ERROR(Txt0001);

                            Rec.TESTFIELD("Global Dimension 1 Code");

                            LineNo := LineNo + 1000;
                            GenJnlLine.INIT;
                            GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                            GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := ImprestDetails."Account No:";
                            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                            //Set these fields to blanks
                            GenJnlLine."Posting Date" := Rec."Surrender Date";
                            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                            GenJnlLine.VALIDATE("Gen. Posting Type");
                            GenJnlLine."Gen. Bus. Posting Group" := '';
                            GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                            GenJnlLine."Gen. Prod. Posting Group" := '';
                            GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                            GenJnlLine."VAT Bus. Posting Group" := '';
                            GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                            GenJnlLine."VAT Prod. Posting Group" := '';
                            GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                            GenJnlLine."Document No." := Rec.No;
                            GenJnlLine.Amount := ImprestDetails."Actual Spent";
                            GenJnlLine.VALIDATE(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                            GenJnlLine."Bal. Account No." := ImprestDetails."Imprest Holder";
                            GenJnlLine.Description := 'Imprest Surrendered by staff';
                            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                            GenJnlLine."Currency Code" := Rec."Currency Code";
                            GenJnlLine.VALIDATE("Currency Code");
                            //Take care of Currency Factor
                            GenJnlLine."Currency Factor" := Rec."Currency Factor";
                            GenJnlLine.VALIDATE("Currency Factor");

                            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                            //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                            //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

                            //Application of Surrender entries
                            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN BEGIN
                                //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                GenJnlLine."Applies-to Doc. No." := Rec."PV No";
                                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                                GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                            END;

                            IF GenJnlLine.Amount <> 0 THEN
                                GenJnlLine.INSERT;

                            //Post Cash Surrender
                            IF ImprestDetails."Cash Receipt Amount" > 0 THEN BEGIN
                                IF ImprestDetails."Bank/Petty Cash" = '' THEN
                                    ERROR('Select a Bank Code where the Cash Surrender will be posted');
                                LineNo := LineNo + 1000;
                                GenJnlLine.INIT;
                                GenJnlLine."Journal Template Name" := GenledSetup."Surrender Template";
                                GenJnlLine."Journal Batch Name" := GenledSetup."Surrender  Batch";
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                GenJnlLine."Account No." := ImprestDetails."Imprest Holder";
                                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.VALIDATE("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                                GenJnlLine."Posting Date" := Rec."Surrender Date";
                                GenJnlLine."Document No." := Rec.No;
                                GenJnlLine.Amount := -ImprestDetails."Cash Receipt Amount";
                                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.VALIDATE("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.VALIDATE("Currency Factor");

                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                                GenJnlLine."Bal. Account No." := ImprestDetails."Bank/Petty Cash";
                                GenJnlLine.Description := 'Imprest Surrender by staff';
                                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                GenJnlLine."Applies-to ID" := ImprestDetails."Imprest Holder";

                                //Application of Surrender entries
                                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := Rec."PV No";
                                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";

                                    IF GenJnlLine.Amount <> 0 THEN
                                        GenJnlLine.INSERT;

                                END;
                            END;
                        //End Post Surrender Journal

                        UNTIL ImprestDetails.NEXT = 0;
                        //Post Entries
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", GenledSetup."Surrender Template");
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", GenledSetup."Surrender  Batch");
                        //Adjust Gen Jnl Exchange Rate Rounding Balances
                        AdjustGenJnl.RUN(GenJnlLine);
                        //End Adjust Gen Jnl Exchange Rate Rounding Balances

                        //GenerateReceipt();

                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    END;

                    //IF JournalPostSuccessful.PostedSuccessfully THEN BEGIN
                    Rec.Posted := TRUE;
                    Rec.Status := Rec.Status::Posted;
                    Rec."Date Posted" := TODAY;
                    Rec."Time Posted" := TIME;
                    Rec."Posted By" := USERID;
                    Rec.MODIFY;
                    //Tag the Source Imprest Requisition as Surrendered
                    ImprestReq.RESET;
                    ImprestReq.SETRANGE(ImprestReq."No.", Rec."Imprest Issue Doc. No");
                    IF ImprestReq.FIND('-') THEN BEGIN
                        ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
                        ImprestReq.MODIFY;
                    END;

                    //End Tag
                    //Post Committment Reversals
                    Doc_Type := Doc_Type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type, Rec."Imprest Issue Doc. No");
                    //END;

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER(No, Rec.No);
                    REPORT.RUN(52178735, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }
    }

    var
        Rcpt: Record "FIN-Imprest Surr. Header";
        //ApprovalEntries: Page "658";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        TarriffCodes: Record "FIN-Tariff Codes";
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        CashierLinks: Record "FIN-Cash Office User Template";
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record "FIN-Imprest Surrender Details";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        //ImprestRequestDet: Record "FIN-Payments-Users";
        GenledSetup: Record "FIN-Cash Office Setup";
        ImprestAmt: Decimal;
        DimName1: Text[80];
        DimName2: Text[80];
        CashPaymentLine: Record "FIN-Cash Payment Line q";
        PaymentLine: Record "FIN-Payment Line";
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit "Journal Post Successful";
        Commitments: Record "FIN-Committment";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "FIN-Imprest Header";
        UserMgt: Codeunit "User Setup Management";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        AdjustGenJnl: Codeunit 407;
        ReceiptHeader: Record "FIN-Receipts Header";
        ImprestSurrHeader: Record "FIN-Imprest Surr. Header";
        RecLine: Record "FIN-Receipt Line q";
        LastNo: Code[20];
        GenSetUp: Record "FIN-Cash Office Setup";
        "No. Series Line": Record 309;
        BankRec: Record "Bank Account";
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        FINImprestSurrLines: Record "FIN-Imprest Surrender Details";

    local procedure ExpenseBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Imprest Budget mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINImprestSurrLines.RESET;
        FINImprestSurrLines.SETRANGE("Surrender Doc No.", Rec.No);
        IF FINImprestSurrLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINImprestSurrLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINImprestSurrLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINImprestSurrLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(FINImprestSurrLines."Account No:", Rec."Surrender Date", '', Rec."Shortcut Dimension 2 Code",
                    FINImprestSurrLines.Amount, FINImprestSurrLines."Account Name", USERID, TODAY, 'IMPREST', Rec."Imprest Issue Doc. No" + FINImprestSurrLines."Account No:", '');
                END;
            END;
            UNTIL FINImprestSurrLines.NEXT = 0;
        END;
    end;
}