table 52178754 "FIN-Bank Codes"
{
    DrillDownPageID = "FIN-Posted Staff Claims";
    LookupPageID = "FIN-Posted Staff Claims";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
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
}

