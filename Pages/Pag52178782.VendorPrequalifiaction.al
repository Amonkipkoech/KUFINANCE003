page 52178782 "Vendor Prequalifiaction"
{
    Caption = 'Vendor Prequalifiaction';
    PageType = ListPart;
    SourceTable = "Prequalification Periods";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor No"; Rec."Vendor No")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
                field("Prequalification period"; Rec."Prequalification period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prequalification period field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}
