report 52178718 "Vendor Statement Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/vendorStament.rdl';

    dataset
    {
        dataitem(Vend; 23)
        {
            RequestFilterFields = "No.", "Date Filter";

            column(No_; "No.")
            {
            }
            column(Name; Name)
            {
            }
            // column(First_Name; "First Name")
            // {

            // }
            // column(Middle_Name; "Middle Name")
            // {

            // }
            // column(Last_Name; "Last Name")
            // {

            // }\
            column(Balance; vend.Balance)
            {
            }
            column(campus; Vend."Global Dimension 1 Code")
            {
            }

            column(compName; CompanyInformation.Name)
            {
            }
            column(address; CompanyInformation.Address + ',' + CompanyInformation."Address 2")
            {
            }
            column(phones; CompanyInformation."Phone No." + '/' + CompanyInformation."Phone No. 2")
            {
            }
            column(pics; CompanyInformation.Picture)
            {
            }
            column(mails; CompanyInformation."E-Mail" + '/' + CompanyInformation."Home Page")
            {
            }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = field("No.");
                DataItemTableView = sorting("Posting Date")
                                   ORDER(Ascending)
                                   WHERE("Entry Type" = FILTER("Initial Entry"));

                column(pDate; vendLedgeretry."Posting Date")
                {
                }
                column(DocNo; vendLedgeretry."Document No.")
                {
                }
                column(Desc; (vendLedgeretry.Description) + vendLedgeretry."External Document No.")
                {
                }
                // column(Desc; COPYSTR(CustLedgerEntry.Description, 1, 35) + CustLedgerEntry."External Document No.")
                // {
                // }
                column(Amount; "Detailed Vendor Ledg. Entry".Amount)
                {
                }
                column(DebitAm; "Detailed Vendor Ledg. Entry"."Debit Amount")
                {
                }
                column(CreditAm; "Detailed Vendor Ledg. Entry"."Credit Amount")
                {
                }
                column(runningBal; runningBal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //runningBal:=runningBal+"Detailed Cust. Ledg. Entry"."Debit Amount"-"Detailed Cust. Ledg. Entry"."Credit Amount";
                    vendLedgeretry.RESET;
                    vendLedgeretry.SETRANGE(vendLedgeretry."Entry No.", "Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.");
                    IF vendLedgeretry.FIND('-') THEN BEGIN
                        IF vendLedgeretry.Reversed THEN CurrReport.SKIP;
                    END;
                    runningBal := runningBal + "Detailed Vendor Ledg. Entry".Amount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(runningBal);

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

    trigger OnInitReport()
    begin
        CompanyInformation.RESET;
        IF CompanyInformation.FIND('-') THEN BEGIN
            CompanyInformation.CALCFIELDS(Picture);
        END;
    end;

    var
        runningBal: Decimal;
        //ACACourseRegistration: Record 61532;
        //Progs: Record 61511;
        vendLedgeretry: Record 25;
        CompanyInformation: Record 79;
}

