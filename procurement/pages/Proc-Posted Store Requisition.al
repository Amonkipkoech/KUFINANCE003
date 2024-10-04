page 52178767 "PROC-Posted Store Requisition"
{
    CardPageID = "PROC-Posted Store Reqs";
    PageType = List;
    SourceTable = "PROC-Store Requistion Header";
    SourceTableView = WHERE(Status = FILTER(Posted));
    Caption = 'Posted STRQ';
    ApplicationArea = all;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = all;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = all;
                }
                field(Justification; Rec.Justification)
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
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = all;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    ApplicationArea = all;
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                }
                field("Store Requisition Type"; Rec."Store Requisition Type")
                {
                    ApplicationArea = all;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = all;
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = all;
                }
                field("SRN.No"; Rec."SRN.No")
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
                    ApplicationArea = all;
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    begin

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
                separator(Separator11)
                {
                    IsHeader = true;
                    Caption = 'Approvals';
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    PromotedCategory = Process;
                    Image = Approvals;
                    Promoted = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::Requisition;
                        ApprovalEntries.Setfilters(DATABASE::"PROC-Store Requistion Header", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                separator(Separator12)
                {
                    IsHeader = true;

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
                    //  ApprovalsMngt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        //ApprovalsMngt.CheckStoreRequisitionApprovalPossible(Rec);
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
                separator(Separator7)
                {
                }
                action("Check Budget Availlabilty")
                {
                    Caption = 'Check Budget Availlabilty';
                    Image = Check;
                    Promoted = true;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin

                    end;
                }
                separator(Separator5)
                {
                }
                action("Cancel Budget Commitments")
                {
                    Caption = 'Cancel Budget Commitments';
                    Image = CancelLine;
                    Promoted = true;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                    end;
                }
                separator(Separator3)
                {
                }
                action("Print/Preview")
                {
                    ApplicationArea = all;
                    Caption = 'Print/Preview';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;


                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(60001, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Separator1)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //  Rec.SetFilter("User ID", UserId);
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        // ApprovalMgt: Codeunit "Approvals Management";
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
        //    MinorAssetsIssue: Record "FIN-Minor Ass. Issue & Returns";
        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "FIN-Budgetary Control Setup";
        DeleteCommitment: Record "FIN-Committment";
        Loc: Record Location;
        ApprovalEntries: Page "Approval Entries";

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

    procedure UpdateControls()
    begin

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

