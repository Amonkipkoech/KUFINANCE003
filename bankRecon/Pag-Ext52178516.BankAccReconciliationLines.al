/// <summary>
/// PageExtension Bank Acc Reconciliation Lines (ID 52178516) extends Record Bank Acc. Reconciliation Lines.
/// </summary>
pageextension 52178722 "Bank Acc Reconciliation Lines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter(Difference)
        {

            field(Reconciled; Rec.Reconciled)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reconciled field.';
            }
        }
    }
}
