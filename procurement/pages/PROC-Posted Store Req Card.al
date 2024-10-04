page 52178768 "PROC-Posted Store Reqs"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PROC-Store Requistion Header";
    SourceTableView = WHERE(Status = FILTER(Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Requisition Type"; Rec."Requisition Type")
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = all;
                }
                field("SRN.No"; Rec."SRN.No")
                {
                    ApplicationArea = all;
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(Control1; "PROC-Store Requisition Line UP")
                {

                    ApplicationArea = all;
                    SubPageLink = "Requistion No" = FIELD("No.");
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
                action(Details)
                {
                    ApplicationArea = all;
                    Caption = 'Details';
                    Image = List;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "PROC-Posted Store Req. Lines";
                    RunPageLink = "Requistion No" = FIELD("No.");
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::Requisition;
                        ApprovalEntries.Setfilters(DATABASE::"PROC-Store Requistion Header", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Print/Preview")
                {
                    ApplicationArea = all;
                    Caption = 'Print/Preview';

                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(51271, true, true, Rec);
                        Rec.Reset;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls();
        // OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        Rec."Responsibility Center" := 'MAIN';
        // OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        UpdateControls;
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        //todo  ApprovalMgt: Codeunit "Approvals Management";
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
        //todo MinorAssetsIssue: Record "FIN-Minor Ass. Issue & Returns";
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

