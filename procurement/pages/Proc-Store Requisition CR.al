page 52178761 "PROC-Store Requisition CR"
{
    CardPageID = "PROC-Store Req. Header CR";
    Caption = 'My Store Requision List';
    PageType = List;
    SourceTable = "PROC-Store Requistion Header";
    // SourceTableView = WHERE("Document Type" = FILTER("Store Req"));
    //for common req CR
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = EditInfo;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Request date"; Rec."Request date")
                {
                    ApplicationArea = all;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = all;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }


                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }

                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = All;
                }
                field("Store Requisition Type"; Rec."Store Requisition Type")
                {
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = all;
                }
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
                action("Post Store Requisition")
                {
                    Visible = false;
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    PromotedOnly = true;


                    trigger OnAction()
                    begin
                        Rec.TestField("Global Dimension 1 Code");
                        Rec.TestField("Responsibility Center");
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if Rec.Status = Rec.Status::Posted then
                            Error('The Document Has Already been Posted');

                        if Rec.Status <> Rec.Status::Released then
                            Error('The Document Has not yet been Approved');


                        Rec.TestField("Issuing Store");
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        ReqLine.SetFilter(ReqLine."Quantity To Issue", '>%1', 0);
                        Rec.TestField("Issuing Store");
                        if ReqLine.Find('-') then begin
                            if InventorySetup.Get then begin
                                //  ERROR('1');
                                InventorySetup.TestField(InventorySetup."Item Issue Template");
                                InventorySetup.TestField(InventorySetup."Item Issue Batch");
                                GenJnline.Reset;
                                GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Item Issue Template");
                                GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Item Issue Batch");
                                if GenJnline.Find('-') then GenJnline.DeleteAll;
                            end;
                            repeat
                            begin
                                //Issue
                                LineNo := LineNo + 1000;

                                GenJnline.Init;
                                GenJnline."Journal Template Name" := InventorySetup."Item Issue Template";
                                GenJnline."Journal Batch Name" := InventorySetup."Item Issue Batch";
                                GenJnline."Line No." := LineNo;
                                GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
                                GenJnline."Document No." := Rec."No.";
                                GenJnline."Item No." := ReqLine."No.";
                                GenJnline.Validate("Item No.");
                                GenJnline."Location Code" := Rec."Issuing Store";
                                GenJnline.Validate("Location Code");
                                GenJnline."Posting Date" := Rec."Request date";
                                GenJnline.Description := ReqLine.Description;
                                //GenJnline.Quantity:=ReqLine.Quantity;
                                GenJnline.Quantity := ReqLine."Quantity To Issue";
                                GenJnline."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnline.Validate("Shortcut Dimension 1 Code");
                                GenJnline."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnline.Validate("Shortcut Dimension 2 Code");
                                GenJnline.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnline.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnline.Validate(Quantity);
                                GenJnline.Validate("Unit Amount");
                                GenJnline."Reason Code" := '221';
                                GenJnline.Validate("Reason Code");
                                GenJnline.Insert(true);

                                ReqLine."Quantity Issued" := ReqLine."Quantity Issued" + ReqLine."Quantity To Issue";
                                ReqLine."Quantity To Issue" := 0;

                                if ReqLine."Quantity Issued" = ReqLine."Quantity Requested" then
                                    ReqLine."Request Status" := ReqLine."Request Status"::Closed;
                                ReqLine.Modify;
                            end;
                            until ReqLine.Next = 0;
                            //Post Entries
                            GenJnline.Reset;
                            GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Item Issue Template");
                            //
                            GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Item Issue Batch");
                            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", GenJnline);
                            //End Post entries

                            //Modify All

                            Post := JournlPosted.PostedSuccessfully();
                            if Post then
                                ReqLine.ModifyAll(ReqLine."Request Status", ReqLine."Request Status"::Closed);

                        end;

                        Post := true;
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        if ReqLine.Find('-') then begin
                            repeat
                            begin
                                if ReqLine."Quantity Issued" <> ReqLine."Quantity Requested" then
                                    if (Post = true) then
                                        Post := false;
                            end;
                            until ReqLine.Next = 0;
                        end;
                        if Post = true then begin
                            Rec.Status := Rec.Status::Posted;
                            Rec.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                separator(Separator1000000010)
                {
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::Requisition;
                        //  ApprovalEntries.Setfilters(DATABASE::"PROC-Store Requistion Header", DocumentType, Rec."No.");
                        //  ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    ApplicationArea = all;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                    // ApprovalsMngt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        // ApprovalsMngt.CheckStoreRequisitionApprovalPossible(Rec);
                        // ApprovalsMngt.OnSendStoreRequisitionForApproval(Rec);

                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = all;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;


                    trigger OnAction()
                    var
                    // ApprovalsMngt: Codeunit "Approval Mgmnt. Ext";
                    begin
                        //  ApprovalsMngt.OnCancelStoreRequisitionForApproval(Rec);

                    end;
                }
                separator(Separator1000000006)
                {
                }


            }
        }
        area(Reporting)
        {
            group(Report)
            {
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedOnly = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(60001, true, true, Rec);
                        Rec.Reset;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls();
        Rec.SetFilter("User ID", UserId);
    end;

    trigger OnInit()
    begin
        Rec.SetFilter("User ID", UserId);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("User ID", UserId);
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        //todo   ApprovalMgt: Codeunit "Approvals Management";
        ReqLine: Record "PROC-Store Requistion Lines";
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        //todo  MinorAssetsIssue: Record "FIN-Minor Ass. Issue & Returns";
        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "FIN-Budgetary Control Setup";
        DeleteCommitment: Record "FIN-Committment";
        Loc: Record Location;
        // ApprovalEntries: Page "Approval Entries-MA";
        EditInfo: Boolean;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "PROC-Store Requistion Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Requistion No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    local procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Open then
            EditInfo := true
        else
            EditInfo := False;

        /* IF Status<>Status::Released THEN BEGIN
         CurrForm."Issue Date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
         CurrForm."Issue Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;
            IF Status=Status::Open THEN BEGIN
         CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
         CurrForm."Request date" .EDITABLE:=TRUE;
         CurrForm."Responsibility Center" .EDITABLE:=TRUE;
         CurrForm."Issuing Store" .EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
         CurrForm."Required Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
         CurrForm."Request Description".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
          CurrForm."Request date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END
         */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

