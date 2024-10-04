table 52178755 "FIN-Cashier Link"
{
    // DrillDownPageID = "HRM-Password Generation";
    // LookupPageID = "HRM-Password Generation";

    fields
    {
        field(1; UserID; Code[20])
        {
            NotBlank = true;
            //TableRelation = 2000000002.Field1;
        }
        field(2; "Bank Account No"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(3; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('BRANCHES'));
        }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

