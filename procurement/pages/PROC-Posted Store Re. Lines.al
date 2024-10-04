page 52178769 "PROC-Posted Store Req. Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "PROC-Store Requistion Lines";

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
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity';
                }
                field("Quantity Requested"; Rec."Quantity Requested")
                {
                    ApplicationArea = all;
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

