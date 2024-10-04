page 52178774 "PROC-Procurement Plan Lines"
{
    PageType = ListPart;
    SourceTable = "PROC-Procurement Plan Lines";

    layout
    {
        area(content)
        {
            repeater(rep)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Type No"; Rec."Type No")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Qty"; Rec."Remaining Qty")
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

