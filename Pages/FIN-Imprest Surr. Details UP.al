page 52178717 "FIN-Imprest Surr. Details UP"
{
    PageType = ListPart;
    SourceTable = "FIN-Imprest Surrender Details";

    layout
    {
        area(content)
        {
            repeater(___________)
            {
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = All;
                }
                field("Surrender Doc No."; Rec."Surrender Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt No"; Rec."Cash Receipt No")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt Amount"; Rec."Cash Receipt Amount")
                {
                    ApplicationArea = All;
                }
                field("Bank/Petty Cash"; Rec."Bank/Petty Cash")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        Amt: Decimal;
}
