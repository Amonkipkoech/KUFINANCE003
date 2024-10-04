table 52178779 "PROC-Procurement Plan Lines"
{

    fields
    {
        field(1; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(2; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Fixed Asset';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset";
        }
        field(4; "Type No"; Code[20])
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                IF Type = 1 THEN BEGIN
                    IF GL.GET("Type No") THEN
                        Description := GL.Name;
                    // Category:=GL."Expense Code";
                END;
                IF Type = 2 THEN BEGIN
                    IF ITM.GET("Type No") THEN
                        Description := ITM.Description;
                    Category := ITM."Gen. Prod. Posting Group";

                END;
                IF Type = 3 THEN BEGIN
                    IF FA.GET("Type No") THEN
                        Description := FA.Description;
                    Category := FA."FA Subclass Code";
                END;
            end;
        }
        field(5; Description; Text[100])
        {
        }
        field(6; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Cost";
                "Remaining Qty" := Quantity;
            end;
        }
        field(7; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Cost";
            end;
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "Remaining Qty"; Decimal)
        {
            Editable = false;
        }
        field(10; Projects; Code[20])
        {
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; Category; Code[20])
        {
        }
        field(12; "Plan Date"; Date)
        {
        }
        field(13; "Procurement Plan Period"; Code[20])
        {
            TableRelation = "PROC-Procurement Plan Period".Code;
        }
        field(14; Campus; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(15; Unit; Code[10])
        {
        }
        field(16; Prefence; Code[20])
        {
        }
        field(17; Reservation; Text[30])
        {
        }
        field(18; Method; Code[10])
        {
        }
        field(19; "Source of Funds"; Text[30])
        {
        }
        field(20; "Time process"; Boolean)
        {
        }
        field(21; "pen Tender"; Boolean)
        {
        }
        field(22; "Evaluate tender"; Text[30])
        {
        }
        field(23; "Procurement Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',open Tender,Quotations,Proposals,Force,Framework Agreement,Restricted,Direct';
            OptionMembers = ,"open Tender",Quotations,Proposals,Force,"Framework Agreement",Restricted,Direct;
        }
        field(24; Committee; Text[30])
        {
        }
        field(25; "Contract Signing"; Code[10])
        {
        }
        field(26; "Total time to contract"; Code[10])
        {
        }
        field(27; "Total time to completion"; Code[10])
        {
        }
        field(28; "Open Tender"; Boolean)
        {
        }
        field(29; notification; Code[10])
        {
        }
        field(30; "Date for completion of Contrac"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Advertise Tender"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Bid Opening"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Bid Evaluation"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Tender Award"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Planned days"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF ("Actual Days" <> 0) AND ("Planned days" = 0) THEN TESTFIELD("Planned days");
                "Variance between Days" := "Planned days" - "Actual Days";
            end;
        }
        field(36; "Actual Days"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Planned days" = 0 THEN TESTFIELD("Planned days");
                "Variance between Days" := "Planned days" - "Actual Days";
            end;
        }
        field(37; "Variance between Days"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /*If "Planned days" <> 0 THEN
                  BEGIN
                    "Variance between Days"  := "Planned days" -  "Actual Days";
                    MODIFY;
                    END;
                */

            end;
        }
        field(38; Citizen; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Citizen,Non-Citizen';
            OptionMembers = Citizen,"Non-Citizen";
        }
    }

    keys
    {
        key(Key1; "Budget Name", Department, Type, "Type No", Campus, "Procurement Plan Period")
        {
            Clustered = true;
        }
        key(Key2; "Budget Name", Department, Type, "Type No", Projects, "Procurement Plan Period")
        {
            //Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GL: Record 15;
        FA: Record 5600;
        ITM: Record 27;
}

