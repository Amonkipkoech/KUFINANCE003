page 52178753 "FIN-Receipt & Payment Types UP"
{
    Editable = false;
    PageType = List;
    SourceTable = "FIN-Receipts and Payment Types";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Chargeable"; Rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = All;
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                    ApplicationArea = All;
                }
                field("Lecturer Claim?"; Rec."Lecturer Claim?")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

