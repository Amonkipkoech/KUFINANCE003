report 52178799 budgetTemplate
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/budgetTemplate.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("G/L Budget Entry"; "G/L Budget Entry")
        {
            RequestFilterFields = "Budget Dimension 1 Code", "Global Dimension 2 Code";
            column(Budget_Name; "Budget Name")
            {

            }
            column(G_L_Account_No_; "G/L Account No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {

            }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {

            }
            column(Budget_Dimension_1_Code; "Budget Dimension 1 Code")
            {

            }
            column(Amount; Amount)
            {

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
        cust: Record Customer;
        poBox: text[100];
        location: text[100];
        email: text[100];
        contact: text[100];
        gl: Record "G/L Account";
        vatAmount: Decimal;
        vatPercentage: Decimal;
}