page 52178733 "Cash Office User Template UP"
{
    DataCaptionFields = UserID;
    PageType = Card;
    SourceTable = "FIN-Cash Office User Template";

    layout
    {
        area(content)
        {
            repeater(____________)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Imprest Template"; Rec."Imprest Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Imprest  Batch"; Rec."Imprest  Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Default Receipts Bank"; Rec."Default Receipts Bank")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Default Petty Cash Bank"; Rec."Default Petty Cash Bank")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Default Payment Bank"; Rec."Default Payment Bank")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment Journal Template"; Rec."Payment Journal Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment Journal Batch"; Rec."Payment Journal Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Petty Cash Template"; Rec."Petty Cash Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Petty Cash Batch"; Rec."Petty Cash Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Inter Bank Template Name"; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Inter Bank Batch Name"; Rec."Inter Bank Batch Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Bank Pay In Journal Template"; Rec."Bank Pay In Journal Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Bank Pay In Journal Batch"; Rec."Bank Pay In Journal Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Claim  Batch"; Rec."Claim  Batch")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Claim Template"; Rec."Claim Template")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}
