/// <summary>
/// TableExtension Bank Ac Ledger Entry Ext (ID 52178505) extends Record Bank Account Ledger Entry.
/// </summary>
tableextension 52178804 "Bank Ac Ledger Entry Ext" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(52178500; "Statement Difference"; Decimal)
        {
            Caption = '"Statement Difference"';
            DataClassification = ToBeClassified;
        }
        field(52178501; "Amount Applied"; decimal)
        {
            Caption = '"Amount Applied"';
            DataClassification = ToBeClassified;
        }
        field(52178502; Remarks; text[250])
        {

        }
    }

}
