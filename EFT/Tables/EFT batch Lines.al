table 52178740 "EFT batch Lines"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Doc No"; Code[20])
        {
        }
        field(3; Payee; Text[150])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Bank A/C No"; Code[20])
        {
        }
        field(6; "Bank Branch No"; Code[20])
        {
        }
        field(7; "Bank A/C Name"; Text[50])
        {
        }
        field(8; "Bank Code"; Code[20])
        {
        }
        field(9; Status; Option)
        {
            OptionMembers = New,Submitted,Cleared;
        }
        field(10; Date; Date)
        {
        }
        field(11; Select; Boolean)
        {
        }
        field(12; Type; Option)
        {
            OptionMembers = Creditors,Salaries;
        }
        field(13; Paid; Boolean)
        {
        }
        field(14; "Paid By"; Code[20])
        {
        }
        field(15; "Paid Date"; Date)
        {
        }
        field(16; "PV Number"; Code[20])
        {
        }
        field(17; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ERROR('Please note that you can not delete EFT payments');
    end;

    trigger OnInsert()
    begin
        IF "Doc No" = '' THEN BEGIN
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."EFT Batch No");
            //NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No",xRec."No. Series",0D,"Doc No","No. Series");
        END;
        PHead.RESET;
        PHead.SETRANGE(PHead."No.", "Doc No");
        IF PHead.FINDFIRST THEN BEGIN
            Date := PHead.Date;

        END;
    end;

    var
        GenLedgerSetup: Record "FIN-Cash Office Setup";
        "No. Series": Code[20];
        PHead: Record "EFT Batch Header";
        NoSeriesMgt: Codeunit 396;
}
