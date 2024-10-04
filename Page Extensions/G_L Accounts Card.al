pageextension 52178710 "G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Budget Controlled"; Rec."Budget Controlled")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
            field(IsService;Rec.IsService)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }
}