table 52178706 "FIN-Receipts Header"
{
    // DrillDownPageID = 68207;
    // LookupPageID = 68207;

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
                Lines.Reset();

                Lines.SetRange(No, Rec."No.");
                Lines.SetRange("Line No.", 1000);
                if Lines.FindFirst() then begin
                    Lines."Bank Account" := Rec."Bank Code";
                    Lines.Modify();
                end else begin
                    Lines.Init();
                    Lines.No := Rec."No.";
                    Lines."Line No." := 1000;
                    Lines."Bank Account" := Rec."Bank Code";
                    Lines.Insert();
                end;

            end;
        }
        // field(9; "Received From"; Text[100])
        // {
        // }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; "Amount Recieved"; Decimal)
        {
            trigger OnValidate()
            var
                BlankReceiveFromError: Label 'Select the Receive from field.';
            begin
                if "Received From" = '' then
                    Error(BlankReceiveFromError);
                Lines.Reset();
                Lines.SetRange(No, Rec."No.");
                //Lines.SetRange("Line No.", 1000);
                if Lines.FindFirst() then begin
                    Lines.validate(Amount, Rec."Amount Recieved");
                    Lines.Validate("Total Amount", Rec."Amount Recieved");
                    Lines.Modify();
                end else begin
                    Lines.Init();
                    Lines.No := "No.";
                    Lines."Line No." := 1000;
                    //Lines."Account Type" := Rec."Received From Account Type";
                    Lines.validate("Account No.", Rec."Received From");
                    Lines.Validate(Amount, Rec."Amount Recieved");
                    Lines.Insert();
                end;
            end;
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
            CalcFormula = Sum("FIN-Receipt Line q"."Total Amount" WHERE(No = FIELD("No.")));
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
            trigger OnValidate()
            begin
                if Format("Document Date") <> '' then
                    "Date Posted" := Rec."Document Date";
            end;
        }
        field(81; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                // IF PayLinesExist THEN BEGIN
                //     ERROR('You first need to delete the existing Receipt lines before changing the Currency Code'
                //     );
                // END ELSE BEGIN
                //     "Bank Code" := '';
                // END;



                TESTFIELD(Status, Status::" ");
                IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text001,
                      RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);

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
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
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
        field(91; "Is Scholarship"; Boolean)
        {

        }
        field(50000; "Patient No."; Code[20])
        {
            //TableRelation = "FIN-Lost Table".Lost;
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
            TableRelation = "FIN-Imprest Header"."No." WHERE(Status = CONST(POSTED));
        }
        field(50006; "Application No"; Code[20])
        {
            //TableRelation = "ACA-Applic. Form Header"."Application No.";
        }
#pragma warning disable AL0717
        field(50007; "Applicant Name"; Text[100])
#pragma warning restore AL0717
        {
            FieldClass = FlowField;
            //CalcFormula = Lookup("ACA-Applic. Form Header".Surname WHERE("Application No." = FIELD("Application No")));

        }
        field(50008; "44666"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Student/staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                Customer.RESET;
                Customer.SETRANGE("No.", "Student/staff No");
                IF Customer.FINDFIRST THEN
                    Name := Customer.Name;
                "Received From" := Customer.Name;
            end;
        }
        field(50010; Name; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; Remarks; Text[200])
        {
            Caption = 'Receipt Description';

            DataClassification = ToBeClassified;

        }
        field(50012; "Is Room Booking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
            Editable = true;
        }
        field(50014; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,Mpesa,EFT,Deposit Slip,Banker''s Cheque,RTGS';
            OptionMembers = " ",Cash,Cheque,Mpesa,EFT,"Deposit Slip","Banker's Cheque",RTGS;

            trigger OnValidate()
            begin
                GenLedgerSetup.RESET;
                GenLedgerSetup.SetRange("Primary Key", '1');
                IF "Pay Mode" = "Pay Mode"::"Deposit Slip" THEN BEGIN
                    "Bank Code" := GenLedgerSetup."Default Bank Deposit Slip A/C";
                END;

                Lines.Reset();
                Lines.SetRange(No, Rec."No.");
                Lines.SetRange("Line No.", 1000);
                if Lines.FindFirst() then begin
                    Lines."Pay Mode" := Rec."Pay Mode";
                    Lines."Cheque/Deposit Slip Date" := Rec."Document Date";
                    Lines.Modify();
                end else begin
                    Lines.Init();
                    Lines.No := Rec."No.";
                    Lines."Line No." := 1000;
                    Lines."Cheque/Deposit Slip Date" := Rec."Document Date";
                    Lines."Pay Mode" := Rec."Pay Mode";
                    Lines.Insert();
                end;
            end;
        }
        field(50015; "Received From Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Received From Account Type';
            DataClassification = ToBeClassified;
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
            trigger OnValidate()
            begin
                Lines.Reset();
                Lines.SetRange(No, Rec."No.");
                Lines.SetRange("Line No.", 1000);
                if Lines.FindFirst() then begin
                    Lines."Account Type" := Rec."Received From Account Type";
                    Lines.Modify();
                end else begin
                    Lines.Init();
                    Lines.No := Rec."No.";
                    Lines."Line No." := 1000;
                    Lines."Account Type" := Rec."Received From Account Type";
                    Lines.Insert();
                end;
            end;
        }
        field(50016; "Received From"; Text[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation =
            IF ("Received From Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = filter(true))
            ELSE
            IF ("Received From Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Received From Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Received From Account Type" = CONST("Bank Account")) "Bank Account" WHERE("Bank Acc. Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Received From Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Received From Account Type" = CONST("IC Partner")) "IC Partner";

            // IF ("Received From Account Type" = CONST("G/L Account")) "G/L Account"
            // ELSE
            // IF ("Received From Account Type" = CONST(Customer)) Customer
            // ELSE
            // IF ("Received From Account Type" = CONST(Vendor)) Vendor
            // ELSE
            // IF ("Received From Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            // ELSE
            // IF ("Received From Account Type" = CONST("Bank Account")) "Bank Account";
            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
                Cust: Record Customer;
                vend: Record Vendor;
                BankAcc: Record "Bank Account";
                FA: Record "Fixed Asset";
                ICPartner: Record 413;

            begin
                //Account Name 
                "Account Name" := '';

                IF "Received From Account Type" IN ["Received From Account Type"::"G/L Account", "Received From Account Type"::Customer,
                "Received From Account Type"::Vendor, "Received From Account Type"::"IC Partner"] THEN
                    CASE "Received From Account Type" OF
                        "Received From Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Received From");
                                "Account Name" := GLAcc.Name;

                            END;
                        "Received From Account Type"::Customer:
                            BEGIN
                                Cust.GET("Received From");
                                "Account Name" := Cust.Name;

                            END;
                        "Received From Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Received From");
                                "Account Name" := Vend.Name;
                            END;
                        "Received From Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Received From");
                                "Account Name" := BankAcc.Name;
                            END;
                        "Received From Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Received From");
                                "Account Name" := FA.Description;
                            END;
                        "Received From Account Type"::"IC Partner":
                            BEGIN
                                ICPartner.RESET;
                                ICPartner.GET("Received From");
                                "Account Name" := ICPartner.Name;
                            END;
                    END;
                //End 
                Lines.Reset();
                Lines.SetRange(No, Rec."No.");
                Lines.SetRange("Line No.", 1000);
                if Lines.FindFirst() then begin
                    Lines."Account No." := Rec."Received From";
                    Lines."Bank Account" := Rec."Bank Code";
                    Lines."Cheque/Deposit Slip No" := Rec."Cheque No.";
                    Lines.Grouping := Rec.Grouping;
                    Lines."Pay Mode" := Rec."Pay Mode";
                    Lines."Account Name" := Rec."Account Name";
                    Lines.Modify();
                end else begin
                    Lines.Init();
                    Lines.No := Rec."No.";
                    Lines."Line No." := 1000;
                    Lines."Account Type" := Rec."Received From Account Type";
                    Lines.validate("Account No.", Rec."Received From");
                    Lines."Bank Account" := Rec."Bank Code";
                    Lines."Cheque/Deposit Slip No" := Rec."Cheque No.";
                    Lines.Grouping := Rec.Grouping;
                    Lines."Pay Mode" := Rec."Pay Mode";
                    Lines."Account Name" := Rec."Account Name";
                    Lines.Insert();
                end;
            end;
        }
        field(50017; "Account Name"; Text[150])
        {
            Caption = 'Customer Name';
        }
        field(50018; "Transaction Type Code"; Code[20])
        {

        }
        field(50019; "Transaction Type"; Text[150])
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
            GenLedgerSetup.Reset();
            GenLedgerSetup.SetRange("Primary Key", '1');
            IF GenLedgerSetup.Find('-') then begin
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipts No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Receipts No", xRec."No. Series", 0D, "No.", "No. Series");
            end;

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
        UserTemplate: Record "FIN-Cash Office User Template";
        RLine: Record "FIN-Receipt Line q";
        Lines: Record "FIN-Receipt Line q";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        DimVal: Record 349;
        bank: Record "Bank Account";
        Customer: Record Customer;
        RecPayTypes: Record "FIN-Receipts and Payment Types";

    //[Scope('Internal')]
    procedure PayLinesExist(): Boolean
    begin
        RLine.RESET;
        RLine.SETRANGE(RLine.No, "No.");
        EXIT(RLine.FINDFIRST);
    end;

    //[Scope('Internal')]
    procedure AssistEdit(OldCust: Record "FIN-Receipts Header"): Boolean
    var
        Cust: Record "FIN-Receipts Header";
    begin
        //WITH Cust DO BEGIN
        Cust := Rec;

        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipts No");

        IF NoSeriesMgt.SelectSeries(GenLedgerSetup."Receipts No", OldCust."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := Cust;
            EXIT(TRUE);
        END;
        //END;
    end;
}