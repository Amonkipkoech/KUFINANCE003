page 52178706 "Bid Analysis Worksheet"
{
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "PROC-Bid Analysis";

    layout
    {
        area(content)
        {
            group(___)
            {
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    Caption = 'Vendor Code Filter';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendList: Page "Vendor List";
                    begin
                        BEGIN
                            VendList.LOOKUPMODE := TRUE;
                            IF VendList.RUNMODAL = ACTION::LookupOK THEN
                                Text := VendList.GetSelectionFilter
                            ELSE
                                EXIT(FALSE);
                        END;

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilter; ItemNoFilter)
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LOOKUPMODE := TRUE;
                        IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                            Text := ItemList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(Total; Rec.Total)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RFQ Line No."; Rec."RFQ Line No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(VendorName; VendorName)
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Vendor Quotations")
            {
                Caption = 'Get Vendor Quotations';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    GetVendorQuotes;
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Bid Analysis1";
                ApplicationArea = All;

                trigger OnAction()
                begin
                    BidAnalysis.RESET;
                    BidAnalysis.SETRANGE("RFQ No.", Rec."RFQ No.");
                    //RFQ No.,RFQ Line No.,Quote No.,Vendor No.
                    IF BidAnalysis.FINDFIRST THEN
                        REPORT.RUN(REPORT::"Bid Analysis1", TRUE, FALSE, BidAnalysis);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vendor.GET(Rec."Vendor No.");
        VendorName := Vendor.Name;
        CalcTotals;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLines: Record "Purchase Line";
        ItemNoFilter: Text[250];
        RFQNoFilter: Text[250];
        InsertCount: Integer;
        SalesCodeFilter: Text[250];
        VendorName: Text;
        Vendor: Record "Vendor";
        Total: Decimal;
        BidAnalysis: Record "PROC-Bid Analysis";

    procedure SetRecFilters()
    begin
        IF SalesCodeFilter <> '' THEN
            Rec.SETFILTER("Vendor No.", SalesCodeFilter)
        ELSE
            Rec.SETRANGE("Vendor No.");

        IF ItemNoFilter <> '' THEN BEGIN
            Rec.SETFILTER("Item No.", ItemNoFilter);
        END ELSE
            Rec.SETRANGE("Item No.");

        CalcTotals;

        CurrPage.UPDATE(FALSE);
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure GetVendorQuotes()
    begin
        //insert the quotes from vendors
        IF RFQNoFilter = '' THEN ERROR('Specify the RFQ No.');

        PurchHeader.SETRANGE("RFQ No.", RFQNoFilter);
        PurchHeader.FINDSET;
        REPEAT
            PurchLines.RESET;
            PurchLines.SETRANGE("Document No.", PurchHeader."No.");
            IF PurchLines.FINDSET THEN
                REPEAT
                    Rec.INIT;
                    Rec."RFQ No." := PurchHeader."RFQ No.";
                    Rec."RFQ Line No." := PurchLines."Line No.";
                    Rec."Quote No." := PurchLines."Document No.";
                    Rec."Vendor No." := PurchLines."Buy-from Vendor No.";
                    Rec."Item No." := PurchLines."No.";
                    Rec.Description := PurchLines.Description;
                    Rec.Quantity := PurchLines.Quantity;
                    Rec."Unit Of Measure" := PurchLines."Unit of Measure";
                    Rec.Amount := PurchLines."Direct Unit Cost";
                    //   "Vat Amount":=PurchLines."VAT Amount";
                    Rec."Line Amount" := Rec.Quantity * Rec.Amount;
                    Rec.INSERT(TRUE);
                    InsertCount := +1;
                UNTIL PurchLines.NEXT = 0;
        UNTIL PurchHeader.NEXT = 0;
        MESSAGE('%1 records have been inserted to the bid analysis');
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure CalcTotals()
    var
        BidAnalysisRec: Record "PROC-Bid Analysis";
    begin
        BidAnalysisRec.SETRANGE("RFQ No.", Rec."RFQ No.");
        IF SalesCodeFilter <> '' THEN
            BidAnalysisRec.SETRANGE("Vendor No.", SalesCodeFilter);
        IF ItemNoFilter <> '' THEN
            BidAnalysisRec.SETRANGE("Item No.", ItemNoFilter);
        BidAnalysisRec.FINDSET;
        BidAnalysisRec.CALCSUMS("Line Amount");
        Rec.Total := BidAnalysisRec."Line Amount";
    end;
}