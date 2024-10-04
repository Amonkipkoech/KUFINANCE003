xmlport 52178701 "Import Vendors"
{
    Caption = 'Import Vendors';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    DefaultFieldsValidation = false;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(Vendor; Vendor)
            {
                fieldattribute(VendorNo; Vendor."No.")
                {

                }
                fieldattribute(VendorName; Vendor.Name)
                {

                }
                fieldattribute(Address; Vendor.Address)
                {

                }
                fieldattribute(City; Vendor.City)
                {

                }
                fieldattribute(Phone; Vendor."Phone No.")
                {

                }
                fieldattribute(Email; Vendor."E-Mail")
                {

                }
                fieldelement(Gen_BS_Posting_G; Vendor."Gen. Bus. Posting Group")
                {

                }
                fieldelement(Vendor_Posting_G; Vendor."Vendor Posting Group")
                {

                }
            }
        }
    }

}