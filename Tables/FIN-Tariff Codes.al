table 52178712 "FIN-Tariff Codes"
{
    DrillDownPageID = "FIN-Tarriff Codes List";
    LookupPageID = "FIN-Tarriff Codes List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Percentage; Decimal)
        {
        }
        field(4; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; Type; Option)
        {
            OptionMembers = " ","W/Tax",VAT,Excise,Others,Retention,PAYE,Commision;
        }
        field(6; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(7; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."VAT Code", Code);
        IF PaymentLine.FIND('-') THEN
            ERROR('You cannot delete the %1 Code its already used', Type);

        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."Withholding Tax Code", Code);
        IF PaymentLine.FIND('-') THEN
            ERROR('You cannot delete the %1 Code its already used', Type);
    end;

    var
        PaymentLine: Record "FIN-Payment Line";
}
