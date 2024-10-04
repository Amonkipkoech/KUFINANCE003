page 52178709 "FIN-Imprests List"
{
    CardPageID = "FIN-Travel Advance Req. UP";
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send,Check';
    // Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Imprest Header";
    SourceTableView = WHERE(Status = FILTER(<> Posted));

    layout
    {
        area(content)
        {
            repeater(____________)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Description Of Purchsae field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }

                field("Total Net Amount"; Rec."Total Net Amount")
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
                ApplicationArea = Basic, Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin

                    ApprovalEntries.Setfilters(DATABASE::"FIN-Imprest Header", 6, Rec."No.");
                    ApprovalEntries.RUN;
                end;
            }
            action(sendApproval)
            {
                ApplicationArea = Basic, suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approval Mgmnt. Ext";
                begin
                    // Check Budget First
                    CommitBudget;
                    IF NOT LinesExists THEN
                        ERROR('There are no Lines created for this Document');

                    IF NOT AllFieldsEntered THEN
                        ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                    //Ensure No Items That should be committed that are not
                    IF LinesCommitmentStatus THEN
                        ERROR('There are some lines that have not been committed');

                    ApprovalMgt.CheckImprestApprovalPossible(Rec);
                    ApprovalMgt.OnSendImprestForApproval(Rec);
                end;
            }
            action(cancellsApproval)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approval Mgmnt. Ext";

                begin
                    IF CONFIRM('This will also reverse Busget Commitment, Continue?', FALSE) = FALSE THEN ERROR('Cancelled by user!');
                    CancelCommitment;
                    ApprovalMgt.OnCancelImprestForApproval(Rec);

                end;
            }
            separator(__________________)
            {
            }

            separator(_____________________________)
            {
            }
            action("Print/Preview")
            {
                ApplicationArea = All;
                Caption = 'Print/Preview';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Category9;

                trigger OnAction()
                begin

                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(69279, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
            separator(___________________)
            {
            }
            action("Cancel Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Document';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    Text000: Label 'Are you sure you want to Cancel this Document?';
                    Text001: Label 'You have selected not to Cancel this Document';
                begin
                    //TESTFIELD(Rec.Status,Rec.Status::Approved);
                    IF CONFIRM('This will also reverse Busget Commitment, Continue?', FALSE) = FALSE THEN ERROR('Cancelled by user!');
                    CancelCommitment;
                    IF CONFIRM(Text000, TRUE) THEN BEGIN
                        //Post Committment Reversals
                        Doc_Type := Doc_Type::Imprest;
                        BudgetControl.ReverseEntries(Doc_Type, Rec."No.");
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.MODIFY;
                    END ELSE
                        ERROR(Text001);
                end;
            }
            action("Post Imprest")
            {
                ApplicationArea = All;
                Caption = 'Post Imprest';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category7;
                Visible = true;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);

                    IF CONFIRM('Post Document?', TRUE) = FALSE THEN EXIT;

                    PostImprest();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        //SETFILTER("Requested By",'=%1',USERID);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
    end;

    var
        ImprestHeader: Record "FIN-Imprest Header";
        Rcpt: Record "FIN-Imprest Header";
        //ApprovalEntries: Page "658";
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
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record "FIN-Committment";
        //UserMgt: Codeunit "User Setup Management";
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Budgetary Control";
        GLEntry: Record 17;
        LastEntry: Integer;
        VBank: Record 287;
        BankPayment: Record "FIN-Bank Payments";
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
        Setup: Record "FIN-Cash Office Setup";
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        FINImprestLines: Record "FIN-Imprest Lines";

    local procedure LookupOKOnPush()
    begin
        PayLine."Account No." := ImprestHeader."Account No.";
    end;

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

    procedure PostImprest()
    begin
        //TESTFIELD("Payment Release Date");
        //TESTFIELD("Paying Bank Account");
        Rec.TESTFIELD("Account No.");
        Rec.TESTFIELD("Account Type", Rec."Account Type"::Customer);

        IF Rec.Posted = TRUE THEN ERROR('The Document is already Posted!');
        /*Check if the user has selcted all the relevant fields*/
        Temp.GET(USERID);
        JTemplate := Temp."Imprest Template";
        JBatch := Temp."Imprest  Batch";

        IF JTemplate = '' THEN ERROR('Please ensure that the Imprest Template is setup in the cash management setup!!');
        IF JBatch = '' THEN ERROR('Please ensure that the Imprest Batch is setup in the cash management setup!!');

        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        IF PayLine.FIND('-') THEN BEGIN
        END ELSE BEGIN
            //ERROR('There are no lines created for this document!');
        END;


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
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine.Description := 'Imprest: ' + Rec."Account No." + ':' + Rec.Payee;
        Rec.CALCFIELDS("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        */
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        IF GLEntry.FINDLAST THEN LastEntry := GLEntry."Entry No.";

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JBatch);
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", Rec."No.");
        IF GLEntry.FIND('-') THEN BEGIN
            Rec.Posted := TRUE;
            Rec."Date Posted" := Rec.Date;
            Rec."Time Posted" := TIME;
            Rec."Posted By" := USERID;
            Rec.Status := Rec.Status::Posted;
            Rec.MODIFY;
        END;

        //EFT
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, Rec."No.");
        IF PayLine.FIND('-') THEN BEGIN
            REPEAT
            /* IF "Pay Mode"="Pay Mode"::EFT THEN BEGIN
             IF PayLine."Account No."<>'' THEN BEGIN
             BankPayment.SETRANGE(BankPayment."Doc No","No.");
             IF BankPayment.FIND('-') THEN BankPayment.DELETE;

             PayLine.TESTFIELD(PayLine."EFT Bank Account No");
            // PayLine.TESTFIELD(PayLine."EFT Branch No.");
             PayLine.TESTFIELD(PayLine."EFT Bank Code");
             PayLine.TESTFIELD(PayLine."EFT Account Name");

             BankPayment.INIT;
             BankPayment."Doc No":=Rec."No.";
             BankPayment.Payee:=PayLine."Account No.";
             BankPayment.Amount:="Total Payment Amount"-("Total Witholding Tax Amount"+"Total VAT Amount");
             BankPayment."Bank A/C No":=PayLine."EFT Bank Account No";
           //  BankPayment."Bank Branch No":=PayLine."EFT Branch No.";
           //  BankPayment."Bank Code":=PayLine."EFT Bank Code";
             BankPayment."Bank A/C Name":=PayLine."EFT Account Name";
            // END;
             BankPayment.Date:=TODAY;
             BankPayment.INSERT;
             END;
             END; */
            UNTIL PayLine.NEXT = 0;
        END;
        Post := FALSE;
        Post := JournlPosted.PostedSuccessfully();

        //IF Post THEN BEGIN
        //END;

    end;

    procedure CheckImprestRequiredItems()
    begin

        Rec.TESTFIELD("Payment Release Date");
        Rec.TESTFIELD("Paying Bank Account");
        Rec.TESTFIELD("Account No.");
        Rec.TESTFIELD("Account Type", Rec."Account Type"::Customer);

        IF Rec.Posted THEN BEGIN
            ERROR('The Document has already been posted');
        END;

        Rec.TESTFIELD(Rec.Status, Rec.Status::Approved);

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

        IF NOT LinesExists THEN
            ERROR('There are no Lines created for this Document');

    end;

    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            "Paying Bank AccountEditable" := FALSE;
            "Pay ModeEditable" := FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := FALSE;
            // CurrForm."Serial No".EDITABLE:=FALSE;
            // CurrPage.UpdateControls();
        END ELSE BEGIN
            "Payment Release DateEditable" := TRUE;
            "Paying Bank AccountEditable" := TRUE;
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
            //  CurrForm."Serial No".EDITABLE:=TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            GlobalDimension1CodeEditable := FALSE;
            ShortcutDimension2CodeEditable := TRUE;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            //  CurrForm."Serial No".EDITABLE:=FALSE;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        END
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "FIN-Imprest Lines";
    begin
        HasLines := FALSE;
        PayLines.RESET;
        PayLines.SETRANGE(PayLines.No, Rec."No.");
        IF PayLines.FIND('-') THEN BEGIN
            HasLines := TRUE;
            EXIT(HasLines);
        END;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "FIN-Imprest Lines";
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
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."Imprest Budget mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        FINImprestLines.RESET;
        FINImprestLines.SETRANGE(No, Rec."No.");
        IF FINImprestLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Check if budget exists
                FINImprestLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINImprestLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                FINBudgetEntries.RESET;
                FINBudgetEntries.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                FINBudgetEntries.SETRANGE("G/L Account No.", FINImprestLines."Account No:");
                FINBudgetEntries.SETRANGE("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense, FINBudgetEntries."Transaction Type"::Commitment
                , FINBudgetEntries."Transaction Type"::Allocation);
                FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2',
                FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::Commitment);
                FINBudgetEntries.SETFILTER(Date, PostBudgetEnties.GetBudgetStartAndEndDates(Rec.Date));
                IF FINBudgetEntries.FIND('-') THEN BEGIN
                    IF FINBudgetEntries.CALCSUMS(Amount) THEN BEGIN
                        IF FINBudgetEntries.Amount > 0 THEN BEGIN
                            IF (FINImprestLines.Amount > FINBudgetEntries.Amount) THEN ERROR('Less Funds, Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                            // Commit Budget Here
                            PostBudgetEnties.CheckBudgetAvailability(FINImprestLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                            FINImprestLines.Amount, FINImprestLines."Account Name", 'IMPREST', Rec."No." + FINImprestLines."Account No:", Rec.Purpose);
                        END ELSE
                            ERROR('No allocation for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                    END;
                END ELSE
                    ERROR('Missing Budget for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
            END;
            UNTIL FINImprestLines.NEXT = 0;
        END;
    end;

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
        FINImprestLines.RESET;
        FINImprestLines.SETRANGE(No, Rec."No.");
        IF FINImprestLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINImprestLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINImprestLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINImprestLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(FINImprestLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINImprestLines.Amount, FINImprestLines."Account Name", USERID, TODAY, 'IMPREST', Rec."No." + FINImprestLines."Account No:", Rec.Purpose);
                END;
            END;
            UNTIL FINImprestLines.NEXT = 0;
        END;
    end;

    local procedure CancelCommitment()
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
        FINImprestLines.RESET;
        FINImprestLines.SETRANGE(No, Rec."No.");
        IF FINImprestLines.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                FINImprestLines.TESTFIELD("Account No:");
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", FINImprestLines."Account No:");
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINImprestLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.CancelBudgetCommitment(FINImprestLines."Account No:", Rec.Date, '', Rec."Shortcut Dimension 2 Code",
                    FINImprestLines.Amount, FINImprestLines."Account Name", USERID, 'IMPREST', Rec."No." + FINImprestLines."Account No:", Rec.Purpose);
                END;
            END;
            UNTIL FINImprestLines.NEXT = 0;
        END;
    end;
}