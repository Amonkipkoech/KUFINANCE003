pageextension 52178706 "Item Card Extension" extends "Item Card"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Editable = true;
        }
        addafter("Item Category Code")
        {
            field("Is Controlled"; Rec."Is Controlled")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Standard Cost")
        {
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(AdjustInventory)
        {
            action("Import Unit of Measure")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unit of Measure';
                Image = Journal;
                RunObject = xmlport "Item Unit of measure";
                ToolTip = 'Item Unit of Measure';
            }
        }
    }
}