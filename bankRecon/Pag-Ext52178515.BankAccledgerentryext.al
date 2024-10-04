/// <summary>
/// PageExtension Bank Acc ledger entry ext (ID 52178515) extends Record Bank Account Ledger Entries.
/// </summary>
pageextension 52178723 "Bank Acc ledger entry ext" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {

            field("Statement Difference"; Rec."Statement Difference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the "Statement Difference" field.';
            }
        }

    }
    actions
    {

        addafter("&Navigate")
        {
            action("Update Amount")
            {
                ApplicationArea = all;
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    bankacledger: record "Bank Account Ledger Entry";
                begin
                    bankacledger.Reset();
                    // bankacledger.SetRange("Bank Account No.",rec."Bank Account No.");
                    bankacledger.SetRange("Entry No.", rec."Entry No.");
                    if bankacledger.Find('-') then begin
                        repeat

                            bankacledger."Statement Difference" := rec.Amount;
                            // bankacledger."Amount Applied" := rec.Amount;
                            bankacledger.Modify();

                        until bankacledger.Next() = 0;
                        Message('Updated');
                    end;


                end;
            }
        }
    }
}
