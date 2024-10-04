table 52178731 "FIN-Budget Entries"
{
    Caption = 'G/L Budget Entry';
    // DrillDownPageID = 77076;
    // LookupPageID = 77076;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Budget Name"; Code[10])
        {
            Caption = 'Budget Name';
            TableRelation = "G/L Budget Name";
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
            ClosingDates = true;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                IF "Global Dimension 1 Code" = xRec."Global Dimension 1 Code" THEN
                    EXIT;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code");
                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code");
            end;
        }
        field(6; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                IF "Global Dimension 2 Code" = xRec."Global Dimension 2 Code" THEN
                    EXIT;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code");
                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code");
            end;
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(9; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(10; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(11; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit 418;
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(12; "Budget Dimension 1 Code"; Code[20])
        {
            AccessByPermission = TableData 348 = R;
            CaptionClass = GetCaptionClass(1);
            Caption = 'Budget Dimension 1 Code';

            trigger OnLookup()
            begin
                "Budget Dimension 1 Code" := OnLookupDimCode(2, "Budget Dimension 1 Code");
            end;

            trigger OnValidate()
            begin
                IF "Budget Dimension 1 Code" = xRec."Budget Dimension 1 Code" THEN
                    EXIT;
                IF GLBudgetName.Name <> "Budget Name" THEN
                    GLBudgetName.GET("Budget Name");
                ValidateDimValue(GLBudgetName."Budget Dimension 1 Code", "Budget Dimension 1 Code");
                UpdateDimensionSetId(GLBudgetName."Budget Dimension 1 Code", "Budget Dimension 1 Code");
            end;
        }
        field(13; "Budget Dimension 2 Code"; Code[20])
        {
            AccessByPermission = TableData 348 = R;
            CaptionClass = GetCaptionClass(2);
            Caption = 'Budget Dimension 2 Code';

            trigger OnLookup()
            begin
                "Budget Dimension 2 Code" := OnLookupDimCode(3, "Budget Dimension 2 Code");
            end;

            trigger OnValidate()
            begin
                IF "Budget Dimension 2 Code" = xRec."Budget Dimension 2 Code" THEN
                    EXIT;
                IF GLBudgetName.Name <> "Budget Name" THEN
                    GLBudgetName.GET("Budget Name");
                ValidateDimValue(GLBudgetName."Budget Dimension 2 Code", "Budget Dimension 2 Code");
                UpdateDimensionSetId(GLBudgetName."Budget Dimension 2 Code", "Budget Dimension 2 Code");
            end;
        }
        field(14; "Budget Dimension 3 Code"; Code[20])
        {
            AccessByPermission = TableData 350 = R;
            CaptionClass = GetCaptionClass(3);
            Caption = 'Budget Dimension 3 Code';

            trigger OnLookup()
            begin
                "Budget Dimension 3 Code" := OnLookupDimCode(4, "Budget Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                IF "Budget Dimension 3 Code" = xRec."Budget Dimension 3 Code" THEN
                    EXIT;
                IF GLBudgetName.Name <> "Budget Name" THEN
                    GLBudgetName.GET("Budget Name");
                ValidateDimValue(GLBudgetName."Budget Dimension 3 Code", "Budget Dimension 3 Code");
                UpdateDimensionSetId(GLBudgetName."Budget Dimension 3 Code", "Budget Dimension 3 Code");
            end;
        }
        field(15; "Budget Dimension 4 Code"; Code[20])
        {
            AccessByPermission = TableData 350 = R;
            CaptionClass = GetCaptionClass(4);
            Caption = 'Budget Dimension 4 Code';

            trigger OnLookup()
            begin
                "Budget Dimension 4 Code" := OnLookupDimCode(5, "Budget Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                IF "Budget Dimension 4 Code" = xRec."Budget Dimension 4 Code" THEN
                    EXIT;
                IF GLBudgetName.Name <> "Budget Name" THEN
                    GLBudgetName.GET("Budget Name");
                ValidateDimValue(GLBudgetName."Budget Dimension 4 Code", "Budget Dimension 4 Code");
                UpdateDimensionSetId(GLBudgetName."Budget Dimension 4 Code", "Budget Dimension 4 Code");
            end;
        }
        field(16; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                    ERROR(DimMgt.GetDimCombErr);
            end;
        }
        field(481; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Allocation,Commitment,Expense';
            OptionMembers = " ",Allocation,Commitment,Expense;
        }
        field(482; "Commitment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Commitment,Commited/Posted,Cancelled';
            OptionMembers = " ",Commitment,"Commited/Posted",Cancelled;
        }
        field(483; "Document Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(484; "Document No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(485; "Document Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Budget Name")
        {
            Clustered = true;
        }
        key(Key2; "Budget Name", "G/L Account No.", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Budget Dimension 1 Code", "Budget Dimension 2 Code", "Budget Dimension 3 Code", "Budget Dimension 4 Code", Date)
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Budget Name", "G/L Account No.", Description, Date)
        {
        }
        key(Key5; "G/L Account No.", Date, "Budget Name", "Dimension Set ID")
        {
            SumIndexFields = Amount;
        }
        key(Key6; "Last Date Modified", "Budget Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CheckIfBlocked;
    end;

    trigger OnInsert()
    var
        TempDimSetEntry: Record 480 temporary;
    begin
        CheckIfBlocked;
        TESTFIELD(Date);
        TESTFIELD("G/L Account No.");
        TESTFIELD("Budget Name");
        LOCKTABLE;
        "User ID" := USERID;
        "Last Date Modified" := TODAY;
        IF "Entry No." = 0 THEN
            "Entry No." := GetNextEntryNo;

        GetGLSetup;
        DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
        UpdateDimSet(TempDimSetEntry, GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code");
        UpdateDimSet(TempDimSetEntry, GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code");
        UpdateDimSet(TempDimSetEntry, GLBudgetName."Budget Dimension 1 Code", "Budget Dimension 1 Code");
        UpdateDimSet(TempDimSetEntry, GLBudgetName."Budget Dimension 2 Code", "Budget Dimension 2 Code");
        UpdateDimSet(TempDimSetEntry, GLBudgetName."Budget Dimension 3 Code", "Budget Dimension 3 Code");
        UpdateDimSet(TempDimSetEntry, GLBudgetName."Budget Dimension 4 Code", "Budget Dimension 4 Code");
        VALIDATE("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
    end;

    trigger OnModify()
    begin
        CheckIfBlocked;
        "User ID" := USERID;
        "Last Date Modified" := TODAY;
    end;

    var
        Text000: Label 'The dimension value %1 has not been set up for dimension %2.';
        Text001: Label '1,5,,Budget Dimension 1 Code';
        Text002: Label '1,5,,Budget Dimension 2 Code';
        Text003: Label '1,5,,Budget Dimension 3 Code';
        Text004: Label '1,5,,Budget Dimension 4 Code';
        GLBudgetName: Record 95;
        GLSetup: Record 98;
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit 408;
        GLSetupRetrieved: Boolean;

    local procedure CheckIfBlocked()
    begin
        IF "Budget Name" = GLBudgetName.Name THEN
            EXIT;
        IF GLBudgetName.Name <> "Budget Name" THEN
            GLBudgetName.GET("Budget Name");
        GLBudgetName.TESTFIELD(Blocked, FALSE);
    end;

    local procedure ValidateDimValue(DimCode: Code[20]; var DimValueCode: Code[20])
    var
        DimValue: Record "Dimension Value";
    begin
        IF DimValueCode = '' THEN
            EXIT;

        DimValue."Dimension Code" := DimCode;
        DimValue.Code := DimValueCode;
        DimValue.FIND('=><');
        IF DimValueCode <> COPYSTR(DimValue.Code, 1, STRLEN(DimValueCode)) THEN
            ERROR(Text000, DimValueCode, DimCode);
        DimValueCode := DimValue.Code;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRetrieved THEN BEGIN
            GLSetup.GET;
            GLSetupRetrieved := TRUE;
        END;
    end;

    local procedure OnLookupDimCode(DimOption: Option "Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; DefaultValue: Code[20]): Code[20]
    var
        DimValue: Record "Dimension Value";
        DimValueList: Page 560;
    begin
        IF DimOption IN [DimOption::"Global Dimension 1", DimOption::"Global Dimension 2"] THEN
            GetGLSetup
        ELSE
            IF GLBudgetName.Name <> "Budget Name" THEN
                GLBudgetName.GET("Budget Name");
        CASE DimOption OF
            DimOption::"Global Dimension 1":
                DimValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
            DimOption::"Global Dimension 2":
                DimValue."Dimension Code" := GLSetup."Global Dimension 2 Code";
            DimOption::"Budget Dimension 1":
                DimValue."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
            DimOption::"Budget Dimension 2":
                DimValue."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
            DimOption::"Budget Dimension 3":
                DimValue."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
            DimOption::"Budget Dimension 4":
                DimValue."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
        END;
        DimValue.SETRANGE("Dimension Code", DimValue."Dimension Code");
        IF DimValue.GET(DimValue."Dimension Code", DefaultValue) THEN;
        DimValueList.SETTABLEVIEW(DimValue);
        DimValueList.SETRECORD(DimValue);
        DimValueList.LOOKUPMODE := TRUE;
        IF DimValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValueList.GETRECORD(DimValue);
            EXIT(DimValue.Code);
        END;
        EXIT(DefaultValue);
    end;

    local procedure GetNextEntryNo(): Integer
    var
        GLBudgetEntry: Record 96;
    begin
        GLBudgetEntry.SETCURRENTKEY("Entry No.");
        IF GLBudgetEntry.FINDLAST THEN
            EXIT(GLBudgetEntry."Entry No." + 1);

        EXIT(1);
    end;

    local procedure GetCaptionClass(BudgetDimType: Integer): Text[250]
    begin
        IF GETFILTER("Budget Name") <> '' THEN
            IF GLBudgetName.Name <> GETRANGEMIN("Budget Name") THEN
                IF NOT GLBudgetName.GET(GETRANGEMIN("Budget Name")) THEN
                    CLEAR(GLBudgetName);
        CASE BudgetDimType OF
            1:
                BEGIN
                    IF GLBudgetName."Budget Dimension 1 Code" <> '' THEN
                        EXIT('1,5,' + GLBudgetName."Budget Dimension 1 Code");

                    EXIT(Text001);
                END;
            2:
                BEGIN
                    IF GLBudgetName."Budget Dimension 2 Code" <> '' THEN
                        EXIT('1,5,' + GLBudgetName."Budget Dimension 2 Code");

                    EXIT(Text002);
                END;
            3:
                BEGIN
                    IF GLBudgetName."Budget Dimension 3 Code" <> '' THEN
                        EXIT('1,5,' + GLBudgetName."Budget Dimension 3 Code");

                    EXIT(Text003);
                END;
            4:
                BEGIN
                    IF GLBudgetName."Budget Dimension 4 Code" <> '' THEN
                        EXIT('1,5,' + GLBudgetName."Budget Dimension 4 Code");

                    EXIT(Text004);
                END;
        END;
    end;

    procedure ShowDimensions()
    var
        DimSetEntry: Record 480;
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Budget Name", "G/L Account No.", "Entry No."));

        IF OldDimSetID = "Dimension Set ID" THEN
            EXIT;

        GetGLSetup;
        GLBudgetName.GET("Budget Name");

        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        "Budget Dimension 1 Code" := '';
        "Budget Dimension 2 Code" := '';
        "Budget Dimension 3 Code" := '';
        "Budget Dimension 4 Code" := '';

        IF DimSetEntry.GET("Dimension Set ID", GLSetup."Global Dimension 1 Code") THEN
            "Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLSetup."Global Dimension 2 Code") THEN
            "Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 1 Code") THEN
            "Budget Dimension 1 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 2 Code") THEN
            "Budget Dimension 2 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 3 Code") THEN
            "Budget Dimension 3 Code" := DimSetEntry."Dimension Value Code";
        IF DimSetEntry.GET("Dimension Set ID", GLBudgetName."Budget Dimension 4 Code") THEN
            "Budget Dimension 4 Code" := DimSetEntry."Dimension Value Code";
    end;

    procedure UpdateDimSet(var TempDimSetEntry: Record 480 temporary; DimCode: Code[20]; DimValueCode: Code[20])
    begin
        IF DimCode = '' THEN
            EXIT;
        IF TempDimSetEntry.GET("Dimension Set ID", DimCode) THEN
            TempDimSetEntry.DELETE;
        IF DimValueCode = '' THEN
            DimVal.INIT
        ELSE
            DimVal.GET(DimCode, DimValueCode);
        TempDimSetEntry.INIT;
        TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry."Dimension Value Code" := DimValueCode;
        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
        TempDimSetEntry.INSERT;
    end;

    local procedure UpdateDimensionSetId(DimCode: Code[20]; DimValueCode: Code[20])
    var
        TempDimSetEntry: Record 480 temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
        UpdateDimSet(TempDimSetEntry, DimCode, DimValueCode);
        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
}