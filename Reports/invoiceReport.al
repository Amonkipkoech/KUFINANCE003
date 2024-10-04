report 52178713 "Purchase Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/invoiceReport.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(purchseInv; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Due_Date; "Due Date")
            {

            }
            column(pic; CompanyInformation.Picture)
            {

            }
            column(name; CompanyInformation.Name)
            {

            }
            column(poBox; poBox)
            {

            }
            column(location; location)
            {

            }
            column(email; email)
            {
            }
            column(contact; contact)
            {
            }

            dataitem(purLines; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                {

                }
            }
            trigger OnAfterGetRecord()
            begin
                vend.Reset();
                vend.SetRange("No.", "No.");
                if vend.Find('-') then begin
                    poBox := vend.Address;
                    location := vend.City;
                    email := vend."E-Mail";
                    contact := vend."Contact Person";
                    Modify();
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

        CompanyInformation: Record 79;
        vend: Record Vendor;
        poBox: text[100];
        location: text[100];
        email: text[100];
        contact: text[100];


}