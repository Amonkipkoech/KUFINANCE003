report 52178716 "Trial Balance Detail/Summary2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/TrialBalanceDetailSummary2.rdl';
    Caption = 'Trial Balance Detail/Summary';
    dataset
    {
        dataitem(DataItem6710; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(MainTitle; MainTitle)
            {
            }
            column(TIME; TIME)
            {

            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }

            column(PeriodText; PeriodText)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(GLEntryFilter; GLEntryFilter)
            {
            }
            column(PrintTypeAll; PrintTypeAll)
            {
            }
            column(PrintTypeBalances; PrintTypeBal)
            {
            }
            column(PrintTypeActivities; PrintTypeAct)
            {
            }
            column(PrintType; PrintType)
            {
            }
            column(UseAddRptCurr; UseAddRptCurr)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(IncludeSecondLine; IncludeSecondLine)
            {
            }
            column(OnlyOnePerPage; OnlyOnePerPage)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TABLECAPTION + ': ' + GLFilter)
            {
            }
            column(G_L_Entry__TABLECAPTION__________GLEntryFilter; TABLECAPTION + ': ' + GLEntryFilter)
            {
            }
            column(STRSUBSTNO_Text002__No___; STRSUBSTNO(Text002, "No."))
            {
            }
            column(G_L_Account_Name; Name)
            {
            }
            column(BeginningBalance; BeginningBalance)
            {
            }
            column(AnyEntries; AnyEntries)
            {
            }
            column(BeginBalTotal; BeginBalTotal)
            {
            }
            column(DebitAmount_GLAccount; DebitAmount)
            {
            }
            column(CreditAmount_GLAccount; CreditAmount)
            {
            }
            column(EndBalTotal; EndBalTotal)
            {
            }
            column(G_L_Account_No_; "No.")
            {
                IncludeCaption = true;
            }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Account_Business_Unit_Filter; "Business Unit Filter")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NoBalCaption; NoBalCaptionLbl)
            {
            }
            column(NoActCaption; NoActCaptionLbl)
            {
            }
            column(BalZeroCaption; BalZeroCaptionLbl)
            {
            }
            column(PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaptionLbl)
            {
            }
            column(DebitAmount_Control85Caption; DebitAmount_Control85CaptionLbl)
            {
            }
            column(CreditAmount_Control86Caption; CreditAmount_Control86CaptionLbl)
            {
            }
            column(DebitAmount_Control75Caption; DebitAmount_Control75CaptionLbl)
            {
            }
            column(CreditAmount_Control76Caption; CreditAmount_Control76CaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Beginning_BalanceCaption; Beginning_BalanceCaptionLbl)
            {
            }
            column(Ending_BalanceCaption; Ending_BalanceCaptionLbl)
            {
            }
            column(ReportTotalsCaption; ReportTotalsCaptionLbl)
            {
            }
            column(ReportTotalBegBalCaption; ReportTotalBegBalCaptionLbl)
            {
            }
            column(ReportTotalActivitiesCaption; ReportTotalActivitiesCaptionLbl)
            {
            }
            column(ReportTotalEndBalCaption; ReportTotalEndBalCaptionLbl)
            {
            }
            dataitem(DataItem7069; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                              "Business Unit Code" = FIELD("Business Unit Filter");
                DataItemTableView = SORTING("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                RequestFilterFields = "Document Type", "Document No.";
                column(Account_______G_L_Account___No__; 'Account: ' + "G/L Account No.")
                {
                }
                column(G_L_Account__Name; "GLAccount".Name)
                {
                }
                column(DebitAmount_GLEntry; DebitAmount)
                {
                }
                column(CreditAmount_GLEntry; CreditAmount)
                {
                }
                column(BeginningBalance_GLEntry; BeginningBalance)
                {
                }
                column(G_L_Entry__Posting_Date_; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__GLName2; "G/L Account Name")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Document_Type_; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Document_No__; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Source_Code_; "Source Code")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Source_Type_; "Source Type")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Source_No__; "Source No.")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Seq1; Seq1)
                {
                }
                column(SourceName; SourceName)
                {
                }
                column(G_L_Entry_Entry_No_; "Entry No.")
                {
                }
                column(G_L_Entry_G_L_Account_No_; "G/L Account No.")
                {
                }
                column(G_L_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(G_L_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(G_L_Entry_Business_Unit_Code; "Business Unit Code")
                {
                }
                column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                {
                }
                column(Balance_to_Carry_ForwardCaption; Balance_to_Carry_ForwardCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF PrintDetail AND IncludeSecondLine THEN BEGIN
                        SourceName := '';
                        CASE "Source Type" OF
                            "Source Type"::Customer:
                                IF Customer.READPERMISSION THEN
                                    IF Customer.GET("Source No.") THEN
                                        SourceName := Customer.Name;
                            "Source Type"::Vendor:
                                IF Vendor.READPERMISSION THEN
                                    IF Vendor.GET("Source No.") THEN
                                        SourceName := Vendor.Name;
                            "Source Type"::Employee:
                                IF Employee.READPERMISSION THEN
                                    IF Employee.GET("Source No.") THEN
                                        SourceName := Employee."Last Name";
                            "Source Type"::"Fixed Asset":
                                IF FixedAsset.READPERMISSION THEN
                                    IF FixedAsset.GET("Source No.") THEN
                                        SourceName := FixedAsset.Description;
                            "Source Type"::"Bank Account":
                                IF BankAccount.READPERMISSION THEN
                                    IF BankAccount.GET("Source No.") THEN
                                        SourceName := BankAccount.Name;
                        END;
                    END;

                    IF UseAddRptCurr THEN BEGIN
                        DebitAmount := "Add.-Currency Debit Amount";
                        CreditAmount := "Add.-Currency Credit Amount";
                    END ELSE BEGIN
                        DebitAmount := "Debit Amount";
                        CreditAmount := "Credit Amount";
                    END;

                    TotalDebitAmount += DebitAmount;
                    TotalCreditAmount += CreditAmount;

                    IF NOT PrintDetail THEN
                        CurrReport.SKIP
                end;

                trigger OnPostDataItem()
                begin
                    IF GLEntryFilter <> '' THEN BEGIN
                        EndingBalance := TotalDebitAmount - TotalCreditAmount;
                        EndBalTotal := EndBalTotal + EndingBalance;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", FromDate, ToDate);
#pragma warning disable AL0667
                    CurrReport.CREATETOTALS(DebitAmount, CreditAmount);
#pragma warning restore AL0667
                end;
            }
            dataitem(Blank; 2000000026)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(PADSTR_____G_L_Account__Indentation_____G_L_Account__Name; PADSTR('', "GLAccount".Indentation) + "GLAccount".Name)
                {
                }
                column(EndingBalance; EndingBalance)
                {
                }
                column(TotalDebitAmount; TotalDebitAmount)
                {
                }
                column(TotalCreditAmount; TotalCreditAmount)
                {
                }
                column(STRSUBSTNO_Text002__G_L_Account___No___; STRSUBSTNO(Text002, "GLAccount"."No."))
                {
                }
                column(Seq2; Seq2)
                {
                }
                column(Blank_Number; Number)
                {
                }
                column(Total_ActivitiesCaption; Total_ActivitiesCaptionLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                // Sets filter to only get Net Change up to closing date of
                // previous period which is the beginnig balance for this period
                SETRANGE("Date Filter", 0D, CLOSINGDATE(FromDate - 1));
                IF UseAddRptCurr THEN BEGIN
                    CALCFIELDS("Additional-Currency Net Change");
                    BeginningBalance := "Additional-Currency Net Change";
                END ELSE BEGIN
                    CALCFIELDS("Net Change");
                    BeginningBalance := "Net Change";
                END;

                // Sets filter to only get Ending Balance at end of period
                SETRANGE("Date Filter", FromDate, ToDate);
                IF UseAddRptCurr THEN BEGIN
                    CALCFIELDS("Add.-Currency Balance at Date");
                    EndingBalance := "Add.-Currency Balance at Date";
                END ELSE BEGIN
                    CALCFIELDS("Balance at Date");
                    EndingBalance := "Balance at Date";
                END;

                // Are there any Activities (entries) for this account?
                "GLENTRY".COPYFILTERS(TempGLEntry);            // get saved user filters
                "GLENTRY".SETFILTER("G/L Account No.", "No.");  // then add our own
                "GLENTRY".SETRANGE("Posting Date", FromDate, ToDate);
                COPYFILTER("Global Dimension 1 Filter", "GLENTRY"."Global Dimension 1 Code");
                COPYFILTER("Global Dimension 2 Filter", "GLENTRY"."Global Dimension 2 Code");
                COPYFILTER("Business Unit Filter", "GLENTRY"."Business Unit Code");

#pragma warning disable AL0606
                WITH "GLENTRY" DO
#pragma warning restore AL0606
                    SETCURRENTKEY("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                AnyEntries := "GLENTRY".FIND('-');

                // Is there any reason to skip this account?
                IF (PrintType = PrintType::"Accounts with Activities") AND NOT AnyEntries THEN
                    CurrReport.SKIP;
                IF (PrintType = PrintType::"Accounts with Balances") AND
                   NOT AnyEntries AND
                   (BeginningBalance = 0)
                THEN
                    CurrReport.SKIP;

                // Having determined that we are really going to print this account,
                // we must not track beginning or ending balances if the user has
                // selected ledger entry filters, since they would then be meaningless.
                IF GLEntryFilter = '' THEN BEGIN
                    BeginBalTotal := BeginBalTotal + BeginningBalance;
                    EndBalTotal := EndBalTotal + EndingBalance;
                END ELSE BEGIN
                    BeginningBalance := 0;
                    EndingBalance := 0;
                END;

                TotalDebitAmount := 0;
                TotalCreditAmount := 0;

                // Will generate a new page if Chart of Accounts account is set to yes for New Page.
                IF "New Page" THEN
#pragma warning disable AL0667
                    CurrReport.NEWPAGE;
#pragma warning restore AL0667
            end;

            trigger OnPreDataItem()
            begin
#pragma warning disable AL0667
                CurrReport.CREATETOTALS(DebitAmount, CreditAmount, BeginningBalance, EndingBalance);
#pragma warning restore AL0667
#pragma warning disable AL0667
                CurrReport.NEWPAGEPERRECORD(OnlyOnePerPage);
#pragma warning restore AL0667
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(From_Date; FromDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'From Date';
                        //  OptionCaption = 'All Accounts,Accounts with Balances,Accounts with Activities';
                        // ToolTip = 'Specifies which accounts to include. All Accounts: Includes all accounts with transactions. Accounts with Balances: Includes accounts with balances. Accounts with Activity: Includes accounts that are currently active.';
                    }
                    field(TO_Date; ToDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'To Date';

                        // ToolTip = 'Specifies which accounts to include. All Accounts: Includes all accounts with transactions. Accounts with Balances: Includes accounts with balances. Accounts with Activity: Includes accounts that are currently active.';
                    }
                    field(Show; PrintType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show';
                        OptionCaption = 'All Accounts,Accounts with Balances,Accounts with Activities';
                        ToolTip = 'Specifies which accounts to include. All Accounts: Includes all accounts with transactions. Accounts with Balances: Includes accounts with balances. Accounts with Activity: Includes accounts that are currently active.';
                    }
                    field(OnlyOnePerPage; OnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New page per Account';
                        ToolTip = 'Specifies if you want to print each account on a separate page. Each account will begin at the top of the following page. Otherwise, each account will follow the previous account on the current page.';
                    }
                    field(PrintTransactionDetail; PrintDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Transaction Detail';
                        ToolTip = 'Specifies if you want the details of each transaction to be included in the report. A detailed report will have a list of each account entry. Otherwise, only the totals of the transactions will be included.';

                        trigger OnValidate()
                        begin
                            IF NOT PrintDetail THEN
                                IncludeSecondLine := FALSE;
                        end;
                    }
                    field(PrintSourceNames; IncludeSecondLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Source Names';
                        ToolTip = 'Specifies if you want the report to include the source names that are attached to each transaction. A source name is the name of a customer or item that has a code attached. This option is only valid if you have also selected the Print Transaction Detail field.';

                        trigger OnValidate()
                        begin
                            IF NOT PrintDetail THEN
                                IncludeSecondLine := FALSE;
                        end;
                    }
                    field(UseAdditionalReportingCurrency; UseAddRptCurr)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Use Additional Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want all amounts to be printed by using the additional reporting currency. If you do not select the check box, then all amounts will be printed in US dollars.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PrintTypeAll := PrintType::"All Accounts";
        PrintTypeAct := PrintType::"Accounts with Activities";
        PrintTypeBal := PrintType::"Accounts with Balances";
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        //FromDate := "GLAccount".GETRANGEMIN("Date Filter");
        //ToDate := "GLAccount".GETRANGEMAX("Date Filter");
        GLAccount.SetFilter("Date Filter", '%1..%2', FromDate, ToDate);
        PeriodText := STRSUBSTNO(Text000, FORMAT(FromDate, 0, 4), FORMAT(ToDate, 0, 4));
        //"GLAccount".SETRANGE("Date Filter");
        // Message('DATE: ' + Format("GLAccount"."Date Filter"));
        GLFilter := "GLAccount".GETFILTERS;
        GLEntryFilter := "GLEntry".GETFILTERS;
        EndBalTotal := 0;
        BeginBalTotal := 0;
        IF GLEntryFilter <> '' THEN BEGIN
            TempGLEntry.COPYFILTERS("GLEntry");  // save user filters for later
                                                 // accounts w/o activities are never printed if all the
                                                 // user is interested in are certain activities.
            IF PrintType = PrintType::"All Accounts" THEN
                PrintType := PrintType::"Accounts with Activities";
        END;
        IF PrintDetail THEN
            MainTitle := Text003
        ELSE
            MainTitle := Text004;
        IF UseAddRptCurr THEN BEGIN
            GLSetup.GET;
            Currency.GET(GLSetup."Additional Reporting Currency");
            SubTitle := STRSUBSTNO(Text001, Currency.Description);
        END;
    end;

    var

        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLENTRY: Record "G/L Entry";
        Employee: Record Employee;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        TempGLEntry: Record "G/L Entry" temporary;
        GLFilter: Text;
        GLEntryFilter: Text;
        FromDate: Date;
        ToDate: Date;
        PeriodText: Text[80];
        MainTitle: Text[88];
        SubTitle: Text[132];
        SourceName: Text[50];
        GLAccount: Record "G/L Account";
        OnlyOnePerPage: Boolean;
        PrintType: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        IncludeSecondLine: Boolean;
        PrintDetail: Boolean;
        BeginningBalance: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        EndingBalance: Decimal;
        BeginBalTotal: Decimal;
        EndBalTotal: Decimal;
        AnyEntries: Boolean;
        UseAddRptCurr: Boolean;
        Text000: Label 'Includes Activities from %1 to %2';
        Text001: Label 'Amounts are in %1';
        Text002: Label 'Account: %1';
        PrintTypeAll: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        PrintTypeBal: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        PrintTypeAct: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        Text003: Label 'Detail Trial Balance';
        Text004: Label 'Summary Trial Balance';
        Seq1: Integer;
        Seq2: Integer;
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        NoBalCaptionLbl: Label 'Accounts without activities or balances during the above period are not included.';
        NoActCaptionLbl: Label 'Accounts without activities during the above period are not included.';
        BalZeroCaptionLbl: Label 'Beginning Balances are set to zero due to existence of G/L Entry filters.';
        PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaptionLbl: Label 'Name';
        DebitAmount_Control85CaptionLbl: Label 'Total Debit Activities';
        CreditAmount_Control86CaptionLbl: Label 'Total Credit Activities';
        DebitAmount_Control75CaptionLbl: Label 'Debit Activities';
        CreditAmount_Control76CaptionLbl: Label 'Credit Activities';
        BalanceCaptionLbl: Label 'Balance';
        Beginning_BalanceCaptionLbl: Label 'Beginning Balance';
        ReportTotalsCaptionLbl: Label 'Report Totals';
        ReportTotalBegBalCaptionLbl: Label 'Report Total Beginning Balance';
        ReportTotalActivitiesCaptionLbl: Label 'Report Total Activities';
        ReportTotalEndBalCaptionLbl: Label 'Report Total Ending Balance';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        Total_ActivitiesCaptionLbl: Label 'Total Activities';
        Ending_BalanceCaptionLbl: Label 'Ending Balance';
}

