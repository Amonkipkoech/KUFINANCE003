table 52178717 "FIN-Receipt Line q"
{
    //LookupPageID = 68559;

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = false;
            TableRelation = "FIN-Receipts Header"."No.";
        }
        field(2; Date; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("FIN-Receipts Header".Date WHERE("No." = FIELD(No)));
        }
        field(3; Type; Code[20])
        {
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = FILTER(Receipt));

            trigger OnValidate()
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                "Pay Mode" := "Pay Mode"::Cash;
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Receipt);

                IF RecPayTypes.FIND('-') THEN BEGIN
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;
                    Grouping := RecPayTypes."Default Grouping";
                    Remarks := RecPayTypes."Transation Remarks";
                    // "Customer Payment On Account":=RecPayTypes."Customer Payment On Account";

                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        // RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        IF "Account No." <> '' THEN
                            VALIDATE("Account No.");
                    END;
                END;

                //Check if the batch account has been inserted it the "Customer Payment On Account" is true
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                /*
                IF RecPayTypes.FIND('-') THEN
                  BEGIN
                    //check if the receipt type has Customer Payment On Account as True
                      IF RecPayTypes."Customer Payment On Account"=TRUE THEN
                        BEGIN
                          //check if the Receivable Batch Account is entered
                          SRSetup.GET();
                          SRSetup.TESTFIELD(SRSetup."Receivable Batch Account");
                        END;
                
                  END;
                  */
                IF RHead.GET(No) THEN BEGIN
                    "Cheque/Deposit Slip Date" := RHead."Document Date";
                    "Bank Code" := RHead."Bank Code";
                    "Transaction Name" := "Account Name";
                    "Total Amount" := RHead."Amount Recieved";
                END;

            end;
        }
        field(4; "Pay Mode"; Option)
        {
            //OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS;

            trigger OnValidate()
            begin
                GenLedgerSetup.RESET;
                GenLedgerSetup.GET();

                IF "Pay Mode" = "Pay Mode"::"Deposit Slip" THEN BEGIN
                    "Bank Account" := GenLedgerSetup."Default Bank Deposit Slip A/C";
                END;
            end;
        }
        field(5; "Cheque/Deposit Slip No"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(6; "Cheque/Deposit Slip Date"; Date)
        {

            trigger OnValidate()
            begin

                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Cheque Reject Period", "Cheque/Deposit Slip Date") <= TODAY THEN BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                END;


                CheckSlipDetails();
            end;
        }
        field(7; "Cheque/Deposit Slip Type"; Option)
        {
            OptionMembers = " "," Local","Up Country";
        }
        field(8; "Bank Code"; Code[20])
        {
            // TableRelation = "Bank Account"."No.";
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[20])
        {
        }
        field(12; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation =
            IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = filter(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" WHERE("Bank Acc. Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                "Account Name" := '';

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer,
                "Account Type"::Vendor, "Account Type"::"IC Partner"] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                //"Global Dimension 1 Code":=GLAcc."Global Dimension 1 Code";
                                "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                                "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                                //"Gen. Posting Type" := GLAcc."Gen. Posting Type";
                                "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                                "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                                VATSetup.RESET;
                                VATSetup.SETRANGE(VATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
                                VATSetup.SETRANGE(VATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
                                IF VATSetup.FIND('-') THEN BEGIN
                                    "VAT %" := VATSetup."VAT %";
                                END;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                "Global Dimension 1 Code" := FA."Global Dimension 1 Code";
                            END;
                        "Account Type"::"IC Partner":
                            BEGIN
                                ICPartner.RESET;
                                ICPartner.GET("Account No.");
                                "Account Name" := ICPartner.Name;
                            END;
                    END;




                /*
                {Check if the global dimension 1 code has een selected by the user}
                IF ("Global Dimension 1 Code"='') AND ("Account Type"<>"Account Type"::"G/L Account")THEN
                  BEGIN
                    ERROR('Please ensure that the Function code is selected');
                  END;
                */

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
            Caption = 'Customer Name';
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[20])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                "VAT Amount" := (Amount * "VAT %") / 100;
                "VAT Amount" := ROUND("VAT Amount", 0.05, '=');
                "Total Amount" := Amount + "VAT Amount";
            end;
        }
        field(21; Remarks; Text[250])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Decription';
        }
        field(23; "Branch Code"; Code[20])
        {
        }
        field(24; "Agent Code"; Code[20])
        {
        }
        field(25; Grouping; Code[20])
        {
            Caption = 'General Ledger Grouping';
            TableRelation = "Customer Posting Group".Code;
            Editable = true;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(28; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(31; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] THEN
                    TESTFIELD("VAT Bus. Posting Group", '');
                VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(32; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] THEN
                    TESTFIELD("VAT Prod. Posting Group", '');

                "VAT %" := 0;
                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";
                IF "Gen. Posting Type" <> 0 THEN BEGIN
                    IF NOT VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN
                        VATPostingSetup.INIT;
                    //"VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    CASE "VAT Calculation Type" OF
                        "VAT Calculation Type"::"Normal VAT":
                            "VAT %" := VATPostingSetup."VAT %";
                        "VAT Calculation Type"::"Full VAT":
                            CASE "Gen. Posting Type" OF
                                "Gen. Posting Type"::Sale:
                                    BEGIN
                                        VATPostingSetup.TESTFIELD("Sales VAT Account");
                                        TESTFIELD("Account No.", VATPostingSetup."Sales VAT Account");
                                    END;
                                "Gen. Posting Type"::Purchase:
                                    BEGIN
                                        VATPostingSetup.TESTFIELD("Purchase VAT Account");
                                        TESTFIELD("Account No.", VATPostingSetup."Purchase VAT Account");
                                    END;
                            END;
                    END;
                END;
                VALIDATE("VAT %");
            end;
        }
        field(33; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate()
            begin
                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] THEN
                    TESTFIELD("Gen. Posting Type", "Gen. Posting Type"::" ");
                IF ("Gen. Posting Type" = "Gen. Posting Type"::Settlement) AND (CurrFieldNo <> 0) THEN
                    ERROR(Text001, "Gen. Posting Type");

                IF "Gen. Posting Type" > 0 THEN
                    VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(34; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin

                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] THEN
                    TESTFIELD("Gen. Bus. Posting Group", '');
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                    IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") THEN
                        VALIDATE("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(35; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin

                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account"] THEN
                    TESTFIELD("Gen. Prod. Posting Group", '');
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                    IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") THEN
                        VALIDATE("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(36; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(37; "VAT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(38; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(39; "User ID"; Code[50])
        {
            //TableRelation = Table2000000002.Field1;
        }
        field(40; "Apply to"; Code[20])
        {
        }
        field(41; "Apply to ID"; Code[20])
        {
            Editable = true;
        }
        field(42; "Dest Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(43; "Dest Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(44; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(45; "Print No."; Integer)
        {
        }
        field(46; Status; Option)
        {
            OptionMembers = " ",Normal,"Post Dated",Posted;
        }
        field(47; "Deposit Slip Time"; Time)
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(48; "Teller ID"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(49; "Customer Payment On Account"; Boolean)
        {
        }
        field(50; Select; Boolean)
        {
        }
        field(51; "Batch Posted"; Boolean)
        {
        }
        field(52; "Transaction No."; Code[20])
        {
        }
        field(53; "Cheque/Deposit Slip Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(54; "Bank Account"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(55; Confirmed; Boolean)
        {
        }
        field(56; Reconciled; Boolean)
        {
        }
        field(57; "Orig. Cashier"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("FIN-Receipts Header".Cashier WHERE("No." = FIELD(No)));

        }
        field(58; Cancelled; Boolean)
        {
        }
        field(59; "Cancelled By"; Code[20])
        {
        }
        field(60; "Cancelled Date"; Date)
        {
        }
        field(61; "Cancelled Time"; Time)
        {
        }
        field(62; "Post Dated"; Boolean)
        {
        }
        field(63; "Cheque Retrieved"; Boolean)
        {
        }
        field(64; "Register Number"; Integer)
        {
        }
        field(65; "From Entry No"; Integer)
        {
        }
        field(66; "To Entry No"; Integer)
        {
        }
        field(67; "Batch Posted UserID"; Code[20])
        {
        }
        field(68; "BD Register Number"; Integer)
        {
        }
        field(69; "BD From Number"; Integer)
        {
        }
        field(70; "BD To Number"; Integer)
        {
        }
        field(71; "Reversal By"; Code[20])
        {
        }
        field(72; "Reversal Date"; Date)
        {
        }
        field(73; "Reversal Time"; Time)
        {
        }
        field(74; "Reversal Register No."; Integer)
        {
        }
        field(75; "Reversal From Entry No."; Integer)
        {
        }
        field(76; "Reversal To Entry No."; Integer)
        {
        }
        field(77; Reversed; Boolean)
        {
        }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(85; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(86; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                CustLedgEntry: Record 21;
                BilToCustNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
            begin
                //CODEUNIT.RUN(CODEUNIT::"Receipt Apply",Rec);
                IF (Rec."Account Type" <> Rec."Account Type"::Customer) AND (Rec."Account Type" <> Rec."Account Type"::Vendor) THEN
                    ERROR('You cannot apply to %1', "Account Type");

                //with Rec DO BEGIN
                Amount := 0;
                VALIDATE(Amount);
                BilToCustNo := Rec."Account No.";
                CustLedgEntry.SETCURRENTKEY("Customer No.", Open);
                CustLedgEntry.SETRANGE("Customer No.", BilToCustNo);
                CustLedgEntry.SETRANGE(Open, TRUE);
                IF "Applies-to ID" = '' THEN
                    "Applies-to ID" := No;
                IF "Applies-to ID" = '' THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION(No), FIELDCAPTION("Applies-to ID"));
                // ApplyCustEntries.SetReceipts(Rec,CustLedgEntry,Rec.FIELDNO("Applies-to ID"));
                ApplyCustEntries.SETRECORD(CustLedgEntry);
                ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                ApplyCustEntries.LOOKUPMODE(TRUE);
                OK := ApplyCustEntries.RUNMODAL = ACTION::LookupOK;
                CLEAR(ApplyCustEntries);
                IF NOT OK THEN
                    EXIT;
                CustLedgEntry.RESET;
                CustLedgEntry.SETCURRENTKEY("Customer No.", Open);
                CustLedgEntry.SETRANGE("Customer No.", BilToCustNo);
                CustLedgEntry.SETRANGE(Open, TRUE);
                CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                IF CustLedgEntry.FIND('-') THEN BEGIN
                    "Applies-to Doc. Type" := 0;
                    "Applies-to Doc. No." := '';
                END ELSE
                    "Applies-to ID" := '';

                //END;
                //Calculate Total Amount
                CustLedgEntry.RESET;
                CustLedgEntry.SETCURRENTKEY("Customer No.", Open, "Applies-to ID");
                CustLedgEntry.SETRANGE("Customer No.", BilToCustNo);
                CustLedgEntry.SETRANGE(Open, TRUE);
                CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                IF CustLedgEntry.FIND('-') THEN BEGIN
                    CustLedgEntry.CALCSUMS(CustLedgEntry."Amount to Apply");
                    Amount := ABS(CustLedgEntry."Amount to Apply");
                    VALIDATE(Amount);
                END;
            end;

            trigger OnValidate()
            begin

                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                END ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    ELSE
                        IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(87; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempCustLedgEntry: Record 21;
            begin
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open);
                    CustLedgEntry.SETRANGE("Customer No.", "Account No.");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    CustLedgEntry.SETRANGE("Applies-to ID", xRec."Applies-to ID");
                    IF CustLedgEntry.FINDFIRST THEN
                        // CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
                        CustLedgEntry.RESET;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", No)
        {
            Clustered = true;
            SumIndexFields = Amount, "Total Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnInsert()
    begin
        RHead.RESET;
        RHead.SETRANGE(RHead."No.", No);
        IF RHead.FINDFIRST THEN BEGIN
            "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := RHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := RHead."Shortcut Dimension 4 Code";
        END;
    end;

    trigger OnModify()
    begin
        RHead.RESET;
        RHead.SETRANGE(RHead."No.", No);
        IF RHead.FINDFIRST THEN BEGIN
            IF RHead.Posted THEN
                ERROR('The transaction has already been posted and therefore cannot be modified.');
        END;

        /* IF (Posted=TRUE) AND ("Customer Payment On Account"=FALSE)  THEN
         ERROR('The transaction has already been posted and therefore cannot be modified.');
         IF (Posted=TRUE) AND ("Customer Payment On Account"=TRUE)  AND ("Batch Posted"=TRUE) THEN
         ERROR('The transaction has already been posted and therefore cannot be modified.');*/

    end;

    trigger OnRename()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record "Customer";
        Vend: Record "Vendor";
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        //NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        VATPostingSetup: Record 325;
        Text001: Label 'The %1 option can only be used internally in the system.';
        GenBusPostingGrp: Record 250;
        GenProdPostingGrp: Record 251;
        Currency: Record 4;
        CurrExchRate: Record 330;
        Cust2: Record "Customer";
        Vend2: Record 23;
        BankAcc2: Record "Bank Account";
        BankAcc3: Record "Bank Account";
        Text002: Label 'LCY';
        VATSetup: Record 25;
        RecLine: Record "FIN-Receipt Line q";
        SRSetup: Record 311;
        ICPartner: Record 413;
        RHead: Record "FIN-Receipts Header";
        CustLedgEntry: Record 21;
        // CustEntrySetApplID: Codeunit "101";
        ApplyCustEntries: Page 232;

    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    begin
        "Currency Code" := '';
        IF AccNo2 <> '' THEN
            CASE AccType2 OF
                AccType2::Customer:
                    IF Cust2.GET(AccNo2) THEN
                        "Currency Code" := Cust2."Currency Code";
                AccType2::Vendor:
                    IF Vend2.GET(AccNo2) THEN
                        "Currency Code" := Vend2."Currency Code";
                AccType2::"Bank Account":
                    IF BankAcc2.GET(AccNo2) THEN
                        "Currency Code" := BankAcc2."Currency Code";
            END;
        EXIT("Currency Code" <> '');
    end;

    local procedure GetCurrency()
    begin
    end;


    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        IF CurrencyCode <> '' THEN
            EXIT(CurrencyCode)
        ELSE
            EXIT(Text002);
    end;


    procedure CheckSlipDetails()
    var
        IsExistent: Boolean;
    begin
        //this function checks the details on the deposit slip to ensure no double presentation of slips
        //the checks will be the slip date,slip no,slip time and teller and the account

        IsExistent := FALSE;

        CASE "Pay Mode" OF
            "Pay Mode"::"Deposit Slip", "Pay Mode"::Cheque:
                BEGIN
                    //reset the variable for holding the records
                    RecLine.RESET;
                    //RecLine.SETRANGE(RecLine."Account Type","Account Type");
                    //RecLine.SETRANGE(RecLine."Account No.","Account No.");
                    RecLine.SETRANGE(RecLine."Pay Mode", "Pay Mode");
                    RecLine.SETRANGE(RecLine."Cheque/Deposit Slip Type", "Cheque/Deposit Slip Type");
                    RecLine.SETRANGE(RecLine."Cheque/Deposit Slip No", "Cheque/Deposit Slip No");
                    RecLine.SETRANGE(RecLine."Cheque/Deposit Slip Date", "Cheque/Deposit Slip Date");
                    RecLine.SETRANGE(RecLine."Deposit Slip Time", "Deposit Slip Time");
                    RecLine.SETRANGE(RecLine."Teller ID", "Teller ID");
                    //check if there is a record with the same details
                    IF RecLine.FIND('-') THEN BEGIN
                        REPEAT
                            IF (RecLine."Line No." <> "Line No.") THEN BEGIN
                                IsExistent := TRUE;
                            END;
                        UNTIL RecLine.NEXT = 0;
                    END;
                END;
        END;
        //ask for user confirmation is the IsExistent
        IF IsExistent THEN BEGIN
            IF CONFIRM('Bank Deposit Slip(s) with the same details exist. Continue?', FALSE) = FALSE THEN BEGIN
                ERROR('Operation Cancelled by User Interrupt');
            END;
        END;
    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgEntry: Record 21;
    begin
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.", AppliesToDocNo);
        CustLedgEntry.SETRANGE("Customer No.", CustomerNo);
        CustLedgEntry.SETRANGE(Open, TRUE);
        IF CustLedgEntry.FINDFIRST THEN BEGIN
            IF CustLedgEntry."Amount to Apply" = 0 THEN BEGIN
                CustLedgEntry.CALCFIELDS("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
            END
            ELSE
                CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Accepted Payment Tolerance" := 0;
            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            codeunit.RUN(codeunit::"Cust. Entry-Edit", CustLedgEntry);//Code Unit 
        END;

    end;
}
