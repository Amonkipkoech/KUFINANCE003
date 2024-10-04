table 52178714 "FIN-Financial Periods"
{

    fields
    {
        field(1; "Period Code"; Code[20])
        {
        }
        field(2; "Period Name"; Text[30])
        {
        }
        field(3; "Current Period"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Period Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
