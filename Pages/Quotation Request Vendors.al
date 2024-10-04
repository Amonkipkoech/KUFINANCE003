page 52178708 "Quotation Request Vendors"
{
    PageType = Card;
    SourceTable = "PROC-Quotation Request Vendors";

    layout
    {
        area(content)
        {
            repeater(______________)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}