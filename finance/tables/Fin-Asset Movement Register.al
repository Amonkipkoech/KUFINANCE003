table 52178770 "Fin-Asset Movement Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            NotBlank = true;
        }
        field(2; "Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                cashsetUp.Get();
                cashsetUp.TestField("Asset Movement");

                if "No." = '' then begin
                    "No." := noseries.GetNextNo(cashsetUp."Asset Movement", Today, true);
                end;

                FA.Reset();
                FA.SetRange("No.", "Asset No.");
                if FA.FindFirst() then begin
                    "Asset Name" := FA.Description + ' ' + FA."Description 2";
                end;
            end;

        }
        field(3; "Transfer Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Old Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FA Location";
        }
        field(5; "Current Location"; Code[20])
        {
            TableRelation = "FA Location";
            DataClassification = ToBeClassified;
        }
        field(6; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
            Enabled = false;
        }
        field(10; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
            Enabled = false;
        }
        field(11; Status; Option)
        {
            //Editable = false;
            OptionMembers = Pending,"Pending Approval",Approved,Posted;

            trigger OnValidate()
            begin
                if Status = Status::Approved then
                    if PostMovement() then begin
                        FixedAssets.Reset();
                        FixedAssets.SetRange("No.", "Asset No.");
                        if FixedAssets.FindFirst() then
                            FixedAssets."FA Location Code" := "Current Location";
                        FixedAssets.Modify();

                        Status := Status::Posted;
                    end;


            end;
        }
        field(12; "Asset Name"; Code[20])
        {
            Editable = false;
        }
        field(20; "Approved By"; Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(22; "Approval DateTime"; DateTime)
        {
            Editable = false;

        }
        field(23; "Old Custodian"; code[20])
        {
            TableRelation = "HRM-Employee (D)";
        }
        field(24; "New Custodian"; code[20])
        {
            TableRelation = "HRM-Employee (D)";
        }
    }

    keys
    {
        key(Key1; "No.")
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



        "User ID" := UserId;
        "Creation Date" := Today;

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        assetReg: Record "Fin-Asset Movement Register";
        assetLedger: Record "Fin Assets Movmt Ledger";
        FixedAssets: Record "Fixed Asset";


    local procedure PostMovement(): Boolean
    begin

        if assetReg.Get("No.") then begin
            assetReg.TestField("Transfer Date");
            assetReg.TestField("Current Location");
            assetReg.TestField("Old Location");

            if assetReg."Old Location" = assetReg."Current Location" then Error('Invalid Transfer. Location must be Different');

            assetLedger.Init();
            assetLedger."Document No" := assetReg."No.";
            assetLedger."Current Location" := assetReg."Current Location";
            assetLedger."Previous Location" := assetReg."Old Location";
            assetLedger."Asset No." := assetReg."Asset No.";
            assetLedger.Validate("Asset No.");
            assetLedger."Approved By" := assetReg."Approved By";
            exit(assetLedger.Insert(true));

        end else
            exit(false);
    end;
}