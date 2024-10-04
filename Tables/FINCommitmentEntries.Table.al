table 52178758 "FIN-Commitment Entries"
{
    DrillDownPageID = "FIN-Staff Advance Surr. List";
    //LookupPageID = 68287;
    fields
    {
        field(1; "Commitment No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                IF "Commitment No" <> xRec."Commitment No" THEN BEGIN
                    GenLedgerSetup.GET();
                    NoSeriesMgt.TestManual( GenLedgerSetup."Commitment No");
                     "Commitment No" := '';
                END;
                 */

            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; "Commitment Type"; Option)
        {
            OptionMembers = Committed,Reversal;
        }
        field(4; Account; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Committed Amount"; Decimal)
        {
        }
        field(6; User; Code[20])
        {
        }
        field(7; OrderNo; Code[20])
        {
        }
        field(8; InvoiceNo; Code[20])
        {
        }
        field(9; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; No; Code[20])
        {
        }
        field(11; "Entry No"; Integer)
        {
            AutoIncrement = false;
        }
        field(12; "Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(15; Closed; Boolean)
        {
        }
        field(16; "Clossed Date"; Date)
        {
        }
        field(17; "Clossed By"; Code[20])
        {
        }
        field(18; "Payment Posted"; Boolean)
        {
            CalcFormula = Lookup("FIN-Payments".Posted WHERE(No = FIELD("Commitment No")));
            FieldClass = FlowField;
        }
        field(19; "Payment Posted Date"; Date)
        {
            CalcFormula = Lookup("FIN-Payments"."Date Posted" WHERE(No = FIELD("Commitment No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
            SumIndexFields = "Committed Amount";
        }
        key(Key2; "Commitment No", "Commitment Type", No)
        {
            SumIndexFields = "Committed Amount";
        }
        key(Key3; OrderNo, "Commitment Type")
        {
            SumIndexFields = "Committed Amount";
        }
        key(Key4; Account, Date, "Global Dimension 1", "Global Dimension 2", Department)
        {
            SumIndexFields = "Committed Amount";
        }
        key(Key5; Department)
        {
        }
        key(Key6; Account, Closed, "Global Dimension 2", Date, Department, "Global Dimension 1")
        {
            SumIndexFields = "Committed Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
       IF "Commitment No" = '' THEN BEGIN
         GenLedgerSetup.GET(GenLedgerSetup."Commitment No");
         GenLedgerSetup.TESTFIELD(GenLedgerSetup."Commitment No");
         NoSeriesMgt.InitSeries(GenLedgerSetup."Commitment No",xRec."No. Series",0D,"Commitment No","No. Series");
       END;
        */

    end;

    var
        GenLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
}

