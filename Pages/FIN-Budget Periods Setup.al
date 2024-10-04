page 52178722 "FIN-Budget Periods Setup"
{
    PageType = List;
    SourceTable = "FIN-Budget Periods Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Budget Name"; Rec."Budget Name")
                {
                    //Editable = false;
                    //Enabled = false;
                    ApplicationArea = All;
                }
                field("Budget Start"; Rec."Budget Start")
                {
                    ApplicationArea = All;
                }
                field("Budget End"; Rec."Budget End")
                {
                    ApplicationArea = All;
                }
                field("Period ID/Quater ID"; Rec."Period ID/Quater ID")
                {
                    ApplicationArea = All;
                }
                field("Period/Quater Start"; Rec."Period/Quater Start")
                {
                    ApplicationArea = All;
                }
                field("Period/Quater End"; Rec."Period/Quater End")
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
