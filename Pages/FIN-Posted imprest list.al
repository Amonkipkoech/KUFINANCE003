page 52178713 "FIN-Posted imprest list"
{
    CardPageID = "FIN-Posted Imprest Req. UP";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Imprest Header";
    SourceTableView = WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Staff ID field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ToolTip = 'Specifies the value of the Staff Name field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
              
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
               
               action("Print Accounting Request")
            {
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178739, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }

            }
        }
    }
}