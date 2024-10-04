table 52178767 "PROC-Internal Requisition"
{
    // DrillDownPageID = "68004";
    //  LookupPageID = 68004;

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the unique identifier of the requisition in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when teh requisition was stored in the database';
            NotBlank = true;
        }
        field(3; "Date Requisitioned"; Date)
        {
            Description = 'Stores the date when the requisition was made';
            NotBlank = true;
        }
        field(4; "Date Required"; Date)
        {
            Description = 'Stores the date when the Requisition should have been met by';
        }
        field(5; "Requisitioned By"; Text[50])
        {
            Description = 'Stores the name of the person who requisitioned for the items';
            NotBlank = true;
        }
        field(6; Department; Code[20])
        {
            Description = 'Stores the reference of the department that the requisition was raised for';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE(Code = CONST('DEPARTMENT'));
        }
        field(7; Remarks; Text[100])
        {
            Description = 'Stores the remarks that the user might make in relation to the requisition in the database';
        }
        field(8; "Entered By"; Code[20])
        {
            Description = 'Stores the code reference of the user who inserted the requisition into the database';
            NotBlank = true;
        }
        field(9; "Units Due"; Decimal)
        {
            CalcFormula = Sum("PROC-Internal Requisition Line"."Total Units Due" WHERE("No." = FIELD("No.")));
            Description = 'Stores the total number of units requisitioned in the database';
            FieldClass = FlowField;
        }
        field(10; "Units Issued"; Decimal)
        {
            CalcFormula = Sum("PROC-Internal Requisition Line"."Total Units Issued" WHERE("No." = FIELD("No.")));
            Description = 'Stores the total number of units that have been issued in the database';
            FieldClass = FlowField;
        }
        field(11; Status; Option)
        {
            Description = 'Stores the status of the requisition in the database. This can be New,Pending,Approved,Rejected,Completed';
            OptionMembers = New,Pending,Approved,Rejected,Completed,Issue,Issued;
        }
        field(12; "No. Series"; Code[20])
        {
            Description = 'Stores the reference to the number series in the database';
            TableRelation = "No. Series".Code;
        }
        field(13; Remaining; Decimal)
        {
            Description = 'Stores the remaining quantity in the database';
        }
        field(14; Select; Boolean)
        {
        }
        field(15; "Prepared By"; Code[20])
        {
        }
        field(16; "Prepared Date"; Date)
        {
        }
        field(17; "Prepared Time"; Time)
        {
        }
        field(18; "HOD Approved By"; Code[20])
        {
        }
        field(19; "HOD Approved Date"; Date)
        {
        }
        field(20; "HOD Approved Time"; Time)
        {
        }
        field(21; "Store Approved By"; Code[20])
        {
        }
        field(22; "Store Approved Date"; Date)
        {
        }
        field(23; "Store Approved Time"; Time)
        {
        }
        field(24; "Principal Approved By"; Code[20])
        {
        }
        field(25; "Principal Approved By Date"; Date)
        {
        }
        field(26; "Principal Approved By Time"; Time)
        {
        }
        field(27; "Request Plan No"; Code[10])
        {
            NotBlank = true;
            TableRelation = "PROC-Internal Requisition Plan"."No." WHERE(Status = CONST(Completed),
                                                                        Department = FIELD(Department));
        }
        field(28; "Selling Outlet"; Code[20])
        {
            //TableRelation = Table39005613.Field1;
        }
        field(29; SRN; Code[10])
        {
        }
        field(30; "HOD Status"; Option)
        {
            OptionCaption = 'Approve,Reject';
            OptionMembers = Approve,Reject;
        }
        field(31; "HOD Remarks"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //insert a new number from the number series table
        IF "No." = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Stores Requisition No");
            NoSeriesMgt.InitSeries(PurchSetup."Stores Requisition No", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit 396;
        PurchSetup: Record 312;
}

