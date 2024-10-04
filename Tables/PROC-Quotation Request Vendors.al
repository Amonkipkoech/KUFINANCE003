table 52178729 "PROC-Quotation Request Vendors"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(4; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
        field(5; "Expected Closing Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}