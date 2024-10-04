table 52178734 "FIN-Value Posting"
{

    fields
    {
        field(1; UserID; Code[20])
        {
            //TableRelation = Table2000000002;
        }
        field(2; "Value Posting"; Integer)
        {
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
