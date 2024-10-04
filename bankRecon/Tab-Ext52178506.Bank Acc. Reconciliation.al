/// <summary>
/// TableExtension ExtBank Acc. Reconciliationbaa (ID 52178506) extends Record Bank Acc. Reconciliation.
/// </summary>
tableextension 52178805 "ExtBank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    /// <summary>
    /// MatchCandidateFilterDate2.
    /// </summary>
    /// <returns>Return value of type Date.</returns>
    procedure MatchCandidateFilterDate2(): Date
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.SetRange("Statement Type", "Statement Type");
        BankAccReconciliationLine.SetRange("Statement No.", "Statement No.");
        BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Account No.");
        BankAccReconciliationLine.SetCurrentKey("Transaction Date");
        BankAccReconciliationLine.Ascending := false;
        if BankAccReconciliationLine.FindFirst() then
            if BankAccReconciliationLine."Transaction Date" > "Statement Date" then
                exit(BankAccReconciliationLine."Transaction Date");

        exit("Statement Date");
    end;
}
