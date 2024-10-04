table 52178718 "FIN-Staff Claim Lines"
{

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Account No:"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
            Editable = true;
            //NotBlank = false;
            trigger OnValidate()
            begin
                if GLAcc.Get("Account No:") then
                    "Account Name" := GLAcc.Name;
            end;

        }
        field(3; "Account Name"; Text[80])
        {
            //TableRelation = "G/L Account".Name where("No." = field("Account No:"));
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Due Date"; Date)
        {
        }
        field(6; "Imprest Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Apply to"; Code[20])
        {
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "M.R. No"; Code[20])
        {
        }
        field(47; "Date Issued"; Date)
        {
        }
        field(48; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(49; "Dept. Vch. No."; Code[20])
        {
        }
        field(50; "Cash Surrender Amt"; Decimal)
        {
        }
        field(51; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(52; "Surrender Doc No."; Code[20])
        {
        }
        field(53; "Date Taken"; Date)
        {
        }
        field(54; Purpose; Text[250])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
            Editable = false;
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the fourth global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Advance Type"; Code[20])
        {
            Caption = 'Claim Type';
            TableRelation = "FIN-Receipts and Payment Types".Code
            WHERE(Type = CONST(Claim), Blocked = filter(false));
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Amount LCY"; Decimal)
        {
        }
        field(88; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(89; "Claim Receipt No"; Code[20])
        {
        }
        field(90; "Expenditure Date"; Date)
        {
        }
        field(91; "Attendee/Organization Names"; Text[250])
        {
        }
        field(50000; "Lecturer No"; Code[20])
        {
            //TableRelation = "HRM-Employee C"."No." WHERE (Lecturer=filter(true));
        }
        field(50001; "Semester Code"; Code[20])
        {
            //TableRelation = ACA-Semesters.Code;
        }
        field(50002; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50003; "Unit Code"; Code[20])
        {
            //TableRelation = "ACA-Lecturers Units - Old".Unit WHERE (Semester=FIELD(Semester Code));
        }
        field(50004; "No. of Hours"; Decimal)
        {
        }
        field(50005; "PAYE Amount"; Decimal)
        {
        }
        field(50006; "PAYE Code"; Code[20])
        {
        }
        field(50007; "Net Amount"; Decimal)
        {
        }
        field(50008; "Pay mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque,EFT,Custom 2,Custom 3,Custom 4,Custom 5';
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 2","Custom 3","Custom 4","Custom 5";
        }
    }

    keys
    {
        key(Key1; "Line No.", No)
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount LCY";
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record 15;
        //Pay: Record "FIN-Staff Claims Header";
        //ImprestHeader: Record "FIN-Staff Claims Header";
        RecPay: Record "FIN-Receipts and Payment Types";
    // LecUnits: Record "61541";
}