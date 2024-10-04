table 52178753 "Sales Tax Amount Line 2"
{
    Caption = 'Sales Tax Amount Line';

    fields
    {
        field(1; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(2; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            TableRelation = "Tax Jurisdiction";
        }
        field(3; "Tax %"; Decimal)
        {
            Caption = 'Tax %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(4; "Tax Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Base Amount';
            Editable = false;
        }
        field(5; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';

            trigger OnValidate()
            begin
                TESTFIELD("Tax %");
                TESTFIELD("Tax Base Amount");
                IF "Tax Amount" / "Tax Base Amount" < 0 THEN
                    ERROR(Text002, FIELDCAPTION("Tax Amount"));
                "Tax Difference" := "Tax Difference" + "Tax Amount" - xRec."Tax Amount";
            end;
        }
        field(6; "Amount Including Tax"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including Tax';
            Editable = false;
        }
        field(7; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            Editable = false;
        }
        field(10; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            Editable = false;
            TableRelation = "Tax Group";
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(12; Modified; Boolean)
        {
            Caption = 'Modified';
        }
        field(13; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(14; "Calculated Tax Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Calculated Tax Amount';
            Editable = false;
        }
        field(15; "Tax Difference"; Decimal)
        {
            Caption = 'Tax Difference';
            Editable = false;
        }
        field(16; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            OptionCaption = 'Sales and Use Tax,Excise Tax,Sales Tax Only,Use Tax Only';
            OptionMembers = "Sales and Use Tax","Excise Tax","Sales Tax Only","Use Tax Only";
        }
        field(17; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(20; "Tax Area Code for Key"; Code[20])
        {
            Caption = 'Tax Area Code for Key';
            TableRelation = "Tax Area";
        }
        field(25; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Amount';
            Editable = false;
        }
        field(26; "Inv. Disc. Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Base Amount';
            Editable = false;
        }
        field(10010; "Expense/Capitalize"; Boolean)
        {
            Caption = 'Expense/Capitalize';
        }
        field(10020; "Print Order"; Integer)
        {
            Caption = 'Print Order';
        }
        field(10030; "Print Description"; Text[30])
        {
            Caption = 'Print Description';
        }
        field(10040; "Calculation Order"; Integer)
        {
            Caption = 'Calculation Order';
        }
        field(10041; "Round Tax"; Option)
        {
            Caption = 'Round Tax';
            Editable = false;
            OptionCaption = 'To Nearest,Up,Down';
            OptionMembers = "To Nearest",Up,Down;
        }
        field(10042; "Is Report-to Jurisdiction"; Boolean)
        {
            Caption = 'Is Report-to Jurisdiction';
            Editable = false;
        }
        field(10043; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(10044; "Tax Base Amount FCY"; Decimal)
        {
            Caption = 'Tax Base Amount FCY';
        }
    }

    keys
    {
        key(Key1; "Tax Area Code for Key", "Tax Jurisdiction Code", "Tax %", "Tax Group Code", "Expense/Capitalize", "Tax Type", "Use Tax", Positive)
        {
            Clustered = true;
        }
        key(Key2; "Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code")
        {
        }
        key(Key3; "Tax Area Code for Key", "Tax Group Code", "Tax Type", "Calculation Order")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Currency: Record Currency;
        AllowTaxDifference: Boolean;
        PricesIncludingTax: Boolean;
        Text000: Label '%1% Tax';
        Text001: Label 'Tax Amount';
        Text002: Label '%1 must not be negative.';
        Text004: Label '%1 for %2 must not exceed %3 = %4.';

    //[Scope('Internal')]
    procedure CheckTaxDifference(NewCurrencyCode: Code[10]; NewAllowTaxDifference: Boolean; NewPricesIncludingTax: Boolean)
    begin
        InitGlobals(NewCurrencyCode, NewAllowTaxDifference, NewPricesIncludingTax);
        IF NOT AllowTaxDifference THEN
            TESTFIELD("Tax Difference", 0);
        IF ABS("Tax Difference") > Currency."Max. VAT Difference Allowed" THEN
            ERROR(
              Text004, FIELDCAPTION("Tax Difference"), Currency.Code,
              Currency.FIELDCAPTION("Max. VAT Difference Allowed"), Currency."Max. VAT Difference Allowed");
    end;

    local procedure InitGlobals(NewCurrencyCode: Code[10]; NewAllowTaxDifference: Boolean; NewPricesIncludingTax: Boolean)
    begin
        SetCurrency(NewCurrencyCode);
        AllowTaxDifference := NewAllowTaxDifference;
        PricesIncludingTax := NewPricesIncludingTax;
    end;

    local procedure SetCurrency(CurrencyCode: Code[10])
    begin
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(CurrencyCode);
    end;

    //[Scope('Internal')]
    procedure TaxAmountText(): Text[30]
    var
        TaxAmountLine2: Record "Sales Tax Amount Line 2";
        TaxAreaCount: Integer;
        TaxPercent: Decimal;
    begin
        IF FINDFIRST THEN BEGIN
            //TaxAmountLine2 := Rec;
            TaxAreaCount := 1;
            REPEAT
                IF "Tax Area Code" <> TaxAmountLine2."Tax Area Code" THEN BEGIN
                    TaxAreaCount := TaxAreaCount + 1;
                    //TaxAmountLine2 := Rec;
                END;
                TaxPercent := TaxPercent + "Tax %";
            UNTIL NEXT = 0;
        END;
        IF TaxPercent <> 0 THEN
            EXIT(STRSUBSTNO(Text000, TaxPercent / TaxAreaCount));
        EXIT(Text001);
    end;

    //[Scope('Internal')]
    procedure GetTotalLineAmount(SubtractTax: Boolean; CurrencyCode: Code[10]): Decimal
    var
        LineAmount: Decimal;
    begin
        IF SubtractTax THEN
            SetCurrency(CurrencyCode);

        LineAmount := 0;

        IF FIND('-') THEN
            REPEAT
                IF SubtractTax THEN
                    LineAmount :=
                      LineAmount + ROUND("Line Amount" / (1 + "Tax %" / 100), Currency."Amount Rounding Precision")
                ELSE
                    LineAmount := LineAmount + "Line Amount";
            UNTIL NEXT = 0;

        EXIT(LineAmount);
    end;

    //[Scope('Internal')]
    procedure GetTotalTaxAmount(): Decimal
    var
        TaxAmount: Decimal;
        PrevJurisdiction: Code[10];
    begin
        TaxAmount := 0;
        IF FIND('-') THEN
            REPEAT
                IF PrevJurisdiction <> "Tax Jurisdiction Code" THEN BEGIN
                    IF "Tax Area Code for Key" = '' THEN     // indicates Canada
                        TaxAmount := ROUND(TaxAmount);
                    PrevJurisdiction := "Tax Jurisdiction Code";
                END;
                TaxAmount := TaxAmount + "Tax Amount";
            UNTIL NEXT = 0;
        EXIT(TaxAmount);
    end;

    //[Scope('Internal')]
    procedure GetTotalTaxAmountFCY(): Decimal
    var
        TaxAmount: Decimal;
        PrevJurisdiction: Code[10];
    begin
        IF FINDSET THEN
            REPEAT
                IF PrevJurisdiction <> "Tax Jurisdiction Code" THEN BEGIN
                    IF "Tax Area Code for Key" = '' THEN     // indicates Canada
                        TaxAmount := ROUND(TaxAmount);
                    PrevJurisdiction := "Tax Jurisdiction Code";
                END;
                TaxAmount := TaxAmount + ("Tax Base Amount FCY" * "Tax %" / 100);
            UNTIL NEXT = 0;
        EXIT(TaxAmount);
    end;

    //[Scope('Internal')]
    procedure GetTotalTaxBase(): Decimal
    var
        TaxBase: Decimal;
    begin
        TaxBase := 0;

        IF FIND('-') THEN
            REPEAT
                TaxBase := TaxBase + "Tax Base Amount";
            UNTIL NEXT = 0;
        EXIT(TaxBase);
    end;

    //[Scope('Internal')]
    procedure GetTotalAmountInclTax(): Decimal
    var
        AmountInclTax: Decimal;
    begin
        AmountInclTax := 0;

        IF FIND('-') THEN
            REPEAT
                AmountInclTax := AmountInclTax + "Amount Including Tax";
            UNTIL NEXT = 0;
        EXIT(AmountInclTax);
    end;

    //[Scope('Internal')]
    procedure GetAnyLineModified(): Boolean
    begin
        IF FIND('-') THEN
            REPEAT
                IF Modified THEN
                    EXIT(TRUE);
            UNTIL NEXT = 0;
        EXIT(FALSE);
    end;

    //[Scope('Internal')]
    procedure GetTotalInvDiscAmount(): Decimal
    var
        InvDiscAmount: Decimal;
    begin
        InvDiscAmount := 0;
        IF FIND('-') THEN
            InvDiscAmount := "Invoice Discount Amount";
        EXIT(InvDiscAmount);
    end;

    //[Scope('Internal')]
    procedure SetInvoiceDiscountPercent(NewInvoiceDiscountPct: Decimal; NewCurrencyCode: Code[10]; NewPricesIncludingVAT: Boolean; CalcInvDiscPerVATID: Boolean; NewVATBaseDiscPct: Decimal)
    var
        NewRemainder: Decimal;
    begin
        InitGlobals(NewCurrencyCode, FALSE, NewPricesIncludingVAT);
        IF FIND('-') THEN
            REPEAT
                IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
                    NewRemainder :=
                      NewRemainder + NewInvoiceDiscountPct * "Inv. Disc. Base Amount" / 100;
                    VALIDATE(
                      "Invoice Discount Amount", ROUND(NewRemainder, Currency."Amount Rounding Precision"));
                    IF CalcInvDiscPerVATID THEN
                        NewRemainder := 0
                    ELSE
                        NewRemainder := NewRemainder - "Invoice Discount Amount";
                    Modified := TRUE;
                    MODIFY;
                END;
            UNTIL NEXT = 0;
    end;

    //[Scope('Internal')]
    procedure GetTotalInvDiscBaseAmount(SubtractVAT: Boolean; CurrencyCode: Code[10]): Decimal
    var
        InvDiscBaseAmount: Decimal;
    begin
        IF SubtractVAT THEN
            SetCurrency(CurrencyCode);

        InvDiscBaseAmount := 0;

        IF FIND('-') THEN
            REPEAT
                IF SubtractVAT THEN
                    InvDiscBaseAmount :=
                      InvDiscBaseAmount +
                      ROUND("Inv. Disc. Base Amount" / (1 + "Tax %" / 100), Currency."Amount Rounding Precision")
                ELSE
                    InvDiscBaseAmount := InvDiscBaseAmount + "Inv. Disc. Base Amount";
            UNTIL NEXT = 0;
        EXIT(InvDiscBaseAmount);
    end;

    //[Scope('Internal')]
    procedure SetInvoiceDiscountAmount(NewInvoiceDiscount: Decimal; NewCurrencyCode: Code[10]; NewPricesIncludingVAT: Boolean; NewVATBaseDiscPct: Decimal)
    var
        TotalInvDiscBaseAmount: Decimal;
        NewRemainder: Decimal;
    begin
        InitGlobals(NewCurrencyCode, FALSE, NewPricesIncludingVAT);
        TotalInvDiscBaseAmount := GetTotalInvDiscBaseAmount(FALSE, Currency.Code);
        IF TotalInvDiscBaseAmount = 0 THEN
            EXIT;
        FIND('-');
        REPEAT
            IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
                IF TotalInvDiscBaseAmount = 0 THEN
                    NewRemainder := 0
                ELSE
                    NewRemainder :=
                      NewRemainder + NewInvoiceDiscount * "Inv. Disc. Base Amount" / TotalInvDiscBaseAmount;
                VALIDATE(
                  "Invoice Discount Amount", ROUND(NewRemainder, Currency."Amount Rounding Precision"));
                NewRemainder := NewRemainder - "Invoice Discount Amount";
                MODIFY;
            END;
        UNTIL NEXT = 0;
    end;
}