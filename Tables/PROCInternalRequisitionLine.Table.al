table 52178765 "PROC-Internal Requisition Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference to the requisition header in the database';
        }
        field(2; Type; Option)
        {
            Description = 'Stores the type of item being requisitioned can be Item, GL Account or Fixed Asset';
            OptionMembers = Item;
        }
        field(3; "Type No."; Code[20])
        {
            Description = 'Stores the reference code the item being requisitioned for.';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                Item.SETRANGE(Item."No.", "Type No.");
                IF Item.FIND('-') THEN BEGIN
                    "Gen.pro Posting" := Item."Gen. Prod. Posting Group";
                    "Unit of Measure" := Item."Base Unit of Measure";
                    "Unit Direct Cost" := Item."Standard Cost";
                END;
            end;
        }
        field(4; Description; Text[50])
        {
            Description = 'Stores the description of the item being requisitioned for';
        }
        field(5; Purpose; Text[50])
        {
            Description = 'Stores the purpose of the requisition for the item in the database';
        }
        field(6; Qty; Decimal)
        {
            Description = 'Stores the quantity being requisitioned for in the database';
        }
        field(7; "Unit of Measure"; Code[20])
        {
            Description = 'Stores the reference code of the unit of measure in the database';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Type No."));
        }
        field(8; "Units per Unit of Measure"; Decimal)
        {
            Description = 'Stores the number of units in the unit of measure for the item in the database';
        }
        field(9; "Unit Direct Cost"; Decimal)
        {
            Description = 'Stores the unit direct cost of the item in the database';
        }
        field(10; "Total Units Due"; Decimal)
        {
            Description = 'Stores the total units due in the requisition';
        }
        field(11; "Total Cost"; Decimal)
        {
            Description = 'Stores the total cost expected in the database i.e. Unit Direct Cost * Total Units Due';
        }
        field(12; "Total Units Issued"; Decimal)
        {
            Description = 'Stores the total units issued to date for the item in the database';
        }
        field(13; "Action"; Option)
        {
            Description = 'Stores the action tied to the item in the database';
            OptionMembers = Issue,"Issue & Raise Procurement Requisition","Raise Procurement Requisition";
        }
        field(14; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Remaining Qty"; Decimal)
        {
        }
        field(16; "Gen.pro Posting"; Code[20])
        {
        }
        field(17; "Selling OutLet"; Code[20])
        {
            //TableRelation = 39005613.Field1;
        }
        field(18; "Existing Qty"; Decimal)
        {
            Description = 'Existing Stock';
        }
        field(19; Location; Code[20])
        {
            TableRelation = Location.Code;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Total Units Due", "Total Units Issued";
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record 27;
}

