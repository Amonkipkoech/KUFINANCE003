table 52178762 "FIN-Payments"
{
    //DrillDownPageID = "HMS-Treatment History List";
    //LookupPageID = "HMS-Treatment History List";

    fields
    {
        /*         field(38; "Payment Type"; Option)
                {
                    OptionMembers = Normal,"Petty Cash",Imprest,Claims,Salary;
                }  */
        field(1; No; Code[20])
        {

            trigger OnValidate()
            var
                GenLedgerSetup: Record 98;
                NoSeriesMgt: Codeunit 396;
            begin
                IF No <> xRec.No THEN BEGIN
                    GenLedgerSetup.GET;
                    IF "Payment Type" = "Payment Type"::Imprest THEN BEGIN
                        NoSeriesMgt.TestManual(GenLedgerSetup."Imprest No");

                    END;

                    IF "Payment Type" = "Payment Type"::Normal THEN BEGIN
                        NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                    END
                    ELSE BEGIN
                        NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                    END;
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; Type; Code[20])
        {
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = FILTER(Payment));

            trigger OnValidate()
            var
                RecPayTypes: Record "FIN-Receipts and Payment Types";
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF RecPayTypes.FIND('-') THEN BEGIN
                    Grouping := RecPayTypes."Default Grouping";
                END;

                IF RecPayTypes.FIND('-') THEN BEGIN
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;

                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        VALIDATE("Account No.");
                    END;


                END;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Code[20])
        {
            TableRelation = "FIN-Pay Modes".Code;
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Payment Date"; Date)
        {
        }
        field(7; "Cheque Type"; Code[20])
        {
            TableRelation = "FIN-Cheque Types";
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "FIN-Bank Codes";
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[20])
        {
        }
        field(12; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Type))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                RecPayTypes: Record "FIN-Receipts and Payment Types";
                GLAcc: Record 15;
                Vend: Record 23;
                Cust: Record 18;
                BankAcc: Record 270;
            begin
                "Account Name" := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                Department := '';
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                // "VAT Code":=Cust."Default VAT Code";
                                //"Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                Department := Cust."Global Dimension 1 Code";
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                // "VAT Code":=Vend."Default VAT Code";
                                // "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                // "Retention Fee Code":=Vend."Default Retention Code";
                                Department := Vend."Global Dimension 1 Code";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                Department := BankAcc."Global Dimension 1 Code";

                            END;
                    /*
                  "Account Type"::"Fixed Asset":
                    BEGIN
                      FA.GET("Account No.");
                      "Account Name":=FA.Description;
                      "VAT Code":=FA."Default VAT Code";
                      "Withholding Tax Code":=FA."Default Withholding Tax Code";
                       "Global Dimension 1 Code":=FA."Global Dimension 1 Code";
                    END;
                    */
                    END;

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[50])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                IF ("Payment Type" = "Payment Type"::Imprest) OR ("Payment Type" = "Payment Type"::Claims) THEN BEGIN
                    IF Department = '' THEN ERROR('Please select the department');
                    //to do "Check Vote"();
                END;
            end;
        }
        field(21; Remarks; Text[250])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(23; "VAT Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(25; "VAT Amount"; Decimal)
        {
        }
        field(26; "Withholding Tax Amount"; Decimal)
        {
        }
        field(27; "Net Amount"; Decimal)
        {
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(29; Payee; Text[100])
        {
        }
        field(30; Department; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));

            trigger OnValidate()
            begin
                IF ("Payment Type" = "Payment Type"::Imprest) OR ("Payment Type" = "Payment Type"::Claims) THEN BEGIN
                    IF Department = '' THEN ERROR('Please select the department');
                    //to do "Check Vote"();
                END;
            end;
        }
        field(31; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(32; "PO/INV No"; Code[20])
        {
            //TableRelation = Table50133.Field1;
        }
        field(33; "Bank Account No"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; Option)
        {
            InitValue = New;
            OptionCaption = 'New,Pending,1st Approval,2nd Approval,3r Approval,4th Approval,5th Approval,6th Approval';
            OptionMembers = New,Pending,"1st Approval","2nd Approval","3r Approval","4th Approval","5th Approval","6th Approval";
        }
        field(36; Select; Boolean)
        {
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash",Imprest,Claims,Salary;
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(41; "Apply to"; Code[20])
        {

            trigger OnLookup()
            var
                vEntry: Record 25;
                LineNo: Integer;
            begin
                vEntry.RESET;
                vEntry.SETRANGE(vEntry."Vendor No.", "Account No.");

                /* IF RUNMODAL(29, vEntry, vEntry."Document No.") = ACTION::LookupOK THEN BEGIN
                    "Apply to" := vEntry."Document No.";
                END; */
            end;

            trigger OnValidate()
            var
                LineNo: Integer;
                vEntry: Record 25;
            begin
            end;
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(43; "No of Units"; Decimal)
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
            InitValue = false;
        }
        field(46; "Surrender Doc. No"; Code[20])
        {
        }

        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                //to do "Check Vote"();
            end;
        }
        field(48; "Total Allocation"; Decimal)
        {
        }
        field(49; "Total Expenditure"; Decimal)
        {
        }
        field(50; "Total Commitments"; Decimal)
        {
        }
        field(51; Balance; Decimal)
        {
        }
        field(52; "Balance Less this Entry"; Decimal)
        {
        }
        field(53; "Applicant Designation"; Text[100])
        {
        }
        field(54; "Petty Cash"; Boolean)
        {
        }
        field(55; "Retention Fee Code"; Code[10])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(56; "Retention Fee Amount"; Decimal)
        {
        }
        field(100; "Admin Remarks"; Text[100])
        {
        }
        field(57; "HOD Remarks"; Text[30])
        {

            trigger OnValidate()
            begin
                IF "Admin Remarks" <> '' THEN ERROR('Please note that you can not change remarks at this point');
            end;
        }
        field(58; "Surrender Remarks"; Text[30])
        {
        }
        field(59; "IW No"; Code[10])
        {

            trigger OnValidate()
            var
                PayRec: Record "FIN-Payments";
            begin
                PayRec.RESET;
                PayRec.SETRANGE(PayRec."IW No", "IW No");
                PayRec.SETRANGE(PayRec."Payment Type", "Payment Type");
                IF PayRec.FIND('-') THEN BEGIN
                    ERROR('Warrant No Already Exists')
                END;
            end;
        }
        field(60; "Imp No"; Code[10])
        {
            TableRelation = "FIN-Imprest Details".No;
        }
        field(62; Refunded; Boolean)
        {
            InitValue = false;
        }
        field(63; "Applies to ID Cust"; Code[20])
        {
            TableRelation = "Cust. Ledger Entry"."Customer No." WHERE("Customer No." = FIELD("Account No."));
        }
        field(64; "Refunded By"; Code[50])
        {
        }
        field(65; "Refunded Date"; Date)
        {
        }
        field(66; "Raised By"; Code[100])
        {
        }
        field(67; "Approved By"; Code[100])
        {
        }
        field(68; "Approved Date"; Date)
        {
        }
        field(69; "Vendor Bank Account No"; Code[10])
        {
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));
        }
        field(70; "Revenue Type"; Code[20])
        {
            TableRelation = "Dimension Value"."Dimension Code" WHERE("Dimension Code" = CONST('BUSINESS'));
        }
        field(71; "Checked By"; Code[100])
        {
        }
        field(72; "Checked On"; Date)
        {
        }
        field(73; OPN; Code[20])
        {
            Description = 'Original Payment Voucher No';

            trigger OnValidate()
            var
                PayRec: Record "FIN-Payments";
            begin
                PayRec.RESET;
                PayRec.SETRANGE(PayRec.OPN, OPN);
                PayRec.SETRANGE(PayRec."Payment Type", "Payment Type");
                IF PayRec.FIND('-') THEN BEGIN
                    ERROR('OPN No Already Exists')
                END;
            end;
        }
        field(74; "Dept Name"; Text[60])
        {
        }
        field(75; "Business Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(76; "Include VAT"; Boolean)
        {
        }
        field(77; "Cashier Remarks"; Text[100])
        {
        }
        field(78; Reversed; Boolean)
        {
        }
        field(79; ReversedBy; Code[50])
        {
        }
        field(80; "Reversal Date"; Date)
        {
        }
        field(81; "Reversal Remarks"; Text[100])
        {
        }
        field(82; "Surrendered Amount"; Decimal)
        {
        }
        field(83; "Recoupment No"; Code[50])
        {
        }
        field(84; "Excise Duty"; Code[20])
        {
            TableRelation = "FIN-Tariff Codes";
        }
        field(85; "Excise Duty Amount"; Decimal)
        {
        }
        field(86; "Cancelled By"; Code[20])
        {
        }
        field(87; "Cancelled Date"; Date)
        {
        }
        field(88; Converted; Boolean)
        {
        }
        field(89; "Converted to"; Option)
        {
            OptionCaption = ',CLaim,Imprest<Salary Voucher';
            OptionMembers = ,CLaim,"Imprest<Salary Voucher";
        }
        field(90; "Converted By"; Code[20])
        {
        }
        field(91; "Converted Date"; Date)
        {
        }
        field(92; "System Entry"; Boolean)
        {
        }
        field(93; "Customer Bank Account No"; Code[20])
        {
            TableRelation = "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No."));
        }
        field(94; "Cheque Raised"; Boolean)
        {
        }
        field(95; "Cheque Raised Date"; Date)
        {
        }
        field(96; "Cheque Raised Time"; Time)
        {
        }
        field(97; "Cheque Raised By"; Code[20])
        {
        }
        field(98; "No. Printed"; Integer)
        {
        }
        field(99; Committed; Boolean)
        {
        }

        field(101; "1st Approved By"; Code[20])
        {
        }
        field(102; "1st Approval Date"; Date)
        {
        }
        field(103; "1st Approval Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(104; "2nd Approved By"; Code[20])
        {
        }
        field(105; "2nd Approval Date"; Date)
        {
        }
        field(106; "2nd Approval Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(107; "3rd Approved By"; Code[20])
        {
        }
        field(108; "3rd Approval Date"; Date)
        {
        }
        field(109; "3rd Approval Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(110; "4th Approved By"; Code[20])
        {
        }
        field(111; "4th Approval Date"; Date)
        {
        }
        field(112; "4th Approval Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(113; "Imprest Purpose"; Code[200])
        {
        }
        field(50000; "From Date"; Date)
        {
        }
        field(50001; "To date"; Date)
        {
        }
        field(50002; "While In"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record 15;
        Cust: Record 18;
        Vend: Record 23;
        FA: Record 5600;
        BankAcc: Record 270;
        //NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record 98;
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        CashierLinks: Record "FIN-Cashier Link";
        GLAccount: Record 15;
        EntryNo: Integer;
        Comm: Record "FIN-Commitment Entries";
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
        CommitmentEntries: Record "FIN-Commitment Entries";
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        PayRec: Record "FIN-Payments";
        Pay: Record "FIN-Payments";
        BudgetRec: Record 96;
        GenSetUp: Record 98;
        Allocation: Decimal;
        Spent: Decimal;
        ImpRec: Record "FIN-Imprest Details";
        CommAmount: Decimal;
        GLEntry: Record 17;


    procedure "Check Vote"()
    begin

        GenSetUp.GET();
        // Calculate Allocations

        Allocation := 0;
        BudgetRec.RESET;
        // BudgetRec.SETFILTER(BudgetRec.Date,'%1..%2',GenSetUp."Current Budget Start Date",GenSetUp."Current Budget End Date");
        BudgetRec.SETFILTER(BudgetRec."Budget Name", GenSetUp."Current Budget");
        BudgetRec.SETFILTER(BudgetRec."G/L Account No.", "Vote Book");
        BudgetRec.SETFILTER(BudgetRec."Global Dimension 2 Code", Department);
        IF BudgetRec.FIND('-') THEN BEGIN
            REPEAT
                Allocation := Allocation + BudgetRec.Amount
            UNTIL BudgetRec.NEXT = 0;
        END;

        // Calculate Expenses
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."G/L Account No.", "Vote Book");
        GLEntry.SETFILTER(GLEntry."Posting Date", '%1..%2', GenSetUp."Current Budget Start Date", GenSetUp."Current Budget End Date");
        GLEntry.SETFILTER(GLEntry."Global Dimension 2 Code", Department);
        IF GLEntry.FIND('-') THEN BEGIN
            REPEAT
                Spent := Spent + GLEntry.Amount
            UNTIL GLEntry.NEXT = 0;
        END;
        // Calculate  Committements
        Comm.RESET;
        Comm.SETRANGE(Comm.Account, "Vote Book");
        Comm.SETRANGE(Comm.Closed, FALSE);
        // Comm.SETFILTER(Comm.Date,'%1..%2',GenSetUp."Current Budget Start Date",GenSetUp."Current Budget End Date");
        Comm.SETRANGE(Comm.Department, Department);

        IF Comm.FIND('-') THEN BEGIN
            REPEAT
                IF (Comm.Date > GenSetUp."Current Budget Start Date") AND (Comm.Date < GenSetUp."Current Budget End Date") THEN
                    CommAmount := CommAmount + Comm."Committed Amount";

            UNTIL Comm.NEXT = 0;
        END;




        "Total Allocation" := Allocation;
        "Total Commitments" := CommAmount;
        "Total Expenditure" := Spent;
        Balance := Allocation - (CommAmount + Spent);
        "Balance Less this Entry" := Allocation - (CommAmount + Spent + Amount);
        MODIFY;


        // IF (Allocation-Spent)<0 THEN ERROR('You have Exceed the Budget allocation by '+FORMAT((Allocation-Spent)));
    end;

    trigger OnDelete()
    begin

        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');

        CommitmentEntries.RESET;
        CommitmentEntries.SETRANGE(CommitmentEntries."Commitment No", No);
        IF CommitmentEntries.FIND('-') THEN
            CommitmentEntries.DELETEALL();
    end;

    trigger OnInsert()
    var
        //GenLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
    begin
        IF No = '' THEN BEGIN
            GenLedgerSetup.GET;
            IF "Payment Type" = "Payment Type"::Imprest THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Imprest No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Imprest No", xRec."No. Series", 0D, No, "No. Series");

            END;
            IF "Payment Type" = "Payment Type"::Claims THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Claims No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Claims No", xRec."No. Series", 0D, No, "No. Series");

            END;

            IF "Payment Type" = "Payment Type"::Salary THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Salary PV No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Salary PV No", xRec."No. Series", 0D, No, "No. Series");

            END;


            IF "Payment Type" = "Payment Type"::Normal THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Normal Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, No, "No. Series");
            END
            ELSE BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Petty Cash Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Petty Cash Payments No", xRec."No. Series", 0D, No, "No. Series");
            END;
        END;
        //MESSAGE(No);
        Date := TODAY;
        Cashier := USERID;
        "Raised By" := USERID;
        CashierLinks.RESET;
        CashierLinks.SETRANGE(CashierLinks.UserID, USERID);
        IF CashierLinks.FIND('-') THEN BEGIN
            "Branch Code" := CashierLinks."Branch Code";
            "Cashier Bank Account" := CashierLinks."Bank Account No";
        END;
    end;

    trigger OnModify()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnRename()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

}

