page 52178772 "FIN-Cash Office User Temp. UP"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    DataCaptionFields = UserID;
    PageType = Card;
    SourceTable = "FIN-Cash Office User Template";
    PromotedActionCategories = 'New,Process,Report,Print/Send,Receipt';
    Editable = true;

    layout
    {

        area(content)
        {

            repeater(Control1102758000)
            {
                ShowCaption = false;


                field("User ID"; Rec.UserID)
                {
                    ApplicationArea = All;
                }
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Imprest Template"; Rec."Imprest Template")
                {
                    ApplicationArea = All;
                }
                field("Imprest  Batch"; Rec."Imprest  Batch")
                {
                    ApplicationArea = All;
                }
                field("Default Receipts Bank"; Rec."Default Receipts Bank")
                {
                    ApplicationArea = All;
                }
                field("Default Petty Cash Bank"; Rec."Default Petty Cash Bank")
                {
                    ApplicationArea = All;
                }
                field("Default Payment Bank"; Rec."Default Payment Bank")
                {
                    ApplicationArea = All;
                }
                field("Payment Journal Template"; Rec."Payment Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Payment Journal Batch"; Rec."Payment Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Template"; Rec."Petty Cash Template")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Batch"; Rec."Petty Cash Batch")
                {
                    ApplicationArea = All;
                }
                field("Inter Bank Template Name"; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = All;
                }
                field("Inter Bank Batch Name"; Rec."Inter Bank Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Pay In Journal Template"; Rec."Bank Pay In Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Bank Pay In Journal Batch"; Rec."Bank Pay In Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Claim Template"; Rec."Claim Template")
                {
                    ApplicationArea = All;
                }
                field("Claim  Batch"; Rec."Claim  Batch")
                {
                    ApplicationArea = All;
                }
                field("Direct Cash Sale Bank"; Rec."Direct Cash Sale Bank")
                {
                    ApplicationArea = All;
                }
                field("Direct Sales Inv. Nos."; Rec."Direct Sales Inv. Nos.")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt No. Series"; Rec."Cash Receipt No. Series")
                {
                    ApplicationArea = All;
                }
                field("Default Direct Sale Customer"; Rec."Default Direct Sale Customer")
                {
                    ApplicationArea = All;
                }
                field("Direct Sales External Doc. Nos"; Rec."Direct Sales External Doc. Nos")
                {
                    ApplicationArea = All;
                }
                field("Default Direct Sales Location"; Rec."Default Direct Sales Location")
                {
                    ApplicationArea = All;
                }
                field("Direct Sales Item Category"; Rec."Direct Sales Item Category")
                {
                    ApplicationArea = All;
                }
                field("Direct Cash Sale Deposit Nos."; Rec."Direct Cash Sale Deposit Nos.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Direct  Cash Sale Paybill"; Rec."Direct  Cash Sale Paybill")
                {
                    ApplicationArea = All;
                }
                field("Default Credit Sale Customer"; Rec."Default Credit Sale Customer")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

