pageextension 52178720 "Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        modify(Status)
        {
            Editable = true;
        }
    }
    actions
    {
        addafter(TestReport)
        {
            action(printReport)
            {
                Caption = 'Print Invoice';
                ApplicationArea = All;
                RunObject = report "Purchase Invoice";
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
            }

        }


    }


}

