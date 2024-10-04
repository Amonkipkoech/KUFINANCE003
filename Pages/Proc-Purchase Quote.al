page 52178789 "Proc-Purchase Quote"
{
    Caption = 'Purchase Quote';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    // SourceTableView = WHERE("Document Type" = FILTER(Quote),
    //                         "Document Type 2" = FILTER(Quote),
    //                         DocApprovalType = FILTER(Quote));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    Importance = Promoted;
                    Visible = DocNoVisible;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Vendor';
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec.GETFILTER("Buy-from Vendor No.") = xRec."Buy-from Vendor No." THEN
                            IF Rec."Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN
                                Rec.SETRANGE("Buy-from Vendor No.");

                        CurrPage.UPDATE;
                    end;
                }

                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Request for Quote No."; Rec."Request for Quote No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = All;
                }


                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Importance = Standard;
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
            }
            part(PurchLines; 97)
            {
                ApplicationArea = All;
                Editable = Rec."Buy-from Vendor No." <> '';
                Enabled = Rec."Buy-from Vendor No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code"; Rec."Currency Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
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

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = All;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';
                    ApplicationArea = All;
                }
            }

        }
        area(factboxes)
        {
            part(Factbox; 9103)
            {
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = All;
            }
            part("Buy from Vendor"; 9093)
            {
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                Visible = false;
                ApplicationArea = All;
            }
            part("Pay to Vendor No"; 9094)
            {
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                ApplicationArea = All;
            }
            part("Buy from Vendor No"; 9095)
            {
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                ApplicationArea = All;
            }
            part("Pay to Vendor"; 9096)
            {
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                Visible = false;
                ApplicationArea = All;
            }
            part("Purchase Line"; 9100)
            {
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                ApplicationArea = All;
            }
            part("Table Id"; 9092)
            {
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            part(IncomingDocAttachFactBox; 193)
            {
                ShowFilter = false;
                Visible = false;
                ApplicationArea = All;
            }
            part(WorkflowStatus; 1528)
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
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
                Image = Quote;
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
                        IF Rec."Tax Area Code" = '' THEN
                            PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec)
                        ELSE
                            PAGE.RUNMODAL(PAGE::"Purchase Statistics", Rec);
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Vendor)
                {
                    Caption = 'Vendor';
                    Image = Vendor;
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
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ApplicationArea = All;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(Approvals)
                {

                    AccessByPermission = TableData 454 = R;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        //ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Bid Analysis")
                {
                    Caption = 'Bid Analysis';
                    Image = Worksheet;
                    Visible = false;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    RunObject = Page "Bid Analysis Worksheet";
                    RunPageLink = "RFQ No." = FIELD("Request for Quote No.");

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        ItemNoFilter: Text[250];
                        RFQNoFilter: Text[250];
                        InsertCount: Integer;
                        BidAnalysis: Record "PROC-Bid Analysis";
                    begin
                        //deletebidanalysis for this vendor
                        //BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."No.");
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Request for Quote No.");
                        BidAnalysis.DELETEALL;

                        //insert the quotes from vendors
                        PurchaseHeader.SETRANGE("RFQ No.", Rec."Request For Quote No.");
                        PurchaseHeader.FINDSET;
                        REPEAT
                            PurchaseLines.RESET;
                            PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                            IF PurchaseLines.FINDSET THEN
                                REPEAT
                                    //Message('Im here');
                                    BidAnalysis.INIT;
                                    BidAnalysis."RFQ No." := Rec."Request For Quote No.";
                                    BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                                    BidAnalysis."Quote No." := PurchaseLines."Document No.";
                                    BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                    BidAnalysis."Item No." := PurchaseLines."No.";
                                    BidAnalysis.Description := PurchaseLines.Description;
                                    BidAnalysis.Quantity := PurchaseLines.Quantity;
                                    BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                                    BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                                    //BidAnalysis."Vat Amount":=PurchaseLines."VAT Amount";
                                    BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                                    BidAnalysis.Remarks := PurchaseLines."RFQ Remarks";
                                    IF BidAnalysis.INSERT(TRUE) THEN
                                        InsertCount += 1;
                                UNTIL PurchaseLines.NEXT = 0;
                        UNTIL PurchaseHeader.NEXT = 0;
                        //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                    end;
                }
                // action("Print Bid Analysis")
                // {
                //     Caption = 'Print Bid Analysis';
                //     Image = Report2;
                //     Promoted = true;
                //     PromotedCategory = "Report";
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     var
                //         PurchaseHeader: Record "Purchase Header";
                //         PurchaseLines: Record "Purchase Line";
                //         ItemNoFilter: Text[250];
                //         RFQNoFilter: Text[250];
                //         InsertCount: Integer;
                //         BidAnalysis: Record "PROC-Bid Analysis";
                //     begin
                //         //deletebidanalysis for this vendor
                //         // BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."RFQ No.");
                //         BidAnalysis.DELETEALL;


                //         //insert the quotes from vendors

                //         PurchaseHeader.SETRANGE("RFQ No.", Rec."RFQ No.");
                //         PurchaseHeader.FINDSET;
                //         REPEAT
                //             PurchaseLines.RESET;
                //             PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                //             IF PurchaseLines.FINDSET THEN
                //                 REPEAT
                //                     BidAnalysis.INIT;
                //                     BidAnalysis."RFQ No." := Rec."RFQ No.";
                //                     BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                //                     BidAnalysis."Quote No." := PurchaseLines."Document No.";
                //                     BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                //                     BidAnalysis."Item No." := PurchaseLines."No.";
                //                     BidAnalysis.Description := PurchaseLines.Description;
                //                     BidAnalysis.Quantity := PurchaseLines.Quantity;
                //                     BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                //                     BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                //                     //BidAnalysis."Vat Amount":=PurchaseLines."VAT Amount";
                //                     BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                //                     BidAnalysis.Remarks := PurchaseLines."RFQ Remarks";
                //                     BidAnalysis.INSERT(TRUE);
                //                     InsertCount += 1;
                //                 UNTIL PurchaseLines.NEXT = 0;
                //         UNTIL PurchaseHeader.NEXT = 0;
                //         //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                //         COMMIT;

                //         BidAnalysis.RESET;
                //         BidAnalysis.SETRANGE("RFQ No.", Rec."RFQ No.");
                //         //RFQ No.,RFQ Line No.,Quote No.,Vendor No.
                //         IF BidAnalysis.FIND
                //          THEN
                //             REPORT.RUN(REPORT::"Bid Analysis1", TRUE, FALSE, BidAnalysis);
                //     end;
                // }
                action("Print Bid Analysis")
                {
                    Caption = 'Print Bid Analysis';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        ItemNoFilter: Text[250];
                        RFQNoFilter: Text[250];
                        InsertCount: Integer;
                        BidAnalysis: Record "PROC-Bid Analysis";
                    begin
                        //deletebidanalysis for this vendor
                        //BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."RFQ No.");
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Request for Quote No.");
                        BidAnalysis.DELETEALL;


                        //insert the quotes from vendors

                        PurchaseHeader.SETRANGE("Request For Quote No.", Rec."Request For Quote No.");
                        PurchaseHeader.FINDSET;
                        REPEAT
                            PurchaseLines.RESET;
                            PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                            IF PurchaseLines.FINDSET THEN
                                REPEAT
                                    BidAnalysis.INIT;
                                    BidAnalysis."RFQ No." := Rec."Request For Quote No.";
                                    BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                                    BidAnalysis."Quote No." := PurchaseLines."Document No.";
                                    BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                    BidAnalysis."Item No." := PurchaseLines."No.";
                                    BidAnalysis.Description := PurchaseLines.Description;
                                    BidAnalysis.Quantity := PurchaseLines.Quantity;
                                    BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                                    BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                                    //BidAnalysis."Vat Amount":=PurchaseLines."VAT Amount";
                                    BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                                    BidAnalysis.Remarks := PurchaseLines."RFQ Remarks";
                                    BidAnalysis.INSERT(TRUE);
                                    InsertCount += 1;
                                UNTIL PurchaseLines.NEXT = 0;
                        UNTIL PurchaseHeader.NEXT = 0;
                        //MESSAGE('%1 records have been inserted to the bid analysis', InsertCount);
                        COMMIT;

                        BidAnalysis.RESET;
                        BidAnalysis.SETRANGE("RFQ No.", Rec."Request for Quote No.");
                        //RFQ No.,RFQ Line No.,Quote No.,Vendor No.
                        IF BidAnalysis.FIND
                         THEN
                            REPORT.RUN(REPORT::"Bid Analysis1", TRUE, FALSE, BidAnalysis);
                    end;
                }
            }
        }
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                end;
            }
            action(Delegate)
            {
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                end;
            }
            action(Comment)
            {
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }

            action(Print)
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DocPrint.PrintPurchHeader(Rec);
                end;
            }
            group("Release ")
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit 415;
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit 415;
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData 24 = R;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                        //CurrPage.PurchLines.PAGE.RecalculateTaxes;
                    end;
                }
                separator(____)
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    Image = VendorCode;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record 175;
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                action(CopyDocument)
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RUNMODAL;
                        CLEAR(CopyPurchDoc);
                        IF Rec.GET(Rec."Document Type", Rec."No.") THEN;
                    end;
                }
                action("Archive Document")
                {
                    Caption = 'Archi&ve Document';
                    Image = Archive;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            IncomingDocument: Record 130;
                        begin
                            IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData 130 = R;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        ApplicationArea = All;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record 130;
                        begin
                            Rec.VALIDATE("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RECORDID));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = CreateIncomingDocumentEnabled;
                        Image = Attach;
                        ApplicationArea = All;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record 133;
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ApplicationArea = All;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record 130;
                        begin
                            IF IncomingDocument.GET(Rec."Incoming Document Entry No.") THEN
                                IncomingDocument.RemoveLinkToRelatedRecord;
                            Rec."Incoming Document Entry No." := 0;
                            Rec.MODIFY(TRUE);
                        end;
                    }
                }
            }
            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                Enabled = NOT OpenApprovalEntriesExist;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit 1535;
                begin
                    ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                end;
            }

            group("Make Order ")
            {
                Caption = 'Make Order';
                Image = MakeOrder;
                action("Make Order")
                {
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                            CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Purchase Advice")
            {
                Caption = 'Purchase Advice';
                Image = "Report";
                Promoted = false;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                // RunObject = Report 10155;
            }
            action("Vendor/Item Catalog")
            {
                Caption = 'Vendor/Item Catalog';
                Image = "Report";
                Promoted = false;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                // RunObject = Report 10164;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(Rec.ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Quote;
        Rec."Document Type 2" := Rec."Document Type 2"::Quote;
        Rec.DocApprovalType := Rec.DocApprovalType::Quote;
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;

        IF (NOT DocNoVisible) AND (Rec."No." = '') THEN
            Rec.SetBuyFromVendorFromFilter;
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;

        SetDocNoVisible;
    end;

    var
        CopyPurchDoc: Report 492;
        DocPrint: Codeunit 229;
        UserMgt: Codeunit 5700;
        ArchiveManagement: Codeunit 5063;
        PurchCalcDiscByType: Codeunit 66;
        ChangeExchangeRate: Page 511;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CreateIncomingDocumentEnabled: Boolean;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit 1400;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Quote, Rec."No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit 1535;
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '')
    end;
}
