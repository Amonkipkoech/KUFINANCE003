table 52178723 "FIN-Staff Advanc Surr. Details"
{

    fields
    {
        field(1; "Surrender Doc No."; Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = filter(true));

            trigger OnValidate()
            begin


                IF GLAcc.GET("Account No:") THEN
                    "Account Name" := GLAcc.Name;
                GLAcc.TESTFIELD("Direct Posting", TRUE);
                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                Pay.SETRANGE(Pay.No, "Surrender Doc No.");
                IF Pay.FINDFIRST THEN BEGIN
                    IF Pay."Account No." <> '' THEN BEGIN
                        "Advance Holder" := Pay."Account No.";
                        "Shortcut Dimension 1 Code" := Pay."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := Pay."Shortcut Dimension 2 Code";
                        "Currency Factor" := Pay."Currency Factor";
                        "Currency Code" := Pay."Currency Code";

                    END ELSE
                        ERROR('Please Enter the Customer/Account Number');
                END;
            end;
        }
        field(3; "Account Name"; Text[30])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; "Advance Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                //Allow actual spent to be more than amount if open for overexpenditure and from original document
                IF NOT ("Allow Overexpenditure") AND ("Line on Original Document") THEN BEGIN

                    /*
                    IF "Actual Spent">Amount THEN
                         ERROR('The Actual Spent Cannot be more than the Issued Amount');
                         */
                END;

                IF "Actual Spent" > Amount THEN BEGIN
                    "Difference Owed" := "Actual Spent" - Amount;
                    "Cash Surrender Amt" := 0;
                END
                ELSE
                    IF "Actual Spent" < Amount THEN BEGIN
                        "Cash Surrender Amt" := Amount - "Actual Spent";
                        "Difference Owed" := 0;
                    END;
                // ERROR('The Actual Spent Cannot be more than the Issued Amount');
                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := "Actual Spent" / "Currency Factor"
                ELSE
                    "Amount LCY" := "Actual Spent";




                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := "Actual Spent" / "Currency Factor"
                ELSE
                    "Amount LCY" := "Actual Spent";

            end;
        }
        field(8; "Apply to"; Code[20])
        {
            Editable = false;
        }
        field(9; "Apply to ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "Surrender Date"; Date)
        {
            Editable = false;
        }
        field(11; Surrendered; Boolean)
        {
            Editable = false;
        }
        field(12; "Cash Receipt No"; Code[20])
        {
            TableRelation = "FIN-Receipts Header"."No." WHERE("Receipt Reference" = CONST("Other Advance Refunds"),
                                                             "Staff Number" = FIELD("Advance Holder"),
                                                             "Currency Code" = FIELD("Currency Code"));

            trigger OnValidate()
            begin

                IF CashRcptHdr.GET("Cash Receipt No") THEN
                    "Actual Receipt Amount" := CashRcptHdr."Amount Recieved";
                "Cash Receipt Amount" := 0;
                "Cash Receipt Amount" := "Actual Receipt Amount";

                IF "Cash Receipt No" <> '' THEN BEGIN
                    OtherAdvSurrLines.RESET;
                    OtherAdvSurrLines.SETRANGE(OtherAdvSurrLines."Cash Receipt No", "Cash Receipt No");
                    IF OtherAdvSurrLines.FIND('-') THEN BEGIN
                        REPEAT
                            IF OtherAdvSurrLines."Surrender Doc No." <> "Surrender Doc No." THEN BEGIN
                                IF NOT CONFIRM('This Receipt is already in use do you want to continue using it', TRUE, FALSE) THEN
                                    ERROR('Assigning of receipt aborted');
                            END;

                        UNTIL OtherAdvSurrLines.NEXT = 0;
                    END;
                END;
            end;
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15; "Dept. Vch. No."; Code[20])
        {
        }
        field(16; "Cash Surrender Amt"; Decimal)
        {
        }
        field(17; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18; " Doc No."; Code[20])
        {
            Editable = false;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(23; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(24; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = Dimension;
        }
        field(25; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = Dimension;
        }
        field(26; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = Dimension;
        }
        field(27; "VAT Prod. Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28; "Imprest Type"; Code[20])
        {
            Caption = 'Advance Type';
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = CONST(Advance));

            trigger OnValidate()
            begin
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader.No, "Surrender Doc No.");
                IF ImprestHeader.FINDFIRST THEN BEGIN
                    IF (ImprestHeader.Status = ImprestHeader.Status::Approved) OR
                    (ImprestHeader.Status = ImprestHeader.Status::Posted) OR
                    (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") THEN
                        ERROR('You Cannot Insert a new record when the status of the document is not Pending');
                END;

                RecPay.RESET;
                RecPay.SETRANGE(RecPay.Code, "Imprest Type");
                RecPay.SETRANGE(RecPay.Type, RecPay.Type::Advance);
                IF RecPay.FIND('-') THEN BEGIN
                    "Account No:" := RecPay."G/L Account";
                    "Account Name" := RecPay."Transation Remarks";
                    VALIDATE("Account No:");
                END;
            end;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Amount LCY"; Decimal)
        {
        }
        field(88; "Cash Surrender Amt LCY"; Decimal)
        {
        }
        field(89; "Imprest Req Amt LCY"; Decimal)
        {
        }
        field(90; "Cash Receipt Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                IF "Cash Receipt Amount" <> 0 THEN BEGIN
                    IF "Cash Receipt No" = '' THEN
                        ERROR('You must select a receipt to before you can enter the amount receipted');
                END;

                //Get Total of Receipt used
                TotalForReceipt.SETCURRENTKEY("Cash Receipt No");
                TotalForReceipt.SETRANGE(TotalForReceipt."Cash Receipt No", "Cash Receipt No");
                TotalForReceipt.CALCSUMS(TotalForReceipt."Cash Receipt Amount");

                IF "Actual Receipt Amount" < (TotalForReceipt."Cash Receipt Amount" + "Cash Receipt Amount") THEN
                    ERROR('The Cash Receipt Amounts linked to Advance accounting %1 cannot be more than the actual receipt amount of %2',
                    ("Cash Receipt Amount" + TotalForReceipt."Cash Receipt Amount"), "Actual Receipt Amount");
            end;
        }
        field(91; "Line No."; Integer)
        {
        }
        field(92; Committed; Boolean)
        {
        }
        field(93; "Budgetary Control A/C"; Boolean)
        {
        }
        field(94; "Line on Original Document"; Boolean)
        {
        }
        field(95; "Allow Overexpenditure"; Boolean)
        {
        }
        field(96; "Open for Overexpenditure by"; Code[20])
        {
        }
        field(97; "Date opened for OvExpenditure"; Date)
        {
        }
        field(98; "Actual Receipt Amount"; Decimal)
        {
        }
        field(50000; "Difference Owed"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent", "Cash Receipt Amount";
        }
        key(Key2; "Cash Receipt No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //Don't Allow deleting of lines on original document
        IF "Line on Original Document" THEN
            ERROR('You are not allowed to delete lines that were on the original issuing document');

        Pay.RESET;
        Pay.SETRANGE(Pay.No, "Surrender Doc No.");
        IF Pay.FIND('-') THEN
            IF (Pay.Status = Pay.Status::Posted) OR (Pay.Status = Pay.Status::"Pending Approval")
            OR (Pay.Status = Pay.Status::Approved) THEN
                ERROR('This Document is already Send for Approval/Approved or Posted');

        TESTFIELD(Committed, FALSE);
    end;

    trigger OnInsert()
    begin
        //Do not allow insertion of lines until the document is open for over expenditure
        Pay.RESET;
        Pay.SETRANGE(Pay.No, "Surrender Doc No.");
        //   IF Pay.FIND('-') THEN  BEGIN
        //       IF NOT Pay."Allow Overexpenditure" THEN
        //          ERROR('You must first open the document to allow over expenditure and addition of lines');
        //   END;
    end;

    trigger OnModify()
    begin
        Pay.RESET;
        Pay.SETRANGE(Pay.No, "Surrender Doc No.");
        IF Pay.FIND('-') THEN
            IF (Pay.Status = Pay.Status::Posted) OR (Pay.Status = Pay.Status::"Pending Approval")
            OR (Pay.Status = Pay.Status::Approved) THEN
                ERROR('This Document is already Send for Approval/Approved or Posted');
        //Pay.TESTFIELD("Commitment Status",FALSE);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "FIN-Staff Advance Surr. Header";
        Dim: Record "Dimension Value";
        CustLedger: Record 21;
        Text000: Label 'Receipt No %1 Is already Used in Another Document';
        ImprestHeader: Record "FIN-Staff Advance Surr. Header";
        RecPay: Record "FIN-Receipts and Payment Types";
        OtherAdvAccLine: Record "FIN-Staff Advanc Surr. Details";
        OtherAdvSurrLines: Record "FIN-Staff Advanc Surr. Details";
        CashRcptHdr: Record "FIN-Receipts Header";
        TotalForReceipt: Record "FIN-Staff Advanc Surr. Details";
}
