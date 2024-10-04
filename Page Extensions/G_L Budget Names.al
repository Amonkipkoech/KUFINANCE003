pageextension 52178702 "G/L Budget Names" extends "G/L Budget Names"
{

    actions
    {
        addafter(EditBudget)
        {
            action("Budget Summary")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Budget Summary';
                Image = Journal;
                RunObject = Page "FIN-Budgetary Comparison List";
                ToolTip = 'Budget Summary';
            }
            action("Update Budget")
            {
                ApplicationArea = Suite;
                Caption = 'Update';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';
                ToolTip = 'Updates budget once modified';
                trigger OnAction()
                var
                    PostBudgetEnties: Codeunit "Post Budget Enties";
                begin
                    PostBudgetEnties.PostBudget();
                    PostBudgetEnties.Run();
                end;
            }
            action("Budget Periods")
            {
                ApplicationArea = Suite;
                Caption = 'Budget Periods';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';
                ToolTip = 'Budget Periods';

                RunObject = page "FIN-Budget Periods Setup";
                RunPageLink = "Budget Name" = FIELD(Name);

                // trigger OnAction()
                // var
                //     BudgPeriod: page "FIN-Budget Periods Setup";
                // begin
                //     BudgPeriod.Run();

                // end;
            }
            action("Budget Comparison Report")
            {
                ApplicationArea = Suite;
                Caption = 'Budget Comparison Summary';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';
                ToolTip = 'Budget Comparison Summary';
                //RunObject = page "FIN-Budgetary Comparison List";
                //RunPageLink = "Budget Name" = FIELD(Name);
                trigger OnAction()
                var
                    budgComparison: page "FIN-Budgetary Comparison List";
                begin
                    budgComparison.Run();
                end;
            }

        }
    }

}