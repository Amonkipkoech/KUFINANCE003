page 52178794 "EFT batch Header"
{
    CardPageID = "EFT batch card";
    PageType = List;
    SourceTable = "EFT Batch Header";
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}