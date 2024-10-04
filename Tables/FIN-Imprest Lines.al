table 52178709 "FIN-Imprest Lines"
{
    //DrillDownPageID = 68049;
    //LookupPageID = 68049;

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Caption = 'Budget Voter';
            //Editable = false;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                IF GLAcc.GET("Account No:") THEN GLAcc.VALIDATE(GLAcc."No.");
                "Account Name" := GLAcc.Name;
                GLAcc.TESTFIELD("Direct Posting", TRUE);
                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                Pay.SETRANGE(Pay."No.", No);
                IF Pay.FINDFIRST THEN BEGIN
                    IF Pay."Account No." <> '' THEN
                        "Imprest Holder" := Pay."Account No."
                    ELSE
                        ERROR('Please Enter the Customer/Account Number');
                END;
            end;
        }
        field(3; "Account Name"; Text[80])
        {
            Caption = 'Budget Vote Name';
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := Amount / "Currency Factor"
                ELSE
                    "Amount LCY" := Amount;
            end;
        }
        field(5; "Due Date"; Date)
        {
        }
        field(6; "Imprest Holder"; Code[20])
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
            Editable = false;
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
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = CONST(Imprest));

            trigger OnValidate()
            begin
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", No);
                IF ImprestHeader.FIND('-') THEN BEGIN
                    IF (ImprestHeader.Status <> ImprestHeader.Status::Pending) THEN
                        ERROR('You Cannot Insert a new record when the status of the document is not Pending');

                END;

                RecPay.RESET;
                RecPay.SETRANGE(RecPay.Code, "Advance Type");
                RecPay.SETRANGE(RecPay.Type, RecPay.Type::Imprest);
                IF RecPay.FIND('-') THEN BEGIN
                    RecPay.TESTFIELD(RecPay."G/L Account");
                    "Account No:" := RecPay."G/L Account";
                    VALIDATE("Account No:");
                END;

                //MODIFY;
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
        field(88; "EFT Bank Account No"; Code[20])
        {
        }
        field(89; "EFT Bank Code"; Code[20])
        {
        }
        field(90; "EFT Account Name"; Text[50])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(50001; "Budgeted Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                               "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
                                                               "Budget Name" = FIELD("Budget Name"),
                                                               "G/L Account No." = FIELD("Account No:")));

        }
        field(50002; "Actual Expenditure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Account No:"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                        "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));

        }
        field(50003; "Committed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("FIN-Committment".Amount WHERE(Budget = FIELD("Budget Name"),
                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                            "Shortcut Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
                                                            "G/L Account No." = FIELD("Account No:")));

        }
        field(50004; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;

            trigger OnValidate()
            begin
                CALCFIELDS("Budgeted Amount");
                CALCFIELDS("Actual Expenditure");
                CALCFIELDS("Committed Amount");
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", No);
                IF ImprestHeader.FIND('-') THEN BEGIN
                    ImprestHeader."Budgeted Amount" := "Budgeted Amount";
                    ImprestHeader."Committed Amount" := "Committed Amount";
                    ImprestHeader."Actual Expenditure" := "Actual Expenditure";
                    ImprestHeader."Budget Balance" := "Budget Balance";
                    ImprestHeader.MODIFY
                END;
            end;
        }
        field(50005; "Budget Balance"; Decimal)
        {
        }
        field(50006; "Budget For"; Option)
        {
            OptionMembers = " ",Yes,No;
            trigger OnValidate()
            begin
                if "Budget For" = "Budget For"::Yes then
                    "Budgetary Control A/C" := true
                else
                    "Budgetary Control A/C" := false;
            end;
        }


    }

    keys
    {
        key(Key1; No, "Advance Type", "Shortcut Dimension 2 Code", "Account No:")
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
                IF "Account No:" <> '' THEN
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
            "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
            "Due Date" := TODAY;
            "Date Issued" := TODAY;

            //ImprestHeader.TESTFIELD("Responsibility Center");
            ImprestHeader.TESTFIELD("Global Dimension 1 Code");
            //ImprestHeader.TESTFIELD("Shortcut Dimension 2 Code");
            //"Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
            //"Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
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
                //  ERROR('You Cannot Modify this record its status is not Pending');

                "Date Taken" := ImprestHeader.Date;
            // "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
            //"Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
            "Currency Factor" := ImprestHeader."Currency Factor";
            "Currency Code" := ImprestHeader."Currency Code";
        END;

        TESTFIELD(Committed, FALSE);
    end;

    var
        GLAcc: Record 15;
        Pay: Record "FIN-Imprest Header";
        ImprestHeader: Record "FIN-Imprest Header";
        RecPay: Record "FIN-Receipts and Payment Types";


    procedure ShowDimensions()
    begin
        //"Dimension Set ID" :=
        // DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2','Imprest',"Line No."));
        //VerifyItemLineDim;
        //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
}