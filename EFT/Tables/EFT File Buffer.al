table 52178792 "EFT File Buffer"
{

    fields
    {
        field(1; "CODE"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "NET AMOUNT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "ACCOUNT NUMBER"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; NAME; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; DESCRIPTION; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "User Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "PF. No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "CODE", "User Name", "PF. No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}