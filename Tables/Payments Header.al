table 52178751 "Payments Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin
                IF PayLinesExist THEN BEGIN
                    ERROR('You first need to delete the existing Payment lines before changing the Currency Code'
                    );
                END ELSE BEGIN
                    "Paying Bank Account" := '';
                    VALIDATE("Paying Bank Account");
                END;
                IF "Currency Code" = xRec."Currency Code" THEN
                    UpdateCurrencyFactor;

                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                END ELSE
                    IF "Currency Code" <> '' THEN
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF PayLinesExist THEN BEGIN
                    ERROR('You first need to delete the existing Payment lines before changing the Currency Code'
                    );
                END ELSE BEGIN
                    "Paying Bank Account" := '';
                    VALIDATE("Paying Bank Account");
                END;
                IF "Currency Code" = xRec."Currency Code" THEN
                    UpdateCurrencyFactor;

                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                END ELSE
                    IF "Currency Code" <> '' THEN
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
            end;
        }
        field(9; Payee; Text[100])
        {
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[30])
        {
            Description = 'Stores the identifier of the cashier in the database';

            trigger OnValidate()
            begin
                /*
                 UserDept.RESET;
                UserDept.SETRANGE(UserDept.UserID,Cashier);
                IF UserDept.FIND('-') THEN
                  //"Global Dimension 1 Code":=UserDept.Department;
                */

            end;
        }
        field(16; Posted; Boolean)
        {
            Description = 'Stores whether the payment voucher is posted or not';
        }
        field(17; "Date Posted"; Date)
        {
            Description = 'Stores the date when the payment voucher was posted';
        }
        field(18; "Time Posted"; Time)
        {
            Description = 'Stores the time when the payment voucher was posted';
        }
        field(19; "Posted By"; Code[30])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line".Amount WHERE(No = FIELD("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                BankAcc.RESET;
                "Bank Name" := '';

                /*IF BankAcc.GET("Paying Bank Account") THEN
                  BEGIN
                  BankAcc.TESTFIELD(BankAcc."Last Pv No.");
                  "Reference No.":=BankAcc."Last Pv No."+'-'+COPYSTR("No.",4,20);
                  BankAcc."Last Pv No.":=INCSTR(BankAcc."Last Pv No.");
                  BankAcc.MODIFY;
                   // IF "Pay Mode"="Pay Mode"::Cash THEN BEGIN
                    //  IF BankAcc.Test<>BankAcc.Test::"1" THEN
                     //    ERROR('This Payment can only be made against Banks Handling Cash');
                   // END;
                
                    "Bank Name":=BankAcc.Name;
                    //"Currency Code":=BankAcc."Currency Code";
                    // VALIDATE("Currency Code");
                  END;
                  */
                PLine.RESET;
                PLine.SETRANGE(PLine.No, "No.");
                PLine.SETRANGE(PLine."Account Type", PLine."Account Type"::"Bank Account");
                PLine.SETRANGE(PLine."Account No.", "Paying Bank Account");
                IF PLine.FINDFIRST THEN
                    ERROR(Text002);

            end;
        }
        field(30; "Global Dimension 1 Code"; Code[30])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
                DimVal.SETRANGE(DimVal.Code, "Global Dimension 1 Code");
                IF DimVal.FIND('-') THEN
                    "Function Name" := DimVal.Name;
                UpdateLines;
            end;
        }
        field(35; Status; Option)
        {

            Description = 'Stores the status of the record in the database';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash",Cash,"Fixed Deposit",SMPA,"Chq Collection";
        }
        field(56; "Shortcut Dimension 2 Code"; Code[30])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
                DimVal.SETRANGE(DimVal.Code, "Shortcut Dimension 2 Code");
                IF DimVal.FIND('-') THEN
                    "Budget Center Name" := DimVal.Name;
                UpdateLines
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[150])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[100])
        {
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(61; Select; Boolean)
        {
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Amount" WHERE(No = FIELD("No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Withholding Tax Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Net Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[20])
        {
        }
        field(67; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit","Custom 3","Custom 4","Custom 5";
        }
        field(68; "Payment Release Date"; Date)
        {

            trigger OnValidate()
            begin
                //Changed to ensure Release date is not less than the Date entered
                IF "Payment Release Date" < Date THEN
                    ERROR('The Payment Release Date cannot be lesser than the Document Date');
            end;
        }
        field(69; "No. Printed"; Integer)
        {
        }
        field(70; "VAT Base Amount"; Decimal)
        {
        }
        field(71; "Exchange Rate"; Decimal)
        {
        }
        field(72; "Currency Reciprical"; Decimal)
        {
        }
        field(73; "Current Source A/C Bal."; Decimal)
        {
        }
        field(74; "Cancellation Remarks"; Text[250])
        {
        }
        field(75; "Register Number"; Integer)
        {
        }
        field(76; "From Entry No."; Integer)
        {
        }
        field(77; "To Entry No."; Integer)
        {
        }
        field(78; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(79; "Total Payment Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."NetAmount LCY" WHERE(No = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
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
        field(82; "Shortcut Dimension 4 Code"; Code[20])
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
        field(83; Dim3; Text[250])
        {
        }
        field(84; Dim4; Text[250])
        {
        }
        field(85; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin

                TESTFIELD(Status, Status::Pending);

                IF PayLinesExist THEN BEGIN
                    ERROR('You first need to delete the existing Payment lines before changing the Responsibility Center');
                END ELSE BEGIN
                    "Currency Code" := '';
                    VALIDATE("Currency Code");
                    "Paying Bank Account" := '';
                    VALIDATE("Paying Bank Account");
                END;


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
        field(86; "Cheque Type"; Option)
        {
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(87; "Total Retention Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Retention  Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(88; "Payment Narration"; Text[200])
        {
        }
        field(89; "Total PAYE Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."PAYE Amount" WHERE(No = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(90; "Reference No."; Code[50])
        {
        }
        field(91; "Cheque Printed"; Boolean)
        {
        }
        field(92; "Apply to Document Type"; Option)
        {
            OptionCaption = ' ,Imprest,Claim';
            OptionMembers = " ",Imprest,Claim;
        }
        field(93; "Apply to Document No"; Code[20])
        {
            FieldClass = Normal;
        }
        field(94; "Imprest No."; Code[20])
        {
        }
        field(95; "Claim No."; Code[20])
        {
        }
        field(96; "PF No"; Code[30])
        {
            NotBlank = true;
        }
        field(97; Semester; Code[20])
        {
            NotBlank = true;
        }
        field(98; "Financial Period"; Code[20])
        {
            TableRelation = "Financial Periods"."Period Code" WHERE("Current Period" = FILTER(true));
        }
        field(50001; "Budgeted Amount"; Decimal)
        {
            Editable = false;
        }
        field(50002; "Actual Expenditure"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Committed Amount"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Budget Balance"; Decimal)
        {
            Editable = false;
        }
        field(50148; "Bank Criteria"; Option)
        {
            OptionCaption = ' ,Recurrent  Exp,Development Exp';
            OptionMembers = " ","Recurrent  Exp","Development Exp";
        }
        field(50149; "Contract No."; Integer)
        {
        }
        field(50150; "Contract Amount"; Decimal)
        {
        }
        field(50151; "Contract Balance"; Decimal)
        {
        }
        field(50152; "Certificate No."; Integer)
        {
        }
        field(50153; "Reversed?"; Boolean)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry".Reversed WHERE("Document No." = FIELD("No."), Reversed = filter(true)));
            FieldClass = FlowField;
        }
        field(50154; "Total VAT Withholding Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Withheld Amount" WHERE(No = FIELD("No.")));
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50155; "Vendor No."; Code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50156; "Vendor Name"; Text[150])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Responsibility Center")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /* IF (Status=Status::Approved) OR (Status=Status::Posted) OR (Status=Status::"Pending Approval")THEN
            ERROR('You Cannot Delete this record');   */

    end;

    trigger OnInsert()
    begin


        IF "No." = '' THEN BEGIN
            GenLedgerSetup.GET;
            IF "Payment Type" = "Payment Type"::Normal THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Normal Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, "No.", "No. Series");
            END
            ELSE BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Petty Cash Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Petty Cash Payments No", xRec."No. Series", 0D, "No.", "No. Series");
            END;
        END;
        UserTemplate.RESET;
        UserTemplate.SETRANGE(UserTemplate.UserID, USERID);
        IF UserTemplate.FINDFIRST THEN BEGIN
            IF "Payment Type" = "Payment Type"::"Petty Cash" THEN BEGIN
                UserTemplate.TESTFIELD(UserTemplate."Default Petty Cash Bank");
                // "Paying Bank Account":=UserTemplate."Default Petty Cash Bank";
            END ELSE BEGIN
                "Paying Bank Account" := UserTemplate."Default Payment Bank";
            END;
            VALIDATE("Paying Bank Account");
        END;

        Date := TODAY;
        Cashier := USERID;
        VALIDATE(Cashier);
        //"Global Dimension 1 Code":='FIN';
        //VALIDATE("Global Dimension 1 Code");

        "Global Dimension 1 Code" := '2000';
        "Responsibility Center" := 'MMU';
    end;

    trigger OnModify()
    begin
        IF Status = Status::Pending THEN
            UpdateLines();

        /*IF (Status=Status::Approved) OR (Status=Status::Posted) THEN
           ERROR('You Cannot modify an already approved/posted document');*/

    end;

    var
        CStatus: Code[20];
        //PVUsers: Record "CshMgt PV Steps Users";
        UserTemplate: Record "Cash Office User Template";
        GLAcc: Record "G/L Account";
        Cust: Record "Customer";
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        //CashierLinks: Record "60252";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record 98;
        "Total Budget": Decimal;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        //PVSteps: Record "60240";
        PLine: Record "Payment Line";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        CurrExchRate: Record 330;
        PayLine: Record "Payment Line";
        Text002: Label 'There is an Account number on the  payment lines the same as Paying Bank Account you are trying to select.';

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        IF "Currency Code" <> '' THEN BEGIN
            CurrencyDate := Date;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        END ELSE
            "Currency Factor" := 0;
    end;

    //[Scope('Internal')]
    procedure UpdateLines()
    begin
        PLine.RESET;
        PLine.SETRANGE(PLine.No, "No.");
        IF PLine.FINDFIRST THEN BEGIN
            REPEAT
                PLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                PLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                PLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                PLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                PLine."Currency Factor" := "Currency Factor";
                PLine."Paying Bank Account" := "Paying Bank Account";
                PayLine."Payment Type" := "Payment Type";
                PLine.VALIDATE("Currency Factor");
                PLine.MODIFY;
            UNTIL PLine.NEXT = 0;
        END;
    end;

    //[Scope('Internal')]
    procedure PayLinesExist(): Boolean
    begin
        PayLine.RESET;
        PayLine.SETRANGE("Payment Type", "Payment Type");
        PayLine.SETRANGE(PayLine.No, "No.");
        EXIT(PayLine.FINDFIRST);
    end;
}