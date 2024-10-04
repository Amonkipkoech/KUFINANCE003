report 52178719 purchaseOrderReport
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Reports/SSR/purchaseOrderReport.rdl';
    ApplicationArea = All;


    dataset
    {
        dataitem(lpo; "Purchase Header")
        {
            RequestFilterFields = Status, "No.", "Shortcut Dimension 2 Code";
            DataItemTableView = where("Document Type" = filter('Order'));
            column(No_; "No.")
            {

            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {

            }
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Document_Date; format("Document Date"))
            {

            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {

            }
            column(Status; Status)
            {

            }
            column(pic; CompanyInformation.Picture)
            {

            }
            column(name; CompanyInformation.Name)
            {

            }
            column(departName; departName)
            {

            }
            trigger OnAfterGetRecord()
            begin
                dimV.Reset();
                dimV.SetRange(Code, "Shortcut Dimension 2 Code");
                if dimV.Find('-') then begin
                    departName := dimV.Name;
                end;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnInitReport()
    begin


        CompanyInformation.RESET;
        IF CompanyInformation.FIND('-') THEN BEGIN
            CompanyInformation.CALCFIELDS(Picture);

        END;

    end;

    var
        myInt: Integer;
        CompanyInformation: Record 79;
        dimV: Record "Dimension Value";
        departName: Text[100];
}