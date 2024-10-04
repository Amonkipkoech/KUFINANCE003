table 52178736 "FIN-CshMgt PV Steps"
{
    // DrillDownPageID = 68598;
    // LookupPageID = 68598;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the code of the status in the database';
        }
        field(2; Description; Text[30])
        {
            Description = 'Stores the description of the status in the database';
        }
        field(3; Users; Integer)
        {
            CalcFormula = Count("FIN-CshMgt PV Steps Users" WHERE(Code = FIELD(Code)));
            Description = 'Stores the number of user for the steps';
            FieldClass = FlowField;
        }
        field(67; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit","Custom 3","Custom 4","Custom 5";
        }
        field(68; "Default Account"; Code[20])
        {
            Description = 'Stores the default account in the database';
            TableRelation = "Bank Account"."No.";
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