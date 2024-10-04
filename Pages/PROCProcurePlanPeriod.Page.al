page 52178775 "PROC-Procure. Plan Period"
{
    PageType = List;
    SourceTable = "PROC-Procurement Plan Period";

    layout
    {
        area(content)
        {
            repeater(rep)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Period Name"; Rec."Period Name")
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

