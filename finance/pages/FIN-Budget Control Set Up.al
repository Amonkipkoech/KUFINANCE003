page 52178777 "FIN-Budgetary Control Setup"
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
                field("PV Budget Mandatory"; Rec."PV Budget Mandatory")
                {
                    ToolTip = 'Specifies the value of the PV Budget Mandatory field.';
                    ApplicationArea = All;
                }
                field("Payroll Budget Mandatory"; Rec."Payroll Budget Mandatory")
                {
                    ToolTip = 'Specifies the value of the Payroll Budget Mandatory field.';
                    ApplicationArea = All;
                }
                field("Imprest Budget mandatory"; Rec."Imprest Budget mandatory")
                {
                    ToolTip = 'Specifies the value of the Imprest Budget mandatory field.';
                    ApplicationArea = All;
                }
                field("LPO Budget Mandatory"; Rec."LPO Budget Mandatory")
                {
                    ToolTip = 'Specifies the value of the LPO Budget Mandatory field.';
                    ApplicationArea = All;
                }
                field("Claims Budget mandatory"; Rec."Claims Budget mandatory")
                {
                    ToolTip = 'Specifies the value of the Claims Budget mandatory field.';
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

