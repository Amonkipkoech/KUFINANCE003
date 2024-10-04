pageextension 52178758 "Fixed Asset Card EXT" extends "Fixed Asset Card"
{
    layout
    {

        addafter("No.")
        {
            field("Asset Description"; Rec."Asset Description")
            {
                ApplicationArea = All;
            }
            field(building; Rec.building)
            {
                ApplicationArea = All;
            }
            field(model; Rec.model)
            {
                ApplicationArea = All;
            }

        }

    }

    // actions
    // {
    //     addafter()
    //     {
    //         action("Import Unit of Measure")
    //         {
    //             ApplicationArea = Basic, Suite;
    //             Caption = 'Unit of Measure';
    //             Image = Journal;
    //             RunObject = xmlport "Item Unit of measure";
    //             ToolTip = 'Item Unit of Measure';
    //         }
    //     }
    // }
}