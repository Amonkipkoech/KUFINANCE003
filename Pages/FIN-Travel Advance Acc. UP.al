page 52178716 "FIN-Travel Advance Acc. UP"
{
    Caption = 'Imprest Accounting';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send';
    SourceTable = "FIN-Imprest Surr. Header";
    SourceTableView = WHERE(Posted = filter(false));

    layout

    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    ApplicationArea = All;
                    Editable = "Surrender DateEditable";
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = "Account No.Editable";
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    ApplicationArea = All;
                    Editable = "Imprest Issue Doc. NoEditable";
                }
                field("Receipt Attached"; Rec."Receipt Attached")
                {
                    ToolTip = 'Specifies the value of the Receipt Attached field.';
                    ApplicationArea = All;
                }
                field("Nature Of Expense"; Rec."Nature Of Expense")
                {
                    ToolTip = 'Specifies the value of the Nature Of Expense field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    //Editable = "Responsibility CenterEditable";
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    // ApplicationArea = All;
                    Editable = true;
                    ApplicationArea = All;
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; DimName1)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    //ApplicationArea = All;
                    Editable = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        // DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                    end;
                }
                field(DimName2; DimName2)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    // ApplicationArea = All;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Dim3; Rec.Dim3)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    // ApplicationArea = All;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("PV No"; Rec."PV No")
                {
                    Visible = false;
                    // ApplicationArea = All;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Financial Period"; Rec."Financial Period")
                {
                    Visible = false;
                    ApplicationArea = All;
                    //  ApplicationArea = All;
                }
            }
            part(ImprestLines; "FIN-Imprest Surr. Details UP")
            {
                ApplicationArea = all;
                Editable = ImprestLinesEditable;
                SubPageLink = "Surrender Doc No." = FIELD(No);
            }
            label(_________)
            {
                CaptionClass = Text19053222;
                Style = Standard;
                StyleExpr = TRUE;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Attachments)
            {
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Category6;
                ApplicationArea = All;
                RunObject = Page "Imprest Document Attachment";
            }

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category6;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.Setfilters(DATABASE::"FIN-Imprest Surr. Header", 6, Rec.No);
                    ApprovalEntries.RUN;
                end;
            }
            separator(________________)
            {

            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    ApprovalMgnt: Codeunit "Approval Mgmnt. Ext";
                begin

                    ApprovalMgnt.CheckImprestSurrenderApprovalPossible(Rec);
                    ApprovalMgnt.OnSendImprestSurrenderForApproval(Rec);
                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approval Mgmnt. Ext";

                begin
                    ApprovalMgt.OnCancelImprestSurrenderForApproval(Rec);
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
                Visible = true;

                trigger OnAction()
                var
                    Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                begin
                    ExpenseBudget;


                    //Rec.TESTFIELD(Status, Rec.Status::Approved);

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
                                //ERROR(Txt0001);

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
                        /*IF ImprestDetails."Cash Receipt Amount" > 0 THEN BEGIN
                            IF ImprestDetails."Bank/Petty Cash" = '' THEN
                                //ERROR('Select a Bank Code where the Cash Surrender will be posted');
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
                        END;*/
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
                        // Message('Available');
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
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER(No, Rec.No);
                    REPORT.RUN(52178735, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
            action("Print Accounting")
            {
                Caption = 'Print Accounting';
                Image = Print;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
            }
        }
    }

    trigger OnInit()
    begin
        ImprestLinesEditable := TRUE;
        "Responsibility CenterEditable" := TRUE;
        "Imprest Issue Doc. NoEditable" := TRUE;
        "Account No.Editable" := TRUE;
        "Surrender DateEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."User ID" := USERID;
        Rcpt.RESET;
        Rcpt.SETRANGE(Rcpt.Posted, FALSE);
        Rcpt.SETRANGE(Rcpt.Cashier, USERID);
        IF Rcpt.COUNT > 0 THEN BEGIN
            IF CONFIRM('There are still some unposted imprest Surrenders. Continue?', FALSE) = FALSE THEN BEGIN
                ERROR('There are still some unposted imprest Surrenders. Please utilise them first');
            END;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
    end;

    trigger OnOpenPage()
    begin
        /*IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        AccountName:=GetCustName("Account No.");
        */

    end;

    var
        Rcpt: Record "FIN-Imprest Surr. Header";
        //ApprovalEntries: Page "658";
        //RecPayTypes: Record "61129";
        //TarriffCodes: Record "61716";
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        //CashierLinks: Record "61712";
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record "FIN-Imprest Surrender Details";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        //ImprestRequestDet: Record "61719";
        GenledSetup: Record "Cash Office Setup";
        ImprestAmt: Decimal;
        DimName1: Text[80];
        DimName2: Text[80];
        //CashPaymentLine: Record "61718";
        //PaymentLine: Record "61705";
        //CurrSurrDocNo: Code[20];
        //JournalPostSuccessful: Codeunit "50113";
        //Commitments: Record "61722";
        BCSetup: Record "FIN-Budgetary Control Setup";
        BudgetControl: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record "FIN-Imprest Header";
        UserMgt: Codeunit "User Setup Management";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        AdjustGenJnl: Codeunit 407;
        ReceiptHeader: Record "FIN-Receipts Header";
        //ImprestSurrHeader: Record "61504";
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
        Text19053222: Label 'Enter Advance Accounting Details below';
        //FINBudgetEntries: Record "77078";
        FINImprestSurrLines: Record "FIN-Imprest Surrender Details";

    //[Scope('Internal')]
    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record 98;
        DimVal: Record 349;
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
        IF Rec.Status <> Rec.Status::Pending THEN BEGIN
            "Surrender DateEditable" := FALSE;
            "Account No.Editable" := FALSE;
            "Imprest Issue Doc. NoEditable" := FALSE;
            "Responsibility CenterEditable" := FALSE;
            ImprestLinesEditable := FALSE;
        END ELSE BEGIN
            "Surrender DateEditable" := TRUE;
            "Account No.Editable" := TRUE;
            "Imprest Issue Doc. NoEditable" := TRUE;
            "Responsibility CenterEditable" := TRUE;
            ImprestLinesEditable := TRUE;

        END;
    end;

    //[Scope('Internal')]
    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name := '';
        IF Cust.GET(No) THEN
            Name := Cust.Name;
        EXIT(Name);
    end;

    //[Scope('Internal')]
    procedure UpdateforNoActualSpent()
    begin
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
    end;

    //[Scope('Internal')]
    procedure CompareAllAmounts()
    begin
    end;

    //[Scope('Internal')]
    procedure GenerateReceipt()
    begin
        IF ImprestDetails."Cash Receipt Amount" <> 0 THEN
            Rec.TESTFIELD("Received From");

        IF BankRec.GET(ImprestDetails."Bank/Petty Cash") THEN
            BankRec.TESTFIELD(BankRec."Receipt No. Series");

        LastNo := '';
        GenSetUp.GET;
        "No. Series Line".SETRANGE("No. Series Line"."Series Code", GenSetUp."Receipts No");
        IF "No. Series Line".FIND('-') THEN BEGIN
            LastNo := BankRec."Receipt No. Series" + '-' + INCSTR("No. Series Line"."Last No. Used");
            "No. Series Line"."Last No. Used" := INCSTR("No. Series Line"."Last No. Used");
            "No. Series Line".MODIFY;
        END;


        IF ImprestDetails."Cash Surrender Amt" <> 0 THEN BEGIN

            ReceiptHeader.INIT;
            ReceiptHeader."No." := LastNo;
            ReceiptHeader.Date := Rec."Surrender Date";
            ReceiptHeader."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
            ReceiptHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            ReceiptHeader.VALIDATE("Global Dimension 1 Code");
            ReceiptHeader.VALIDATE("Shortcut Dimension 2 Code");
            ReceiptHeader.Cashier := USERID;
            ReceiptHeader."Date Posted" := TODAY;
            ReceiptHeader."Time Posted" := TIME;
            ReceiptHeader.Posted := TRUE;
            ReceiptHeader."Received From" := Rec."Received From";
            ReceiptHeader."Amount Recieved" := ImprestDetails."Cash Receipt Amount";
            ReceiptHeader."Responsibility Center" := 'CUC';
            ReceiptHeader."Bank Code" := ImprestDetails."Bank/Petty Cash";
            ReceiptHeader."Surrender No" := Rec.No;

            IF ImprestDetails."Cash Surrender Amt" <> 0 THEN
                ReceiptHeader.INSERT;

            RecLine.INIT;
            RecLine.No := LastNo;
            RecLine.Type := 'SURRENDER';
            RecLine."Account No." := Rec."Account No.";
            RecLine."Account Name" := 'Imprest Cash Surrender';
            RecLine.Amount := ImprestDetails."Cash Receipt Amount";
            RecLine.VALIDATE(RecLine.Amount);
            RecLine."Cheque/Deposit Slip No" := ImprestDetails."Cheque/Deposit Slip No";
            RecLine."Cheque/Deposit Slip Date" := ImprestDetails."Cheque/Deposit Slip Date";
            RecLine."Cheque/Deposit Slip Type" := ImprestDetails."Cheque/Deposit Slip Type";
            RecLine."Cheque/Deposit Slip Bank" := ImprestDetails."Bank/Petty Cash";
            RecLine."Pay Mode" := ImprestDetails."Cash Pay Mode";

            IF ImprestDetails."Cash Surrender Amt" <> 0 THEN
                RecLine.INSERT;
        END;
    end;

    local procedure ExpenseBudget()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory)) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
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
                DimensionValue.SETRANGE(Code, Rec."Global Dimension 1 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (FINImprestSurrLines.Amount > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(FINImprestSurrLines."Account No:", Rec."Surrender Date", Rec."Global Dimension 1 Code", Rec."Shortcut Dimension 2 Code",
                    FINImprestSurrLines."Actual Spent", FINImprestSurrLines."Account Name", USERID, TODAY, 'IMPREST', Rec."Imprest Issue Doc. No" + FINImprestSurrLines."Account No:", '');
                END;
            END;
            UNTIL FINImprestSurrLines.NEXT = 0;
        END;
    end;
}