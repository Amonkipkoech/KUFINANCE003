page 52178721 "FIN-Budgetary Comparison List"
{
    Editable = false;
    PageType = List;
    SourceTable = "FIN-Budget Entries Summary";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Budget Name"; Rec."Budget Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vote Name"; Rec."Vote Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Department';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Projects';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Allocation; Rec.Allocation)
                {
                    ApplicationArea = All;
                }
                field(Commitments; Rec.Commitments)
                {
                    ApplicationArea = All;
                }
                field(Expenses; Rec.Expenses)
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field("Net Balance"; Rec."Net Balance")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("% Balance"; Rec."% Balance")
                {
                    ApplicationArea = All;
                    // ApplicationArea = All;
                }
                field("% Net Balance"; Rec."% Net Balance")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}