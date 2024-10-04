page 52178892 "Prequalification Periods"
{
    PageType = ListPart;
    SourceTable = "Prequalification Years";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(PrequalYr; Rec.PrequalYr)
                {
                    ApplicationArea = ALL;
                }
                field("Prequalification Year"; Rec."Prequalification Year")
                {
                    ApplicationArea = aLL;
                }
                field("Current Period"; Rec."Current Period")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}