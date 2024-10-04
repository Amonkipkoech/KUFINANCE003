pageextension 52178703 Budget extends Budget
{
    actions
    {
        addafter("Copy Budget")
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
                trigger OnAction()
                var
                    BudgPeriod: page "FIN-Budget Periods Setup";
                begin
                    BudgPeriod.Run();
                end;
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

                trigger OnAction()
                var
                    budgComparison: page "FIN-Budgetary Comparison List";
                begin
                    // budgComparison.RESET;
                    // budgComparison.SETRANGE("Budget Name",Rec.Name);
                    budgComparison.Run();
                end;
            }

        }
        addafter(ReportTrialBalance)
        {
            action("Budget Summary2")
            {
                ApplicationArea = All;
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report budgetTemplate;
            }
        }
    }
}