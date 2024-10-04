page 52178703 "PROC-Purchase Quote List"
{
    CardPageID = "PROC-Purchase Quot Req. Header";
    Editable = false;
    PageType = List;
    SourceTable = "PROC-Purchase Quote Header";

    layout
    {
        area(content)
        {
            repeater(___)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Expected Opening Date"; Rec."Expected Opening Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Expected Closing Date"; Rec."Expected Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Process")
            {
                Caption = '&Process';
                Image = Process;
                action("Assign Vendor(s)")
                {
                    Caption = 'Assign Vendor(s)';
                    Image = Allocate;
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

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
                separator(____________)
                {

                }
                group(Status)
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

                    trigger OnAction()
                    begin
                        PQH.SETRECFILTER;
                        PQH.SETFILTER(PQH."Document Type", '%1', Rec."Document Type");
                        PQH.SETFILTER("No.", Rec."No.");
                        repVend.SETTABLEVIEW(PQH);
                        repVend.RUN;
                    end;
                }
                action("Get Purchase Requisition Lines")
                {
                    Caption = 'Get Purchase Requisition Lines';
                    Image = GetLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "PROC-PRF Lines";
                    ApplicationArea = All;

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

    var
        PurchHeader: Record "Purchase Header";
        PParams: Record "PROC-Purchase Quote Params";
        Lines: Record "PROC-Purchase Quote Line";
        PQH: Record "PROC-Purchase Quote Header";
        repVend: Report "Purchase Quote Report";
        RFQ: Code[10];
        Purchaselines: Record "Purchase Line";
        GETLINES: Page "PROC-PRF Lines";
}