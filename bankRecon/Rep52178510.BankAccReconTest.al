report 52178802 "Bank Acc. Recon. Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/BankAccReconTest.rdl';
    Caption = 'Bank Acc. Recon. - Test';

    dataset
    {
        dataitem("BankAccReconciliation"; "Bank Acc. Reconciliation")
        {
            RequestFilterFields = "Statement No.";
            column(BankCode; BankCode)
            {
            }
            column(BankAccountNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Bank Account No.")
            {
            }
            column(StatementNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement No.")
            {
            }
            column(StatementDate_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Date")
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(StatementEndingBalance_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Ending Balance")
            {
            }
            column(Statement_Ending_Balance; "Statement Ending Balance")
            {

            }
            column(StatementEnding; "Statement Ending Balance")
            {

            }
            column(BankName; BankName)
            {
            }
            column(BankAccountBalanceasperCashBook; BankAccountBalanceasperCashBook)
            {
            }
            column(UnpresentedChequesTotal; UnpresentedChequesTotal)
            {
            }
            column(UnpresentedCTT; UnpresentedChequesTotal)
            {
            }
            column(UncreditedBanking; UncreditedBanking)
            {
            }
            column(UncreditedBankingTT; UncreditedBanking)
            {
            }
            column(DifferencesBWTT; DifferencesBW)
            {
            }
            column(DifferencesInBankTotalDebitsTT; DifferencesInBankTotalDebits)
            {
            }
            column(DifferencesInBankTotalCreditsTT; DifferencesInBankTotalCredits)
            {
            }
            column(DifferencesInBankTotalTT; DifferencesInBankTotal)
            {
            }
            column(ReconciliationStatement; ReconciliationStatement)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(RecCashBkBal; RecCashBkBal)
            {
            }
            column(DifferencesBW; DifferencesBW)
            {
            }
            column(DifferencesInBankTotal; DifferencesInBankTotal)
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(Description; Descr)
            {
            }
            column(DifferencesInBankTotalDebits; DifferencesInBankTotalDebits)
            {
            }
            column(DifferencesInBankTotalCredits; DifferencesInBankTotalCredits)
            {
            }
            column(mydeference; myDifferences)
            {
            }
            dataitem(BankAccountLedgerEntry; 271)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                DataItemTableView = WHERE("Statement Status" = FILTER(Open),
                                          Reversed = CONST(False),
                                          Open = CONST(true),
                                          Amount = FILTER(< 0));
                // Amount = FILTER(<> 0));
                column(StatementLineNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Document No.")
                {
                }
                column(TransactionDate_BankAccountLedgerEntry; BankAccountLedgerEntry."Posting Date")
                {
                }
                column(PayeeName_BankAccountLedgerEntry; BankAccountLedgerEntry.Description)
                {
                }
                column(Description_BankAccountLedgerEntry; BankAccountLedgerEntry.Description)
                {
                }
                column(StatementAmount_BankAccountLedgerEntry; BankAccountLedgerEntry.Amount)
                {
                }
                column(SNo; SNo)
                {
                }
                column(Remarks_BankAccountLedgerEntry; BankAccountLedgerEntry.Remarks)
                {
                }
                column(StatementDifference_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Difference")
                {
                }
                column(CreditAmount_BankAccountLedgerEntry; BankAccountLedgerEntry."Credit Amount")
                {
                }
                column(ExternalDocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    //BankAccountLedgerEntry.SETFILTER("Posting Date",'<=%1',"Bank Acc. Reconciliation"."Statement Date");
                    SETFILTER("Posting Date", '%1..%2', 20220601D, BankAccReconciliation."Statement Date");
                    SETFILTER("Statement Status", '%1', "Statement Status"::Open);
                    SETFILTER(Open, '%1', TRUE);
                    SETFILTER(Reversed, '%1', FALSE);

                    //BankAccountLedgerEntry.SETFILTER("Statement Difference",'<>%1',0);
                    /// SETFILTER(Amount, '<%1', 0);
                    //SETFILTER("Statement Difference",'<%1',0);
                end;
            }
            dataitem(BankAccountLedgerEntry1; 271)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                column(StatementLineNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Document No.")
                {
                }
                column(TransactionDate_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Posting Date")
                {
                }
                column(Description_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description)
                {
                }
                column(StatementAmount_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Amount)
                {
                }
                column(SNo1; SNo1)
                {
                }
                column(Remarks_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Remarks)
                {
                }
                column(StatementDifference_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Difference")
                {
                }
                column(ExternalDocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SNo1 += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    //BankAccountLedgerEntry1.SETFILTER("Posting Date",'<=%1',"Bank Acc. Reconciliation"."Statement Date");
                    SETFILTER("Posting Date", '%1..%2', 20220601D, BankAccReconciliation."Statement Date");
                    SETFILTER("Statement Status", '%1', "Statement Status"::Open);
                    //BankAccountLedgerEntry1.SETFILTER("Statement Difference",'<>%1',0);
                    SETFILTER(Open, '%1', TRUE);
                    SETFILTER(Reversed, '%1', FALSE);
                    SETFILTER(Amount, '>%1', 0);
                    //SETFILTER("Statement Difference",'>%1',0);

                    SETFILTER("Debit Amount", '<>%1', 0);
                end;
            }
            dataitem(DataItem1000000002; 274)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                DataItemTableView = WHERE(Difference = FILTER(<> 0),
                                          "Applied Amount" = FILTER(= 0));
                column(StatementLineNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Document No.")
                {
                }
                column(TransactionDate_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Transaction Date")
                {
                }
                column(Description_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Description)
                {
                }
                column(StatementAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Amount")
                {
                }
                column(Difference_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Difference)
                {
                }
                column(BankDebits; BankDebits)
                {
                }
                column(BankCredits; BankCredits)
                {
                }
                column(CreditAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Credit Amount")
                {
                }
                column(DebitAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Debit Amount")
                {
                }
                column(CheckNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Check No.")
                {
                }
                column(AdditionalTransactionInfo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Additional Transaction Info")
                {
                }
            }
            dataitem(BankAccReconciliationLine1; 274)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                column(StatementLineNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Document No.")
                {
                }
                column(TransactionDate_BankAccReconciliationLine1; BankAccReconciliationLine1."Transaction Date")
                {
                }
                column(Description_BankAccReconciliationLine1; BankAccReconciliationLine1.Description)
                {
                }
                column(StatementAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Amount")
                {
                }
                column(Difference_BankAccReconciliationLine1; BankAccReconciliationLine1.Difference)
                {
                }
                column(CheckNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Check No.")
                {
                }
                column(AdditionalTransactionInfo_BankAccReconciliationLine1; BankAccReconciliationLine1."Additional Transaction Info")
                {
                }
                column(CreditAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Credit Amount")
                {
                }
                column(DebitAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Debit Amount")
                {
                }

                trigger OnPreDataItem()
                begin
                    BankAccReconciliationLine1.SETFILTER(Difference, '>%1', 0);
                end;
            }
            dataitem(BankAccReconciliationLine3; 274)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                column(StatementLineNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Statement Line No.")
                {
                }
                column(DocumentNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Document No.")
                {
                }
                column(TransactionDate_BankAccReconciliationLine3; BankAccReconciliationLine3."Transaction Date")
                {
                }
                column(Description_BankAccReconciliationLine3; BankAccReconciliationLine3.Description)
                {
                }
                column(StatementAmount_BankAccReconciliationLine3; BankAccReconciliationLine3."Statement Amount")
                {
                }
                column(Difference_BankAccReconciliationLine3; BankAccReconciliationLine3.Difference)
                {
                }
                column(CheckNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Check No.")
                {
                }
                column(AdditionalTransactionInfo_BankAccReconciliationLine3; BankAccReconciliationLine3."Additional Transaction Info")
                {
                }
                column(CreditAmount_BankAccReconciliationLine3; BankAccReconciliationLine3."Credit Amount")
                {
                }
                column(DebitAmount_BankAccReconciliationLine3; BankAccReconciliationLine3."Debit Amount")
                {
                }

                trigger OnPreDataItem()
                begin
                    BankAccReconciliationLine3.SETFILTER(Difference, '<%1', 0);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BankAccountLedgerEntry2: Record "Bank Account Ledger Entry";
                BankAccountRecLine: Record "Bank Acc. Reconciliation Line";
            begin
                BankCode := '';
                BankAccountNo := '';
                BankName := '';
                BankDebits := 0;
                BankCredits := 0;
                BankAccountBalanceasperCashBook := 0;
                UnpresentedChequesTotal := 0;
                UncreditedBanking := 0;

                RecCashBkBal := 0;

                TotalDiffFunc();

                Bank.RESET;
                Bank.SETRANGE(Bank."No.", "Bank Account No.");
                IF Bank.FIND('-') THEN BEGIN
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    Bank.SETRANGE(Bank."Date Filter", 0D, "Statement Date");
                    Bank.CALCFIELDS(Bank."Net Change");
                    BankAccountBalanceasperCashBook := Bank."Net Change";
                    /*
                      BankStatementLine.RESET;
                      BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.",Bank."No.");
                      BankStatementLine.SETRANGE(BankStatementLine."Statement No.","Statement No.");
                      BankStatementLine.SETRANGE(BankStatementLine.Reconciled,FALSE);
                      IF BankStatementLine.FIND('-') THEN REPEAT
                        IF BankStatementLine."Statement Amount"<0 THEN
                         UnpresentedChequesTotal:=UnpresentedChequesTotal+BankStatementLine."Statement Amount"
                        ELSE IF BankStatementLine."Statement Amount">0 THEN
                         UncreditedBanking:=UncreditedBanking+BankStatementLine."Statement Amount";
                      UNTIL BankStatementLine.NEXT=0;
                    */

                    BankStatementLine.RESET;
                    BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.", Bank."No.");
                    BankStatementLine.SETRANGE(BankStatementLine."Statement No.", "Statement No.");
                    //BankStatementLine.SETRANGE(BankStatementLine.Reconciled,FALSE);
                    IF BankStatementLine.FIND('-') THEN
                        REPEAT
                            RecCashBkBal += BankStatementLine."Applied Amount";
                        UNTIL BankStatementLine.NEXT = 0;

                    BankAccountLedgerEntry2.RESET;
                    BankAccountLedgerEntry2.SETRANGE("Bank Account No.", Bank."No.");
                    BankAccountLedgerEntry2.SETRANGE(Open, TRUE);
                    BankAccountLedgerEntry2.SETRANGE(Reversed, FALSE);
                    BankAccountLedgerEntry2.SETFILTER("Posting Date", '%1..%2', 20220601D, BankAccReconciliation."Statement Date");
                    //BankAccountLedgerEntry2.SETFILTER("Statement Difference",'<>%1',0);
                    IF BankAccountLedgerEntry2.FIND('-') THEN
                        REPEAT

                            IsApplied := (BankAccountLedgerEntry2."Statement Status" = BankAccountLedgerEntry2."Statement Status"::Open);
                            IF IsApplied THEN
                                IF BankAccountLedgerEntry2.Amount < 0 THEN
                                    UnpresentedChequesTotal := UnpresentedChequesTotal + BankAccountLedgerEntry2.Amount

                                ELSE
                                    IF BankAccountLedgerEntry2.Amount > 0 THEN
                                        UncreditedBanking := UncreditedBanking + BankAccountLedgerEntry2.Amount;
                        UNTIL BankAccountLedgerEntry2.NEXT = 0;

                    UnpresentedChequesTotal := UnpresentedChequesTotal * -1;
                    //message('%1', UnpresentedChequesTotal);
                    BankStatBalance := "BankAccReconciliation"."Statement Ending Balance";

                    BankAccReconciliationLine.RESET;
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine."Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine."Statement No.", BankAccReconciliation."Statement No.");
                    //BankAccReconciliationLine.SETRANGE(Imported,FALSE);
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine.Type, BankAccReconciliationLine.Type::"Bank Account Ledger Entry");
                    BankAccReconciliationLine.SETFILTER("Applied Amount", '=%1', 0);
                    IF BankAccReconciliationLine.Difference < 0 THEN BEGIN
                        BankDebits := BankDebits + BankAccReconciliationLine.Difference;
                    END ELSE BEGIN
                        BankCredits := BankCredits + BankAccReconciliationLine.Difference;
                    END;


                    DifferencesInBankTotal := 0;
                    DifferencesInBankTotalDebits := 0;
                    DifferencesInBankTotalCredits := 0;

                    BankAccReconciliationLine2.RESET;
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Statement No.", BankAccReconciliation."Statement No.");
                    BankAccReconciliationLine2.SETFILTER(Difference, '<>%1', 0);
                    IF BankAccReconciliationLine2.FINDSET THEN BEGIN
                        BankAccReconciliationLine2.CALCSUMS(Difference);
                        DifferencesInBankTotal := BankAccReconciliationLine2.Difference;
                    END;
                    //Have deits and credits Separate
                    BankAccReconciliationLine2.RESET;
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Statement No.", BankAccReconciliation."Statement No.");
                    BankAccReconciliationLine2.SETFILTER(Difference, '<>%1', 0);
                    IF BankAccReconciliationLine2.FindSET() THEN BEGIN
                        REPEAT
                            IF BankAccReconciliationLine2.Difference > 0 THEN
                                DifferencesInBankTotalDebits := DifferencesInBankTotalDebits + BankAccReconciliationLine2.Difference
                            ELSE
                                IF BankAccReconciliationLine2.Difference < 0 THEN
                                    DifferencesInBankTotalCredits := (DifferencesInBankTotalCredits + BankAccReconciliationLine2.Difference * -1)

                  UNTIL BankAccReconciliationLine2.NEXT = 0
                    END;

                    BankAccReconciliationLine1.RESET;
                    BankAccReconciliationLine1.SETRANGE(BankAccReconciliationLine1."Bank Account No.", BankAccReconciliation."Bank Account No.");
                    BankAccReconciliationLine1.SETRANGE(BankAccReconciliationLine1."Statement No.", BankAccReconciliation."Statement No.");
                    BankAccReconciliationLine1.SETFILTER(Difference, '<>%1', 0);
                    IF BankAccReconciliationLine.Findset() THEN
                        //BEGIN
                        IF BankAccReconciliationLine1.Difference < 0 THEN
                            BankDebits := BankDebits + BankAccReconciliationLine1."Statement Amount";

                    //END;

                    IF ((BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference - DifferencesBW = "Statement Ending Balance") THEN
                        ReconciliationStatement := ''
                    ELSE
                        ReconciliationStatement := 'Reconciliation is incomplete please go through it again';
                END;

                myDifferences := 0;

                //myDifferences :=  ("Bank Acc. Reconciliation"."Statement Ending Balance"-UnpresentedChequesTotal-DifferencesInBankTotalDebits+DifferencesInBankTotalCredits+UncreditedBanking)-(BankAccountBalanceasperCashBook);
                //myDifferences :=  (UnpresentedChequesTotal-DifferencesInBankTotalDebits+DifferencesInBankTotalCredits+UncreditedBanking)-(BankAccountBalanceasperCashBook);
                myDifferences := BankAccountBalanceasperCashBook;
                IF ReconciliationStatement <> '' THEN BEGIN
                    IF myDifferences > 0 THEN IF myDifferences <= 10 THEN ReconciliationStatement := '';
                    IF myDifferences < 0 THEN IF myDifferences >= -10 THEN ReconciliationStatement := '';
                END;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
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

    trigger OnPreReport()
    begin
        //BankAccReconFilter := "Bank Acc. Reconciliation".GETFILTERS;
    end;

    var
        "Bank Acc. Reconciliation Line": record "Bank Acc. Reconciliation Line";
        Text000: Label '%1 must be specified.';
        Text001: Label '%1 is not equal to Total Balance.';
        Text002: Label '%1 must be %2 for %3 %4.';
        Text003: Label '%1 %2 does not exist.';
        Text004: Label '%1 must be %2.';
        Text005: Label 'Application is wrong.';
        Text006: Label 'The total difference is %1. It must be %2.';
        Bank_Account_Statement___TestCaptionLbl: Label 'Bank Account Statement - Test';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Bank_Acc__Reconciliation___Balance_Last_Statement_CaptionLbl: Label 'Balance Last Statement';
        Bank_Acc__Reconciliation___Statement_Date_CaptionLbl: Label 'Statement Date';
        Bank_Acc__Reconciliation___Statement_Ending_Balance_CaptionLbl: Label 'Statement Ending Balance';
        ErrorText_Number_CaptionLbl: Label 'Warning!';
        Bank_Acc__Reconciliation_Line__Transaction_Date_CaptionLbl: Label 'Transaction Date';
        Bank_Acc__Reconciliation_Line__Value_Date_CaptionLbl: Label 'Value Date';
        TotalsCaptionLbl: Label 'Totals';
        ErrorText_Number__Control97CaptionLbl: Label 'Warning!';
        ErrorText_Number__Control31CaptionLbl: Label 'Warning!';
        Bank: Record "Bank Account";
        BankCode: Code[20];
        BankAccountNo: Code[20];
        BankName: Text;
        BankAccountBalanceasperCashBook: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        "Bank Acc. Reconciliation": record "Bank Acc. Reconciliation";
        BankStatementLine: Record "Bank Acc. Reconciliation Line";
        CompanyInfo: Record "Company Information";
        ReconciliationStatement: Text;
        TotalDifference: Decimal;
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        BankRecUnPresented: Record "Bank Acc. Reconciliation Line";
        BankStatBalance: Decimal;
        RecCashBkBal: Decimal;
        SNo: Integer;
        SNo1: Integer;
        DifferencesBW: Decimal;
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        DifferencesInBankTotal: Decimal;
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        DifferencesInBankTotalDebits: Decimal;
        DifferencesInBankTotalCredits: Decimal;
        IsApplied: Boolean;
        BankDebits: Decimal;
        BankCredits: Decimal;
        DocNo: Code[30];
        Descr: Text[250];
        myDifferencesInBankTotalDebits: Decimal;
        myDifferences: Decimal;

    local procedure AddError(Text: Text[250])
    begin
        /*
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
        */

    end;


    procedure TotalDiffFunc()
    begin
        BankRecPresented.RESET;
        BankRecPresented.SETRANGE(BankRecPresented."Bank Account No.", "BankAccReconciliation"."Bank Account No.");
        BankRecPresented.SETRANGE(BankRecPresented."Statement No.", "BankAccReconciliation"."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        IF BankRecPresented.FIND('-') THEN
            REPEAT
                TotalDifference := TotalDifference + BankRecPresented.Difference;
            UNTIL BankRecPresented.NEXT = 0;
        //MESSAGE('%1',TotalDifference);
    end;
}

