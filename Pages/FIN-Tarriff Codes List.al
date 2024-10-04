page 52178752 "FIN-Tarriff Codes List"
{
    PageType = List;
    SourceTable = "FIN-Tariff Codes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
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

