page 52178763 "PROC-Store Requisition Line UP"
{
    PageType = ListPart;
    SourceTable = "PROC-Store Requistion Lines";
    //SourceTableView = where(Reversed = filter(false));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    //Visible = false;
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field(Quantity;Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity Requested"; Rec."Quantity Requested")
                {
                    ApplicationArea = all;
                    Visible = False;
                }
                field("Quantity To Issue"; Rec."Quantity To Issue")
                {
                    ApplicationArea = all;
                }
                field("Quantity Issued"; Rec."Quantity Issued")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty in store"; Rec."Qty in store")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
    }
}

