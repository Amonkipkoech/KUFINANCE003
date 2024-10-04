page 52178749 "FIN-Receipts Types"
{
    PageType = Worksheet;
    SourceTable = "FIN-Receipts and Payment Types";
    SourceTableView = WHERE(Type = CONST(Receipt));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("PAYE Tax Chargeable"; Rec."PAYE Tax Chargeable")
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
                field("VAT Withheld Code"; Rec."VAT Withheld Code")
                {
                    ApplicationArea = All;
                }
                field("PAYE Tax Code"; Rec."PAYE Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Use PAYE Table"; Rec."Use PAYE Table")
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
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                }
                field("Customer Payment On Account"; Rec."Customer Payment On Account")
                {
                    ApplicationArea = All;
                }
                field("Direct Expense"; Rec."Direct Expense")
                {
                    ApplicationArea = All;
                }
                field("Calculate Retention"; Rec."Calculate Retention")
                {
                    ApplicationArea = All;
                }
                field("Retention Code"; Rec."Retention Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Retention Fee Code"; Rec."Retention Fee Code")
                {
                    ApplicationArea = All;
                }
                field("Retention Fee Applicable"; Rec."Retention Fee Applicable")
                {
                    ApplicationArea = All;
                }
                field("Subsistence?"; Rec."Subsistence?")
                {
                    ApplicationArea = All;
                }
                field("Council Claim?"; Rec."Council Claim?")
                {
                    ApplicationArea = All;
                }
                field("Telephone Allowance?"; Rec."Telephone Allowance?")
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