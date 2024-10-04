table 52178760 "FIN-Pay Modes"
{
    DrillDownPageID = "FIN-Staff Claim List";
    LookupPageID = "FIN-Staff Claim List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Account Affected"; Option)
        {
            OptionMembers = Cashier,Predefined,Postdefined;
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                //"Account Name":=GLAcc.Name;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                //"Account Name":=Cust.Name;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                //"Account Name":=Vend.Name;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                //"Account Name":=BankAcc.Name;
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                //"Account Name":=FA.Description;
                            END;
                    END;
            end;
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

    var
        GLAcc: Record 15;
        Cust: Record 18;
        Vend: Record 23;
        FA: Record 5600;
        BankAcc: Record 270;
}

