pageextension 52178701 "ExtAccountant Role Center" extends "Accountant Role Center"
{
    layout
    {

    }
    actions
    {
        addafter("Cash Management")
        {
            group("Finance Operations")
            {
                Caption = 'Finance Operations';
                Image = Journals;
                ToolTip = 'Imprests, Payment and bank transfers';

                action("Receipts List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Receipts List';
                    Image = Journal;
                    RunObject = Page "FIN-Receipts List";
                    ToolTip = 'Receipts List';
                }

                action("Posted Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Receipts List';
                    Image = Journal;
                    RunObject = Page "FIN-Posted Receipts list";
                    ToolTip = 'Posted Receipts';
                }


                action("Imprest")
                {//Receipt List
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprest Warrant';
                    Image = Journal;
                    RunObject = Page "FIN-Imprests List";
                    //RunPageView = WHERE("Template Type" = CONST(General),Recurring = CONST(false));
                    ToolTip = 'Imprest Requests';
                }

                action("Posted Imprest")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Imprest';
                    Image = Journal;
                    RunObject = Page "FIN-Posted imprest list";
                    ToolTip = 'Posted Imprests';
                }
                action("Imprest Accounting")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprest Accounting';
                    Image = Journal;
                    RunObject = Page "FIN-Imprest Accounting";
                    ToolTip = 'Imprest Accounting';
                }
                action("Posted Imprest Accounting")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Imprest Accounting';
                    Image = Journal;
                    //RunObject = Page "FIN-Travel Advance Acc. UP";
                    RunObject = Page "FIN-Posted Imprest Accounting";
                    //RunObject = Page "FIN-Posted Travel Advs. Acc.";
                    ToolTip = 'Posted Imprest Accounting';
                }
                action("Payment Vouchers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Vouchers';
                    Image = Journal;
                    RunObject = Page "FIN-Payment Vouchers";
                    ToolTip = 'Payment Vouchers';
                }
                action("Posted Vouchers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Vouchers';
                    Image = Journal;
                    RunObject = Page "FIN-Posted Payment Vouch.";
                    ToolTip = 'Posted Payment Vouchers';
                }
                action("Petty Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Petty Cash';
                    Image = Journal;
                    RunObject = Page "FIN-Petty Cash Vouchers List";
                    ToolTip = 'Petty Cash Vouchers';
                }
                action("Posted Petty Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Petty Cash';
                    Image = Journal;
                    RunObject = Page "FIN-Posted petty cash";
                    ToolTip = 'Posted Petty Cash Vouchers';
                }
                action(Claims)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Claims List';
                    Image = Journal;
                    RunObject = Page "FIN-Staff Claim List";
                    ToolTip = 'Claims List';
                    //FIN-Staff Claim List Posted
                }
                action("Posted Claims")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Claims List';
                    Image = Journal;
                    RunObject = Page "FIN-Staff Claim List Posted";
                    ToolTip = 'posted Claims List';
                    //FIN-Staff Claim List Posted
                }

                action("Inter Bank Tranfers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Transfers';
                    Image = Journal;
                    RunObject = Page "FIN-Interbank Transfer";
                    ToolTip = 'Bank Trasfers';
                }
                action("Posted Bank Trasfers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Bank Transfers';
                    Image = Journal;
                    RunObject = Page "FIN-Posted Interbank Trans2";
                    ToolTip = 'Posted Bank Trasfers';
                }
            }
            group("Financial Setups")
            {
                Caption = 'Financial Setups';
                Image = Setup;
                ToolTip = 'Financial Setups';

                action("Cash Office User Templet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Office User Templet';
                    Image = Setup;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Cash Office User Templet';
                }

                action("Imprests Types")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprests Types';
                    Image = Journal;
                    RunObject = Page "FIN-Imprest Types";
                    //RunPageView = WHERE("Template Type" = CONST(General),Recurring = CONST(false));
                    ToolTip = 'Imprest Requests';
                }

                action("Payment Types")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Types';
                    Image = Journal;
                    RunObject = Page "FIN-Payment Types";
                    //RunPageView = WHERE("Template Type" = CONST(General),Recurring = CONST(false));
                    ToolTip = 'Payment Types';
                }

                action("Receipt Types")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Receipt Types';
                    Image = Journal;
                    RunObject = Page "FIN-Receipts Types";
                    ToolTip = 'Receipt Types';
                }

                action("Claim Types")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Claim Types';
                    Image = Journal;
                    RunObject = Page "FIN-Claim Types";
                    ToolTip = 'Claim Types';

                }
                action("Tarrif Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Tarriff Codes Setup';
                    Image = Journal;
                    RunObject = Page "FIN-Tarriff Codes List";
                    ToolTip = 'FIN-Tarriff Codes List';
                }

                action("Cash Office Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Office Setup';
                    Image = Journal;
                    RunObject = Page "Cash Office Setup UP";
                    //RunPageView = WHERE("Template Type" = CONST(General),Recurring = CONST(false));
                    ToolTip = 'Cash Office Setup';
                }

                action("Budgetary Control setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Budgetary Control setup';
                    Image = Journal;
                    RunObject = Page "Budgetary Control Setup";
                    //RunPageView = WHERE("Template Type" = CONST(General),Recurring = CONST(false));
                    ToolTip = 'Budgetary Control setup';
                }
            }

            Group(EFTPayments)
            {
                Caption = 'EFT Payment';
                Image = CashFlow;

                action(BatchHeader)
                {
                    ApplicationArea = All;
                    Caption = 'Batch Header';
                    Image = PostBatch;
                    RunObject = page "EFT batch Header";

                }


            }
        }

    }
}
