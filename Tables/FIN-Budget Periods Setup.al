table 52178733 "FIN-Budget Periods Setup"
{

    fields
    {
        field(1; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";

        }
        field(2; "Budget Start"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Budget End"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Period ID/Quater ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Period/Quater Start"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Period/Quater End"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Budget Name", "Period ID/Quater ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}