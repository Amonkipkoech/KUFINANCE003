page 52178780 "Fin-Assets Movent Ledger"
{

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTable = "Fin Assets Movmt Ledger";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.';
                    ApplicationArea = All;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ToolTip = 'Specifies the value of the Asset No. field.';
                    ApplicationArea = All;
                }
                field("Asset Name"; Rec."Asset Name")
                {
                    ToolTip = 'Specifies the value of the Asset Name field.';
                    ApplicationArea = All;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ToolTip = 'Specifies the value of the Posted Date field.';
                    ApplicationArea = All;
                }
                field("Current Location"; Rec."Current Location")
                {
                    ToolTip = 'Specifies the value of the Current Location field.';
                    ApplicationArea = All;
                }
                field("Previous Location"; Rec."Previous Location")
                {
                    ToolTip = 'Specifies the value of the Previous Location field.';
                    ApplicationArea = All;
                }
                field("Posted by"; Rec."Posted by")
                {
                    ToolTip = 'Specifies the value of the Posted by field.';
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the value of the Approved By field.';
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {


                trigger OnAction();
                begin

                end;
            }
        }
    }
}