pageextension 52178704 "Vendor Card EXT" extends "Vendor Card"
{
    actions
    {
        addbefore(PayVendor)
        {
            action("Vendor Prequalification Periods")
            {
                ApplicationArea = Basic, Suite;
                Image = Prepayment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Vendor Prequalifiaction";
                RunPageLink = "Vendor No" = FIELD("No.");

            }


        }
    }
}
