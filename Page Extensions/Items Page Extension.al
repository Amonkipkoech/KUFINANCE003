/* pageextension 52178704 "Items Page Extension" extends "Item List"
{
    layout
    {

    }
    actions
    {
        addafter(CopyItem)
        {
            action("Import Items ")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Items';
                Image = Import;
                RunObject = xmlport "Import Items";
                ToolTip = 'Import Items';
            }

        }
    }
} */