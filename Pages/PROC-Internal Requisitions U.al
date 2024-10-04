page 52178701 "PROC-Internal Requisitions"
{
    Caption = 'Internal Requisition';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send,Make Order,Check Budget';
    SourceTable = 38;
    //SourceTableView = WHERE("Document Type" = FILTER(Quote), DocApprovalType = FILTER(Requisition));
    //                         Status = FILTER(<> Released));
    //SourceTableView = WHERE("Document Type" = FILTER(Quote), Status = FILTER(<> Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    //ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                        Rec."Buy-from Vendor No." := Text19005664;
                    end;



                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;

                    // trigger OnValidate()
                    // begin
                    //     ShortcutDimension2CodeOnAfterV;
                    // end;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Procurement Type Code"; Rec."Procurement Type Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }

                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Caption = 'Requestor User ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(DocApprovalType; Rec.DocApprovalType)
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PurchLines; 97)
            {
                ApplicationArea = All;
                Editable = PurchLinesEditable;
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(VendInfoPanel)
            {
                Caption = 'Vendor Information';
                // label(Reqy)
                // {
                //     CaptionClass = Text19023272;
                // }
                // label(yrt)
                // {
                //     Editable = false;
                // }
                // label(iruru)
                // {
                //     CaptionClass = Text19005663;
                // }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        /*CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                         */

                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Entry Point"; Rec."Entry Point")
                {
                    ApplicationArea = All;
                }

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
                        Rec.CalcInvDiscForHeader();
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."), "Document Line No." = CONST(0);
                    ApplicationArea = All;
                }
                action(Dimension)
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
                PromotedCategory = Category10;
                PromotedIsBig = true;
                Visible = false;

                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record 36;

                begin


                    CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
            // action(Attachments1)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Attachments';

            //     trigger OnAction()
            //     var
            //         RecRef: RecordRef;
            //         DocumentAttachment: Page "Document Attachment Custom";
            //     begin
            //         Clear(DocumentAttachment);
            //         RecRef.GETTABLE(Rec);
            //         DocumentAttachment.OpenForRecReference(RecRef);
            //         DocumentAttachment.RUNMODAL;
            //     end;
            // }
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
                separator(_________________________________________)
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
                separator(____________________)
                {

                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record 175;
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(________________)
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
                separator(_______________)
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
                        ApprovalsMgmt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        ApprovalsMgmt.CheckPurchaseRequisitionApprovalPossible(Rec);
                        ApprovalsMgmt.OnSendPurchaseRequisitionForApproval(Rec);
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
                        ApprovalsMgmt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        ApprovalsMgmt.OnCancelPurchaseRequisitionForApproval(Rec);
                    end;
                }
                separator(________________________________)
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

                separator(______________________________)
                {

                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;


                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;


                }
                separator(________)
                {

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
                    Rec.RESET;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        PurchLinesEditable := TRUE;
        PurchHistoryBtn1Visible := TRUE;
        PayToCommentBtnVisible := TRUE;
        PayToCommentPictVisible := TRUE;
        PurchHistoryBtnVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        /*//Add dimensions if set by default here
        "Shortcut Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
        VALIDATE("Shortcut Dimension 1 Code");
        "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
        VALIDATE("Shortcut Dimension 2 Code");*/


        Rec.DocApprovalType := Rec.DocApprovalType::Requisition;
        Rec."Assigned User ID" := USERID;

        UpdateControls;
        //OnAfterGetCurrRecord;

    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
    end;

    var
        vend: Record Vendor;
        PurchSetup: Record 312;
        CopyPurchDoc: Report 492;
        DocPrint: Codeunit 229;
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchInfoPaneMgmt: Codeunit "Purchases Info-Pane Management";
        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "FIN-Budgetary Control Setup";
        DeleteCommitment: Record "FIN-Committment";
        PurchLine: Record 39;
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
        Text19005664: Label 'DEPART';



    procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure UpdateInfoPanel()
    var
        DifferBuyFromPayTo: Boolean;
    begin
        DifferBuyFromPayTo := Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.";
        PurchHistoryBtnVisible := DifferBuyFromPayTo;
        PayToCommentPictVisible := DifferBuyFromPayTo;
        PayToCommentBtnVisible := DifferBuyFromPayTo;
        //PurchHistoryBtn1Visible := PurchInfoPaneMgmt.DocExist(Rec,"Buy-from Vendor No.");

    end;


    procedure LinesCommitted() Exists: Boolean
    var
        PurchLines: Record 39;
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

    procedure SomeLinesCommitted() Exists: Boolean
    var
        PurchLines: Record 39;
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


    procedure UpdateControls()
    begin
        IF Rec.Status <> Rec.Status::Open THEN BEGIN
            PurchLinesEditable := FALSE;
        END ELSE
            PurchLinesEditable := TRUE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;


    // local procedure OnAfterGetCurrRecord()
    // begin
    //     xRec := Rec;

    //     UpdateControls;
    // end;
}
