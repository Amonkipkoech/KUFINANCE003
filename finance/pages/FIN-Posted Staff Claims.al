page 52178770 "FIN-Posted Staff Claim List"
{
    CardPageID = "FIN-Posted Staff Claims";
    Caption = 'Posted Staff Claims List';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Staff Claims Header";
    SourceTableView = where(Status = filter(Posted));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = All;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Doc.")
            {
                Caption = 'Print';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    REPORT.Run(60025, true, true, Rec);
                end;
            }
        }
    }
}

