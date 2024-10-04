table 52178772 "Prequalification Periods"
{
    Caption = 'Prequalification Periods';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No"; code[20])
        {

        }
        field(2; "Prequalification period"; code[20])
        {
            TableRelation = "Prequalification Years";
        }
        field(3; Status; Option)
        {
            OptionMembers = Active,Inactive,Blacklisted;
        }
    }
    keys
    {
        key(PK; "Vendor No", "Prequalification period")
        {
            Clustered = true;
        }
    }
}
