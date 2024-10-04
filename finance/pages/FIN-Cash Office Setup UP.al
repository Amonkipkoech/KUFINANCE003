page 52178771 "FIN-Cash Office Setup UP"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "FIN-Cash Office Setup";
    PromotedActionCategories = 'New,Process,Report,Print/Send,Receipt';
   
    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Primary Key field.';
                }
                
                field("Normal Payments No"; Rec."Normal Payments No")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Voucher';
                }
                field("Cheque Reject Period"; Rec."Cheque Reject Period")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Payments No"; Rec."Petty Cash Payments No")
                {
                    ApplicationArea = All;
                }
                field("Current Budget"; Rec."Current Budget")
                {
                    ApplicationArea = All;
                }
                field("Current Budget Start Date"; Rec."Current Budget Start Date")
                {
                    ApplicationArea = All;
                }
                field("Current Budget End Date"; Rec."Current Budget End Date")
                {
                    ApplicationArea = All;
                }
                field("Bank Deposit No."; Rec."Bank Deposit No.")
                {
                    ApplicationArea = All;
                }
                field("Staff Claim No"; Rec."Staff Claim No")
                {
                    ApplicationArea = All;
                }
                field("InterBank Transfer No."; Rec."InterBank Transfer No.")
                {
                    ApplicationArea = All;
                }
                field("Surrender Template"; Rec."Surrender Template")
                {
                    ApplicationArea = All;
                }
                field("Surrender  Batch"; Rec."Surrender  Batch")
                {
                    ApplicationArea = All;
                }
                field("Receipts No"; Rec."Receipts No")
                {
                    ApplicationArea = All;
                }
                field("Cashier Transfer Nos"; Rec."Cashier Transfer Nos")
                {
                    ApplicationArea = All;
                }
                field("Default Bank Deposit Slip A/C"; Rec."Default Bank Deposit Slip A/C")
                {
                    ApplicationArea = All;
                }
                field("Imprest Req No"; Rec."Imprest Req No")
                {
                    ApplicationArea = All;
                    Caption = 'Imprest Req No.';
                }
                field("Imprest Surrender No"; Rec."Imprest Surrender No")
                {
                    ApplicationArea = All;
                }
                field("PV Template"; Rec."PV Template")
                {
                    ApplicationArea = All;
                }
                field("PV  Batch"; Rec."PV  Batch")
                {
                    ApplicationArea = All;
                }
                field("Asset Movement"; Rec."Asset Movement")
                {
                    ToolTip = 'Specifies the value of the Asset Movement field.';
                    ApplicationArea = All;
                }
                
            }  
        }
    }

}

