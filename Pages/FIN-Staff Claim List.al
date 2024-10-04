page 52178737 "FIN-Staff Claim List"
{
    CardPageID = "FIN-Staff Claims";
    DeleteAllowed = false;
    // Editable = false;
    // InsertAllowed = true;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send';
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Staff Claims Header";
    SourceTableView = WHERE(Posted = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(_____)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
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

            action("Post Payment and Print")
            {
                Caption = 'Post Payment and Print';
                Visible = false;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    ExpenseBudget;
                    CheckClaimRequiredItems;
                    PostClaim;

                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(39006260, TRUE, TRUE, Rec);
                    Rec.RESET;

                    CurrPage.UPDATE;
                end;
            }
            separator(Action29)
            {
            }
            action("Post Payment")
            {
                Caption = 'Post Payment';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category7;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                begin
                    ExpenseBudget;
                    CheckClaimRequiredItems;
                    PostClaim;

                    CurrPage.UPDATE;
                end;
            }
            separator(Action30)
            {
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                ApplicationArea = Basic, Suite;
                PromotedCategory = Category6;



                trigger OnAction()
                var
                    Approvalentries: Page "Approval Entries";
                begin
                    Approvalentries.Setfilters(DATABASE::"FIN-Staff Claims Header", 6, Rec."No.");
                    Approvalentries.RUN;
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approval Mgmnt. Ext";

                begin
                    CommitBudget;

                    IF NOT AllFieldsEntered THEN
                        ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                    ApprovalMgt.CheckStaffClaimApprovalPossible(Rec);
                    ApprovalMgt.OnSendStaffClaimForApproval(Rec);


                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category5;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approval Mgmnt. Ext";

                begin
                    CancelCommitment;
                    ApprovalMgt.OnCancelStaffClaimForApproval(Rec);
                end;
            }
            separator(_______)
            {
            }

            separator(_________)
            {
            }
            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = AddWatch;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category9;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                begin
                    //IF Status<>Status::Approved THEN
                    // ERROR('You can only print after the document is Approved');
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(69272, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
            separator(___________)
            {
            }
            action("Cancel Document")
            {
                Caption = 'Cancel Document';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Text000: Label 'Are you sure you want to Cancel this Document?';
                    Text001: Label 'You have selected not to Cancel this Document';
                begin
                    CancelCommitment;

                    //TESTFIELD(Status,Status::Approved);
                    IF (Rec.Status = Rec.Status::Approved) OR (Rec.Status = Rec.Status::Pending) THEN BEGIN
                        IF CONFIRM(Text000, TRUE) THEN BEGIN
                            //Post Committment Reversals
                            Doc_Type := Doc_Type::Imprest;
                            BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.MODIFY;
                        END ELSE
                            ERROR(Text001);

                    END;
                end;
            }

        }
    }

    var
        GLEntry: Record 17;
        PayLine: Record "FIN-Staff Claim Lines";
        PVUsers: Record "FIN-CshMgt PV Steps Users";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "FIN-Payments Header";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        TarriffCodes: Record "FIN-Tariff Codes";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "FIN-Cash Office User Template";
        LineNo: Integer;
        Temp: Record "FIN-Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        PCheck: Codeunit "Budgetary Control";
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "FIN-Payments Header";
        ApprovalEntries: Page "Approval Entries";
        BankAcc: Record "Bank Account";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record "FIN-Committment";
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Budgetary Control";
        TravReqHeader: Record "FIN-Staff Claims Header";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        [InDataSet]
        "Paying Bank AccountVisible": Boolean;
        [InDataSet]
        "Bank NameVisible": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        FINStaffClaimLines: Record "FIN-Staff Claim Lines";

    //[Scope('Internal')]
    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "FIN-Budgetary Control Setup";
    begin
        IF BCsetup.GET() THEN BEGIN
            IF NOT BCsetup.Mandatory THEN BEGIN
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
    procedure PostClaim()
    begin
        IF Temp.GET(USERID) THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DELETEALL;
        END;

        //CREDIT BANK
        LineNo := LineNo + 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Rec."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine.Description := Rec.Purpose;
        IF Rec.CALCFIELDS("Total Net Amount") THEN
            GenJnlLine."Credit Amount" := Rec."Total Net Amount";
        GenJnlLine.VALIDATE("Credit Amount");
        // GenJnlLine.VALIDATE(GenJnlLine.Amount);
        // GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::Purchase;
        //Added for Currency Codes
        // GenJnlLine."Currency Code":="Currency Code";
        // GenJnlLine.VALIDATE("Currency Code");
        //  GenJnlLine."Currency Factor":="Currency Factor";
        // GenJnlLine.VALIDATE("Currency Factor");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;



        //DEBIT RESPECTIVE G/L ACCOUNT(S)
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        IF PayLine.FIND('-') THEN BEGIN
            REPEAT
                LineNo := LineNo + 1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Posting Date" := Rec."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Document No." := Rec."No.";
                GenJnlLine."External Document No." := Rec."Cheque No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No." := PayLine."Account No:";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description := Rec.Purpose;
                GenJnlLine."Debit Amount" := PayLine.Amount;
                GenJnlLine.VALIDATE(GenJnlLine."Debit Amount");
                //Added for Currency Codes
                // GenJnlLine."Currency Code":="Currency Code";
                //GenJnlLine.VALIDATE("Currency Code");
                // GenJnlLine."Currency Factor":="Currency Factor";
                // GenJnlLine.VALIDATE("Currency Factor");
                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

            UNTIL PayLine.NEXT = 0
        END;


        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances

        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        Post := FALSE;
        Post := JournlPosted.PostedSuccessfully();
        //IF Post THEN BEGIN
        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", Rec."No.");
        IF GLEntry.FIND('-') THEN BEGIN
            Rec.Posted := TRUE;
            Rec."Date Posted" := TODAY;
            Rec."Time Posted" := TIME;
            Rec."Posted By" := USERID;
            Rec.Status := Rec.Status::Posted;
            Rec.MODIFY;
        END;
        //END;
    end;

    //[Scope('Internal')]
    procedure CheckClaimRequiredItems()
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
        JTemplate := Temp."Claim Template";
        JBatch := Temp."Claim  Batch";

        IF JTemplate = '' THEN BEGIN
            ERROR('Ensure the Claim Template is set up in Cash Office Setup');
        END;

        IF JBatch = '' THEN BEGIN
            ERROR('Ensure the Claim Batch is set up in the Cash Office Setup')
        END;

        IF NOT LinesExists THEN
            ERROR('There are no Lines created for this Document');

    end;

    //[Scope('Internal')]
    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            "Paying Bank AccountEditable" := FALSE;
            "Paying Bank AccountVisible" := FALSE;
            "Bank NameVisible" := FALSE;
            "Pay ModeEditable" := FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            "Paying Bank AccountVisible" := TRUE;
            "Bank NameVisible" := TRUE;
            "Payment Release DateEditable" := TRUE;
            //"Paying Bank AccountEditable" :=TRUE;
            "Pay ModeEditable" := TRUE;
            "Cheque No.Editable" := TRUE;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        END;

        IF Rec.Status = Rec.Status::Pending THEN BEGIN
            GlobalDimension1CodeEditable := TRUE;
            ShortcutDimension2CodeEditable := TRUE;
            //CurrForm.Payee.EDITABLE:=TRUE;
            ShortcutDimension3CodeEditable := TRUE;
            ShortcutDimension4CodeEditable := TRUE;
            DateEditable := TRUE;
            //CurrForm."Account No.".EDITABLE:=TRUE;
            "Currency CodeEditable" := TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            GlobalDimension1CodeEditable := FALSE;
            ShortcutDimension2CodeEditable := FALSE;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            // CurrPage.UpdateControls();
        END
    end;

    //[Scope('Internal')]
    procedure LinesExists(): Boolean
    var
        PayLines: Record "FIN-Staff Claim Lines";
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
        PayLines: Record "FIN-Staff Claim Lines";
    begin
        AllKeyFieldsEntered := TRUE;
        PayLines.RESET;
        PayLines.SETRANGE(PayLines.No, Rec."No.");
        IF PayLines.FIND('-') THEN BEGIN
            REPEAT
                IF (PayLines."Account No:" = '') OR (PayLines.Amount <= 0) THEN
                    AllKeyFieldsEntered := FALSE;
            UNTIL PayLines.NEXT = 0;
            EXIT(AllKeyFieldsEntered);
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
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Claims Budget mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINStaffClaimLines.RESET;
        FINStaffClaimLines.SETRANGE(No, Rec."No.");
        IF FINStaffClaimLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Check if budget exists
                FINStaffClaimLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINStaffClaimLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                FINBudgetEntries.RESET;
                FINBudgetEntries.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                FINBudgetEntries.SETRANGE("G/L Account No.", FINStaffClaimLines."Account No:");
                FINBudgetEntries.SETRANGE("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense, FINBudgetEntries."Transaction Type"::Commitment
                , FINBudgetEntries."Transaction Type"::Allocation);
                FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2',
                FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::Commitment);
                FINBudgetEntries.SETFILTER(Date, PostBudgetEnties.GetBudgetStartAndEndDates(Rec.Date));
                IF FINBudgetEntries.FIND('-') THEN BEGIN
                    IF FINBudgetEntries.CALCSUMS(Amount) THEN BEGIN
                        IF FINBudgetEntries.Amount > 0 THEN BEGIN
                            IF (FINStaffClaimLines.Amount > FINBudgetEntries.Amount) THEN ERROR('Less Funds, Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                            // Commit Budget Here
                            PostBudgetEnties.CheckBudgetAvailability(FINStaffClaimLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                            FINStaffClaimLines.Amount, FINStaffClaimLines."Account Name", 'CLAIM', Rec."No." + FINStaffClaimLines."Account No:", Rec.Purpose);
                        END ELSE
                            ERROR('No allocation for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                    END;
                END ELSE
                    ERROR('Missing Budget for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
            END;
            UNTIL FINStaffClaimLines.NEXT = 0;
        END;
    end;

    local procedure ExpenseBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Claims Budget mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINStaffClaimLines.RESET;
        FINStaffClaimLines.SETRANGE(No, Rec."No.");
        IF FINStaffClaimLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINStaffClaimLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINStaffClaimLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINStaffClaimLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(FINStaffClaimLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINStaffClaimLines.Amount, FINStaffClaimLines."Account Name", USERID, TODAY, 'CLAIM', Rec."No." + FINStaffClaimLines."Account No:", Rec.Purpose);
                END;
            END;
            UNTIL FINStaffClaimLines.NEXT = 0;
        END;
    end;

    local procedure CancelCommitment()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Claims Budget mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINStaffClaimLines.RESET;
        FINStaffClaimLines.SETRANGE(No, Rec."No.");
        IF FINStaffClaimLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINStaffClaimLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINStaffClaimLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINStaffClaimLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.CancelBudgetCommitment(FINStaffClaimLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINStaffClaimLines.Amount, FINStaffClaimLines."Account Name", USERID, 'CLAIM', Rec."No." + FINStaffClaimLines."Account No:", Rec.Purpose);
                END;
            END;
            UNTIL FINStaffClaimLines.NEXT = 0;
        END;
    end;
}