table 52178766 "PROC-Internal Req. Plan Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference to the requisition header in the database';
        }
        field(2; Type; Option)
        {
            Description = 'Stores the type of item being requisitioned can be Item, GL Account or Fixed Asset';
            OptionCaption = 'Item,G/L Account,Fixed Assets';
            OptionMembers = Item,"G/L Account","Fixed Assets";
        }
        field(3; "Type No."; Code[20])
        {
            Description = 'Stores the reference code the item being requisitioned for.';
            TableRelation = IF (Type = CONST(Item)) Item."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No." WHERE("Account Type" = CONST(Posting))
            ELSE
            IF (Type = CONST("Fixed Assets")) "Fixed Asset"."No." WHERE(Blocked = CONST(false));
        }
        field(4; Description; Text[100])
        {
            Description = 'Stores the description of the item being requisitioned for';
        }
        field(5; Purpose; Text[100])
        {
            Description = 'Stores the purpose of the requisition for the item in the database';
        }
        field(6; Qty; Decimal)
        {
            Description = 'Stores the quantity being requisitioned for in the database';
        }
        field(7; "Unit of Measure"; Code[20])
        {
            Description = 'Stores the reference code of the unit of measure in the database';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Type No."))
            ELSE
            IF (Type = CONST("G/L Account")) "Unit of Measure".Code
            ELSE
            IF (Type = CONST("Fixed Assets")) "Unit of Measure".Code;
        }
        field(8; "Units per Unit of Measure"; Decimal)
        {
            Description = 'Stores the number of units in the unit of measure for the item in the database';
        }
        field(9; "Unit Direct Cost"; Decimal)
        {
            Description = 'Stores the unit direct cost of the item in the database';
        }
        field(10; "Total Units Due"; Decimal)
        {
            Description = 'Stores the total units due in the requisition';
        }
        field(11; "Total Cost"; Decimal)
        {
            Description = 'Stores the total cost expected in the database i.e. Unit Direct Cost * Total Units Due';
        }
        field(12; "Total Units Issued"; Decimal)
        {
            Description = 'Stores the total units issued to date for the item in the database';
        }
        field(13; "Action"; Option)
        {
            Description = 'Stores the action tied to the item in the database';
            OptionMembers = Issue,"Issue & Raise Procurement Requisition","Raise Procurement Requisition";
        }
        field(14; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Plan No"; Code[20])
        {
        }
        field(16; Inventory; Decimal)
        {
        }
        field(17; "Budget Balance"; Decimal)
        {
        }
        field(18; Status; Option)
        {
            InitValue = Department;
            OptionMembers = Department,Procurement,Finance;
        }
        field(19; "Vote Book"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                date := TODAY;
                EVALUATE(CurrMonth, FORMAT(DATE2DMY(date, 2)));
                EVALUATE(CurrYR, FORMAT(DATE2DMY(date, 3)));
                EVALUATE(BudgetDate, FORMAT('01' + '/' + CurrMonth + '/' + CurrYR));

                //Get the last day of the month

                LastDay := CALCDATE('1M', BudgetDate);
                LastDay := CALCDATE('-1D', LastDay);


                //Get Budget for the G/L
                IF GenLedSetup.GET THEN BEGIN
                    GLAccount.SETFILTER(GLAccount."Budget Filter", GenLedSetup."Current Budget");
                    GLAccount.SETRANGE(GLAccount."No.", "Vote Book");
                    GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                    /*Get the exact Monthly Budget*/
                    //Start from first date of the budget.//BudgetDate
                    GLAccount.SETRANGE(GLAccount."Date Filter", GenLedSetup."Current Budget Start Date", LastDay);

                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                        MonthBudget := GLAccount."Budgeted Amount";
                        Expenses := GLAccount."Net Change";
                        BudgetAvailable := GLAccount."Budgeted Amount" - GLAccount."Net Change";
                        // "Total Allocation":=MonthBudget;
                        // "Total Expenditure":=Expenses;
                    END;
                END;



                CommitmentEntries.RESET;
                CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                CommitmentEntries.SETRANGE(CommitmentEntries.Account, "Vote Book");
                CommitmentEntries.SETRANGE(CommitmentEntries.Date, GenLedSetup."Current Budget Start Date", LastDay);
                CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                CommittedAmount := CommitmentEntries."Committed Amount";

                //"Total Commitments":=CommittedAmount;
                "Budget Balance" := BudgetAvailable - CommittedAmount;
                // "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                MODIFY;

            end;
        }
        field(20; "Requested Qty"; Decimal)
        {
        }
        field(21; "Approved Qty"; Decimal)
        {
        }
        field(22; Approval; Option)
        {
            OptionMembers = Approve,Reject;
        }
        field(23; "Procurement Type"; Option)
        {
            OptionMembers = ,"Open Tender","Restricted Tender","Request For Proposal","Direct Procurement","Request For Quotations","Low Value Procurement","International Tender",Other;
        }
        field(24; Select; Boolean)
        {
        }
        field(25; Printed; Boolean)
        {
        }
        field(26; "Issued Qty"; Decimal)
        {
        }
        field(27; "Remaining Qty"; Decimal)
        {
        }
        field(28; Posted; Boolean)
        {
            InitValue = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Total Units Due", "Total Units Issued";
        }
    }

    fieldgroups
    {
    }

    var
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgetDate: Date;
        LastDay: Date;
        GenLedSetup: Record 98;
        GLAccount: Record 15;
        MonthBudget: Decimal;
        Expenses: Decimal;
        BudgetAvailable: Decimal;
        CommitmentEntries: Record "FIN-Commitment Entries";
        date: Date;
        CommittedAmount: Decimal;
}

