pageextension 52178718 "Posted Purchase Receipts Ext" extends "Posted Purchase Receipts"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action("Print GRN")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print GRN';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178727, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;

            }
            action("Print Inspection")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Inspection';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178725, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }
    }
}