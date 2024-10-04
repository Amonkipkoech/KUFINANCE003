codeunit 52178701 "Post Budget Enties"
{

    trigger OnRun()
    begin
        //MESSAGE(GetBudgetStartAndEndDates(TODAY));
    end;

    var
        GLBudgetEntry: Record 96;
        GLBudgetName: Record 95;
        FINBudgetEntries: Record "FIN-Budget Entries";
        LastItem: Integer;
        FINBudgetEntries2: Record "FIN-Budget Entries";

    procedure PostBudget()
    var
        FINBudgetEntriesSummary: Record "FIN-Budget Entries Summary";
        BudgetStartDate: Date;
    begin
        //IF NOT CONFIRM('Update Budget Entries?') THEN ERROR('Cancelled!');
        CLEAR(BudgetStartDate);
        BudgetStartDate := GetBudgetStartDates(GetCurrentBudget);
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Budget Name", GetCurrentBudget);
        IF GLBudgetEntry.FIND('-') THEN BEGIN
            FINBudgetEntries.RESET;
            FINBudgetEntries.SETRANGE("Budget Name", GetCurrentBudget);
            FINBudgetEntries.SETRANGE("Transaction Type", FINBudgetEntries."Transaction Type"::Allocation);
            IF FINBudgetEntries.FIND('-') THEN FINBudgetEntries.DELETEALL;
            FINBudgetEntriesSummary.RESET;
            FINBudgetEntriesSummary.SETRANGE("Budget Name", GetCurrentBudget);
            IF FINBudgetEntriesSummary.FIND('-') THEN FINBudgetEntriesSummary.DELETEALL;
            CLEAR(LastItem);
            REPEAT
            BEGIN
                //Update the Reporting table here.RESET;
                FINBudgetEntriesSummary.RESET;
                FINBudgetEntriesSummary.SETRANGE("Budget Name", GetCurrentBudget);
                FINBudgetEntriesSummary.SETRANGE("Global Dimension 1 Code", GLBudgetEntry."Global Dimension 1 Code");
                FINBudgetEntriesSummary.SETRANGE("Global Dimension 2 Code", GLBudgetEntry."Global Dimension 2 Code");
                FINBudgetEntriesSummary.SETRANGE("G/L Account No.", GLBudgetEntry."G/L Account No.");
                IF NOT (FINBudgetEntriesSummary.FIND('-')) THEN BEGIN
                    FINBudgetEntriesSummary.INIT;
                    FINBudgetEntriesSummary."Budget Name" := GLBudgetEntry."Budget Name";
                    FINBudgetEntriesSummary."G/L Account No." := GLBudgetEntry."G/L Account No.";
                    FINBudgetEntriesSummary."Budget Start Date" := BudgetStartDate;
                    FINBudgetEntriesSummary."Global Dimension 1 Code" := GLBudgetEntry."Global Dimension 1 Code";
                    FINBudgetEntriesSummary."Global Dimension 2 Code" := GLBudgetEntry."Global Dimension 2 Code";
                    FINBudgetEntriesSummary.INSERT();
                END ELSE BEGIN
                    FINBudgetEntriesSummary."Budget Start Date" := BudgetStartDate;
                    FINBudgetEntriesSummary.MODIFY();
                END;
                //
                FINBudgetEntries.RESET;
                FINBudgetEntries.SETRANGE("Budget Name", GetCurrentBudget);
                IF FINBudgetEntries.FIND('+') THEN LastItem := FINBudgetEntries."Entry No.";
                LastItem := LastItem + 1;
                FINBudgetEntries.INIT;
                FINBudgetEntries."Entry No." := LastItem;
                FINBudgetEntries."Budget Name" := GLBudgetEntry."Budget Name";
                FINBudgetEntries."G/L Account No." := GLBudgetEntry."G/L Account No.";
                FINBudgetEntries.Date := GLBudgetEntry.Date;
                FINBudgetEntries."Global Dimension 1 Code" := GLBudgetEntry."Global Dimension 1 Code";
                FINBudgetEntries."Global Dimension 2 Code" := GLBudgetEntry."Global Dimension 2 Code";
                FINBudgetEntries.Amount := GLBudgetEntry.Amount;
                FINBudgetEntries.Description := GLBudgetEntry.Description;
                FINBudgetEntries."Business Unit Code" := GLBudgetEntry."Business Unit Code";
                FINBudgetEntries."User ID" := GLBudgetEntry."User ID";
                FINBudgetEntries."Budget Dimension 1 Code" := GLBudgetEntry."Budget Dimension 1 Code";
                FINBudgetEntries."Budget Dimension 2 Code" := GLBudgetEntry."Budget Dimension 2 Code";
                FINBudgetEntries."Budget Dimension 3 Code" := GLBudgetEntry."Budget Dimension 3 Code";
                FINBudgetEntries."Budget Dimension 4 Code" := GLBudgetEntry."Budget Dimension 4 Code";
                FINBudgetEntries."Last Date Modified" := GLBudgetEntry."Last Date Modified";
                FINBudgetEntries."Dimension Set ID" := GLBudgetEntry."Dimension Set ID";
                FINBudgetEntries."Transaction Type" := FINBudgetEntries."Transaction Type"::Allocation;
                FINBudgetEntries."Document Type" := 'ALLOCATION';
                FINBudgetEntries."Document No" := 'ALLOC' + GetCurrentBudget;
                FINBudgetEntries."Document Description" := 'Budget Allocation';
                FINBudgetEntries.INSERT();
                UpdatePercentages(GLBudgetEntry."G/L Account No.", GLBudgetEntry."Global Dimension 1 Code", GLBudgetEntry."Global Dimension 2 Code");
            END;
            UNTIL GLBudgetEntry.NEXT = 0;
        END;
        MESSAGE('Budget updated successfully!');
    end;

    //[Scope('Internal')]
    procedure CheckBudgetAvailability(GLAccount: Code[20]; Dates: Date; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; Amounts: Decimal; Descriptions: Text; DocumentType: Code[20]; DocumentNo: Code[20]; DocumentDescription: Text[250])
    begin

        //Update Budget First
        IF checkBudgetControl(GLAccount) = FALSE THEN EXIT;
        PostBudget;
        FINBudgetEntries.RESET;
        FINBudgetEntries.SETRANGE("Budget Name", GetCurrentBudget);
        FINBudgetEntries.SETRANGE("Document No", DocumentNo);
        FINBudgetEntries.SETFILTER(FINBudgetEntries."Commitment Status", '<>%1', FINBudgetEntries."Commitment Status"::Cancelled);
        IF FINBudgetEntries.FIND('-') THEN EXIT;//ERROR('Budget already checked!');

        CLEAR(LastItem);
        FINBudgetEntries.RESET;
        IF FINBudgetEntries.FIND('+') THEN LastItem := FINBudgetEntries."Entry No.";
        BEGIN
            LastItem := LastItem + 1;
            FINBudgetEntries.INIT;
            FINBudgetEntries."Entry No." := LastItem;
            FINBudgetEntries."Budget Name" := GetCurrentBudget;
            FINBudgetEntries."G/L Account No." := GLAccount;
            FINBudgetEntries.Date := Dates;
            FINBudgetEntries."Global Dimension 1 Code" := GlobalDim1Code;
            FINBudgetEntries."Global Dimension 2 Code" := GlobalDim2Code;
            FINBudgetEntries.Amount := -Amounts;
            FINBudgetEntries.Description := Descriptions;
            FINBudgetEntries."Business Unit Code" := '';
            FINBudgetEntries."User ID" := USERID;
            FINBudgetEntries."Budget Dimension 1 Code" := '';
            FINBudgetEntries."Budget Dimension 2 Code" := '';
            FINBudgetEntries."Budget Dimension 3 Code" := '';
            FINBudgetEntries."Budget Dimension 4 Code" := '';
            FINBudgetEntries."Last Date Modified" := TODAY;
            //FINBudgetEntries."Dimension Set ID":='';
            FINBudgetEntries."Transaction Type" := FINBudgetEntries."Transaction Type"::Commitment;
            FINBudgetEntries."Commitment Status" := FINBudgetEntries."Commitment Status"::Commitment;
            FINBudgetEntries."Document Type" := DocumentType;
            FINBudgetEntries."Document No" := DocumentNo;
            FINBudgetEntries."Document Description" := DocumentDescription;
            FINBudgetEntries.INSERT;
        END;
        UpdatePercentages(GLAccount, GlobalDim1Code, GlobalDim2Code);
    end;

    //[Scope('Internal')]
    procedure CancelBudgetCommitment(GLAccount: Code[20]; Dates: Date; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; Amounts: Decimal; Descriptions: Text; UserID: Code[20]; DocumentType: Code[20]; DocumentNo: Code[20]; DocumentDescription: Text[250])
    begin

        IF checkBudgetControl(GLAccount) = FALSE THEN EXIT;

        FINBudgetEntries.RESET;
        FINBudgetEntries.SETRANGE("Budget Name", GetCurrentBudget);
        FINBudgetEntries.SETRANGE("Document No", DocumentNo);
        FINBudgetEntries.SETRANGE("Document Type", DocumentType);
        FINBudgetEntries.SETFILTER(FINBudgetEntries."Commitment Status", '%1', FINBudgetEntries."Commitment Status"::Commitment);
        //  IF NOT (FINBudgetEntries.FIND('-')) THEN ERROR('No pending commitment found in the filters');
        IF (FINBudgetEntries.FIND('-')) THEN BEGIN
            FINBudgetEntries."Commitment Status" := FINBudgetEntries."Commitment Status"::Cancelled;
            FINBudgetEntries.MODIFY;
        END;

        UpdatePercentages(GLAccount, GlobalDim1Code, GlobalDim2Code);
    end;

    //[Scope('Internal')]
    procedure ExpenseBudget(GLAccount: Code[20]; Dates: Date; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; Amounts: Decimal; Descriptions: Text; UserID: Code[20]; LastDateModified: Date; DocumentType: Code[20]; DocumentNo: Code[20]; DocumentDescription: Text[250])
    begin

        IF checkBudgetControl(GLAccount) = FALSE THEN EXIT;
        FINBudgetEntries.RESET;
        FINBudgetEntries.SETRANGE("Budget Name", GetCurrentBudget);
        FINBudgetEntries.SETRANGE("Document No", DocumentNo);
        FINBudgetEntries.SETRANGE("Document Type", DocumentType);
        FINBudgetEntries.SETFILTER(FINBudgetEntries."Commitment Status", '%1', FINBudgetEntries."Commitment Status"::Commitment);
        IF NOT (FINBudgetEntries.FIND('-')) THEN BEGIN
            //Try Commiting Budget Again
            CheckBudgetAvailability(GLAccount, Dates, GlobalDim1Code, GlobalDim2Code, Amounts, Descriptions, DocumentType, DocumentNo, DocumentDescription);
            FINBudgetEntries2.RESET;
            FINBudgetEntries2.SETRANGE("Budget Name", GetCurrentBudget);
            FINBudgetEntries2.SETRANGE("Document No", DocumentNo);
            FINBudgetEntries2.SETRANGE("Document Type", DocumentType);
            FINBudgetEntries2.SETFILTER(FINBudgetEntries2."Commitment Status", '%1', FINBudgetEntries2."Commitment Status"::Commitment);
            IF NOT (FINBudgetEntries2.FIND('-')) THEN ERROR('No pending commitment found in the filters')
        END;
        //  IF Amounts<>FINBudgetEntries.Amount THEN ERROR('The amount to be expensed is different from the amount to expense.');
        FINBudgetEntries.Amount := Amounts;
        FINBudgetEntries."Commitment Status" := FINBudgetEntries."Commitment Status"::"Commited/Posted";
        FINBudgetEntries.MODIFY;
        // Create a Budget Expense Entry into the Budget entry Tables
        CLEAR(LastItem);
        FINBudgetEntries.RESET;
        IF FINBudgetEntries.FIND('+') THEN LastItem := FINBudgetEntries."Entry No.";
        BEGIN
            LastItem := LastItem + 1;
            FINBudgetEntries.INIT;
            FINBudgetEntries."Entry No." := LastItem;
            FINBudgetEntries."Budget Name" := GetCurrentBudget;
            FINBudgetEntries."G/L Account No." := GLAccount;
            FINBudgetEntries.Date := Dates;
            FINBudgetEntries."Global Dimension 1 Code" := GlobalDim1Code;
            FINBudgetEntries."Global Dimension 2 Code" := GlobalDim2Code;
            FINBudgetEntries.Amount := -Amounts;
            FINBudgetEntries.Description := Descriptions;
            FINBudgetEntries."Business Unit Code" := '';
            FINBudgetEntries."User ID" := UserID;
            FINBudgetEntries."Budget Dimension 1 Code" := '';
            FINBudgetEntries."Budget Dimension 2 Code" := '';
            FINBudgetEntries."Budget Dimension 3 Code" := '';
            FINBudgetEntries."Budget Dimension 4 Code" := '';
            FINBudgetEntries."Last Date Modified" := TODAY;
            //FINBudgetEntries."Dimension Set ID":='';
            FINBudgetEntries."Transaction Type" := FINBudgetEntries."Transaction Type"::Expense;
            FINBudgetEntries."Document Type" := DocumentType;
            FINBudgetEntries."Document No" := DocumentNo;
            FINBudgetEntries."Document Description" := DocumentDescription;
            FINBudgetEntries.INSERT;
        END;
        UpdatePercentages(GLAccount, GlobalDim1Code, GlobalDim2Code);
    end;

    //[Scope('Internal')]
    procedure GetCurrentBudget() CurrBudget: Code[20]
    var
        GLBudgetName: Record 95;
        FINBudgetaryControlSetup: Record "FIN-Budgetary Control Setup";
    begin
        CLEAR(CurrBudget);
        FINBudgetaryControlSetup.RESET();
        IF FINBudgetaryControlSetup.FIND('-') THEN BEGIN
            FINBudgetaryControlSetup.TESTFIELD("Current Budget Code");

        END;
        CurrBudget := FINBudgetaryControlSetup."Current Budget Code";
    end;

    //[Scope('Internal')]
    procedure GetBudgetStartAndEndDates(Transdate: Date) BudgetDatesFilter: Text[150]
    var
        StartDate: Date;
        EndDate: Date;
        // FINBudgetPeriodsSetup: Record "FIN-Budget Periods Setup";
        FINBudgetPeriodsSetup: Record "Cash Office Setup";

    begin
        CLEAR(StartDate);
        CLEAR(EndDate);
        FINBudgetPeriodsSetup.RESET;
        FINBudgetPeriodsSetup.SETRANGE("Current Budget", GetCurrentBudget);
        IF FINBudgetPeriodsSetup.FIND('-') THEN BEGIN
            StartDate := FINBudgetPeriodsSetup."Current Budget Start Date";
            EndDate := FINBudgetPeriodsSetup."Current Budget End Date";
        END;
        CLEAR(BudgetDatesFilter);
        BudgetDatesFilter := FORMAT(StartDate) + '..' + FORMAT(EndDate);
    end;
    procedure GetBudgetStartDate(Transdate: Date) BudgetDatesFilter: Date
    var
        StartDate: Date;
        EndDate: Date;
        // FINBudgetPeriodsSetup: Record "FIN-Budget Periods Setup";
        FINBudgetPeriodsSetup: Record "Cash Office Setup";

    begin
        CLEAR(StartDate);
        CLEAR(EndDate);
        FINBudgetPeriodsSetup.RESET;
        FINBudgetPeriodsSetup.SETRANGE("Current Budget", GetCurrentBudget);
        IF FINBudgetPeriodsSetup.FIND('-') THEN BEGIN
            StartDate := FINBudgetPeriodsSetup."Current Budget Start Date";
            EndDate := FINBudgetPeriodsSetup."Current Budget End Date";
        END;
        CLEAR(BudgetDatesFilter);
        BudgetDatesFilter := StartDate;
    end;
    procedure GetBudgetEndDate(Transdate: Date) BudgetDatesFilter: Date
    var
        StartDate: Date;
        EndDate: Date;
        // FINBudgetPeriodsSetup: Record "FIN-Budget Periods Setup";
        FINBudgetPeriodsSetup: Record "Cash Office Setup";

    begin
        CLEAR(StartDate);
        CLEAR(EndDate);
        FINBudgetPeriodsSetup.RESET;
        FINBudgetPeriodsSetup.SETRANGE("Current Budget", GetCurrentBudget);
        IF FINBudgetPeriodsSetup.FIND('-') THEN BEGIN
            StartDate := FINBudgetPeriodsSetup."Current Budget Start Date";
            EndDate := FINBudgetPeriodsSetup."Current Budget End Date";
        END;
        CLEAR(BudgetDatesFilter);
        BudgetDatesFilter := EndDate;
    end;


    //[Scope('Internal')]
    procedure checkBudgetControl(var glAcc: Code[20]) IsBudgetControlled: Boolean
    var
        GLAccount: Record "G/L Account";
    begin
        CLEAR(IsBudgetControlled);
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", glAcc);
        IF GLAccount.FIND('-') THEN;
        IF GLAccount."Budget Controlled" THEN;
        IsBudgetControlled := GLAccount."Budget Controlled";
        //ELSE ERROR('Missing account');
    end;

    procedure GetBudgetStartDates(BudgetNames: Code[20]) StartDate: Date
    var
        EndDate: Date;
        FINBudgetPeriodsSetup: Record "FIN-Budget Periods Setup";
    begin
        CLEAR(StartDate);
        CLEAR(EndDate);
        FINBudgetPeriodsSetup.RESET;
        FINBudgetPeriodsSetup.SETRANGE("Budget Name", BudgetNames);
        FINBudgetPeriodsSetup.SETRANGE("Period ID/Quater ID", 1);
        IF FINBudgetPeriodsSetup.FIND('-') THEN BEGIN
            FINBudgetPeriodsSetup.TESTFIELD("Period/Quater Start");
            StartDate := FINBudgetPeriodsSetup."Period/Quater Start";
        END;
    end;

    //[Scope('Internal')]
    procedure GetBudgetEndDates(Transdate: Date) EndDate: Date
    var
        StartDate: Date;
        FINBudgetPeriodsSetup: Record "FIN-Budget Periods Setup";
    begin
        CLEAR(StartDate);
        CLEAR(EndDate);

        FINBudgetPeriodsSetup.RESET;
        FINBudgetPeriodsSetup.SETRANGE("Budget Name", GetCurrentBudget);
        FINBudgetPeriodsSetup.SETFILTER("Period/Quater Start", '<%1|=%2', Transdate);
        FINBudgetPeriodsSetup.SETFILTER("Period/Quater End", '>%1|=%2', Transdate);
        IF FINBudgetPeriodsSetup.FIND('-') THEN BEGIN
            FINBudgetPeriodsSetup.TESTFIELD("Period/Quater End");
            EndDate := FINBudgetPeriodsSetup."Period/Quater End";
        END;
    end;

    local procedure UpdatePercentages(glAccount: Code[20]; global1: Code[20]; Global2: Code[20])
    var
        FINBudgetEntriesSummary: Record "FIN-Budget Entries Summary";
    begin
        IF GetCurrentBudget <> '' THEN BEGIN
            FINBudgetEntriesSummary.RESET;
            FINBudgetEntriesSummary.SETRANGE("Budget Name", GetCurrentBudget);
            FINBudgetEntriesSummary.SETRANGE("G/L Account No.", glAccount);
            FINBudgetEntriesSummary.SETRANGE("Global Dimension 1 Code", global1);
            //FINBudgetEntriesSummary.SETRANGE("Global Dimension 2 Code", Global2);
            IF FINBudgetEntriesSummary.FIND('-') THEN BEGIN
                FINBudgetEntriesSummary.CALCFIELDS(Allocation, Commitments, Expenses, Balance, "Net Balance");
                IF FINBudgetEntriesSummary.Allocation > 0 THEN BEGIN
                    FINBudgetEntriesSummary."% Balance" := (FINBudgetEntriesSummary.Balance / FINBudgetEntriesSummary.Allocation) * 100;
                    FINBudgetEntriesSummary."% Net Balance" := (FINBudgetEntriesSummary."Net Balance" / FINBudgetEntriesSummary.Allocation) * 100;
                    FINBudgetEntriesSummary.MODIFY;
                END;
            END;
        END;
    end;
}
