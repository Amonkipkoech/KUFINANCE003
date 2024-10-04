table 52178739 "EFT Batch Header"
{
    DrillDownPageID = "EFT batch Header";
    LookupPageID = "EFT batch Header";

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
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Cashier; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(6; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Posted by"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
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

    trigger OnDelete()
    begin
        IF (Status = Status::Approved) OR (Status = Status::Posted) OR (Status = Status::"Pending Approval") THEN
            ERROR('You Cannot Delete this record');

    end;

    trigger OnInsert()
    begin

        IF "No." = '' THEN BEGIN
            //   GenLedgerSetup.GET;
            //GenLedgerSetup.TESTFIELD(GenLedgerSetup."EFT Batch No");
            NoSeriesMgt.InitSeries('EFT', xRec."No. Series", 0D, "No.", "No. Series");
        END;


        UserTemplate.RESET;
        UserTemplate.SETRANGE(UserTemplate.UserID, USERID);
        IF UserTemplate.FINDFIRST THEN BEGIN

        END;

        Date := TODAY;
        Cashier := USERID;
        VALIDATE(Cashier);
        //"Global Dimension 1 Code":='FIN';
        //VALIDATE("Global Dimension 1 Code");

        //"Global Dimension 1 Code":='2000';
        "Responsibility Center" := 'BU';
    end;

    trigger OnModify()
    begin
        /*IF Status=Status::"" THEN
          UpdateLines();
        
            {IF (Status=Status::Approved) OR (Status=Status::Posted) THEN
               ERROR('You Cannot modify an already approved/posted document');}
        */

    end;

    var
        CStatus: Code[20];
        PVUsers: Record "FIN-CshMgt PV Steps Users";
        UserTemplate: Record "FIN-Cash Office User Template";
        GLAcc: Record "G/L Account";
        Cust: Record 18;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record "FIN-Cash Office Setup";
        RecPayTypes: Record "FIN-Receipts and Payment Types";
        //CashierLinks: Record "61720";
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
        //PVSteps: Record "61710";
        PLine: Record "EFT batch Lines";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        CurrExchRate: Record 330;
        PayLine: Record "FIN-Payment Line";
        Text002: Label 'There is an Account number on the  payment lines the same as Paying Bank Account you are trying to select.';
        ImpLines: Record "FIN-Imprest Lines";
        ImpH: Record "FIN-Imprest Header";
        LecturerName: Text[80];
    //HREmployee: Record "61188";
    //Claim: Record "61602";
    //ClaimLines: Record "61603";

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
    end;

    procedure UpdateLines()
    begin
        PLine.RESET;
        PLine.SETRANGE(PLine."Doc No", "No.");
        IF PLine.FINDFIRST THEN BEGIN
            REPEAT

            UNTIL PLine.NEXT = 0;
        END;
    end;

    procedure PayLinesExist(): Boolean
    begin
    end;
}