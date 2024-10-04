table 52178703 "PROC-Store Requistion Lines"
{
    //DrillDownPageID = 68151;
    //LookupPageID = 68151;

    fields
    {
        field(1; "Requistion No"; Code[20])
        {

            trigger OnValidate()
            begin

                //   IF ReqHeader.GET("Requistion No") THEN BEGIN
                //     IF ReqHeader."Global Dimension 1 Code"='' THEN
                //        ERROR('Please Select the Global Dimension 1 Requisitioning')
                //   END;
                IF ReqHeader.GET("Requistion No") THEN BEGIN
                    "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
                end;



            end;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Minor Asset';
            OptionMembers = " ",Item,"Minor Asset";
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("Minor Asset")) "Fixed Asset"."No." WHERE("FA Location Code" = FIELD("Issuing Store"));

            trigger OnValidate()
            begin


                //Control: Don't Post Same Item Twice NOT GL's
                IF Type = Type::" " THEN BEGIN
                    RequisitionLine.RESET;
                    RequisitionLine.SETRANGE(RequisitionLine."Requistion No", "Requistion No");
                    RequisitionLine.SETRANGE(RequisitionLine."No.", "No.");
                    IF RequisitionLine.FIND('-') THEN
                        ERROR('You Cannot enter two lines for the same Item');
                END;
                //

                "Action Type" := "Action Type"::"Ask for Quote";

                IF Type = Type::Item THEN BEGIN
                    IF QtyStore.GET("No.") THEN
                        Description := QtyStore.Description;
                    "Unit of Measure" := QtyStore."Base Unit of Measure";
                    "Unit Cost" := QtyStore."Unit Cost";
                    "Line Amount" := "Unit Cost" * "Quantity To Issue";
                    QtyStore.CALCFIELDS(QtyStore.Inventory);
                    "Qty in store" := QtyStore.Inventory;
                    IF ((QtyStore.Inventory <= 0)) THEN MESSAGE('There are no  ''' + QtyStore.Description + '''  on stock.');
                    //   IF ((QtyStore.Inventory<=0)) THEN ERROR('There are no '''+QtyStore.Description+''' in the Store to be issued!!\Please consult the store Manager for advice.');
                END;

                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("No.") THEN
                        Description := Item.Description;
                END;

                IF Type = Type::"Minor Asset" THEN BEGIN
                    IF FA.GET("No.") THEN
                        Description := FA.Description;
                END;

            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity Requested';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity To Issue" := Quantity;

                IF Type = Type::" " THEN BEGIN
                    "Line Amount" := "Unit Cost" * Quantity;
                END;

                IF QtyStore.GET("No.") THEN
                    QtyStore.CALCFIELDS(QtyStore.Inventory);
                "Qty in store" := QtyStore.Inventory;
                //CheckStocklevel;
            end;
        }
        field(9; "Qty in store"; Decimal)
        {
            FieldClass = Normal;
        }
        field(10; "Request Status"; Option)
        {
            Editable = true;
            OptionMembers = Pending,Released,"Director Approval","Budget Approval","FD Approval","CEO Approval",Approved,Closed;
        }
        field(11; "Action Type"; Option)
        {
            OptionMembers = " ",Issue,"Ask for Quote";

            trigger OnValidate()
            begin
                IF Type = Type::" " THEN BEGIN
                    IF "Action Type" = "Action Type"::Issue THEN
                        ERROR('You cannot Issue a G/L Account please order for it')
                END;


                //Compare Quantity in Store and Qty to Issue
                IF Type = Type::" " THEN BEGIN
                    IF "Action Type" = "Action Type"::Issue THEN BEGIN
                        IF Quantity > "Qty in store" THEN
                            ERROR('You cannot Issue More than what is available in store')
                    END;
                END;
            end;
        }
        field(12; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(13; "Total Budget"; Decimal)
        {
        }
        field(14; "Current Month Budget"; Decimal)
        {
        }
        field(15; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                // IF Type=Type::Item THEN
                "Line Amount" := "Unit Cost" * "Quantity To Issue";
            end;
        }
        field(16; "Line Amount"; Decimal)
        {
        }
        field(17; "Quantity Requested"; Decimal)
        {
            Caption = 'Quantity Requested';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Quantity := "Quantity Requested";
                "Quantity To Issue" := "Quantity Requested";

                VALIDATE(Quantity);
                //"Line Amount":="Unit Cost"*Quantity;
                //"Line Amount":="Unit Cost"*"Quantity Issue;
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Current Actuals Amount"; Decimal)
        {
        }
        field(27; Committed; Boolean)
        {
        }
        field(81; "Shortcut Dimension 3 Code"; Code[120])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[120])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(83; "Issuing Store"; Code[20])
        {
            TableRelation = IF (Type = CONST(Item)) Location
            ELSE
            IF (Type = CONST("Minor Asset")) "FA Location";

            trigger OnValidate()
            begin
                //IF Loc.GET("Issuing Store") THEN
                //  "Issue UserID":=Loc."Milk Collection Vehicle";
            end;
        }
        field(84; "Quantity To Issue"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Quantity To Issue" > Quantity THEN ERROR('You cannot Issue more than requested.');
                IF ("Quantity Issued" + "Quantity To Issue") > Quantity THEN
                    ERROR('Total Issued Items cannot exceed the Total Requested..');
                "Issue Quantity" := "Quantity To Issue";
                "Line Amount" := "Unit Cost" * "Quantity To Issue";
            end;
        }
        field(85; "Quantity Issued"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(86; "Issue Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(50035; "Budgeted Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Name" = FIELD("Budget Name"),
                                                               "G/L Account No." = FIELD("Vote Account"),
                                                               "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
                                                               "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));

        }
        field(50036; "Actual Expenditure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Vote Account"),
                                                        "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
                                                        "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));

        }
        field(50037; "Committed Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("FIN-Committment".Amount WHERE("G/L Account No." = FIELD("Vote Account"),
                                                            Budget = FIELD("Budget Name"),
                                                            "Shortcut Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
                                                            "Shortcut Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));

        }
        field(50038; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50039; "Budget Balance"; Decimal)
        {
        }
        field(50040; "Vote Account"; Code[20])
        {
        }
        field(50041; "Issue UserID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Requistion No", "No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount";
        }
        key(Key2; "No.", Type, "Request Status")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ReqHeader.RESET;
        ReqHeader.SETRANGE(ReqHeader."No.", "Requistion No");
        IF ReqHeader.FIND('-') THEN
            IF ReqHeader.Status <> ReqHeader.Status::Open THEN
                ERROR('You Cannot Delete Entries if status is not Pending/Open')
    end;

    trigger OnInsert()
    begin

        "Line Amount" := "Unit Cost" * "Quantity To Issue";

        ReqHeader.RESET;
        ReqHeader.SETRANGE(ReqHeader."No.", "Requistion No");
        IF ReqHeader.FIND('-') THEN BEGIN
            "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
            IF ReqHeader.Status <> ReqHeader.Status::Open THEN
                ERROR('You Cannot Enter Entries if status is not Pending')
        END;
    end;

    trigger OnModify()
    begin

        IF Type = Type::" " THEN
            "Line Amount" := "Unit Cost" * "Quantity To Issue";


        ReqHeader.RESET;
        ReqHeader.SETRANGE(ReqHeader."No.", "Requistion No");
        IF ReqHeader.FIND('-') THEN BEGIN
            "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
            //IF ReqHeader.Status<>ReqHeader.Status::Open THEN
            // IF (("Quantity To Issue"=xRec."Quantity To Issue") AND (xRec."Quantity Issued"="Quantity Issued")
            //AND ("Issue Quantity"=xRec."Issue Quantity")) THEN
            //  ERROR('You Cannot Modify Entries if status is not Pending')
        END;

        /* ReqHeader.RESET;
         ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
         IF ReqHeader.FIND('-') THEN BEGIN
          "Shortcut Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code":=ReqHeader."Shortcut Dimension 2 Code";
          "Shortcut Dimension 3 Code":=ReqHeader."Shortcut Dimension 3 Code";
          "Shortcut Dimension 4 Code":=ReqHeader."Shortcut Dimension 4 Code";
          IF ReqHeader.Status<>ReqHeader.Status::Open THEN
              ERROR('You Cannot Modify Entries if status is not Pending')
         END; */

    end;

    var
        GLAccount: Record 15;
        GenLedSetup: Record 98;
        QtyStore: Record 27;
        GenPostGroup: Record 252;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        ReqHeader: Record "PROC-Store Requistion Header";
        BudgetDate: Date;
        YrBudget: Decimal;
        RequisitionLine: Record "PROC-Store Requistion Lines";
        Item: Record 27;
        FA: Record 5600;
        qty: Integer;
        Loc: Record 14;


    procedure CheckStocklevel()
    begin
        Item.RESET;
        Item.GET("No.");
        Item.SETFILTER(Item."Location Filter", "Issuing Store");
        Item.CALCFIELDS(Item.Inventory);
        qty := Item.Inventory;
        IF (qty - Quantity) < 0 THEN BEGIN
            ERROR('This transaction will result in Negative stock');
        END;
    end;
}