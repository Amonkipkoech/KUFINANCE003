page 52178758 "HRM-Committments"
{
    PageType = List;
    SourceTable = "FIN-Committment";
    SourceTableView = WHERE("Uploaded Manually" = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Month Budget"; Rec."Month Budget")
                {
                    ApplicationArea = All;
                }
                field("Month Actual"; Rec."Month Actual")
                {
                    ApplicationArea = All;
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = All;
                }
                field("Committed By"; Rec."Committed By")
                {
                    ApplicationArea = All;
                }
                field("Committed Date"; Rec."Committed Date")
                {
                    ApplicationArea = All;
                }
                field("Committed Time"; Rec."Committed Time")
                {
                    ApplicationArea = All;
                }
                field("Committed Machine"; Rec."Committed Machine")
                {
                    ApplicationArea = All;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = All;
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Time"; Rec."Cancelled Time")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Machine"; Rec."Cancelled Machine")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                }
                field("Vendor/Cust No."; Rec."Vendor/Cust No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("EXist GL"; Rec."EXist GL")
                {
                    ApplicationArea = All;
                }
                field("Exist Posted Inv"; Rec."Exist Posted Inv")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Uploaded Manually"; Rec."Uploaded Manually")
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

