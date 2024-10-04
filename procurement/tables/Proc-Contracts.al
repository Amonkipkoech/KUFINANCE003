table 52178799 "Proc-Contracts"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Contract Code"; code[10])
        {

        }
        field(2; "Contract Name"; Text[100])
        {

        }
        field(3; "Contract Date"; Date)
        {

        }
        field(4; "Contract Period"; code[10])
        {

        }
        field(5; "Service Provider"; Code[20])
        {
            TableRelation = Vendor;
            trigger OnValidate()
            begin
                if vend.Get("Service Provider") then begin
                    "Service Provider Name" := vend.Name;
                    "Contact Person" := vend."Contact Person";
                    "Suplier Telephone" := vend."Mobile Phone No.";
                    "Supplier E-Mail" := vend."E-Mail";

                end;
            end;

        }
        field(6; "Service Provider Name"; Text[100])
        {

        }
        field(7; "Service Description"; Text[100])
        {

        }
        field(8; "Contact Person"; Text[70])
        {

        }
        field(9; "Suplier Telephone"; code[20])
        {

        }
        field(10; "Supplier E-Mail"; text[50])
        {

        }
        field(11; "User Department E-mail"; Text[50])
        {

        }
        field(12; "DVC Admin Email"; Text[50])
        {

        }
        field(13; "Legal Department E-mail"; text[50])
        {

        }
        field(14; "Contract Status"; Option)
        {
            OptionMembers = Active,Executed,Cancelled;
        }
        field(15; "Cancelation Reason"; Text[200])
        {

        }
        field(16; "Requisition Date"; Date)
        {

        }
        field(17; "Requestor Id"; Code[20])
        {

        }
        field(18; "Approval Status"; Option)

        {
            OptionMembers = " ","Pending Approvals",Approved;
        }
    }

    keys
    {
        key(Key1; "Contract Code")
        {
            Clustered = true;
        }
    }

    var
        vend: Record Vendor;




}