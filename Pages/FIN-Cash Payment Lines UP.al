page 52178728 "FIN-Cash Payment Lines UP"
{
    PageType = ListPart;
    SourceTable = "FIN-Payment Line";

    layout
    {
        area(content)
        {
            repeater(______________________)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    //ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //check if the payment reference is for farmer purchase
                        IF Rec."Payment Reference" = Rec."Payment Reference"::"Farmer Purchase" THEN BEGIN
                            IF Rec.Amount <> xRec.Amount THEN BEGIN
                                ERROR('Amount cannot be modified');
                            END;
                        END;

                        Rec."Amount With VAT" := Rec.Amount;
                        IF Rec."Account Type" IN [Rec."Account Type"::Customer, Rec."Account Type"::Vendor,
                        Rec."Account Type"::"G/L Account", Rec."Account Type"::"Bank Account", Rec."Account Type"::"Fixed Asset"] THEN
                            CASE Rec."Account Type" OF
                                Rec."Account Type"::"G/L Account":
                                    BEGIN

                                        Rec.TESTFIELD(Amount);
                                        RecPayTypes.RESET;
                                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        IF RecPayTypes.FIND('-') THEN BEGIN
                                            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."VAT Amount" := 0;
                                            END;

                                            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (Rec.Amount - Rec."VAT Amount") * (TarriffCodes.Percentage / 100);
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."Withholding Tax Amount" := 0;
                                            END;
                                        END;
                                    END;
                                Rec."Account Type"::Customer:
                                    BEGIN

                                        Rec.TESTFIELD(Amount);
                                        RecPayTypes.RESET;
                                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        IF RecPayTypes.FIND('-') THEN BEGIN
                                            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                Rec.TESTFIELD("VAT Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."VAT Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."VAT Amount" := 0;
                                            END;

                                            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                Rec.TESTFIELD("Withholding Tax Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;

                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");

                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."Withholding Tax Amount" := 0;
                                            END;
                                        END;



                                    END;
                                Rec."Account Type"::Vendor:
                                    BEGIN

                                        Rec.TESTFIELD(Amount);
                                        RecPayTypes.RESET;
                                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        IF RecPayTypes.FIND('-') THEN BEGIN
                                            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                Rec.TESTFIELD("VAT Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."VAT Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    //
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."VAT Amount" := 0;
                                            END;

                                            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                Rec.TESTFIELD("Withholding Tax Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."Withholding Tax Amount" := 0;
                                            END;
                                        END;


                                    END;
                                Rec."Account Type"::"Bank Account":
                                    BEGIN

                                        Rec.TESTFIELD(Amount);
                                        RecPayTypes.RESET;
                                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        IF RecPayTypes.FIND('-') THEN BEGIN
                                            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    //
                                                    Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."VAT Amount" := 0;
                                            END;

                                            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."Withholding Tax Amount" := 0;
                                            END;
                                        END;


                                    END;
                                Rec."Account Type"::"Fixed Asset":
                                    BEGIN

                                        Rec.TESTFIELD(Amount);
                                        RecPayTypes.RESET;
                                        RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                        IF RecPayTypes.FIND('-') THEN BEGIN
                                            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                    Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."VAT Amount" := 0;
                                            END;

                                            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                TarriffCodes.RESET;
                                                TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                IF TarriffCodes.FIND('-') THEN BEGIN
                                                    //
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                    Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                    //
                                                END;
                                            END
                                            ELSE BEGIN
                                                Rec."Withholding Tax Amount" := 0;
                                            END;
                                        END;


                                    END;
                            END;


                        Rec."Net Amount" := Rec.Amount - Rec."Withholding Tax Amount";
                        Rec.VALIDATE("Net Amount");
                    end;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    Editable = false;
                    Lookup = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        TarriffCodes: Record "FIN-Tariff Codes";
    // GenJnlLine: Record 81;
    // DefaultBatch: Record 232;
    // CashierLinks: Record "61055";
    // LineNo: Integer;
    // CustLedger: Record "25";
    // CustLedger1: Record "25";
    // Amt: Decimal;
    // TotAmt: Decimal;
    // ApplyInvoice: Codeunit "402";
    // AppliedEntries: Record "61055";
    // VendEntries: Record "25";
    // PInv: Record "122";
    // VATPaid: Decimal;
    // VATToPay: Decimal;
    // PInvLine: Record "123";
    // VATBase: Decimal;
    // "G/L Vote": Record "15";
}