table 52178756 "FIN-Cheque Types"
{
    DrillDownPageID = "FIN-Claim Types";
    LookupPageID = "FIN-Claim Types";

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

