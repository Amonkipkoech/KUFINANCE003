page 52178795 "EFT batch card"
{
    PageType = Card;
    SourceTable = "EFT Batch Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Posted by"; Rec."Posted by")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
#pragma warning disable AL0269
            part(lis; "EFt batch Lines")
#pragma warning restore AL0269
            {
                SubPageLink = "Doc No" = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Preview")
            {
                Caption = 'Print Preview';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178700, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }
    }
}