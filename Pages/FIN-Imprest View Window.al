page 52178712 "FIN-Imprest View Window"
{
    PageType = List;
    SourceTable = "FIN-Imprest Header";

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
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
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
