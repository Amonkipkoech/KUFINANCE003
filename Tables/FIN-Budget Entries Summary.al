table 52178732 "FIN-Budget Entries Summary"
{
    Caption = 'G/L Budget Entry';
    DrillDownPageID = 120;
    LookupPageID = 120;

    fields
    {
        field(1; "Budget Name"; Code[10])
        {
            Caption = 'Budget Name';
            TableRelation = "G/L Budget Name";
        }
        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(3; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(4; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5; "Budget Start Date"; Date)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(6; "Budget End Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(7; Allocation; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = Sum("FIN-Budget Entries".Amount WHERE("Transaction Type" = FILTER(Allocation),
                                                                 "Commitment Status" = FILTER(' '),
                                                                 "Budget Name" = FIELD("Budget Name"),
                                                                 Date = FIELD("Budget End Date"),
                                                                 "G/L Account No." = FIELD("G/L Account No."),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));

        }
        field(8; Commitments; Decimal)
        {
            TableRelation = "FIN-Budget Entries".Amount;
            CalcFormula = Sum("FIN-Budget Entries".Amount WHERE("Transaction Type" = FILTER(Commitment),
                                                                 "Commitment Status" = FILTER(Commitment),
                                                                "Budget Name" = FIELD("Budget Name"),
                                                                 Date = FIELD("Budget End Date"),
                                                                 "G/L Account No." = FIELD("G/L Account No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(9; Expenses; Decimal)
        {
            TableRelation = "FIN-Budget Entries".Amount;
            CalcFormula = Sum("FIN-Budget Entries".Amount WHERE("Transaction Type" = FILTER(Expense),
                                                                 "Budget Name" = FIELD("Budget Name"),
                                                                 Date = FIELD("Budget End Date"),
                                                                 "G/L Account No." = FIELD("G/L Account No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(10; Balance; Decimal)
        {
            TableRelation = "FIN-Budget Entries".Amount;
            CalcFormula = Sum("FIN-Budget Entries".Amount WHERE("Transaction Type" = FILTER(Allocation | Commitment | Expense),
                                                                 "Commitment Status" = FILTER(<> "Commited/Posted"),
                                                                 "Budget Name" = FIELD("Budget Name"),
                                                                 Date = FIELD("Budget End Date"),
                                                                 "G/L Account No." = FIELD("G/L Account No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(11; "Net Balance"; Decimal)
        {
            TableRelation = "FIN-Budget Entries".Amount;
            CalcFormula = Sum("FIN-Budget Entries".Amount WHERE("Transaction Type" = FILTER(Allocation | Commitment | Expense),
                                                                 "Commitment Status" = FILTER(<> "Commited/Posted"),
                                                                "Budget Name" = FIELD("Budget Name"),
                                                                 Date = FIELD("Budget End Date"),
                                                                 "G/L Account No." = FIELD("G/L Account No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(12; "% Balance"; Decimal)
        {
        }
        field(13; "% Net Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Vote Name"; Text[100])
        {
            TableRelation = "G/L Account";
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
        }
    }

    keys
    {
        key(Key1; "Budget Name", "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TempDimSetEntry: Record 480 temporary;
    begin
    end;

    var
        Text000: Label 'The dimension value %1 has not been set up for dimension %2.';
        Text001: Label '1,5,,Budget Dimension 1 Code';
        Text002: Label '1,5,,Budget Dimension 2 Code';
        Text003: Label '1,5,,Budget Dimension 3 Code';
        Text004: Label '1,5,,Budget Dimension 4 Code';
        GLBudgetName: Record "G/L Budget Name";
        GLSetup: Record 98;
        DimVal: Record "Dimension Value";
        //DimMgt: Codeunit 408;
        GLSetupRetrieved: Boolean;
}
