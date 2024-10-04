table 52178771 "Fin Assets Movmt Ledger"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Line No."; Integer)
        {

            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Current Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FA Location";
        }
        field(4; "Previous Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FA Location";
        }
        field(5; "Posted by"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Users;
        }
        field(6; "Posted Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Asset No."; Code[20])
        {

            trigger OnValidate()

            var
                FA: Record "Fixed Asset";
            begin
                FA.Reset();
                FA.SetRange("No.", "Asset No.");
                if FA.FindFirst() then begin
                    "Asset Name" := FA.Description + ' ' + FA."Description 2";
                end;
            end;
        }
        field(8; "Asset Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Approved By"; Code[20])
        {
            TableRelation = User;
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        cashsetUp: Record "FIN-Cash Office Setup";
        noseries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin

        "Posted by" := UserId;
        "Posted Date" := today;
    end;

    trigger OnModify()
    begin
        Error('Reccord can not be modified');
    end;

    trigger OnDelete()
    begin
        Error('Reccord can not be deleted');
    end;

    trigger OnRename()
    begin
        Error('Reccord can not be modified');
    end;

}