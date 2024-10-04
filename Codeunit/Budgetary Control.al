codeunit 52178700 "Budgetary Control"
{

    trigger OnRun()
    begin
    end;

    var
        BCSetup: Record "FIN-Budgetary Control Setup";
        DimMgt: Codeunit "DimensionManagement";
        ShortcutDimCode: array[8] of Code[20];
        BudgetGL: Code[20];
        DimCode1: Code[20];
        DimCode2: Code[20];
        Text0001: Label 'You Have exceeded the Budget by ';
        Text0002: Label ' Do you want to Continue?';
        Text0003: Label 'There is no Budget to Check against do you wish to continue?';
        GLBudgetEntry: Record "G/L Budget Entry";


    procedure CheckPurchase(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PurchHeader."Document Date" < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3', PurchHeader."Document Date",
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (PurchHeader."Document Date" > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3', PurchHeader."Document Date",
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PurchLine.RESET;
            PurchLine.SETRANGE(PurchLine."Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE(PurchLine."Document No.", PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN BEGIN
                REPEAT
                    IF PurchLine.Type <> PurchLine.Type::" " THEN BEGIN

                        //Get the Dimension Here
                        //IF PurchLine."Line No." <> 0 THEN
                        // DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(
                        // DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                        // PurchLine."Line No.",ShortcutDimCode)
                        //  ELSE
                        // DimMgt.ClearDimSetFilter(ShortcutDimCode);
                        //Had to be put here for the sake of Calculating Individual Line Entries

                        //check the type of account in the payments line
                        //Item
                        IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                            Item.RESET;
                            IF NOT Item.GET(PurchLine."No.") THEN
                                ERROR('Item Does not Exist');

                            Item.TESTFIELD("Item G/L Budget Account");
                            BudgetGL := Item."Item G/L Budget Account";
                        END;

                        IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
                            FixedAssetsDet.RESET;
                            FixedAssetsDet.SETRANGE(FixedAssetsDet."No.", PurchLine."No.");
                            IF FixedAssetsDet.FIND('-') THEN BEGIN
                                FAPostingGRP.RESET;
                                FAPostingGRP.SETRANGE(FAPostingGRP.Code, FixedAssetsDet."FA Posting Group");
                                IF FAPostingGRP.FIND('-') THEN
                                    IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Maintenance THEN BEGIN
                                        BudgetGL := FAPostingGRP."Maintenance Expense Account";
                                        IF BudgetGL = '' THEN
                                            ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account', PurchLine."No.");
                                    END ELSE BEGIN
                                        IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                            BudgetGL := FAPostingGRP."Acquisition Cost Account";
                                            IF BudgetGL = '' THEN
                                                ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account', PurchLine."No.");
                                        END;
                                        //To Accomodate any Additional Item under Custom 1 and Custom 2
                                        IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Maintenance THEN BEGIN
                                            BudgetGL := FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL = '' THEN
                                                ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account', PurchLine."No.",
                                                FAPostingGRP."Custom 1 Account");
                                        END;

                                        IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Appreciation THEN BEGIN
                                            BudgetGL := FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL = '' THEN
                                                ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account', PurchLine."No.",
                                                FAPostingGRP."Custom 1 Account");
                                        END;
                                        //To Accomodate any Additional Item under Custom 1 and Custom 2

                                    END;
                            END;
                        END;

                        IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
                            BudgetGL := PurchLine."No.";
                            IF GLAcc.GET(PurchLine."No.") THEN
                                GLAcc.TESTFIELD("Budget Controlled", TRUE);
                        END;

                        //End Checking Account in Payment Line

                        //check the votebook now
                        FirstDay := DMY2DATE(1, DATE2DMY(PurchHeader."Document Date", 2), DATE2DMY(PurchHeader."Document Date", 3));
                        CurrMonth := DATE2DMY(PurchHeader."Document Date", 2);
                        IF CurrMonth = 12 THEN BEGIN
                            LastDay := DMY2DATE(1, 1, DATE2DMY(PurchHeader."Document Date", 3) + 1);
                            LastDay := CALCDATE('-1D', LastDay);
                        END
                        ELSE BEGIN
                            CurrMonth := CurrMonth + 1;
                            LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(PurchHeader."Document Date", 3));
                            LastDay := CALCDATE('-1D', LastDay);
                        END;

                        //If Budget is annual then change the Last day
                        IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                            LastDay := BCSetup."Current Budget End Date";

                        /* //check the summation of the budget in the database
                         BudgetAmount:=0;
                         Budget.RESET;
                         Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                         Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                         Budget."Dimension 4 Value Code");
                         Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                         Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                         Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                         Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                         Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                        // Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                         //Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                             Budget.CALCSUMS(Budget.Amount);
                             BudgetAmount:= Budget.Amount;
                             */
                        BudgetAmount := 0;
                        GLBudgetEntry.RESET;
                        GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Name", BCSetup."Current Budget Code");
                        GLBudgetEntry.SETRANGE(GLBudgetEntry.Date, BCSetup."Current Budget Start Date", LastDay);
                        GLBudgetEntry.SETRANGE(GLBudgetEntry."G/L Account No.", BudgetGL);
                        GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                        GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                        IF GLBudgetEntry.FIND('-') THEN BEGIN
                            REPEAT
                                //ActualsAmount +=
                                //BudgetAmount +=  GLBudgetEntry.Amount;
                                BudgetAmount := BudgetAmount + GLBudgetEntry.Amount;

                            UNTIL GLBudgetEntry.NEXT = 0;
                        END;
                        //get the summation on the actuals
                        //Separate Analysis View and G/L Entry
                        /*IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;*/
                        //END ELSE BEGIN
                        ActualsAmount := 0;
                        GLAccount.RESET;
                        GLAccount.SETRANGE(GLAccount."No.", BudgetGL);
                        GLAccount.SETRANGE(GLAccount."Date Filter", BCSetup."Current Budget Start Date", LastDay);
                        IF PurchLine."Shortcut Dimension 1 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter", PurchLine."Shortcut Dimension 1 Code");
                        IF PurchLine."Shortcut Dimension 2 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter", PurchLine."Shortcut Dimension 2 Code");
                        IF GLAccount.FIND('-') THEN BEGIN
                            GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                            ActualsAmount := GLAccount."Net Change";
                        END;

                        //END;
                        //get the committments
                        CommitmentAmount := 0;
                        Commitments.RESET;
                        Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                        Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                        Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                        Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                        Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                        Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                        Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                        Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                        Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", ShortcutDimCode[3]);
                        Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", ShortcutDimCode[4]);
                        Commitments.CALCSUMS(Commitments.Amount);
                        CommitmentAmount := Commitments.Amount;

                        //check if there is any budget
                        IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                            ERROR('No Budget To Check Against');
                        END ELSE BEGIN
                            IF (BudgetAmount <= 0) THEN BEGIN
                                IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                    ERROR('Budgetary Checking Process Aborted');
                                END;
                            END;
                        END;

                        //check if the actuals plus the amount is greater then the budget amount
                        IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)") + ActualsAmount > BudgetAmount)
                        AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                            ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                            PurchLine."Document No.", PurchLine.Type, PurchLine."No.",
                              FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PurchLine."Outstanding Amount (LCY)"))));
                        END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                            IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)") + ActualsAmount > BudgetAmount) THEN BEGIN
                                IF NOT CONFIRM(Text0001 +
                                FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PurchLine."Outstanding Amount (LCY)")))
                                + Text0002, TRUE) THEN BEGIN
                                    ERROR('Budgetary Checking Process Aborted');
                                END;
                            END;
                            //END ADDING CONFIRMATION
                            Commitments.RESET;
                            Commitments.INIT;
                            EntryNo += 1;
                            Commitments."Line No." := EntryNo;
                            Commitments.Date := TODAY;
                            Commitments."Posting Date" := PurchHeader."Document Date";
                            IF PurchHeader.DocApprovalType = PurchHeader.DocApprovalType::Purchase THEN
                                Commitments."Document Type" := Commitments."Document Type"::LPO
                            ELSE
                                Commitments."Document Type" := Commitments."Document Type"::Requisition;

                            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                                Commitments."Document Type" := Commitments."Document Type"::PurchInvoice;

                            Commitments."Document No." := PurchHeader."No.";
                            Commitments.Amount := PurchLine."Outstanding Amount (LCY)";
                            Commitments."Month Budget" := BudgetAmount;
                            Commitments."Month Actual" := ActualsAmount;
                            Commitments.Committed := TRUE;
                            Commitments."Committed By" := USERID;
                            Commitments."Committed Date" := PurchHeader."Document Date";
                            Commitments."G/L Account No." := BudgetGL;
                            Commitments."Committed Time" := TIME;
                            // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                            Commitments."Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
                            Commitments."Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
                            Commitments."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
                            Commitments."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
                            Commitments.Budget := BCSetup."Current Budget Code";
                            Commitments.Type := Commitments.Type::Vendor;
                            Commitments."Vendor/Cust No." := PurchHeader."Buy-from Vendor No.";
                            Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                            Commitments."Actual Source" := BCSetup."Actual Source";
                            Commitments."Document Line No." := PurchLine."Line No.";
                            Commitments.INSERT;
                            //Tag the Purchase Line as Committed
                            PurchLine.Committed := TRUE;
                            PurchLine.MODIFY;
                            //End Tagging PurchLines as Committed
                        END;
                    END;
                UNTIL PurchLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;

        PurchHeader.RESET;
        PurchHeader.SETRANGE(PurchHeader."No.", PurchLine."Document No.");
        IF PurchHeader.FIND('-') THEN BEGIN
            PurchHeader."Budgeted Amount" := BudgetAmount;
            PurchHeader."Actual Expenditure" := ActualsAmount;
            PurchHeader."Committed Amount" := CommitmentAmount;
            PurchHeader."Budget Balance" := BudgetAmount - (ActualsAmount + CommitmentAmount + PurchHeader.Amount);
            PurchHeader.MODIFY;
        END;

    end;


    procedure CheckPayments(var PaymentHeader: Record "FIN-Payments Header")
    var
        PayLine: Record "FIN-Payment Line";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin

        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PaymentHeader.Date < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3', PaymentHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (PaymentHeader.Date > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3', PaymentHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No, PaymentHeader."No.");
            PayLine.SETRANGE(PayLine."Account Type", PayLine."Account Type"::"G/L Account");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
            IF PayLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(PaymentHeader.Date, 2), DATE2DMY(PaymentHeader.Date, 3));
                    CurrMonth := DATE2DMY(PaymentHeader.Date, 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(PaymentHeader.Date, 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(PaymentHeader.Date, 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;

                    //If Budget is annual then change the Last day
                    IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                        LastDay := BCSetup."Current Budget End Date";

                    BudgetGL := PayLine."Account No.";
                    //check the summation of the budget in the database
                    BudgetAmount := 0;
                    GLBudgetEntry.RESET;
                    GLBudgetEntry.SETRANGE("G/L Account No.", BudgetGL);
                    GLBudgetEntry.SETRANGE(Date, BCSetup."Current Budget Start Date", LastDay);
                    GLBudgetEntry.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    //GLAcc.SETRANGE("Dimension Set ID Filter",PayLine."Dimension Set ID");
                    IF GLBudgetEntry.FIND('-') THEN BEGIN
                        REPEAT
                            // GLBudgetEntry.CALCFIELDS(Amount,"Net Change");
                            //ActualsAmount := GLAcc."Net Change";
                            BudgetAmount := BudgetAmount + GLBudgetEntry.Amount;  //GLBudgetEntry.Amount;
                        UNTIL GLBudgetEntry.NEXT = 0;
                        //MESSAGE('%1',BudgetAmount);
                    END;
                    //get the summation on the actuals

                    ActualsAmount := 0;
                    GLEntry.RESET;
                    GLEntry.SETRANGE(GLEntry."G/L Account No.", BudgetGL);
                    GLEntry.SETRANGE(GLEntry."Posting Date", BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    GLEntry.SETRANGE(GLEntry."Global Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    GLEntry.SETRANGE(GLEntry."Global Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    IF GLEntry.FIND('-') THEN BEGIN
                        REPEAT
                            ActualsAmount := ActualsAmount + GLEntry.Amount;
                        UNTIL GLEntry.NEXT = 0;
                    END;


                    /*
                     Budget.RESET;
                     Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                     Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                     Budget."Dimension 4 Value Code");
                     Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                     Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                     Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                     Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                     Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                     Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                     Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                         Budget.CALCSUMS(Budget.Amount);
                         BudgetAmount:= Budget.Amount;

                //get the summation on the actuals
                //Separate Analysis View and G/L Entry
                  IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                  ActualsAmount:=0;
                  Actuals.RESET;
                  Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                  Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                  Actuals."Posting Date",Actuals."Account No.");
                  Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                  Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                  Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                  Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                  Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                  Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                  Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                     Actuals.CALCSUMS(Actuals.Amount);
                     ActualsAmount:= Actuals.Amount;
                  END ELSE BEGIN
                      GLAccount.RESET;
                      GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                      GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                      IF PayLine."Global Dimension 1 Code" <> '' THEN
                        GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                      IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                        GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                      IF GLAccount.FIND('-') THEN BEGIN
                       GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                       ActualsAmount:=GLAccount."Net Change";
                      END;

                  END;*/
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");

                    //                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                    //                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                    REPEAT
                        Commitments.CALCSUMS(Commitments.Amount);
                        CommitmentAmount := Commitments.Amount;
                    UNTIL Commitments.NEXT = 0;
                    //check if there is any budget
                    IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END ELSE BEGIN
                        IF (BudgetAmount <= 0) THEN BEGIN
                            IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF ((CommitmentAmount + PayLine."NetAmount LCY" + ActualsAmount) > BudgetAmount)
                    AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, PayLine.Type, PayLine.No,
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."NetAmount LCY"))));
                    END ELSE BEGIN
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        IF ((CommitmentAmount + PayLine."NetAmount LCY" + ActualsAmount) > BudgetAmount) THEN BEGIN
                            IF NOT CONFIRM(Text0001 +
                            FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."NetAmount LCY")))
                            + Text0002, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := PaymentHeader.Date;
                        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal THEN
                            Commitments."Document Type" := Commitments."Document Type"::"Payment Voucher"
                        ELSE
                            Commitments."Document Type" := Commitments."Document Type"::PettyCash;
                        Commitments."Document No." := PaymentHeader."No.";
                        Commitments.Amount := PayLine."NetAmount LCY";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := PaymentHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                        Commitments."Actual Source" := BCSetup."Actual Source";
                        Commitments."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.INSERT;
                        //Tag the Payment Line as Committed
                        PayLine.Committed := TRUE;
                        PayLine.MODIFY;
                        //End Tagging Payment Lines as Committed
                    END;

                UNTIL PayLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;



        PaymentHeader."Budgeted Amount" := BudgetAmount;
        PaymentHeader."Actual Expenditure" := ActualsAmount;
        PaymentHeader."Committed Amount" := CommitmentAmount;
        PaymentHeader.CALCFIELDS(PaymentHeader."Total Net Amount");
        PaymentHeader."Budget Balance" := BudgetAmount - CommitmentAmount;//(ActualsAmount+CommitmentAmount+PaymentHeader."Total Net Amount");
        PaymentHeader.MODIFY;

        MESSAGE('Budgetary Checking Completed Successfully');

        MESSAGE('Budgetary Checking Completed Successfully');

    end;


    procedure CheckImprest(var ImprestHeader: Record "FIN-Imprest Header")
    var
        PayLine: Record "FIN-Imprest Lines";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (ImprestHeader.Date > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No, ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
            IF PayLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(ImprestHeader.Date, 2), DATE2DMY(ImprestHeader.Date, 3));
                    CurrMonth := DATE2DMY(ImprestHeader.Date, 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(ImprestHeader.Date, 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ImprestHeader.Date, 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;

                    //If Budget is annual then change the Last day
                    IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";
                    DimCode1 := PayLine."Global Dimension 1 Code";
                    DimCode2 := PayLine."Shortcut Dimension 2 Code";

                    //check the summation of the budget in the database
                    /* BudgetAmount:=0;
                     Budget.RESET;
                     Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                     Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                     Budget."Dimension 4 Value Code");
                     Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                     Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                     Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                     Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                     Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                     Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                     Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                         Budget.CALCSUMS(Budget.Amount);
                         BudgetAmount:= Budget.Amount;*/

                    GLBudgetEntry.RESET;
                    GLBudgetEntry.SETRANGE("G/L Account No.", BudgetGL);
                    GLBudgetEntry.SETRANGE(Date, BCSetup."Current Budget Start Date", LastDay);
                    GLBudgetEntry.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    //GLAcc.SETRANGE("Dimension Set ID Filter",PayLine."Dimension Set ID");
                    IF GLBudgetEntry.FIND('-') THEN BEGIN
                        REPEAT
                            BudgetAmount := BudgetAmount + GLBudgetEntry.Amount; //GLBudgetEntry.Amount;
                                                                                 //MESSAGE('%1',BudgetAmount);
                        UNTIL GLBudgetEntry.NEXT = 0;
                    END;
                    //get the summation on the actuals

                    ActualsAmount := 0;
                    GLEntry.RESET;
                    GLEntry.SETRANGE(GLEntry."G/L Account No.", BudgetGL);
                    GLEntry.SETRANGE(GLEntry."Posting Date", BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    GLEntry.SETRANGE(GLEntry."Global Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    GLEntry.SETRANGE(GLEntry."Global Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    IF GLEntry.FIND('-') THEN BEGIN
                        REPEAT
                            ActualsAmount := ActualsAmount + GLEntry.Amount;
                        UNTIL GLEntry.NEXT = 0;
                    END;

                    //Separate Analysis View and G/L Entry
                    /* IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                     ActualsAmount:=0;
                     Actuals.RESET;
                     Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                     Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                     Actuals."Posting Date",Actuals."Account No.");
                     Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                     Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                     Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                     Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                     Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                     Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                     Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                        Actuals.CALCSUMS(Actuals.Amount);
                        ActualsAmount:= Actuals.Amount;
                     END ELSE BEGIN
                         GLAccount.RESET;
                         GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                         GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                         IF PayLine."Global Dimension 1 Code" <> '' THEN
                           GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                         IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                           GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                         IF GLAccount.FIND('-') THEN BEGIN
                          GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                          ActualsAmount:=GLAccount."Net Change";
                         END;
                     END;*/
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                    REPEAT
                        Commitments.CALCSUMS(Commitments.Amount);
                        CommitmentAmount := Commitments.Amount;
                    UNTIL Commitments.NEXT = 0;

                    //check if there is any budget
                    IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END ELSE BEGIN
                        IF (BudgetAmount <= 0) THEN BEGIN
                            IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Imprest', PayLine.No,
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    END ELSE BEGIN
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) THEN BEGIN
                            IF NOT CONFIRM(Text0001 +
                            FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."Document Type"::Imprest;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine."Amount LCY";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        Commitments."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                        Commitments."Actual Source" := BCSetup."Actual Source";
                        Commitments.INSERT;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := TRUE;
                        PayLine.MODIFY;
                        //End Tagging Imprest Lines as Committed
                    END;

                UNTIL PayLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;

        ImprestHeader."Budgeted Amount" := BudgetAmount;
        ImprestHeader."Actual Expenditure" := ActualsAmount;
        ImprestHeader."Committed Amount" := CommitmentAmount;
        ImprestHeader.CALCFIELDS("Total Net Amount");
        ImprestHeader."Budget Balance" := BudgetAmount - (ActualsAmount + CommitmentAmount + ImprestHeader."Total Net Amount");
        ImprestHeader.MODIFY;
        MESSAGE('Budgetary Checking Completed Successfully');

    end;


    procedure ReverseEntries(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20])
    var
        Commitments: Record "FIN-Committment";
        EntryNo: Integer;
        CommittedLines: Record "FIN-Committment";
    begin
        //Get Commitment Lines
        Commitments.RESET;
        IF Commitments.FIND('+') THEN
            EntryNo := Commitments."Line No.";

        CommittedLines.RESET;
        CommittedLines.SETRANGE(CommittedLines."Document Type", DocumentType);
        CommittedLines.SETRANGE(CommittedLines."Document No.", DocNo);
        CommittedLines.SETRANGE(CommittedLines.Committed, TRUE);
        IF CommittedLines.FIND('-') THEN BEGIN
            REPEAT
                Commitments.RESET;
                Commitments.INIT;
                EntryNo += 1;
                Commitments."Line No." := EntryNo;
                Commitments.Date := TODAY;
                Commitments."Posting Date" := CommittedLines."Posting Date";
                Commitments."Document Type" := CommittedLines."Document Type";
                Commitments."Document No." := CommittedLines."Document No.";
                Commitments.Amount := -CommittedLines.Amount;
                //Before Posting the Amount Check the Amount being passed From LPO as Qty Received
                IF DocumentType = DocumentType::LPO THEN BEGIN
                    Commitments.Amount := -GetLineAmountToReverse(DocumentType, DocNo, CommittedLines."Document Line No.");
                END ELSE BEGIN
                    Commitments.Amount := -CommittedLines.Amount;
                END;
                //END CHECK AMOUNT BEING POSTED FOR LPO

                Commitments."Month Budget" := CommittedLines."Month Budget";
                Commitments."Month Actual" := CommittedLines."Month Actual";
                Commitments.Committed := FALSE;
                Commitments."Committed By" := USERID;
                Commitments."Committed Date" := CommittedLines."Committed Date";
                Commitments."G/L Account No." := CommittedLines."G/L Account No.";
                Commitments."Committed Time" := TIME;
                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                Commitments."Shortcut Dimension 1 Code" := CommittedLines."Shortcut Dimension 1 Code";
                Commitments."Shortcut Dimension 2 Code" := CommittedLines."Shortcut Dimension 2 Code";
                Commitments."Shortcut Dimension 3 Code" := CommittedLines."Shortcut Dimension 3 Code";
                Commitments."Shortcut Dimension 4 Code" := CommittedLines."Shortcut Dimension 4 Code";
                Commitments.Budget := CommittedLines.Budget;
                Commitments."Document Line No." := CommittedLines."Document Line No.";
                Commitments."Budget Check Criteria" := CommittedLines."Budget Check Criteria";
                Commitments."Actual Source" := CommittedLines."Actual Source";
                Commitments.INSERT;

            UNTIL CommittedLines.NEXT = 0;
        END;
    end;


    procedure CheckFundsAvailability(Payments: Record "FIN-Payments Header")
    var
        BankAcc: Record "Bank Account";
        "Current Source A/C Bal.": Decimal;
    begin
        //get the source account balance from the database table
        BankAcc.RESET;
        BankAcc.SETRANGE(BankAcc."No.", Payments."Paying Bank Account");
        BankAcc.SETRANGE(BankAcc."Bank Type", BankAcc."Bank Type"::Cash);
        IF BankAcc.FINDFIRST THEN BEGIN
            BankAcc.CALCFIELDS(BankAcc.Balance);
            "Current Source A/C Bal." := BankAcc.Balance;
            IF ("Current Source A/C Bal." - Payments."Total Net Amount") < 0 THEN BEGIN
                ERROR('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2', BankAcc."No.",
                BankAcc.Name);
            END;
        END;
    end;

    procedure UpdateAnalysisView()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        BudgetaryControl: Record "FIN-Budgetary Control Setup";
        AnalysisView: Record "Analysis View";
    begin
        //Update Budget Lines
        IF BudgetaryControl.GET THEN BEGIN
            IF BudgetaryControl."Actual Source" = BudgetaryControl."Actual Source"::"Analysis View Entry" THEN BEGIN
                IF BudgetaryControl."Analysis View Code" = '' THEN
                    ERROR('The Analysis view code can not be blank in the budgetary control setup');
            END;
            IF BudgetaryControl."Analysis View Code" <> '' THEN BEGIN
                AnalysisView.RESET;
                AnalysisView.SETRANGE(AnalysisView.Code, BudgetaryControl."Analysis View Code");
                // IF AnalysisView.FIND('-') THEN
                //   UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
            END;
        END;
    end;

    procedure UpdateDim(DimCode: Code[20]; DimValueCode: Code[20])
    begin
        /*IF DimCode = '' THEN
          EXIT;
        WITH GLBudgetDim DO BEGIN
          IF GET(Rec."Entry No.",DimCode) THEN
            DELETE;
          IF DimValueCode <> '' THEN BEGIN
            INIT;
            "Entry No." := Rec."Entry No.";
            "Dimension Code" := DimCode;
            "Dimension Value Code" := DimValueCode;
            INSERT;
          END;
        END; */

    end;


    procedure CheckIfBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        GLBudgetName.GET(BudgetName);
        GLBudgetName.TESTFIELD(Blocked, FALSE);
    end;

    procedure CheckStaffClaim(var ImprestHeader: Record "FIN-Staff Claims Header")
    var
        PayLine: Record "FIN-Staff Claim Lines";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (ImprestHeader.Date > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No, ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
            IF PayLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(ImprestHeader.Date, 2), DATE2DMY(ImprestHeader.Date, 3));
                    CurrMonth := DATE2DMY(ImprestHeader.Date, 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(ImprestHeader.Date, 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ImprestHeader.Date, 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;
                    //If Budget is annual then change the Last day
                    IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";

                    //check the summation of the budget in the database
                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETCURRENTKEY(Budget."Budget Name", Budget."Posting Date", Budget."G/L Account No.",
                    Budget."Dimension 1 Value Code", Budget."Dimension 2 Value Code", Budget."Dimension 3 Value Code",
                    Budget."Dimension 4 Value Code");
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETRANGE(Budget."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                    Budget.SETRANGE(Budget."Dimension 1 Value Code", PayLine."Global Dimension 1 Code");
                    Budget.SETRANGE(Budget."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                    Budget.SETRANGE(Budget."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                    Budget.SETRANGE(Budget."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                    Budget.CALCSUMS(Budget.Amount);
                    BudgetAmount := Budget.Amount;

                    //get the summation on the actuals
                    //Separate Analysis View and G/L Entry
                    IF BCSetup."Actual Source" = BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                        ActualsAmount := 0;
                        Actuals.RESET;
                        Actuals.SETCURRENTKEY(Actuals."Analysis View Code", Actuals."Dimension 1 Value Code",
                        Actuals."Dimension 2 Value Code", Actuals."Dimension 3 Value Code", Actuals."Dimension 4 Value Code",
                        Actuals."Posting Date", Actuals."Account No.");
                        Actuals.SETRANGE(Actuals."Analysis View Code", BCSetup."Analysis View Code");
                        Actuals.SETRANGE(Actuals."Dimension 1 Value Code", PayLine."Global Dimension 1 Code");
                        Actuals.SETRANGE(Actuals."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                        Actuals.SETRANGE(Actuals."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                        Actuals.SETRANGE(Actuals."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                        Actuals.SETRANGE(Actuals."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                        Actuals.SETRANGE(Actuals."Account No.", BudgetGL);
                        Actuals.CALCSUMS(Actuals.Amount);
                        ActualsAmount := Actuals.Amount;
                    END ELSE BEGIN
                        GLAccount.RESET;
                        GLAccount.SETRANGE(GLAccount."No.", BudgetGL);
                        GLAccount.SETRANGE(GLAccount."Date Filter", BCSetup."Current Budget Start Date", LastDay);
                        IF PayLine."Global Dimension 1 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter", PayLine."Global Dimension 1 Code");
                        IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        IF GLAccount.FIND('-') THEN BEGIN
                            GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                            ActualsAmount := GLAccount."Net Change";
                        END;
                    END;
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;

                    //check if there is any budget
                    IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END ELSE BEGIN
                        IF (BudgetAmount <= 0) THEN BEGIN
                            IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Imprest', PayLine.No,
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    END ELSE BEGIN
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) THEN BEGIN
                            IF NOT CONFIRM(Text0001 +
                            FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."Document Type"::StaffClaim;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine."Amount LCY";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        Commitments."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                        Commitments."Actual Source" := BCSetup."Actual Source";
                        Commitments.INSERT;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := TRUE;
                        PayLine.MODIFY;
                        //End Tagging Imprest Lines as Committed
                    END;

                UNTIL PayLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;
        MESSAGE('Budgetary Checking Completed Successfully');
    end;


    procedure CheckStaffAdvance(var ImprestHeader: Record "FIN-Staff Advance Header")
    var
        PayLine: Record "FIN-Staff Advance Lines";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader.Date < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (ImprestHeader.Date > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader.Date,
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No, ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
            IF PayLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(ImprestHeader.Date, 2), DATE2DMY(ImprestHeader.Date, 3));
                    CurrMonth := DATE2DMY(ImprestHeader.Date, 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(ImprestHeader.Date, 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ImprestHeader.Date, 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;

                    //If Budget is annual then change the Last day
                    IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";

                    //check the summation of the budget in the database
                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETCURRENTKEY(Budget."Budget Name", Budget."Posting Date", Budget."G/L Account No.",
                    Budget."Dimension 1 Value Code", Budget."Dimension 2 Value Code", Budget."Dimension 3 Value Code",
                    Budget."Dimension 4 Value Code");
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETRANGE(Budget."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                    Budget.SETRANGE(Budget."Dimension 1 Value Code", PayLine."Global Dimension 1 Code");
                    Budget.SETRANGE(Budget."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                    Budget.SETRANGE(Budget."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                    Budget.SETRANGE(Budget."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                    Budget.CALCSUMS(Budget.Amount);
                    BudgetAmount := Budget.Amount;

                    //get the summation on the actuals
                    //Separate Analysis View and G/L Entry
                    IF BCSetup."Actual Source" = BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                        ActualsAmount := 0;
                        Actuals.RESET;
                        Actuals.SETCURRENTKEY(Actuals."Analysis View Code", Actuals."Dimension 1 Value Code",
                        Actuals."Dimension 2 Value Code", Actuals."Dimension 3 Value Code", Actuals."Dimension 4 Value Code",
                        Actuals."Posting Date", Actuals."Account No.");
                        Actuals.SETRANGE(Actuals."Analysis View Code", BCSetup."Analysis View Code");
                        Actuals.SETRANGE(Actuals."Dimension 1 Value Code", PayLine."Global Dimension 1 Code");
                        Actuals.SETRANGE(Actuals."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                        Actuals.SETRANGE(Actuals."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                        Actuals.SETRANGE(Actuals."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                        Actuals.SETRANGE(Actuals."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                        Actuals.SETRANGE(Actuals."Account No.", BudgetGL);
                        Actuals.CALCSUMS(Actuals.Amount);
                        ActualsAmount := Actuals.Amount;
                    END ELSE BEGIN
                        GLAccount.RESET;
                        GLAccount.SETRANGE(GLAccount."No.", BudgetGL);
                        GLAccount.SETRANGE(GLAccount."Date Filter", BCSetup."Current Budget Start Date", LastDay);
                        IF PayLine."Global Dimension 1 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter", PayLine."Global Dimension 1 Code");
                        IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        IF GLAccount.FIND('-') THEN BEGIN
                            GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                            ActualsAmount := GLAccount."Net Change";
                        END;
                    END;
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PayLine."Global Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;

                    //check if there is any budget
                    IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END ELSE BEGIN
                        IF (BudgetAmount <= 0) THEN BEGIN
                            IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine.No, 'Staff Imprest', PayLine.No,
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    END ELSE BEGIN
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) THEN BEGIN
                            IF NOT CONFIRM(Text0001 +
                            FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := ImprestHeader.Date;
                        Commitments."Document Type" := Commitments."Document Type"::StaffAdvance;
                        Commitments."Document No." := ImprestHeader."No.";
                        Commitments.Amount := PayLine."Amount LCY";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := ImprestHeader.Date;
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        Commitments."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                        Commitments."Actual Source" := BCSetup."Actual Source";
                        Commitments.INSERT;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := TRUE;
                        PayLine.MODIFY;
                        //End Tagging Imprest Lines as Committed
                    END;

                UNTIL PayLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;
        MESSAGE('Budgetary Checking Completed Successfully');
    end;


    procedure CheckStaffAdvSurr(var ImprestHeader: Record "FIN-Staff Advance Surr. Header")
    var
        PayLine: Record "FIN-Staff Advanc Surr. Details";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ImprestHeader."Surrender Date" < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader."Surrender Date",
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (ImprestHeader."Surrender Date" > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3', ImprestHeader."Surrender Date",
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine."Surrender Doc No.", ImprestHeader.No);
            PayLine.SETRANGE(PayLine."Budgetary Control A/C", TRUE);
            IF PayLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(ImprestHeader."Surrender Date", 2), DATE2DMY(ImprestHeader."Surrender Date", 3));
                    CurrMonth := DATE2DMY(ImprestHeader."Surrender Date", 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(ImprestHeader."Surrender Date", 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ImprestHeader."Surrender Date", 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;

                    //If Budget is annual then change the Last day
                    IF BCSetup."Budget Check Criteria" = BCSetup."Budget Check Criteria"::"Whole Year" THEN
                        LastDay := BCSetup."Current Budget End Date";

                    //The GL Account
                    BudgetGL := PayLine."Account No:";

                    //check the summation of the budget in the database
                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETCURRENTKEY(Budget."Budget Name", Budget."Posting Date", Budget."G/L Account No.",
                    Budget."Dimension 1 Value Code", Budget."Dimension 2 Value Code", Budget."Dimension 3 Value Code",
                    Budget."Dimension 4 Value Code");
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETRANGE(Budget."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                    Budget.SETRANGE(Budget."Dimension 1 Value Code", PayLine."Shortcut Dimension 1 Code");
                    Budget.SETRANGE(Budget."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                    Budget.SETRANGE(Budget."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                    Budget.SETRANGE(Budget."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                    Budget.CALCSUMS(Budget.Amount);
                    BudgetAmount := Budget.Amount;

                    //get the summation on the actuals
                    //Separate Analysis View and G/L Entry
                    IF BCSetup."Actual Source" = BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                        ActualsAmount := 0;
                        Actuals.RESET;
                        Actuals.SETCURRENTKEY(Actuals."Analysis View Code", Actuals."Dimension 1 Value Code",
                        Actuals."Dimension 2 Value Code", Actuals."Dimension 3 Value Code", Actuals."Dimension 4 Value Code",
                        Actuals."Posting Date", Actuals."Account No.");
                        Actuals.SETRANGE(Actuals."Analysis View Code", BCSetup."Analysis View Code");
                        Actuals.SETRANGE(Actuals."Dimension 1 Value Code", PayLine."Shortcut Dimension 1 Code");
                        Actuals.SETRANGE(Actuals."Dimension 2 Value Code", PayLine."Shortcut Dimension 2 Code");
                        Actuals.SETRANGE(Actuals."Dimension 3 Value Code", PayLine."Shortcut Dimension 3 Code");
                        Actuals.SETRANGE(Actuals."Dimension 4 Value Code", PayLine."Shortcut Dimension 4 Code");
                        Actuals.SETRANGE(Actuals."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                        Actuals.SETRANGE(Actuals."Account No.", BudgetGL);
                        Actuals.CALCSUMS(Actuals.Amount);
                        ActualsAmount := Actuals.Amount;
                    END ELSE BEGIN
                        GLAccount.RESET;
                        GLAccount.SETRANGE(GLAccount."No.", BudgetGL);
                        GLAccount.SETRANGE(GLAccount."Date Filter", BCSetup."Current Budget Start Date", LastDay);
                        IF PayLine."Shortcut Dimension 1 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter", PayLine."Shortcut Dimension 1 Code");
                        IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                            GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter", PayLine."Shortcut Dimension 2 Code");
                        IF GLAccount.FIND('-') THEN BEGIN
                            GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                            ActualsAmount := GLAccount."Net Change";
                        END;
                    END;

                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PayLine."Shortcut Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PayLine."Shortcut Dimension 2 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", PayLine."Shortcut Dimension 3 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", PayLine."Shortcut Dimension 4 Code");
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;

                    //check if there is any budget
                    IF (BudgetAmount <= 0) AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END ELSE BEGIN
                        IF (BudgetAmount <= 0) THEN BEGIN
                            IF NOT CONFIRM(Text0003, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount)
                    AND NOT (BCSetup."Allow OverExpenditure") THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        PayLine."Surrender Doc No.", 'Staff Imprest', PayLine."Surrender Doc No.",
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + PayLine."Amount LCY"))));
                    END ELSE BEGIN
                        //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                        IF ((CommitmentAmount + PayLine."Amount LCY" + ActualsAmount) > BudgetAmount) THEN BEGIN
                            IF NOT CONFIRM(Text0001 +
                            FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PayLine."Amount LCY")))
                            + Text0002, TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                            END;
                        END;

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := ImprestHeader."Surrender Date";
                        Commitments."Document Type" := Commitments."Document Type"::StaffSurrender;
                        Commitments."Document No." := ImprestHeader.No;
                        Commitments.Amount := PayLine."Amount LCY";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := ImprestHeader."Surrender Date";
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := PayLine."Shortcut Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        Commitments."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := ImprestHeader."Account Type";
                        Commitments."Vendor/Cust No." := ImprestHeader."Account No.";
                        Commitments."Budget Check Criteria" := BCSetup."Budget Check Criteria";
                        Commitments."Actual Source" := BCSetup."Actual Source";
                        Commitments.INSERT;
                        //Tag the Imprest Line as Committed
                        PayLine.Committed := TRUE;
                        PayLine.MODIFY;
                        //End Tagging Imprest Lines as Committed
                    END;

                UNTIL PayLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;
        MESSAGE('Budgetary Checking Completed Successfully');
    end;


    procedure CheckGrantSurr()
    var
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        /*
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (GrantHeader."Grant Surrender Doc. Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Grant Does Not Fall Within Budget Dates %2 - %3',GrantHeader."Grant Surrender Doc. Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (GrantHeader."Grant Surrender Doc. Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Grant Does Not Fall Within Budget Dates %2 - %3',GrantHeader."Grant Surrender Doc. Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              GrantLine.RESET;
              GrantLine.SETRANGE(GrantLine."Surrender Doc No.",GrantHeader.No);
              GrantLine.SETRANGE(GrantLine."Budgetary Control A/C",TRUE);
              IF GrantLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",2),DATE2DMY(GrantHeader.
                               "Grant Surrender Doc. Date",3));
        
                               CurrMonth:=DATE2DMY(GrantHeader."Grant Surrender Doc. Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //If Budget is annual then change the Last day
                               IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               //The GL Account
                                BudgetGL:=GrantLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",GrantLine."Shortcut Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",GrantLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",GrantLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",GrantLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",GrantLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",GrantLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",GrantLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",GrantLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF GrantLine."Shortcut Dimension 1 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",GrantLine."Shortcut Dimension 1 Code");
                                IF GrantLine."Shortcut Dimension 2 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",GrantLine."Shortcut Dimension 2 Code");
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",GrantLine."Shortcut Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",GrantLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",GrantLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",GrantLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + GrantLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              GrantLine."Surrender Doc No.",'Grant' ,GrantLine."Surrender Doc No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + GrantLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + GrantLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+GrantLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=GrantHeader."Grant Surrender Doc. Date";
                                Commitments."Document Type":=Commitments."Document Type"::StaffSurrender;
                                Commitments."Document No.":=GrantHeader.No;
                                Commitments.Amount:=GrantLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=GrantHeader."Grant Surrender Doc. Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
                               // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=GrantLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=GrantLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=GrantLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=GrantLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=GrantHeader."Account Type";
                                Commitments."Vendor/Cust No.":=GrantHeader."Grant Partner Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.INSERT;
                                //Tag the Grant Surrender Line as Committed
                                  GrantLine.Committed:=TRUE;
                                  GrantLine.MODIFY;
                                //End Tagging Grant Surrender Lines as Committed
                            END;
        
                  UNTIL GrantLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        */

    end;


    procedure CheckGrantsBudget()
    var
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        /*
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PaymentHeader."Starting Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Grant Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Starting Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PaymentHeader."Starting Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In TheGrant Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Starting Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine."Grant No.",PaymentHeader."No.");
              PayLine.SETRANGE(PayLine.Type,PayLine.Type::"2");
              PayLine.SETRANGE(PayLine."Budget Controlled",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //Get Dimensions from Job Tasks
                               DimCode1:=''; DimCode2:='';
                               JobTaskLine.RESET;
                               JobTaskLine.SETRANGE(JobTaskLine."Grant No.",PayLine."Grant No.");
                               JobTaskLine.SETRANGE(JobTaskLine."Grant Task No.",PayLine."Grant Task No.");
                               IF JobTaskLine.FIND('-') THEN BEGIN
                                 DimCode1:=JobTaskLine."Global Dimension 1 Code"; DimCode2:=JobTaskLine."Global Dimension 2 Code";
                               END;
                               //End;
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(PaymentHeader."Starting Date",2),DATE2DMY(PaymentHeader."Starting Date",3));
                               CurrMonth:=DATE2DMY(PaymentHeader."Starting Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(PaymentHeader."Starting Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PaymentHeader."Starting Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //If Budget is annual then change the Last day
                               IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               BudgetGL:=PayLine."No.";
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",DimCode1);
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",DimCode2);
                               //Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               //Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",DimCode1);
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",DimCode2);
                            //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF DimCode1 <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",DimCode1);
                                IF DimCode2 <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",DimCode2);
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",DimCode1);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",DimCode2);
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Total Cost (LCY)"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount in Grant No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine."Grant No.",PayLine.Type ,PayLine."No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Total Cost (LCY)"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Total Cost (LCY)"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Total Cost (LCY)")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                //Tag the Payment Line as Committed
                                  PayLine."Budget Availability Checked":=TRUE;
                                  PayLine."Budget Available":=BudgetAmount-(CommitmentAmount + ActualsAmount);
                                  PayLine.MODIFY;
        
        
                                //End Tagging Payment Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        */

    end;


    procedure GetLineAmountToReverse(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender; DocNo: Code[20]; DocLineNo: Integer) TotalAmount: Decimal
    var
        LPO: Record "Purchase Line";
        QtyToInvoice: Decimal;
    begin
        IF DocumentType = DocumentType::LPO THEN BEGIN
            LPO.RESET;
            LPO.SETRANGE(LPO."Document Type", LPO."Document Type"::Order);
            LPO.SETRANGE(LPO."Document No.", DocNo);
            LPO.SETRANGE(LPO."Line No.", DocLineNo);
            IF LPO.FIND('-') THEN BEGIN
                //Take care of reversal which might not
                IF LPO."Qty. to Invoice" <> 0 THEN
                    QtyToInvoice := LPO."Qty. to Invoice"
                ELSE
                    QtyToInvoice := LPO."Outstanding Quantity";

                IF LPO."VAT %" = 0 THEN
                    TotalAmount := QtyToInvoice * LPO."Direct Unit Cost"
                ELSE
                    TotalAmount := (QtyToInvoice * LPO."Direct Unit Cost") * ((LPO."VAT %" + 100) / 100)

            END;
        END;
    end;


    procedure ReverseOrderEntriesFromInvoice(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance; DocNo: Code[20]; LineNo: Integer; Amount: Decimal)
    var
        Commitments: Record "FIN-Committment";
        EntryNo: Integer;
        CommittedLines: Record "FIN-Committment";
    begin
        //Get Commitment Lines
        Commitments.RESET;
        IF Commitments.FIND('+') THEN
            EntryNo := Commitments."Line No.";

        CommittedLines.RESET;
        CommittedLines.SETRANGE(CommittedLines."Document Type", DocumentType);
        CommittedLines.SETRANGE(CommittedLines."Document No.", DocNo);
        CommittedLines.SETRANGE(CommittedLines."Document Line No.", LineNo);
        CommittedLines.SETRANGE(CommittedLines.Committed, TRUE);
        IF CommittedLines.FIND('-') THEN BEGIN
            REPEAT
                Commitments.RESET;
                Commitments.INIT;
                EntryNo += 1;
                Commitments."Line No." := EntryNo;
                Commitments.Date := TODAY;
                Commitments."Posting Date" := CommittedLines."Posting Date";
                Commitments."Document Type" := CommittedLines."Document Type";
                Commitments."Document No." := CommittedLines."Document No.";
                Commitments.Amount := -Amount;
                Commitments."Month Budget" := CommittedLines."Month Budget";
                Commitments."Month Actual" := CommittedLines."Month Actual";
                Commitments.Committed := FALSE;
                Commitments."Committed By" := USERID;
                Commitments."Committed Date" := CommittedLines."Committed Date";
                Commitments."G/L Account No." := CommittedLines."G/L Account No.";
                Commitments."Committed Time" := TIME;
                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                Commitments."Shortcut Dimension 1 Code" := CommittedLines."Shortcut Dimension 1 Code";
                Commitments."Shortcut Dimension 2 Code" := CommittedLines."Shortcut Dimension 2 Code";
                Commitments."Shortcut Dimension 3 Code" := CommittedLines."Shortcut Dimension 3 Code";
                Commitments."Shortcut Dimension 4 Code" := CommittedLines."Shortcut Dimension 4 Code";
                Commitments.Budget := CommittedLines.Budget;
                Commitments."Document Line No." := CommittedLines."Document Line No.";
                Commitments."Budget Check Criteria" := CommittedLines."Budget Check Criteria";
                Commitments."Actual Source" := CommittedLines."Actual Source";
                Commitments.INSERT;

            UNTIL CommittedLines.NEXT = 0;
        END;
    end;


    procedure ReverseOrdersReversal("No.": Code[20])
    var
        PurchLines: Record "Purchase Line";
        DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance;
        PurchRecptLines: Record "Purch. Rcpt. Line";
        DeleteCommitment: Record "FIN-Committment";
    begin
        PurchLines.RESET;
        PurchLines.SETRANGE(PurchLines."Document Type", PurchLines."Document Type"::Invoice);
        PurchLines.SETRANGE(PurchLines."Document No.", "No.");
        IF PurchLines.FIND('-') THEN BEGIN
            REPEAT
                IF PurchLines.Type <> PurchLines.Type::" " THEN BEGIN
                    //Get Details of Order from Receipt lines
                    PurchRecptLines.RESET;
                    PurchRecptLines.SETRANGE(PurchRecptLines."Document No.", PurchLines."Receipt No.");
                    PurchRecptLines.SETRANGE(PurchRecptLines."Line No.", PurchLines."Receipt Line No.");
                    IF PurchRecptLines.FIND('-') THEN BEGIN
                        DeleteCommitment.RESET;
                        DeleteCommitment.SETRANGE(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::LPO);
                        DeleteCommitment.SETRANGE(DeleteCommitment."Document No.", PurchRecptLines."Order No.");
                        DeleteCommitment.SETRANGE(DeleteCommitment."Document Line No.", PurchRecptLines."Order Line No.");
                        DeleteCommitment.SETRANGE(DeleteCommitment.Committed, FALSE);
                        DeleteCommitment.DELETEALL;

                    END;
                END;
            UNTIL PurchLines.NEXT = 0;
        END;
    end;


    procedure CheckPurchaseGlobal(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        "G/L Entry": Record "G/L Entry";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            /* Commented to allow commitment to prev. budget
            IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
              */
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            PurchLine.RESET;
            PurchLine.SETRANGE(PurchLine."Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE(PurchLine."Document No.", PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN BEGIN
                REPEAT

                    //Get the Dimension Here
                    IF PurchLine."Line No." <> 0 THEN
                        //DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(
                        //  DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                        //  PurchLine."Line No.",ShortcutDimCode)
                        //ELSE
                        //                DimMgt.ClearDimSetFilter(ShortcutDimCode);
                        //Had to be put here for the sake of Calculating Individual Line Entries

                        //check the type of account in the payments line
                        //Item
                        IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                            Item.RESET;
                            IF NOT Item.GET(PurchLine."No.") THEN
                                ERROR('Item Does not Exist');

                            Item.TESTFIELD("Item G/L Budget Account");
                            BudgetGL := Item."Item G/L Budget Account";
                        END;
                    //  MESSAGE('FOUND');
                    IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
                        FixedAssetsDet.RESET;
                        FixedAssetsDet.SETRANGE(FixedAssetsDet."No.", PurchLine."No.");
                        IF FixedAssetsDet.FIND('-') THEN BEGIN
                            FAPostingGRP.RESET;
                            FAPostingGRP.SETRANGE(FAPostingGRP.Code, FixedAssetsDet."FA Posting Group");
                            IF FAPostingGRP.FIND('-') THEN
                                IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Maintenance THEN BEGIN
                                    BudgetGL := FAPostingGRP."Maintenance Expense Account";
                                    IF BudgetGL = '' THEN
                                        ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account', PurchLine."No.");
                                END ELSE BEGIN
                                    BudgetGL := FAPostingGRP."Acquisition Cost Account";
                                    IF BudgetGL = '' THEN
                                        ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account', PurchLine."No.");
                                END;
                        END;
                    END;

                    IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
                        BudgetGL := PurchLine."No.";
                        // IF GLAcc.GET(PurchLine."No.") THEN
                        //GLAcc.TESTFIELD("Vote Book Entry",TRUE);
                    END;

                    //End Checking Account in Payment Line

                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(PurchHeader."Document Date", 2), DATE2DMY(PurchHeader."Document Date", 3));
                    CurrMonth := DATE2DMY(PurchHeader."Document Date", 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(PurchHeader."Document Date", 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(PurchHeader."Document Date", 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;
                    //check the summation of the budget in the database

                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETFILTER(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                    Budget.SETRANGE(Budget."Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                    IF PurchHeader."Purchase Type" <> PurchHeader."Purchase Type"::Global THEN
                        Budget.SETRANGE(Budget."Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                    // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                    //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                    IF Budget.FIND('-') THEN BEGIN
                        REPEAT
                            BudgetAmount := BudgetAmount + Budget.Amount;
                        UNTIL Budget.NEXT = 0;
                    END;
                    //get the summation on the actuals
                    ActualsAmount := 0;
                    "G/L Entry".RESET;
                    "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.", BudgetGL);
                    "G/L Entry".SETRANGE("G/L Entry"."Posting Date", BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                    IF PurchHeader."Purchase Type" <> PurchHeader."Purchase Type"::Global THEN
                        "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                    IF "G/L Entry".FIND('-') THEN BEGIN
                        REPEAT
                            ActualsAmount := ActualsAmount + "G/L Entry".Amount;
                        UNTIL "G/L Entry".NEXT = 0;
                    END;
                    /*
                    BudgetAmount:=0;
                    Budget.RESET;
                    Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                    Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                    Budget."Dimension 4 Value Code");
                    Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                    Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                    Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                   // Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                    //Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                  //  Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                  //  Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                        Budget.CALCSUMS(Budget.Amount);
                        BudgetAmount:= Budget.Amount;
                      //  MESSAGE(FORMAT(Budget.Amount));

               //get the summation on the actuals
                 ActualsAmount:=0;
                 Actuals.RESET;
                 Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                 Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                 Actuals."Posting Date",Actuals."Account No.");
                 Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                 //Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                // Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                 //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                 //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                 Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                 Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                    Actuals.CALCSUMS(Actuals.Amount);
                    ActualsAmount:= Actuals.Amount;
                  */
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    // Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                    //Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                    //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                    //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;
                    //check if there is any budget
                    IF (BudgetAmount <= 0) THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF (CommitmentAmount + PurchLine."Outstanding Amount (LCY)") > BudgetAmount THEN BEGIN
                        //                     IF PurchHeader."Cum. Discount"=FALSE THEN
                        //                      ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                        //                      PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                        //                        FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                    END ELSE BEGIN
                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := PurchHeader."Posting Date";
                        Commitments."Posting Date" := PurchHeader."Document Date";
                        IF PurchHeader.DocApprovalType = PurchHeader.DocApprovalType::Purchase THEN
                            Commitments."Document Type" := Commitments."Document Type"::LPO
                        ELSE
                            Commitments."Document Type" := Commitments."Document Type"::LPO;

                        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                            Commitments."Document Type" := Commitments."Document Type"::PettyCash;

                        Commitments."Document No." := PurchHeader."No.";
                        Commitments.Amount := PurchLine."Outstanding Amount (LCY)";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := PurchHeader."Document Date";
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        // Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                        // Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                        // Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                        //Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                        Commitments.Budget := BCSetup."Current Budget Code";
                        Commitments.Type := Commitments.Type::Vendor;
                        Commitments."Vendor/Cust No." := PurchHeader."Buy-from Vendor No.";
                        Commitments.INSERT;
                        //Tag the Purchase Line as Committed
                        PurchLine.Committed := TRUE;
                        PurchLine.MODIFY;
                        //End Tagging PurchLines as Committed
                    END;

                UNTIL PurchLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;

        PurchHeader.RESET;
        PurchHeader.SETRANGE(PurchHeader."No.", PurchLine."Document No.");
        IF PurchHeader.FIND('-') THEN BEGIN
            PurchHeader."Budgeted Amount" := BudgetAmount;
            PurchHeader."Actual Expenditure" := ActualsAmount;
            PurchHeader."Committed Amount" := CommitmentAmount;
            PurchHeader."Budget Balance" := BudgetAmount - (ActualsAmount + CommitmentAmount + PurchHeader.Amount);
            PurchHeader.MODIFY;
        END;

    end;


    procedure CheckSRN(var ReqHeader: Record "PROC-Store Requistion Header")
    var
        SRNLine: Record "PROC-Store Requistion Lines";
        Commitments: Record "FIN-Committment";
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        "G/L Entry": Record "G/L Entry";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (ReqHeader."Request date" < BCSetup."Current Budget Start Date") THEN BEGIN
                ERROR('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3', ReqHeader."Request date",
                BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
            END
            ELSE
                IF (ReqHeader."Request date" > BCSetup."Current Budget End Date") THEN BEGIN
                    ERROR('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3', ReqHeader."Request date",
                    BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

                END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
            IF Commitments.FIND('+') THEN
                EntryNo := Commitments."Line No.";

            //get the lines related to the payment header
            SRNLine.RESET;
            SRNLine.SETRANGE(SRNLine."Requistion No", ReqHeader."No.");
            // SRNLine.SETRANGE(SRNLine."Budgetary Control A/C",TRUE);
            IF SRNLine.FINDFIRST THEN BEGIN
                REPEAT
                    //check the votebook now
                    FirstDay := DMY2DATE(1, DATE2DMY(ReqHeader."Request date", 2), DATE2DMY(ReqHeader."Request date", 3));
                    CurrMonth := DATE2DMY(ReqHeader."Request date", 2);
                    IF CurrMonth = 12 THEN BEGIN
                        LastDay := DMY2DATE(1, 1, DATE2DMY(ReqHeader."Request date", 3) + 1);
                        LastDay := CALCDATE('-1D', LastDay);
                    END
                    ELSE BEGIN
                        CurrMonth := CurrMonth + 1;
                        LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ReqHeader."Request date", 3));
                        LastDay := CALCDATE('-1D', LastDay);
                    END;

                    //The GL Account
                    //  if SRNLine.Type=SRNLine.Type::item then
                    IF Item.GET(SRNLine."No.") THEN BEGIN
                        Item.TESTFIELD(Item."Item G/L Budget Account");
                        BudgetGL := Item."Item G/L Budget Account";
                    END;

                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETFILTER(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                    //  Budget.SETRANGE(Budget."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                    Budget.SETRANGE(Budget."Global Dimension 2 Code", SRNLine."Shortcut Dimension 2 Code");
                    // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                    //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                    IF Budget.FIND('-') THEN BEGIN
                        REPEAT
                            BudgetAmount := BudgetAmount + Budget.Amount;
                        UNTIL Budget.NEXT = 0;
                    END;
                    //  error(format(Budgetamount));
                    //get the summation on the actuals
                    ActualsAmount := 0;
                    "G/L Entry".RESET;
                    "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.", BudgetGL);
                    "G/L Entry".SETRANGE("G/L Entry"."Posting Date", BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    // "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                    "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 2 Code", SRNLine."Shortcut Dimension 2 Code");
                    IF "G/L Entry".FIND('-') THEN BEGIN
                        REPEAT
                            ActualsAmount := ActualsAmount + "G/L Entry".Amount;
                        UNTIL "G/L Entry".NEXT = 0;
                    END;
                    /*
                     //check the summation of the budget in the database
                     BudgetAmount:=0;
                     Budget.RESET;
                     Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                     Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                     Budget."Dimension 4 Value Code");
                     Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                     Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                     Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                   //  Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                     Budget.SETRANGE(Budget."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                   //  Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                  //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                         Budget.CALCSUMS(Budget.Amount);
                         BudgetAmount:= Budget.Amount;

                //get the summation on the actuals
                  ActualsAmount:=0;
                  Actuals.RESET;
                  Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                  Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                  Actuals."Posting Date",Actuals."Account No.");
                  Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                  Actuals.SETRANGE(Actuals."Dimension 1 Value Code",SRNLine."Shortcut Dimension 1 Code");
                  Actuals.SETRANGE(Actuals."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                 // Actuals.SETRANGE(Actuals."Dimension 3 Value Code",SRNLine."Shortcut Dimension 3 Code");
                 // Actuals.SETRANGE(Actuals."Dimension 4 Value Code",SRNLine."Shortcut Dimension 4 Code");
                  Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                  Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                     Actuals.CALCSUMS(Actuals.Amount);
                     ActualsAmount:= Actuals.Amount;
                */
                    //get the committments
                    CommitmentAmount := 0;
                    Commitments.RESET;
                    Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                    Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
                    Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
                    Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                    Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                    Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                    //  Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", SRNLine."Shortcut Dimension 2 Code");
                    // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                    // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;
                    //check if there is any budget
                    IF (BudgetAmount <= 0) THEN BEGIN
                        ERROR('No Budget To Check Against');
                    END;

                    //check if the actuals plus the amount is greater then the budget amount
                    IF (CommitmentAmount + SRNLine."Line Amount") > BudgetAmount THEN BEGIN
                        ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                        SRNLine."Requistion No", 'SRN', SRNLine."No.",
                          FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + SRNLine."Line Amount"))));
                    END ELSE BEGIN

                        Commitments.RESET;
                        Commitments.INIT;
                        EntryNo += 1;
                        Commitments."Line No." := EntryNo;
                        Commitments.Date := TODAY;
                        Commitments."Posting Date" := ReqHeader."Request date";
                        Commitments."Document Type" := Commitments."Document Type"::SRN;
                        Commitments."Document No." := ReqHeader."No.";
                        Commitments.Amount := SRNLine."Line Amount";
                        Commitments."Month Budget" := BudgetAmount;
                        Commitments."Month Actual" := ActualsAmount;
                        Commitments.Committed := TRUE;
                        Commitments."Committed By" := USERID;
                        Commitments."Committed Date" := ReqHeader."Request date";
                        Commitments."G/L Account No." := BudgetGL;
                        Commitments."Committed Time" := TIME;
                        //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                        Commitments."Shortcut Dimension 1 Code" := SRNLine."Shortcut Dimension 1 Code";
                        Commitments."Shortcut Dimension 2 Code" := SRNLine."Shortcut Dimension 2 Code";
                        Commitments."Shortcut Dimension 3 Code" := SRNLine."Shortcut Dimension 3 Code";
                        Commitments."Shortcut Dimension 4 Code" := SRNLine."Shortcut Dimension 4 Code";
                        Commitments.Budget := BCSetup."Current Budget Code";
                        // Commitments.Type:=Commitments.Type::item;
                        Commitments."Vendor/Cust No." := SRNLine."Requistion No";
                        Commitments.INSERT;
                        //Tag the Imprest Line as Committed
                        SRNLine.Committed := TRUE;
                        SRNLine.MODIFY;
                        //End Tagging Imprest Lines as Committed
                    END;

                UNTIL SRNLine.NEXT = 0;
            END;
        END
        ELSE//budget control not mandatory
          BEGIN

        END;
        MESSAGE('Budgetary Checking Completed Successfully');

        ReqHeader.RESET;
        ReqHeader.SETRANGE(ReqHeader."No.", SRNLine."Requistion No");
        IF ReqHeader.FIND('-') THEN BEGIN
            ReqHeader."Budgeted Amount" := BudgetAmount;
            ReqHeader."Actual Expenditure" := ActualsAmount;
            ReqHeader."Committed Amount" := CommitmentAmount;
            ReqHeader.CALCFIELDS(Amount);
            ReqHeader."Budget Balance" := BudgetAmount - (ActualsAmount + CommitmentAmount + ReqHeader.Amount);
            ReqHeader.MODIFY;
        END;

    end;


    // procedure CheckMeal(var ReqHeader: Record "61778")
    // var
    //     Mline: Record "61779";
    //     Commitments: Record "FIN-Committment";
    //     Amount: Decimal;
    //     GLAcc: Record "G/L Account";
    //     Item: Record Item;
    //     FirstDay: Date;
    //     LastDay: Date;
    //     CurrMonth: Integer;
    //     Budget: Record "G/L Budget Entry";
    //     BudgetAmount: Decimal;
    //     Actuals: Record "Analysis View Entry";
    //     ActualsAmount: Decimal;
    //     CommitmentAmount: Decimal;
    //     FixedAssetsDet: Record "Fixed Asset";
    //     FAPostingGRP: Record "FA Posting Group";
    //     EntryNo: Integer;
    //     "G/L Entry": Record "G/L Entry";
    // begin
    //     //First Update Analysis View
    //     UpdateAnalysisView();

    //     //get the budget control setup first to determine if it mandatory or not
    //     BCSetup.RESET;
    //     BCSetup.GET();
    //     IF BCSetup.Mandatory THEN//budgetary control is mandatory
    //       BEGIN
    //         //check if the dates are within the specified range in relation to the payment header table
    //         IF (ReqHeader."Request Date" < BCSetup."Current Budget Start Date") THEN BEGIN
    //             ERROR('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3', ReqHeader."Request Date",
    //             BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
    //         END
    //         ELSE
    //             IF (ReqHeader."Request Date" > BCSetup."Current Budget End Date") THEN BEGIN
    //                 ERROR('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3', ReqHeader."Request Date",
    //                 BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");

    //             END;
    //         //Is budget Available
    //         CheckIfBlocked(BCSetup."Current Budget Code");

    //         //Get Commitment Lines
    //         IF Commitments.FIND('+') THEN
    //             EntryNo := Commitments."Line No.";

    //         //get the lines related to the payment header
    //         Mline.RESET;
    //         Mline.SETRANGE(Mline."Booking Id", ReqHeader."Booking Id");
    //         // SRNLine.SETRANGE(SRNLine."Budgetary Control A/C",TRUE);
    //         IF Mline.FINDFIRST THEN BEGIN
    //             REPEAT
    //                 //check the votebook now
    //                 FirstDay := DMY2DATE(1, DATE2DMY(ReqHeader."Request Date", 2), DATE2DMY(ReqHeader."Request Date", 3));
    //                 CurrMonth := DATE2DMY(ReqHeader."Request Date", 2);
    //                 IF CurrMonth = 12 THEN BEGIN
    //                     LastDay := DMY2DATE(1, 1, DATE2DMY(ReqHeader."Request Date", 3) + 1);
    //                     LastDay := CALCDATE('-1D', LastDay);
    //                 END
    //                 ELSE BEGIN
    //                     CurrMonth := CurrMonth + 1;
    //                     LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(ReqHeader."Request Date", 3));
    //                     LastDay := CALCDATE('-1D', LastDay);
    //                 END;

    //                 //The GL Account
    //                 //  if SRNLine.Type=SRNLine.Type::item then
    //                 IF Item.GET(Mline."Meal Code") THEN BEGIN
    //                     Item.TESTFIELD(Item."Item G/L Budget Account");
    //                     BudgetGL := Item."Item G/L Budget Account";
    //                 END;

    //                 BudgetAmount := 0;
    //                 Budget.RESET;
    //                 Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
    //                 Budget.SETFILTER(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
    //                 Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
    //                 Budget.SETRANGE(Budget."Global Dimension 1 Code", 'MAIN');
    //                 Budget.SETRANGE(Budget."Global Dimension 2 Code", Mline.Department);
    //                 // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
    //                 //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
    //                 IF Budget.FIND('-') THEN BEGIN
    //                     REPEAT
    //                         BudgetAmount := BudgetAmount + Budget.Amount;
    //                     UNTIL Budget.NEXT = 0;
    //                 END;
    //                 //  error(format(Budgetamount));
    //                 //get the summation on the actuals
    //                 ActualsAmount := 0;
    //                 "G/L Entry".RESET;
    //                 "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.", BudgetGL);
    //                 "G/L Entry".SETRANGE("G/L Entry"."Posting Date", BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
    //                 // "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
    //                 "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 2 Code", Mline.Department);
    //                 IF "G/L Entry".FIND('-') THEN BEGIN
    //                     REPEAT
    //                         ActualsAmount := ActualsAmount + "G/L Entry".Amount;
    //                     UNTIL "G/L Entry".NEXT = 0;
    //                 END;
    //                 /*
    //                  //check the summation of the budget in the database
    //                  BudgetAmount:=0;
    //                  Budget.RESET;
    //                  Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
    //                  Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
    //                  Budget."Dimension 4 Value Code");
    //                  Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
    //                  Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
    //                  Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
    //                //  Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
    //                  Budget.SETRANGE(Budget."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
    //                //  Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
    //               //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
    //                      Budget.CALCSUMS(Budget.Amount);
    //                      BudgetAmount:= Budget.Amount;

    //             //get the summation on the actuals
    //               ActualsAmount:=0;
    //               Actuals.RESET;
    //               Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
    //               Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
    //               Actuals."Posting Date",Actuals."Account No.");
    //               Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
    //               Actuals.SETRANGE(Actuals."Dimension 1 Value Code",SRNLine."Shortcut Dimension 1 Code");
    //               Actuals.SETRANGE(Actuals."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
    //              // Actuals.SETRANGE(Actuals."Dimension 3 Value Code",SRNLine."Shortcut Dimension 3 Code");
    //              // Actuals.SETRANGE(Actuals."Dimension 4 Value Code",SRNLine."Shortcut Dimension 4 Code");
    //               Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
    //               Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
    //                  Actuals.CALCSUMS(Actuals.Amount);
    //                  ActualsAmount:= Actuals.Amount;
    //             */
    //                 //get the committments
    //                 CommitmentAmount := 0;
    //                 Commitments.RESET;
    //                 Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
    //                 Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code",
    //                 Commitments."Shortcut Dimension 3 Code", Commitments."Shortcut Dimension 4 Code");
    //                 Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
    //                 Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
    //                 Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
    //                 //  Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",SRNLine."Global Dimension 1 Code");
    //                 Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", Mline.Department);
    //                 // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
    //                 // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
    //                 Commitments.CALCSUMS(Commitments.Amount);
    //                 CommitmentAmount := Commitments.Amount;
    //                 //check if there is any budget
    //                 IF (BudgetAmount <= 0) THEN BEGIN
    //                     ERROR('No Budget To Check Against');
    //                 END;

    //                 //check if the actuals plus the amount is greater then the budget amount
    //                 IF (CommitmentAmount + Mline.Cost) > BudgetAmount THEN BEGIN
    //                     ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
    //                     Mline."Booking Id", 'SRN', Mline."Booking Id",
    //                       FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + Mline.Cost))));
    //                 END ELSE BEGIN

    //                     Commitments.RESET;
    //                     Commitments.INIT;
    //                     EntryNo += 1;
    //                     Commitments."Line No." := EntryNo;
    //                     Commitments.Date := TODAY;
    //                     Commitments."Posting Date" := ReqHeader."Request Date";
    //                     Commitments."Document Type" := Commitments."Document Type"::Meal;
    //                     Commitments."Document No." := ReqHeader."Booking Id";
    //                     Commitments.Amount := Mline.Cost;
    //                     Commitments."Month Budget" := BudgetAmount;
    //                     Commitments."Month Actual" := ActualsAmount;
    //                     Commitments.Committed := TRUE;
    //                     Commitments."Committed By" := USERID;
    //                     Commitments."Committed Date" := ReqHeader."Request Date";
    //                     Commitments."G/L Account No." := BudgetGL;
    //                     Commitments."Committed Time" := TIME;
    //                     //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
    //                     //Commitments."Shortcut Dimension 1 Code":=mline."Shortcut Dimension 1 Code";
    //                     Commitments."Shortcut Dimension 2 Code" := Mline.Department;
    //                     //Commitments."Shortcut Dimension 3 Code":=SRNLine."Shortcut Dimension 3 Code";
    //                     //Commitments."Shortcut Dimension 4 Code":=SRNLine."Shortcut Dimension 4 Code";
    //                     Commitments.Budget := BCSetup."Current Budget Code";
    //                     // Commitments.Type:=Commitments.Type::item;
    //                     Commitments."Vendor/Cust No." := Mline."Booking Id";
    //                     Commitments.INSERT;
    //                     //Tag the Imprest Line as Committed
    //                     Mline.Commited := TRUE;
    //                     Mline.MODIFY;
    //                     //End Tagging Imprest Lines as Committed
    //                 END;

    //             UNTIL Mline.NEXT = 0;
    //         END;
    //     END
    //     ELSE//budget control not mandatory
    //       BEGIN

    //     END;
    //     MESSAGE('Budgetary Checking Completed Successfully');

    //     ReqHeader.RESET;
    //     ReqHeader.SETRANGE(ReqHeader."Booking Id", Mline."Booking Id");
    //     IF ReqHeader.FIND('-') THEN BEGIN
    //         ReqHeader."Budgeted Amount" := BudgetAmount;
    //         ReqHeader."Actual Expenditure" := ActualsAmount;
    //         ReqHeader."Committed Amount" := CommitmentAmount;
    //         //ReqHeader.CALCFIELDS("Total Cost");
    //         ReqHeader."Budget Balance" := BudgetAmount - (ActualsAmount + CommitmentAmount + ReqHeader."Total Cost");
    //         ReqHeader.MODIFY;
    //     END;

    //end;
}