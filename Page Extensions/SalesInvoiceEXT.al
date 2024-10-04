pageextension 52178721 "Sales Invoice" extends  "Sales Invoice"
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
        addafter(PostAndNew)
        {
            action(printReport)
            {
                Caption = 'Print Invoice';
                ApplicationArea = All;
                RunObject = report SalesInvoice;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
            }

        }


    }


}

