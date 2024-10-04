pageextension 52178717 chartofaccounts extends "Chart of Accounts"
{
    layout
    {
        modify("No.")
        {
            Caption = 'ERP Code';
        }
        modify("Income/Balance")
        {
            Caption = 'Category';
        }
        modify("Account Type")
        {
            Caption = 'Category Type';
        }
        addafter("No.")
        {
            // field("Sage Account"; Rec."Sage Account")
            // {
            //     Caption = 'Sage Code';
            // }
            // field("New Code"; Rec."New Code")
            // {

            // }

        }
    }
    actions
    {
        addafter("G/L Register")
        {
            action(printReport)
            {
                Caption = 'Trial Balance Summary';
                ApplicationArea = All;
                RunObject = report "Trial Balance Detail/Summary2";
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

            }

        }


    }
    // trigger OnOpenPage()
    // begin
    //     Rec.SetFilter(hide, '%1', false);
    // end;
}
