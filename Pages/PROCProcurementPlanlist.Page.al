page 52178776 "PROC-Procurement Plan list"
{
    CardPageID = "PROC-Procurement Plan Header";
    PageType = List;
    SourceTable = "PROC-Procurement Plan Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
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

