report 52178897 "Journal Validate"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/Post Billing.rdl';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; 81)
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(Bal__Account_Type; "Bal. Account Type")
            {

            }
            column(Bal__Account_No_; "Bal. Account No.")
            {

            }
            trigger OnAfterGetRecord()
            var
            begin
                Validate("Bal. Account No.");
                Modify();
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

    

    var
        myInt: Integer;
        
}