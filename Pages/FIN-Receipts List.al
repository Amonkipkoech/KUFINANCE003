page 52178743 "FIN-Receipts List"
{
    CardPageID = "FIN-Receipt Header UP";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send,Check';
    PageType = List;
    SourceTable = "FIN-Receipts Header";
    SourceTableView = WHERE(Posted = filter(false));

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
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }

                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;

                }



                field("Created By"; Rec."Created By")
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
            action("Posted Receipt Card")
            {
                RunObject = Page "FIN-Posted Receipt UP";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = Basic, Suite;
            }
        }
        area(reporting)
        {
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print/Preview';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category9;
                Visible = true;

                trigger OnAction()
                begin

                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(52178734, TRUE, TRUE, Rec);
                    Rec.RESET;
                    //52178741
                end;
            }
            
            
        }

    }
}