page 52178704 "PROC-Purchase Quot Req. Header"
{
    PageType = Card;
    SourceTable = "PROC-Purchase Quote Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }

                field("Expected Closing Date"; Rec."Expected Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Expected Opening Date"; Rec."Expected Opening Date")
                {
                    ApplicationArea = All;
                }
                field("Closing Time"; Rec."Closing Time")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(SF; "PROC-Purchase Quote Req. Line")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Set Specification")
                {
                    Caption = 'Set Specification';
                    Image = Splitlines;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PParams.RESET;
                        PParams.SETRANGE(PParams."Document Type", Rec."Document Type");
                        PParams.SETRANGE(PParams."Document No.", Rec."No.");
                        PParams.SETRANGE(PParams."Line No.", CurrPage.SF.PAGE.getLineNo());
                        //PAGE.RUN(39005968,PParams);
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Assign Vendor(s)")
                {
                    Caption = 'Assign Vendor(s)';
                    Image = Allocate;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Vends: Record "PROC-Quotation Request Vendors";
                    begin
                        Vends.RESET;
                        Vends.SETRANGE(Vends."Document Type", Rec."Document Type");
                        Vends.SETRANGE(Vends."Document No.", Rec."No.");

                        PAGE.RUN(52178708, Vends);
                    end;
                }
                separator(_______________)
                {

                }
                action("Bid Analysis")
                {
                    Visible = false;
                    Caption = 'Bid Analysis';
                    Image = Worksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bid Analysis Worksheet";
                    ApplicationArea = All;
                    //RunPageLink = ("RFQ No." =FIELD("No."));

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
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."No.");
                        BidAnalysis.DELETEALL;


                        //insert the quotes from vendors

                        PurchaseHeader.SETRANGE("Request for Quote No.", Rec."No.");
                        PurchaseHeader.FINDSET;
                        REPEAT
                            PurchaseLines.RESET;
                            PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                            IF PurchaseLines.FINDSET THEN
                                REPEAT
                                    BidAnalysis.INIT;
                                    BidAnalysis."RFQ No." := Rec."No.";
                                    BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                                    BidAnalysis."Quote No." := PurchaseLines."Document No.";
                                    BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                    BidAnalysis."Item No." := PurchaseLines."No.";
                                    BidAnalysis.Description := PurchaseLines.Description;
                                    BidAnalysis.Quantity := PurchaseLines.Quantity;
                                    BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                                    BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                                    BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                                    BidAnalysis.INSERT(TRUE);
                                    InsertCount += 1;
                                UNTIL PurchaseLines.NEXT = 0;
                        UNTIL PurchaseHeader.NEXT = 0;
                        //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                    end;
                }
                group(Statuss)
                {
                    Caption = 'Status';
                    action(Cancel)
                    {
                        Caption = 'Cancel';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            IF CONFIRM('Cancel Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.MODIFY;

                        end;
                    }
                    action(Stop)
                    {
                        Caption = 'Stop';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            IF CONFIRM('Close Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                            Rec.Status := Rec.Status::Closed;
                            Rec.MODIFY;

                        end;
                    }
                    action(Close)
                    {
                        Caption = 'Close';
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            IF CONFIRM('Close Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                            Rec.Status := Rec.Status::Closed;
                            Rec.MODIFY;

                        end;
                    }
                    action(Release)
                    {
                        Caption = 'Release';
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedIsBig = true;
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            IF CONFIRM('Release document?', FALSE) = FALSE THEN BEGIN EXIT END;
                            //check if the document has any lines
                            Lines.RESET;
                            Lines.SETRANGE(Lines."Document Type", Rec."Document Type");
                            Lines.SETRANGE(Lines."Document No.", Rec."No.");
                            IF Lines.FINDFIRST THEN BEGIN
                                REPEAT
                                    Lines.TESTFIELD(Lines.Quantity);
                                    //Lines.TESTFIELD(Lines."Direct Unit Cost");
                                    Lines.TESTFIELD("No.");
                                UNTIL Lines.NEXT = 0;
                            END
                            ELSE BEGIN
                                ERROR('Document has no lines');
                            END;

                            Purchaselines.RESET;
                            Purchaselines.SETRANGE(Purchaselines."RFQ No.", Rec."No.");

                            IF Purchaselines.FIND('-') THEN BEGIN
                                REPEAT
                                    Purchaselines."RFQ Created" := TRUE;
                                    Purchaselines.MODIFY;
                                UNTIL Purchaselines.NEXT = 0;

                            END;

                            Rec.Status := Rec.Status::Released;
                            Rec.MODIFY;
                        end;
                    }
                    action(Reopen)
                    {
                        Caption = 'Reopen';
                        Image = ReOpen;
                        Promoted = true;
                        PromotedIsBig = true;
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type", PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Procurement Request No.", Rec."No.");
                            IF PurchHeader.FINDFIRST THEN BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                            END;

                            IF CONFIRM('Reopen Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                            Rec.Status := Rec.Status::Open;
                            Rec.MODIFY;
                        end;
                    }
                }
                action("&Print/Preview")
                {
                    Caption = '&Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        // PQH.SETRECFILTER;
                        // PQH.SETFILTER(PQH."Document Type", '%1', Rec."Document Type");

                        // PQH.SETFILTER("No.", Rec."No.");
                        // repVend.SETTABLEVIEW(PQH);
                        // repVend.RUN;

                        vends.RESET;
                        vends.SETRANGE(vends."Document No.", Rec."No.");
                        IF vends.FIND('-') THEN BEGIN
                            REPORT.RUN(52178891, TRUE, FALSE, vends);
                        END;

                    end;
                }
                action("Get Purchase Requisition Lines")
                {
                    Caption = 'Get Purchase Requisition Lines';
                    Image = GetLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    RunObject = Page "PROC-PRF Lines";

                    trigger OnAction()
                    begin
                        CLEAR(GETLINES);
                        RFQ := Rec."No.";
                        GETLINES.GetRFQ(RFQ);
                        GETLINES.RUNMODAL();
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF Rec.Status = Rec.Status::Released THEN BEGIN
            ERROR('The RFQ has already been released you cannot delete records');
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Created By" := USERID;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PParams: Record "PROC-Purchase Quote Params";
        Lines: Record "PROC-Purchase Quote Line";
        PQH: Record "PROC-Purchase Quote Header";
        repVend: Report "Purchase Quote Report";
        RFQ: Code[10];
        vends: Record "PROC-Quotation Request Vendors";
        Purchaselines: Record "Purchase line";
        GETLINES: Page "PROC-PRF Lines";
}