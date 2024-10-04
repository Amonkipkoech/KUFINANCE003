table 52178750 "Receipts Header"
{
    // DrillDownPageID = 50651;
    // LookupPageID = 50651;

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the code of the receipt in the database';
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the receipt was entered into the system';
        }
        field(3; Cashier; Code[20])
        {
            Description = 'Stores the user id of the cashier';
        }
        field(4; "Date Posted"; Date)
        {
        }
        field(5; "Time Posted"; Time)
        {
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "No. Series"; Code[20])
        {
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                /*
                IF PayLinesExist THEN BEGIN
                ERROR('You first need to delete the existing Receipt lines before changing the Currency Code'
                );
                END;
                */
                IF bank.GET("Bank Code") THEN
                    "Bank Name" := bank.Name;

            end;
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; "Amount Recieved"; Decimal)
        {
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF PayLinesExist THEN BEGIN
                    ERROR('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                END ELSE BEGIN
                    "Bank Code" := '';
                END;
            end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Receipt Line q".amount WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Posted By"; Code[20])
        {
        }
        field(40; "Print No."; Integer)
        {
        }
        field(41; Status; Option)
        {
            OptionMembers = " ",Normal,"Post Dated",Posted,Partial;
        }
        field(42; "Cheque No."; Code[20])
        {
        }
        field(43; "No. Printed"; Integer)
        {
        }
        field(44; "Created By"; Code[50])
        {
        }
        field(45; "Created Date Time"; DateTime)
        {
        }
        field(46; "Register No."; Integer)
        {
        }
        field(47; "From Entry No."; Integer)
        {
        }
        field(48; "To Entry No."; Integer)
        {
        }
        field(49; "Document Date"; Date)
        {
        }
        field(81; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                IF PayLinesExist THEN BEGIN
                    ERROR('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                END ELSE BEGIN
                    "Bank Code" := '';
                END;


                TESTFIELD(Status, Status::" ");
                IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text001,
                      RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                DimVal.RESET;
                //DimVal.SETRANGE(DimVal.""Global Dimension No."",2);
                DimVal.SETRANGE(DimVal.Code, "Shortcut Dimension 3 Code");
                IF DimVal.FIND('-') THEN
                    Dim3 := DimVal.Name
            end;
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                DimVal.RESET;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SETRANGE(DimVal.Code, "Shortcut Dimension 4 Code");
                IF DimVal.FIND('-') THEN
                    Dim4 := DimVal.Name
            end;
        }
        field(86; Dim3; Text[250])
        {
        }
        field(87; Dim4; Text[250])
        {
        }
        field(88; "Bank Name"; Text[250])
        {
        }
        field(89; "Receipt Reference"; Option)
        {
            Editable = false;
            OptionMembers = Normal,"Travel Advance Refunds","Other Advance Refunds";
        }
        field(90; "Staff Number"; Code[20])
        {
        }
        field(50000; "Patient No."; Code[20])
        {
        }
        field(50001; "Patient Appointment No"; Code[20])
        {
        }
        field(50002; "Surrender No"; Code[20])
        {
        }
        field(50003; "Manual Ref.Number"; Text[30])
        {
        }
        field(50004; "Imprest No"; Code[20])
        {
        }
        field(50006; "Application No"; Code[20])
        {
        }
        field(50007; "Applicant Name"; Text[100])
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
        IF "No." = '' THEN BEGIN
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipts No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Receipts No", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        UserTemplate.RESET;
        UserTemplate.SETRANGE(UserTemplate.UserID, USERID);
        IF UserTemplate.FINDFIRST THEN BEGIN
            //"Bank Code":=UserTemplate."Default Receipts Bank";
            //VALIDATE("Bank Code");
            Cashier := USERID;
        END;
        //*****************************JACK**************************//
        "Created By" := USERID;
        "Created Date Time" := CREATEDATETIME(TODAY, TIME);
        //*****************************END***************************//
    end;

    trigger OnModify()
    begin
        RLine.RESET;
        RLine.SETRANGE(RLine.No, "No.");
        IF RLine.FINDFIRST THEN BEGIN
            REPEAT
                RLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                RLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                RLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                RLine.MODIFY;
            UNTIL RLine.NEXT = 0;
        END;
    end;

    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserTemplate: Record "Cash Office User Template";
        RLine: Record "Receipt Line q";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        DimVal: Record "Dimension Value";
        bank: Record "Bank Account";

    //[Scope('Internal')]
    procedure PayLinesExist(): Boolean
    begin
        RLine.RESET;
        RLine.SETRANGE(RLine.No, "No.");
        EXIT(RLine.FINDFIRST);
    end;

    //[Scope('Internal')]
    procedure AssistEdit(OldCust: Record "Receipts Header"): Boolean
    var
        Cust: Record "Receipts Header";
    begin
        Cust := Rec;

        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipts No");

        IF NoSeriesMgt.SelectSeries(GenLedgerSetup."Receipts No", OldCust."No. Series", Cust."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(Cust."No.");
            Rec := Cust;
            EXIT(TRUE);
        END;
    end;
}
