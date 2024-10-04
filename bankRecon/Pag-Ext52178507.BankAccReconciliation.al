/// <summary>
/// PageExtension Bank Acc. Reconciliation (ID 52178507) extends Record Bank Acc. Reconciliation.
/// </summary>
pageextension 52178801 "Bank Acc. Reconciliation Ext" extends "Bank Acc. Reconciliation"
{
    actions
    {
        modify("&Test Report")
        {
            Visible = false;
        }
        addbefore(Post)
        {
            action("Test Report")
            {
                ApplicationArea = all;
                Image = PrintDocument;
                trigger OnAction()
                var
                    bnkrec: Record "Bank Acc. Reconciliation";
                begin
                    bnkrec.Reset();
                    bnkrec.SetRange("Bank Account No.", Rec."Bank Account No.");
                    bnkrec.SetRange("Statement No.", Rec."Statement No.");
                    report.run(report::"Bank Acc. Recon. Test", true, true, bnkrec)
                end;

            }
            action("Post Reconcilliation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Reconcilliation';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Codeunit "Bank recon post";
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
            }
        }
        addafter(MatchDetails)
        {
            action(MatchMany2One)
            {
                Caption = 'Match Many2One';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                    TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    MatchBankRecLines: Codeunit "Match Bank Recon Line 2";
                begin
                    CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    MatchBankRecLines.MatchMany2One(TempBankAccReconciliationLine, TempBankAccountLedgerEntry, 1);
                end;
            }
            action(MatchManually2)
            {
                Caption = 'Match Manually(Many-To-One)';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary;
                    TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    MatchBankRecLines: Codeunit "Match Bank Recon Line 2";
                begin
                    CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    MatchBankRecLines.MatchManually3(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                end;
            }
            action("Update Statement Difference")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                trigger onaction()
                var

                begin
                    postBankRec.UpdateBankRec(rec."Bank Account No.", rec."Statement Date");

                end;
            }

        }
    }


    var
        BankNo: code[20];
        Sdate: date;
        postBankRec: Codeunit "Modified Gen. Jnl.-Post";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
}
