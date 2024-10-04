codeunit 52178704 "Tax Calculation 2"
{

    trigger OnRun()
    begin
    end;

    //[Scope('Internal')]
    procedure CalculateTax(Rec: Record "Payment Line"; CalculationType: Option VAT,"W/Tax",Retention,PAYE) Amount: Decimal
    begin
        CASE CalculationType OF
            CalculationType::VAT:
                BEGIN
                    Amount := (Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount;
                END;
            /*CalculationType::"W/Tax":
              BEGIN
                  Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
                  *(Rec."W/Tax Rate"/100);

              END;
              */
            CalculationType::Retention:
                BEGIN
                    Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
                     * (Rec."Retention Rate" / 100);
                END;
            CalculationType::PAYE:
                BEGIN
                    Amount := Rec."PAYE Amount";
                END;

            CalculationType::"W/Tax":
                BEGIN
                    Amount := Rec."Withholding Tax Amount";

                END;
        END;

    end;
}