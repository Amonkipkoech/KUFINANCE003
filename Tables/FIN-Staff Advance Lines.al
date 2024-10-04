table 52178721 "FIN-Staff Advance Lines"
{

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                IF Pay.GET(No) THEN
                    "Advance Holder" := Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                IF GLAcc.GET("Account No:") THEN
                    "Account Name" := GLAcc.Name;
                GLAcc.TESTFIELD("Direct Posting", TRUE);
                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                Pay.SETRANGE(Pay."No.", No);
                IF Pay.FINDFIRST THEN BEGIN
                    IF Pay."Account No." <> '' THEN
                        "Advance Holder" := Pay."Account No."
                    ELSE
                        ERROR('Please Enter the Customer/Account Number');
                END;
            end;
        }
        field(3; "Account Name"; Text[30])
        {
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin

                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", No);
                IF ImprestHeader.FINDFIRST THEN BEGIN
                    "Date Taken" := ImprestHeader.Date;
                    ImprestHeader.TESTFIELD("Responsibility Center");
                    ImprestHeader.TESTFIELD("Global Dimension 1 Code");
                    ImprestHeader.TESTFIELD("Shortcut Dimension 2 Code");
                    "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
                    "Currency Factor" := ImprestHeader."Currency Factor";
                    "Currency Code" := ImprestHeader."Currency Code";
                    IF Purpose = '' THEN
                        Purpose := ImprestHeader.Purpose;

                END;

                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := Amount / "Currency Factor"
                ELSE
                    "Amount LCY" := Amount;
            end;
        }
        field(5; "Due Date"; Date)
        {
        }
        field(6; "Advance Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Apply to"; Code[20])
        {
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "M.R. No"; Code[20])
        {
        }
        field(47; "Date Issued"; Date)
        {
        }
        field(48; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(49; "Dept. Vch. No."; Code[20])
        {
        }
        field(50; "Cash Surrender Amt"; Decimal)
        {
        }
        field(51; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(52; "Surrender Doc No."; Code[20])
        {
        }
        field(53; "Date Taken"; Date)
        {
        }
        field(54; Purpose; Text[250])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the fourth global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Advance Type"; Code[20])
        {
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = CONST(Advance),
                                                                         Blocked = CONST(false));

            trigger OnValidate()
            begin
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", No);
                IF ImprestHeader.FINDFIRST THEN BEGIN
                    IF (ImprestHeader.Status = ImprestHeader.Status::Approved) OR
                    (ImprestHeader.Status = ImprestHeader.Status::Posted) OR
                    (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") THEN
                        ERROR('You Cannot Insert a new record when the status of the document is not Pending');
                END;

                RecPay.RESET;
                RecPay.SETRANGE(RecPay.Code, "Advance Type");
                RecPay.SETRANGE(RecPay.Type, RecPay.Type::Advance);
                IF RecPay.FIND('-') THEN BEGIN
                    "Account No:" := RecPay."G/L Account";
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

            trigger OnValidate()
            begin
                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := Amount / "Currency Factor"
                ELSE
                    "Amount LCY" := Amount;
            end;
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
        field(88; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(89; "Claim Receipt No"; Code[20])
        {
        }
        field(90; "Expenditure Date"; Date)
        {
        }
        field(91; "Attendee/Organization Names"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Line No.", No)
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount LCY";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", No);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF (ImprestHeader.Status = ImprestHeader.Status::Approved) OR
            (ImprestHeader.Status = ImprestHeader.Status::Posted) OR
            (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") THEN
                ERROR('You Cannot Delete this record its status is not Pending');
        END;
        TESTFIELD(Committed, FALSE);
    end;

    trigger OnInsert()
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", No);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            "Date Taken" := ImprestHeader.Date;
            //ImprestHeader.TESTFIELD("Responsibility Center");
            ImprestHeader.TESTFIELD("Global Dimension 1 Code");
            ImprestHeader.TESTFIELD("Shortcut Dimension 2 Code");
            "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
            IF Purpose = '' THEN
                Purpose := ImprestHeader.Purpose;
        END;
    end;

    trigger OnModify()
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", No);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF (ImprestHeader.Status = ImprestHeader.Status::Approved) OR
                (ImprestHeader.Status = ImprestHeader.Status::Posted) OR
                (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") THEN
                ERROR('You Cannot Modify this record its status is not Pending');

            "Date Taken" := ImprestHeader.Date;
            "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
            IF Purpose = '' THEN
                Purpose := ImprestHeader.Purpose;

        END;

        TESTFIELD(Committed, FALSE);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "FIN-Staff Advance Header";
        ImprestHeader: Record "FIN-Staff Advance Header";
        RecPay: Record "FIN-Receipts and Payment Types";
}