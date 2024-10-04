page 52178754 "FIN-Posted Staff Claims"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "FIN-Staff Claims Header";
    SourceTableView = WHERE(Posted = CONST(true),
                            Status = FILTER(<> Cancelled));

    layout
    {
        area(content)
        {
            group(Group)
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
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Staff No/Name';
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.VALIDATE(Payee);
                    end;
                }
                field(Payee; Rec.Payee)
                {
                    Editable = false;
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

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.VALIDATE("Bank Name");
                    end;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Caption = 'Claim Description';
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
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
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
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    Editable = "Cheque No.Editable";
                    ApplicationArea = All;
                }
            }
            part(PVLines; "FIN-Staff Claim Lines")
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Payment and Print")
                {
                    Caption = 'Post Payment and Print';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;

                        Rec.RESET;
                        Rec.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(39006261, TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }
                separator("-")
                {
                }
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
                separator("--")
                {
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::"Staff Claim";
                        ApprovalEntries.Setfilters(DATABASE::"FIN-Staff Claims Header", DocumentType, Rec."No.");
                        ApprovalEntries.RUN;
                    end;
                }
                separator("~~")
                {
                }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.RESET;
                        Rec.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(69272, TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }
                separator(" ~~ ")
                {
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

        //check if the documenent has been added while another one is still pending
        /*  TravReqHeader.RESET;
          //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
          TravReqHeader.SETRANGE(TravReqHeader.Cashier,USERID);
          TravReqHeader.SETRANGE(TravReqHeader.Status,Status::Pending);

          IF TravReqHeader.COUNT>0 THEN
            BEGIN
              ERROR('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
            END;
      //*********************************END ****************************************/


        Rec."Payment Type" := Rec."Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Customer;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*"Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        "Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
        VALIDATE("Global Dimension 1 Code");
        "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
        VALIDATE("Shortcut Dimension 2 Code");
        "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
        VALIDATE("Shortcut Dimension 3 Code");
        "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
        VALIDATE("Shortcut Dimension 4 Code");
       OnAfterGetCurrRecord;
       */

    end;

    trigger OnOpenPage()
    begin
        /*"Currency CodeEditable" := TRUE;
        DateEditable := TRUE;
        ShortcutDimension2CodeEditable := TRUE;
        GlobalDimension1CodeEditable := TRUE;
        "Cheque No.Editable" := TRUE;
        "Pay ModeEditable" := TRUE;
        "Paying Bank AccountEditable" := TRUE;
        "Payment Release DateEditable" := TRUE;
        
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        UpdateControls;*/

    end;

    var
        PayLine: Record "FIN-Imprest Lines";
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
        PCheck: Codeunit "Posting Check FP";
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "FIN-Payments Header";
        BankAcc: Record 270;
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Commitments: Record "FIN-Committment";
        UserMgt: Codeunit "User Setup Management BR";
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender;
        HasLines: Boolean;
        ApprovalEntries: Page 658;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Budgetary Control";
        TravReqHeader: Record "FIN-Imprest Header";
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
        Rec.CALCFIELDS("Total Net Amount");
        GenJnlLine."Credit Amount" := Rec."Total Net Amount";
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
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
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Document No." := Rec."No.";
                GenJnlLine."External Document No." := Rec."Cheque No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No." := Rec."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description := Rec.Purpose;
                GenJnlLine."Debit Amount" := PayLine.Amount;
                GenJnlLine.VALIDATE(GenJnlLine."Debit Amount");
                //Added for Currency Codes
                GenJnlLine."Currency Code" := Rec."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
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
        JTemplate := Temp."Claim Template";
        JBatch := Temp."Claim  Batch";

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
            //CurrPage.UpdateControls();
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
}

