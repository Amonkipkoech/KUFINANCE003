page 52178720 "FIN-Bank & Cash Trans. Req. UP"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send';
    SourceTable = "FIN-InterBank Transfers";
    SourceTableView = WHERE(Posted = filter(false),
                            Status = FILTER(<> Cancelled));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Editable = DateEditable;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    //Editable = false;
                    ApplicationArea = All;
                }
                label(_________________)
                {
                    CaptionClass = Text19025618;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Receiving Transfer Type"; Rec."Receiving Transfer Type")
                {
                    Editable = ReceivingTransferTypeEditable;
                    ApplicationArea = All;
                }
                field("Reciept Responsibility Center"; Rec."Reciept Responsibility Center")
                {
                    Editable = RecieptResponsibilityCenterEdi;
                    ApplicationArea = All;
                }
                field("Receipt Resp Centre"; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = All;
                }
                field("Receiving Depot Code"; Rec."Receiving Depot Code")
                {
                    ApplicationArea = All;
                }
                field("Receiving Department Code"; Rec."Receiving Department Code")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("Receiving Account"; Rec."Receiving Account")
                {
                    Editable = "Receiving AccountEditable";
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ReceivingAccountOnAfterValidat;
                    end;
                }
                field("Receiving Bank Account Name"; Rec."Receiving Bank Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code Destination"; Rec."Currency Code Destination")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    Editable = "Amount 2Editable";
                    ApplicationArea = All;
                }
                field("Request Amt LCY"; Rec."Request Amt LCY")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = RemarksEditable;
                    ApplicationArea = All;
                }
                label(_______________________)
                {
                    CaptionClass = Text19044997;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Source Transfer Type"; Rec."Source Transfer Type")
                {
                    Editable = "Source Transfer TypeEditable";
                    ApplicationArea = All;
                }
                field("Sending Responsibility Center"; Rec."Sending Responsibility Center")
                {
                    Editable = SendingResponsibilityCenterEdi;
                    ApplicationArea = All;
                }
                field("Sending Resp Centre"; Rec."Sending Resp Centre")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("Source Depot Code"; Rec."Source Depot Code")
                {
                    ApplicationArea = All;
                }
                field("Source Department Code"; Rec."Source Department Code")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field("Paying Account"; Rec."Paying Account")
                {
                    ApplicationArea = All;
                    Editable = "Paying AccountEditable";

                    trigger OnValidate()
                    begin
                        PayingAccountOnAfterValidate;
                    end;
                }
                field("Paying  Bank Account Name"; Rec."Paying  Bank Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code Source"; Rec."Currency Code Source")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = AmountEditable;
                    ApplicationArea = All;
                }
                field("Pay Amt LCY"; Rec."Pay Amt LCY")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field("External Doc No."; Rec."External Doc No.")
                {
                    Editable = "External Doc No.Editable";
                    ApplicationArea = All;
                }
                field("Transfer Release Date"; Rec."Transfer Release Date")
                {
                    Editable = "Transfer Release DateEditable";
                    ApplicationArea = All;
                }
                field("Exch. Rate Destination"; Rec."Exch. Rate Destination")
                {
                    Editable = "Exch. Rate DestinationEditable";
                    Visible = "Exch. Rate DestinationVisible";
                    ApplicationArea = All;
                }
                field("Exch. Rate Source"; Rec."Exch. Rate Source")
                {
                    Editable = "Exch. Rate SourceEditable";
                    Visible = "Exch. Rate SourceVisible";
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Functions';
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

                        ApprovalEntries.Setfilters(DATABASE::"FIN-InterBank Transfers", 6, Rec.No);
                        ApprovalEntries.RUN;
                    end;
                }
                separator(__________________________)
                {
                }
                action(sendApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmnt. Ext";
                    begin
                        ApprovalMgt.CheckInterBankTransferApprovalPossible(Rec);
                        ApprovalMgt.OnSendInterbankTransferForApproval(Rec);
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
                        ApprovalMgt.OnCancelInterbankTransferForApproval(Rec);

                    end;
                }
                separator(___________)
                {

                }
                action(Print)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category9;


                    trigger OnAction()
                    begin
                        Rec.RESET;
                        Rec.SETRANGE(No, Rec.No);
                        REPORT.RUN(52178736, TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }
                action("Cancel Document")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Document';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to Cancel this Document?';
                        Text001: Label 'You have selected not to Cancel this Document';
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Approved);
                        IF CONFIRM(Text000, TRUE) THEN BEGIN
                            Rec.Status := Rec.Status::Cancelled;
                            Rec."Cancelled By" := USERID;
                            Rec."Date Cancelled" := TODAY;
                            Rec."Time Cancelled" := TIME;
                            Rec.MODIFY;
                        END ELSE
                            ERROR(Text001);
                    end;
                }
            }
            group(post)
            {
                action("&Post")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TempBatch.RESET;
                        TempBatch.SETRANGE(TempBatch.UserID, USERID);
                        IF TempBatch.FIND('-') THEN BEGIN
                            Rec."Inter Bank Template Name" := TempBatch."Inter Bank Template Name";
                            Rec."Inter Bank Journal Batch" := TempBatch."Inter Bank Batch Name";
                        END;

                        Rec.TESTFIELD(Status, Rec.Status::Approved);
                        Rec.TESTFIELD("Transfer Release Date");

                        //Check whether the two LCY amounts are same
                        IF Rec."Request Amt LCY" <> Rec."Pay Amt LCY" THEN
                            ERROR('The [Requested Amount in LCY: %1] should be same as the [Paid Amount in LCY: %2]', Rec."Request Amt LCY", Rec."Pay Amt LCY");

                        //get the source account balance from the database table
                        BankAcc.RESET;
                        BankAcc.SETRANGE(BankAcc."No.", Rec."Paying Account");
                        BankAcc.SETRANGE(BankAcc."Bank Type", BankAcc."Bank Type"::Cash);

                        IF BankAcc.FINDFIRST THEN BEGIN
                            BankAcc.CALCFIELDS(BankAcc.Balance);
                            Rec."Current Source A/C Bal." := BankAcc.Balance;
                            IF (Rec."Current Source A/C Bal." - Rec.Amount) < 0 THEN BEGIN
                                ERROR('The transaction will result in a negative balance in a CASH ACCOUNT.');
                            END;
                        END;
                        IF Rec.Amount = 0 THEN BEGIN
                            ERROR('Please ensure Amount to Transfer is entered');
                        END;
                        /*Check if the user's batch has any records within it*/
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Rec."Inter Bank Template Name");
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", Rec."Inter Bank Journal Batch");
                        GenJnlLine.DELETEALL;

                        LineNo := 1000;
                        /*Insert the new lines to be updated*/
                        GenJnlLine.INIT;
                        /*Insert the lines*/
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                        GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                        GenJnlLine."Posting Date" := Rec."Transfer Release Date";
                        GenJnlLine."Document No." := Rec.No;
                        IF Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Intra-Company" THEN BEGIN
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        END
                        ELSE
                            IF Rec."Receiving Transfer Type" = Rec."Receiving Transfer Type"::"Inter-Company" THEN BEGIN
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                            END;
                        GenJnlLine."Account No." := Rec."Receiving Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No);
                        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Receiving Depot Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Receiving Department Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code1");
                        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code1");
                        GenJnlLine."External Document No." := Rec."External Doc No.";
                        GenJnlLine.Description := Rec.Remarks;
                        IF Rec.Remarks = '' THEN BEGIN GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No); END;
                        GenJnlLine."Currency Code" := Rec."Currency Code Destination";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        IF Rec."Currency Code Destination" <> '' THEN BEGIN
                            GenJnlLine."Currency Factor" := Rec."Exch. Rate Destination";//"Reciprical 2";
                            GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                        END;
                        GenJnlLine.Amount := Rec."Amount 2";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine.INSERT;


                        GenJnlLine.INIT;
                        /*Insert the lines*/
                        GenJnlLine."Line No." := LineNo + 1;
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Journal Template Name" := Rec."Inter Bank Template Name";
                        GenJnlLine."Journal Batch Name" := Rec."Inter Bank Journal Batch";
                        GenJnlLine."Posting Date" := Rec."Transfer Release Date";
                        GenJnlLine."Document No." := Rec.No;
                        IF Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Intra-Company" THEN BEGIN
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        END
                        ELSE
                            IF Rec."Source Transfer Type" = Rec."Source Transfer Type"::"Inter-Company" THEN BEGIN
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                            END;


                        GenJnlLine."Account No." := Rec."Paying Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Source Depot Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Source Department Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                        GenJnlLine."External Document No." := Rec."External Doc No.";
                        GenJnlLine.Description := Rec.Remarks;
                        IF Rec.Remarks = '' THEN BEGIN GenJnlLine.Description := 'Inter-Bank Transfer Ref No:' + FORMAT(Rec.No); END;
                        GenJnlLine."Currency Code" := Rec."Currency Code Source";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        IF Rec."Currency Code Source" <> '' THEN BEGIN
                            GenJnlLine."Currency Factor" := Rec."Exch. Rate Source";//"Reciprical 1";
                            GenJnlLine.VALIDATE(GenJnlLine."Currency Factor");
                        END;
                        GenJnlLine.Amount := -Rec.Amount;
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine.INSERT;
                        Post := FALSE;
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                        Post := JournalPostedSuccessfully.PostedSuccessfully();

                        //IF Post THEN BEGIN
                        Rec.Posted := TRUE;
                        Rec."Date Posted" := TODAY;
                        Rec."Time Posted" := TIME;
                        Rec."Posted By" := USERID;
                        Rec.MODIFY;
                        MESSAGE('The Journal Has Been Posted Successfully');
                        //END;

                    end;
                }
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Transfer Release DateEditable" := TRUE;
        "External Doc No.Editable" := TRUE;
        "Exch. Rate SourceEditable" := TRUE;
        AmountEditable := TRUE;
        "Paying AccountEditable" := TRUE;
        SendingResponsibilityCenterEdi := TRUE;
        "Source Transfer TypeEditable" := TRUE;
        "Exch. Rate DestinationEditable" := TRUE;
        RemarksEditable := TRUE;
        "Amount 2Editable" := TRUE;
        "Receiving AccountEditable" := TRUE;
        RecieptResponsibilityCenterEdi := TRUE;
        ReceivingTransferTypeEditable := TRUE;
        DateEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Date := TODAY;
        Rec."Inter Bank Template Name" := JTemplate;
        Rec."Inter Bank Journal Batch" := JBatch;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Reciept Responsibility Center" := UserMgt.GetPurchasesFilter();
        //VALIDATE( "Reciept Responsibility Center");
        Rec.Status := Rec.Status::Pending;
        Rec."Created By" := USERID;

        //UpdateControl;
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Reciept Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;


        TempBatch.RESET;

        TempBatch.SETRANGE(TempBatch.UserID, USERID);
        IF TempBatch.FIND('-') THEN BEGIN
            JTemplate := TempBatch."Inter Bank Template Name";
            JBatch := TempBatch."Inter Bank Batch Name";
        END;

        /*Check if the user has the batches selected*/
        IF (JTemplate = '') OR (JBatch = '') THEN BEGIN
            ERROR('Please ensure you are setup as an interbank transfer user');
        END;

        /*
       IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
         FILTERGROUP(2);
         SETRANGE("Reciept Responsibility Center" ,UserMgt.GetPurchasesFilter());
         FILTERGROUP(0);
       END;
          //Reciept Responsibility Center
          */

    end;

    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        TempBatch: Record "FIN-Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        //PCheck: Codeunit "50110";
        Post: Boolean;
        BankAcc: Record "Bank Account";
        RegNo: Integer;
        FromNo: Integer;
        ToNo: Integer;
        //RegMgt: Codeunit "50103";
        JournalPostedSuccessfully: Codeunit "Journal Post Successful";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        //ApprovalEntries: Page "658";
        [InDataSet]
        "Exch. Rate DestinationVisible": Boolean;
        [InDataSet]
        "Exch. Rate SourceVisible": Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        ReceivingTransferTypeEditable: Boolean;
        [InDataSet]
        RecieptResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Receiving AccountEditable": Boolean;
        [InDataSet]
        "Amount 2Editable": Boolean;
        [InDataSet]
        RemarksEditable: Boolean;
        [InDataSet]
        "Exch. Rate DestinationEditable": Boolean;
        NameSendInterbankapprovalRequest: Integer;
        [InDataSet]
        "Source Transfer TypeEditable": Boolean;
        [InDataSet]
        SendingResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Paying AccountEditable": Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Exch. Rate SourceEditable": Boolean;
        [InDataSet]
        "External Doc No.Editable": Boolean;
        [InDataSet]
        "Transfer Release DateEditable": Boolean;
        Text19025618: Label 'Requesting Details';
        Text19044997: Label 'Source Details';

    //[Scope('Internal')]
    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record 98;
        DimVal: Record "Dimension Value";
        Text000: Label 'Are you sure you want to Cancel this Document?';
        Text001: Label 'You have selected not to Cancel this Document';
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
        /*IF Status<>Status::Pending THEN BEGIN
           DateEditable :=FALSE;
           ReceivingTransferTypeEditable :=FALSE;
           RecieptResponsibilityCenterEdi :=FALSE;
           "Receiving AccountEditable" :=FALSE;
           "Amount 2Editable" :=FALSE;
           RemarksEditable :=FALSE;
           "Exch. Rate DestinationEditable" :=FALSE;
        END ELSE BEGIN
           DateEditable :=TRUE;
           ReceivingTransferTypeEditable :=TRUE;
           RecieptResponsibilityCenterEdi :=TRUE;
           "Receiving AccountEditable" :=TRUE;
           "Amount 2Editable" :=TRUE;
           RemarksEditable :=TRUE;
           "Exch. Rate DestinationEditable" :=TRUE;
        
        
        END;
        
        IF Status=Status::Approved THEN BEGIN
           "Source Transfer TypeEditable" :=TRUE;
           SendingResponsibilityCenterEdi :=TRUE;
           "Paying AccountEditable" :=TRUE;
           AmountEditable :=TRUE;
           "Paying AccountEditable" :=TRUE;
           "Exch. Rate SourceEditable" :=TRUE;
           "External Doc No.Editable" :=TRUE;
           "Transfer Release DateEditable" :=TRUE;
        END ELSE BEGIN
           "Source Transfer TypeEditable" :=FALSE;
           SendingResponsibilityCenterEdi :=FALSE;
           AmountEditable :=FALSE;
           "Paying AccountEditable" :=FALSE;
           "Exch. Rate SourceEditable" :=FALSE;
           "External Doc No.Editable" :=FALSE;
           "Transfer Release DateEditable" :=FALSE;
        END;
         */

    end;

    local procedure ReceivingAccountOnAfterValidat()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate DestinationVisible" := FALSE;
        IF Rec."Currency Code Destination" <> '' THEN BEGIN
            "Exch. Rate DestinationVisible" := TRUE;
        END;
    end;

    local procedure PayingAccountOnAfterValidate()
    begin
        //check if the currency code field has been filled in
        "Exch. Rate SourceVisible" := FALSE;
        IF Rec."Currency Code Source" <> '' THEN BEGIN
            "Exch. Rate SourceVisible" := TRUE;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        IF Rec."Currency Code Source" <> '' THEN BEGIN
            "Exch. Rate SourceVisible" := TRUE;
        END
        ELSE BEGIN
            "Exch. Rate SourceVisible" := FALSE;
        END;

        IF Rec."Currency Code Destination" <> '' THEN BEGIN
            "Exch. Rate DestinationVisible" := TRUE;
        END
        ELSE BEGIN
            "Exch. Rate DestinationVisible" := FALSE;
        END;

        UpdateControl;
    end;
}
