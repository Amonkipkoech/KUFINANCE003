report 52178735 "Imprest Surrender"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/ImprestAccounting.rdl';

    dataset
    {
        dataitem(impSurrHead; "FIN-Imprest Surr. Header")
        {
            RequestFilterFields = No, "Surrender Date";
            column(No_ImprestSurrenderHeader; impSurrHead.No)
            {
            }
            column(SurrenderDate_ImprestSurrenderHeader; impSurrHead."Surrender Date")
            {
            }
            column(Type_ImprestSurrenderHeader; impSurrHead.Type)
            {
            }
            column(PayMode_ImprestSurrenderHeader; impSurrHead."Pay Mode")
            {
            }
            column(ChequeNo_ImprestSurrenderHeader; impSurrHead."Cheque No")
            {
            }
            column(ChequeDate_ImprestSurrenderHeader; impSurrHead."Cheque Date")
            {
            }
            column(ChequeType_ImprestSurrenderHeader; impSurrHead."Cheque Type")
            {
            }
            column(BankCode_ImprestSurrenderHeader; impSurrHead."Bank Code")
            {
            }
            column(ReceivedFrom_ImprestSurrenderHeader; impSurrHead."Received From")
            {
            }
            column(OnBehalfOf_ImprestSurrenderHeader; impSurrHead."On Behalf Of")
            {
            }
            column(Cashier_ImprestSurrenderHeader; impSurrHead.Cashier)
            {
            }
            column(AccountType_ImprestSurrenderHeader; impSurrHead."Account Type")
            {
            }
            column(AccountNo_ImprestSurrenderHeader; impSurrHead."Account No.")
            {
            }
            column(NoSeries_ImprestSurrenderHeader; impSurrHead."No. Series")
            {
            }
            column(AccountName_ImprestSurrenderHeader; impSurrHead."Account Name")
            {
            }
            column(Posted_ImprestSurrenderHeader; impSurrHead.Posted)
            {
            }
            column(DatePosted_ImprestSurrenderHeader; impSurrHead."Date Posted")
            {
            }
            column(TimePosted_ImprestSurrenderHeader; impSurrHead."Time Posted")
            {
            }
            column(PostedBy_ImprestSurrenderHeader; impSurrHead."Posted By")
            {
            }
            column(Amount_ImprestSurrenderHeader; impSurrHead.Amount)
            {
            }
            column(Remarks_ImprestSurrenderHeader; impSurrHead.Remarks)
            {
            }
            column(TransactionName_ImprestSurrenderHeader; impSurrHead."Transaction Name")
            {
            }
            column(NetAmount_ImprestSurrenderHeader; impSurrHead."Net Amount")
            {
            }
            column(PayingBankAccount_ImprestSurrenderHeader; impSurrHead."Paying Bank Account")
            {
            }
            column(Payee_ImprestSurrenderHeader; impSurrHead.Payee)
            {
            }
            column(GlobalDimension1Code_ImprestSurrenderHeader; impSurrHead."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ImprestSurrenderHeader; impSurrHead."Global Dimension 2 Code")
            {
            }
            column(BankAccountNo_ImprestSurrenderHeader; impSurrHead."Bank Account No")
            {
            }
            column(CashierBankAccount_ImprestSurrenderHeader; impSurrHead."Cashier Bank Account")
            {
            }
            column(Status_ImprestSurrenderHeader; impSurrHead.Status)
            {
            }
            column(Grouping_ImprestSurrenderHeader; impSurrHead.Grouping)
            {
            }
            column(PaymentType_ImprestSurrenderHeader; impSurrHead."Payment Type")
            {
            }
            column(BankType_ImprestSurrenderHeader; impSurrHead."Bank Type")
            {
            }
            column(PVType_ImprestSurrenderHeader; impSurrHead."PV Type")
            {
            }
            column(ApplytoID_ImprestSurrenderHeader; impSurrHead."Apply to ID")
            {
            }
            column(NoPrinted_ImprestSurrenderHeader; impSurrHead."No. Printed")
            {
            }
            column(ImprestIssueDate_ImprestSurrenderHeader; impSurrHead."Imprest Issue Date")
            {
            }
            column(Surrendered_ImprestSurrenderHeader; impSurrHead.Surrendered)
            {
            }
            column(ImprestIssueDocNo_ImprestSurrenderHeader; impSurrHead."Imprest Issue Doc. No")
            {
            }
            column(VoteBook_ImprestSurrenderHeader; impSurrHead."Vote Book")
            {
            }
            column(TotalAllocation_ImprestSurrenderHeader; impSurrHead."Total Allocation")
            {
            }
            column(TotalExpenditure_ImprestSurrenderHeader; impSurrHead."Total Expenditure")
            {
            }
            column(TotalCommitments_ImprestSurrenderHeader; impSurrHead."Total Commitments")
            {
            }
            column(Balance_ImprestSurrenderHeader; impSurrHead.Balance)
            {
            }
            column(BalanceLessthisEntry_ImprestSurrenderHeader; impSurrHead."Balance Less this Entry")
            {
            }
            column(PettyCash_ImprestSurrenderHeader; impSurrHead."Petty Cash")
            {
            }
            column(ShortcutDimension2Code_ImprestSurrenderHeader; impSurrHead."Shortcut Dimension 2 Code")
            {
            }
            column(FunctionName_ImprestSurrenderHeader; impSurrHead."Function Name")
            {
            }
            column(BudgetCenterName_ImprestSurrenderHeader; impSurrHead."Budget Center Name")
            {
            }
            column(UserID_ImprestSurrenderHeader; impSurrHead."User ID")
            {
            }
            column(IssueVoucherType_ImprestSurrenderHeader; impSurrHead."Issue Voucher Type")
            {
            }
            column(ShortcutDimension3Code_ImprestSurrenderHeader; impSurrHead."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_ImprestSurrenderHeader; impSurrHead."Shortcut Dimension 4 Code")
            {
            }
            column(Dim3_ImprestSurrenderHeader; impSurrHead.Dim3)
            {
            }
            column(Dim4_ImprestSurrenderHeader; impSurrHead.Dim4)
            {
            }
            column(CurrencyFactor_ImprestSurrenderHeader; impSurrHead."Currency Factor")
            {
            }
            column(CurrencyCode_ImprestSurrenderHeader; impSurrHead."Currency Code")
            {
            }
            column(ResponsibilityCenter_ImprestSurrenderHeader; impSurrHead."Responsibility Center")
            {
            }
            column(AmountSurrenderedLCY_ImprestSurrenderHeader; impSurrHead."Amount Surrendered LCY")
            {
            }
            column(PVNo_ImprestSurrenderHeader; impSurrHead."PV No")
            {
            }
            column(PrintNo_ImprestSurrenderHeader; impSurrHead."Print No.")
            {
            }
            column(CashSurrenderAmt_ImprestSurrenderHeader; impSurrHead."Cash Surrender Amt")
            {
            }
            column(FinancialPeriod_ImprestSurrenderHeader; impSurrHead."Financial Period")
            {
            }
            column(CompanyName; CompInf.Name)
            {
            }
            column(CompanyPicture; CompInf.Picture)
            {
            }
            column(CompanyAddr1; CompInf.Address)
            {
            }
            column(CompanyAddr2; CompInf."Address 2")
            {
            }
            column(CompanyPhone; CompInf."Phone No.")
            {
            }
            column(CompanyName2; CompInf."Name 2")
            {
            }
            dataitem(ImpSurrDetails; "FIN-Imprest Surrender Details")
            {
                DataItemLink = "Surrender Doc No." = FIELD(No);
                column(SurrenderDocNo_ImprestSurrenderDetails; ImpSurrDetails."Surrender Doc No.")
                {
                }
                column(AccountNo_ImprestSurrenderDetails; ImpSurrDetails."Account No:")
                {
                }
                column(AccountName_ImprestSurrenderDetails; ImpSurrDetails."Account Name")
                {
                }
                column(Amount_ImprestSurrenderDetails; ImpSurrDetails.Amount)
                {
                }
                column(DueDate_ImprestSurrenderDetails; ImpSurrDetails."Due Date")
                {
                }
                column(ImprestHolder_ImprestSurrenderDetails; ImpSurrDetails."Imprest Holder")
                {
                }
                column(ActualSpent_ImprestSurrenderDetails; ImpSurrDetails."Actual Spent")
                {
                }
                column(Applyto_ImprestSurrenderDetails; ImpSurrDetails."Apply to")
                {
                }
                column(ApplytoID_ImprestSurrenderDetails; ImpSurrDetails."Apply to ID")
                {
                }
                column(SurrenderDate_ImprestSurrenderDetails; ImpSurrDetails."Surrender Date")
                {
                }
                column(Surrendered_ImprestSurrenderDetails; ImpSurrDetails.Surrendered)
                {
                }
                column(CashReceiptNo_ImprestSurrenderDetails; ImpSurrDetails."Cash Receipt No")
                {
                }
                column(DateIssued_ImprestSurrenderDetails; ImpSurrDetails."Date Issued")
                {
                }
                column(TypeofSurrender_ImprestSurrenderDetails; ImpSurrDetails."Type of Surrender")
                {
                }
                column(DeptVchNo_ImprestSurrenderDetails; ImpSurrDetails."Dept. Vch. No.")
                {
                }
                column(CashSurrenderAmt_ImprestSurrenderDetails; ImpSurrDetails."Cash Surrender Amt")
                {
                }
                column(BankPettyCash_ImprestSurrenderDetails; ImpSurrDetails."Bank/Petty Cash")
                {
                }
                column(DocNo_ImprestSurrenderDetails; ImpSurrDetails."Doc No.")
                {
                }
                column(ShortcutDimension1Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 2 Code")
                {
                }
                column(ShortcutDimension3Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 3 Code")
                {
                }
                column(ShortcutDimension4Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimension5Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 5 Code")
                {
                }
                column(ShortcutDimension6Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 6 Code")
                {
                }
                column(ShortcutDimension7Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 7 Code")
                {
                }
                column(ShortcutDimension8Code_ImprestSurrenderDetails; ImpSurrDetails."Shortcut Dimension 8 Code")
                {
                }
                column(VATProdPostingGroup_ImprestSurrenderDetails; ImpSurrDetails."VAT Prod. Posting Group")
                {
                }
                column(ImprestType_ImprestSurrenderDetails; ImpSurrDetails."Imprest Type")
                {
                }
                column(CurrencyFactor_ImprestSurrenderDetails; ImpSurrDetails."Currency Factor")
                {
                }
                column(CurrencyCode_ImprestSurrenderDetails; ImpSurrDetails."Currency Code")
                {
                }
                column(AmountLCY_ImprestSurrenderDetails; ImpSurrDetails."Amount LCY")
                {
                }
                column(CashSurrenderAmtLCY_ImprestSurrenderDetails; ImpSurrDetails."Cash Surrender Amt LCY")
                {
                }
                column(ImprestReqAmtLCY_ImprestSurrenderDetails; ImpSurrDetails."Imprest Req Amt LCY")
                {
                }
                column(CashReceiptAmount_ImprestSurrenderDetails; ImpSurrDetails."Cash Receipt Amount")
                {
                }
                column(ChequeDepositSlipNo_ImprestSurrenderDetails; ImpSurrDetails."Cheque/Deposit Slip No")
                {
                }
                column(ChequeDepositSlipDate_ImprestSurrenderDetails; ImpSurrDetails."Cheque/Deposit Slip Date")
                {
                }
                column(ChequeDepositSlipType_ImprestSurrenderDetails; ImpSurrDetails."Cheque/Deposit Slip Type")
                {
                }
                column(ChequeDepositSlipBank_ImprestSurrenderDetails; ImpSurrDetails."Cheque/Deposit Slip Bank")
                {
                }
                column(CashPayMode_ImprestSurrenderDetails; ImpSurrDetails."Cash Pay Mode")
                {
                }
                column(OverExpenditure_ImprestSurrenderDetails; ImpSurrDetails."Over Expenditure")
                {
                }
                // column(NumberText; NumberText)
                // {
                // }

                trigger OnAfterGetRecord()
                begin
                    //CheckReport.InitTextVariable();
                    //"Imprest Surrender Header".CALCFIELDS("Imprest Surrender Header"."Net Amount");
                    //CheckReport.FormatNoText2('',impSurrHead."Net Amount",'');
                    //CheckReport.InitTextVariable();
                    //NumberText:=CheckReport.FormatNoText2('',ImpSurrDetails.Amount,'');
                    // NumberText := CheckReport.FormatNoText(NumberText, impSurrHead.Amount, '');

                    //FormatNoText(NumberText, impSurrHead.Amount, '');
                end;
            }

            trigger OnPreDataItem()
            begin
                CompInf.GET;
                CompInf.CALCFIELDS(CompInf.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInf: Record "Company Information";
        CheckReport: Report Check;
        //  NumberText: Text[1024];
        NumberText: array[2] of Text[1024];
}
