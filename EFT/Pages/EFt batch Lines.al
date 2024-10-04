page 52178796 "EFt batch Lines"
{
    PageType = List;
    SourceTable = "EFT batch Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field("Doc No"; Rec."Doc No")
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bank A/C No"; Rec."Bank A/C No")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No"; Rec."Bank Branch No")
                {
                    ApplicationArea = All;
                }
                field("Bank A/C Name"; Rec."Bank A/C Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    ApplicationArea = All;
                }
                field("Paid By"; Rec."Paid By")
                {
                    ApplicationArea = All;
                }
                field("Paid Date"; Rec."Paid Date")
                {
                    ApplicationArea = All;
                }
                field("PV Number"; Rec."PV Number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}