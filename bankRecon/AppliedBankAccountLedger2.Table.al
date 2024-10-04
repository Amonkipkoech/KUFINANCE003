table 52178800 "Applied Bank Account Ledger2"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(3; "Statement No."; Code[20])
        {
        }
        field(4; "Statement Line No."; Integer)
        {
        }
        field(5; "Ledger Entry No."; Integer)
        {
        }
        field(6; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

