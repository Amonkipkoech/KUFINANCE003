page 52178702 "FIN-Purchase Requisition"
{
    CardPageID = "PROC-Internal Requisitions";
    PageType = List;
    Editable = false;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send,Make Order,Check Budget';
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Quote));
    //                         DocApprovalType = FILTER(Requisition),
    //                         Status = FILTER(<> Released));

    //SourceTableView = WHERE("Document Type" = FILTER(Quote));

    layout
    {
        area(content)
        {
            repeater(Group)
            {


                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = All;
                }

                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Department';
                    ApplicationArea = All;
                }

                // field("Location Code"; Rec."Location Code")
                // {
                //     ApplicationArea = All;
                // }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                // field("Receiving No."; Rec."Receiving No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Posting No."; Rec."Posting No.")
                // {
                //     ApplicationArea = All;
                // }

                // field("No. of Archived Versions"; Rec."No. of Archived Versions")
                // {
                //     ApplicationArea = All;
                // }
                // field("Doc. No. Occurrence"; Rec."Doc. No. Occurrence")
                // {
                //     ApplicationArea = All;
                // }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                // field("PO Status"; Rec."PO Status")
                // {
                //     ApplicationArea = All;
                // }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quote")
            {
                Caption = '&Quote';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ApplicationArea = All;


                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 26;
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 66;
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."), "Document Line No." = CONST(0);
                    ApplicationArea = All;
                }
                action(Dimensionss)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Category6;

                    // trigger OnAction()
                    // var
                    //     ApprovalEntries: Page "658";
                    // begin
                    //     ApprovalEntries.Setfilters(DATABASE::"Purchase Header", Rec."Document Type", Rec."No.");
                    //     ApprovalEntries.RUN;
                    // end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(2);
                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ShowDimensions;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    Caption = 'Item Charge &Assignment';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ItemChargeAssgnt;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.OpenItemTrackingLines;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Make &Order")
            {
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category11;
                PromotedIsBig = true;
                Visible = false;

                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";

                begin

                    CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(_________________)
                {

                }
                action("E&xplode BOM")
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ExplodeBOM;
                    end;
                }
                action("Insert &Ext. Texts")
                {
                    Caption = 'Insert &Ext. Texts';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.InsertExtendedText(TRUE);
                    end;
                }
                separator(_____________)
                {

                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(____________)
                {

                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RUNMODAL;
                        CLEAR(CopyPurchDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    Caption = 'Archi&ve Document';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                separator(__________________)
                {

                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmnt. Ext";
                    begin
                        ApprovalMgt.CheckPurchaseRequisitionApprovalPossible(Rec);
                        ApprovalMgt.OnSendPurchaseRequisitionForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelledEntries;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmnt. Ext";
                    begin
                        ApprovalMgt.OnCancelPurchaseRequisitionForApproval(Rec);
                    end;
                }
                separator(_______________)
                {

                }
                action("Check Budget Availability")
                {
                    Caption = 'Check Budget Availability';
                    Image = CheckLedger;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Category11;

                    trigger OnAction()
                    var
                        BCSetup: Record "FIN-Budgetary Control Setup";
                    begin

                    end;
                }

                separator(________________)
                {

                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        IF LinesCommitted THEN
                            ERROR('All Lines should be committed');

                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        IF LinesCommitted THEN
                            ERROR('All Lines should be committed');

                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(________________________)
                {

                }
                action("&Send BizTalk Rqst. for Purch. Quote")
                {
                    Caption = '&Send BizTalk Rqst. for Purch. Quote';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    //ApprovalMgt: Codeunit "Approvals Management";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
                        //  BizTalkManagement.SendReqforPurchQuote(Rec);
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.RESET();
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(52178738, TRUE, TRUE, Rec);
                    //Rec.RESET;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action(PurchHistoryBtn)
            {
                Caption = 'Purchase H&istory';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtnVisible;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Pay-to Vendor No.",TRUE);
                end;
            }
            action(PurchHistoryBtn1)
            {
                Caption = 'Purchase Histor&y';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtn1Visible;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Buy-from Vendor No.",FALSE);
                end;
            }

        }
    }

    var
        PurchSetup: Record "Purchases & Payables Setup";
        CopyPurchDoc: Report "Copy Purchase Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit "ArchiveManagement";
        PurchInfoPaneMgmt: Codeunit "Purchases Info-Pane Management";
        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "FIN-Budgetary Control Setup";
        DeleteCommitment: Record "FIN-Committment";
        PurchLine: Record "Purchase Line";
        [InDataSet]

        PurchHistoryBtnVisible: Boolean;
        [InDataSet]
        PayToCommentPictVisible: Boolean;
        [InDataSet]
        PayToCommentBtnVisible: Boolean;
        [InDataSet]
        PurchHistoryBtn1Visible: Boolean;
        [InDataSet]
        PurchLinesEditable: Boolean;
        Text19023272: Label 'Buy-from Vendor';
        Text19005663: Label 'Pay-to Vendor';
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;

    local procedure ApproveCalcInvDisc()
    begin
        //CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure UpdateInfoPanel()
    var
        DifferBuyFromPayTo: Boolean;
    begin
        DifferBuyFromPayTo := Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.";
        PurchHistoryBtnVisible := DifferBuyFromPayTo;
        PayToCommentPictVisible := DifferBuyFromPayTo;
        PayToCommentBtnVisible := DifferBuyFromPayTo;
    end;

    //[Scope('Internal')]
    procedure LinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
        IF BCSetup.GET() THEN BEGIN
            IF NOT BCSetup.Mandatory THEN BEGIN
                Exists := FALSE;
                EXIT;
            END;
        END ELSE BEGIN
            Exists := FALSE;
            EXIT;
        END;
        IF BCSetup.GET THEN BEGIN
            Exists := FALSE;
            PurchLines.RESET;
            PurchLines.SETRANGE(PurchLines."Document Type", Rec."Document Type");
            PurchLines.SETRANGE(PurchLines."Document No.", Rec."No.");
            PurchLines.SETRANGE(PurchLines.Committed, FALSE);
            IF PurchLines.FIND('-') THEN
                Exists := TRUE;
        END ELSE
            Exists := FALSE;
    end;

    //[Scope('Internal')]
    procedure SomeLinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
        IF BCSetup.GET THEN BEGIN
            Exists := FALSE;
            PurchLines.RESET;
            PurchLines.SETRANGE(PurchLines."Document Type", Rec."Document Type");
            PurchLines.SETRANGE(PurchLines."Document No.", Rec."No.");
            PurchLines.SETRANGE(PurchLines.Committed, TRUE);
            IF PurchLines.FIND('-') THEN
                Exists := TRUE;
        END ELSE
            Exists := FALSE;
    end;

    //[Scope('Internal')]
    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Open THEN BEGIN
            PurchLinesEditable := FALSE;
        END ELSE
            PurchLinesEditable := TRUE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    // local procedure OnAfterGetCurrRecord()
    // begin
    //     xRec := Rec;

    //     UpdateControls;
    // end;
}