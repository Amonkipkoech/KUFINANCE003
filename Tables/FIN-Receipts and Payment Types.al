table 52178710 "FIN-Receipts and Payment Types"
{
    DrillDownPageID = "FIN-Receipt & Payment Types UP";
    LookupPageID = "FIN-Receipt & Payment Types UP";


    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,None';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None";

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::"G/L Account" THEN
                    "Direct Expense" := TRUE
                ELSE
                    "Direct Expense" := FALSE;
            end;
        }
        field(4; Type; Option)
        {
            NotBlank = true;
            OptionCaption = ' ,Receipt,Payment,Imprest,Claim,Advance';
            OptionMembers = " ",Receipt,Payment,Imprest,Claim,Advance;
        }
        field(5; "VAT Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(6; "Withholding Tax Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(7; "VAT Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(8; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(9; "Default Grouping"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account Posting Group"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(10; "G/L Account"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No.";

            trigger OnValidate()
            begin
                GLAcc.RESET;
                IF GLAcc.GET("G/L Account") THEN BEGIN
                    IF Type = Type::Payment THEN
                        GLAcc.TESTFIELD(GLAcc."Budget Controlled", TRUE);
                    IF GLAcc."Direct Posting" = FALSE THEN BEGIN
                        ERROR('Direct Posting must be True');
                    END;
                END;
            end;
        }
        field(11; "Pending Voucher"; Boolean)
        {
        }
        field(12; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                IF "Account Type" <> "Account Type"::"Bank Account" THEN BEGIN
                    ERROR('You can only enter Bank No where Account Type is Bank Account');
                END;
            end;
        }
        field(13; "Transation Remarks"; Text[250])
        {
            NotBlank = true;
        }
        field(14; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(15; "Customer Payment On Account"; Boolean)
        {
        }
        field(16; "Direct Expense"; Boolean)
        {
            Editable = false;
        }
        field(17; "Calculate Retention"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(18; "Retention Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(20; Blocked; Boolean)
        {
        }
        field(21; "Retention Fee Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(22; "Retention Fee Applicable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(23; "Subsistence?"; Boolean)
        {
        }
        field(24; "Lecturer Claim?"; Boolean)
        {
        }
        field(25; "VAT Withheld Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes".Code;
        }
        field(26; "Council Claim?"; Boolean)
        {
        }
        field(27; "Telephone Allowance?"; Boolean)
        {
        }
        field(28; "PAYE Tax Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(29; "PAYE Tax Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(30; "Use PAYE Table"; Boolean)
        {
        }
        field(31; Fuel; Boolean)
        {
        }
        field(32; "Advance Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Advance Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,None';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None";

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::"G/L Account" THEN
                    "Direct Expense" := TRUE
                ELSE
                    "Direct Expense" := FALSE;
            end;
        }
        field(33; "Advance Grouping"; Code[20])
        {
            TableRelation = IF ("Advance Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Advance Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Advance Type" = CONST("Bank Account")) "Bank Account Posting Group"
            ELSE
            IF ("Advance Type" = CONST("Fixed Asset")) "FA Posting Group"
            ELSE
            IF ("Advance Type" = CONST("IC Partner")) "IC Partner";
        }
        field(34; "Advance Name"; Text[100])
        {

        }
    }

    keys
    {
        key(Key1; "Code", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Type = Type::Imprest THEN BEGIN
            ImprestLine.SETRANGE(ImprestLine."Advance Type", Code);
            IF ImprestLine.FIND('-') THEN BEGIN
                ERROR('You cannot delete this imprest type because it is already in use');
            END;
        END;

        IF Type = Type::Receipt THEN BEGIN
            RecLine.SETRANGE(RecLine.Type, Code);
            IF RecLine.FIND('-') THEN BEGIN
                ERROR('You cannot delete this Receipt type because it is already in use');
            END;
        END;

        IF Type = Type::Payment THEN BEGIN
            PayLine.SETRANGE(PayLine.Type, Code);
            IF PayLine.FIND('-') THEN BEGIN
                ERROR('You cannot delete this Payment type because it is already in use');
            END;
        END;

        IF Type = Type::Claim THEN BEGIN
            ClaimLine.SETRANGE(ClaimLine."Advance Type", Code);
            IF ClaimLine.FIND('-') THEN BEGIN
                ERROR('You cannot delete this Claim type because it is already in use');
            END;
        END;
    end;

    var
        GLAcc: Record "G/L Account";
        PayLine: Record "FIN-Payment Line";
        ImprestLine: Record "FIN-Imprest Lines";
        ClaimLine: Record "FIN-Staff Claim Lines";
        RecLine: Record "FIN-Receipt Line q";
}