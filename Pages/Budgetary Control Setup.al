page 52178736 "Budgetary Control Setup"
{
    PageType = Card;
    SourceTable = "FIN-Budgetary Control Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = All;
                }
            }
            group(Budget)
            {
                Caption = 'Budget';
                field("Current Budget Code"; Rec."Current Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Current Budget Start Date"; Rec."Current Budget Start Date")
                {
                    ApplicationArea = All;
                }
                field("Current Budget End Date"; Rec."Current Budget End Date")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 1 Code"; Rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 2 Code"; Rec."Budget Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 3 Code"; Rec."Budget Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 4 Code"; Rec."Budget Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 5 Code"; Rec."Budget Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Budget Dimension 6 Code"; Rec."Budget Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Actuals)
            {
                Caption = 'Actuals';
                field("Analysis View Code"; Rec."Analysis View Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Code"; Rec."Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2 Code"; Rec."Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 3 Code"; Rec."Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 4 Code"; Rec."Dimension 4 Code")
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
