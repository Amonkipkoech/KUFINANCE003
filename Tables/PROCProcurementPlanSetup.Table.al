table 52178763 "PROC-Procurement Plan Setup"
{

    fields
    {
        field(1; No; Code[10])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; Open; Boolean)
        {
            InitValue = false;
        }
        field(4; "Procurement Period"; Code[40])
        {
        }
        field(6; Remarks; Text[50])
        {
        }
        field(7; "Current plan Amt"; Decimal)
        {
        }
        field(8; "Current Items Qty"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

