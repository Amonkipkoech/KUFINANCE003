report 52178715 SalesInvoice
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/salesinvoice.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(salesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Bill_to_Address; "Bill-to Address")
            {

            }
            column(Document_Date; format("Document Date"))
            {

            }
            column(Due_Date; Format("Due Date"))
            {

            }
            column(Work_Description; "Work Description")
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
            column(pin; pin)
            {

            }
            column(glName; glName)
            {

            }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(itemNo; "No.")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
                // column(exclVatAmount; Amount)
                // {

                // }
                column(Amount; Amount)
                {

                }
                column(Description; Description)
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(vatAmount; vatAmount)
                {

                }
                column(vatPercentage; vatPercentage)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    gl.Reset();
                    gl.SetRange("No.", "Sales Line"."No.");
                    if gl.Find('-') then begin
                        glName := gl.Name;
                        if gl."VAT Bus. Posting Group" = 'VAT 16' then begin
                            vatAmount := Amount * 0.16;
                            vatPercentage := 16;
                        end;



                    end;
                end;



            }
            trigger OnAfterGetRecord()
            begin
                cust.Reset();
                cust.SetRange("No.", salesHeader."Sell-to Customer No.");
                if cust.Find('-') then begin
                    poBox := cust.Address;
                    location := cust.City;
                    email := cust."E-Mail";
                    contact := cust.Contact;
                    pin := cust."VAT Registration No.";
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

        CompanyInformation: Record 79;
        cust: Record Customer;
        poBox: text[100];
        location: text[100];
        email: text[100];
        contact: text[100];
        gl: Record "G/L Account";
        vatAmount: Decimal;
        vatPercentage: Decimal;
        pin: code[20];
        glName: Text[100];
}