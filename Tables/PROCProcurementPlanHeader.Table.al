table 52178777 "PROC-Procurement Plan Header"
{
    DrillDownPageID = "PROC-Procurement Plan list";
    LookupPageID = "PROC-Procurement Plan list";
    fields
    {
        field(1; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(2; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(3; "Campus Code"; Code[20])
        {

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(4; "Procurement Plan Period"; Code[20])
        {
            TableRelation = "PROC-Procurement Plan Period".Code;
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionMembers = Pending,"Pending Approval",Approved;
        }
    }

    keys
    {
        key(Key1; "Budget Name", "Department Code", "Campus Code", "Procurement Plan Period")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Dim: Record "Dimension Value";
        DptName: Text[50];
        planLines: Record "PROC-Procurement Plan Lines";

    procedure PlanLinesExist(): Boolean
    begin
        planLines.Reset();
        planLines.SetRange("Budget Name", Rec."Budget Name");
        planLines.SetRange(Campus, Rec."Campus Code");
        planLines.SetRange(Department, Rec."Department Code");
        planLines.SetRange("Procurement Plan Period", Rec."Procurement Plan Period");
        exit(planLines.Find('-'));

    end;
}

