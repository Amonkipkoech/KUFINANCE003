report 52178721 "Bid Analysis1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/BidAnalysis.rdl';

    dataset
    {
        dataitem(DataItem1102755000; "PROC-Bid Analysis")
        {
            RequestFilterFields = "RFQ No.";
            column(RFQNo_BidAnalysis; DataItem1102755000."RFQ No.")
            {
            }
            column(QuoteNo_BidAnalysis; DataItem1102755000."Quote No.")
            {
            }
            column(VendorNo_BidAnalysis; DataItem1102755000."Vendor No.")
            {
            }
            column(ItemNo_BidAnalysis; DataItem1102755000."Item No.")
            {
            }
            column(Description_BidAnalysis; DataItem1102755000.Description)
            {
            }
            column(Quantity_BidAnalysis; DataItem1102755000.Quantity)
            {
            }
            column(UnitOfMeasure_BidAnalysis; DataItem1102755000."Unit Of Measure")
            {
            }
            column(Amount_BidAnalysis; DataItem1102755000.Amount)
            {
            }
            column(LineAmount_BidAnalysis; DataItem1102755000."Line Amount")
            {
            }
            column(RFQLineNo_BidAnalysis; DataItem1102755000."RFQ Line No.")
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(LastDirectCost_BidAnalysis; DataItem1102755000."Last Direct Cost")
            {
            }
            column(Total_BidAnalysis; DataItem1102755000.Total)
            {
            }
            column(Name_Vendor; VendorName)
            {
            }
            column(SelectedVendor; SelectedVendor)
            {
            }
            column(SelectedPrice; SelectedPrice)
            {
            }
            column(TotalPrice; TotalPrice)
            {
            }
            column(SelectedRemarks; SelectedRemarks)
            {
            }
            column(SelectedVendor_Text001; STRSUBSTNO(Text001, SelectedVendor))
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Vendor.GET(DataItem1102755000."Vendor No.") THEN
                    VendorName := Vendor.Name;
                BidAnalysis.RESET;
                BidAnalysis.SETRANGE("RFQ No.", "RFQ No.");
                BidAnalysis.SETRANGE("RFQ Line No.", "RFQ Line No.");
                BidAnalysis.SETCURRENTKEY(BidAnalysis."RFQ No.", BidAnalysis."RFQ Line No.", BidAnalysis.Amount);
                IF BidAnalysis.FINDFIRST THEN BEGIN
                    Vendor.GET(BidAnalysis."Vendor No.");
                    SelectedVendor := Vendor.Name;
                    SelectedPrice := BidAnalysis.Amount;
                    TotalPrice := BidAnalysis.Amount * BidAnalysis.Quantity;
                    SelectedRemarks := BidAnalysis.Remarks;
                END
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record 79;
        Vendor: Record Vendor;
        BidAnalysis: Record "PROC-Bid Analysis";
        SelectedVendor: Text;
        SelectedPrice: Decimal;
        TotalPrice: Decimal;
        VendorName: Text;
        SelectedRemarks: Text;
        Text001: Label ' Based on Price,  %1  has been Recommended on this bid analysis';
}
