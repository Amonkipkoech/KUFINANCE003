table 52178747 "Payment Line"
{
    // DrillDownPageID = 39005479;
    // LookupPageID = 39005479;

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                /*
                IF No <> xRec.No THEN BEGIN
                  GenLedgerSetup.GET;
                  IF "Payment Type"="Payment Type"::Normal THEN BEGIN
                    NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                  END
                  ELSE BEGIN
                    NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                  END;
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; Type; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment));

            trigger OnValidate()
            var
                TarrifCode: Record "Tariff Codes";
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF RecPayTypes.FIND('-') THEN BEGIN
                    Grouping := RecPayTypes."Default Grouping";
                    "Require Surrender" := RecPayTypes."Pending Voucher";
                    "Payment Reference" := RecPayTypes."Payment Reference";
                    // "Budgetary Control A/C":=RecPayTypes."Direct Expense";

                    IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                        //  "VAT Withheld Code":='VAT 6';
                        //  "VAT Six % Rate":=0.06;
                        "VAT Code" := RecPayTypes."VAT Code";

                        IF TarrifCode.GET("VAT Code") THEN
                            "VAT Rate" := TarrifCode.Percentage;
                    END;
                    IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN

                        "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                        IF TarrifCode.GET("Withholding Tax Code") THEN
                            "W/Tax Rate" := TarrifCode.Percentage;

                    END;
                    IF RecPayTypes."PAYE Tax Chargeable" = RecPayTypes."PAYE Tax Chargeable"::Yes THEN BEGIN
                        "PAYE Code" := RecPayTypes."PAYE Tax Code";
                        IF TarrifCode.GET("PAYE Code") THEN
                            "PAYE Rate" := TarrifCode.Percentage;
                    END;

                    IF RecPayTypes."Calculate Retention" = RecPayTypes."Calculate Retention"::Yes THEN BEGIN
                        "Retention Code" := RecPayTypes."Retention Code";
                        IF TarrifCode.GET("Retention Code") THEN
                            "Retention Rate" := TarrifCode.Percentage;

                    END;

                END;

                IF RecPayTypes.FIND('-') THEN BEGIN
                    "Account Type" := RecPayTypes."Account Type";
                    VALIDATE("Account Type");
                    "Transaction Name" := RecPayTypes.Description;
                    // "Budgetary Control A/C":=RecPayTypes."Direct Expense";
                    /*
                     IF RecPayTypes."Account Type"=RecPayTypes."Account Type"::"G/L Account" THEN
                       BEGIN
                         RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                         "Account No.":=RecPayTypes."G/L Account";
                         VALIDATE("Account No.");
                       END;


                            */
                    /////////////////////
                    IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                        "VAT Withheld Code" := RecPayTypes."VAT Withheld Code";
                        IF TarrifCode.GET("VAT Withheld Code") THEN
                            "VAT Six % Rate" := TarrifCode.Percentage;
                    END;

                    /////////////////////

                    //Banks
                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"Bank Account" THEN BEGIN
                        "Account No." := RecPayTypes."Bank Account";
                        VALIDATE("Account No.");
                    END;
                END;
                //GL
                IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                    "Account No." := RecPayTypes."G/L Account";
                    VALIDATE("Account No.");
                END;


                PHead.RESET;
                PHead.SETRANGE(PHead."No.", No);
                IF PHead.FINDFIRST THEN BEGIN
                    Date := PHead.Date;
                    PHead.TESTFIELD("Responsibility Center");
                    "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
                    "Currency Code" := PHead."Currency Code";
                    "Currency Factor" := PHead."Currency Factor";
                    "Payment Type" := PHead."Payment Type";
                END;

            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Cheque Type"; Code[20])
        {
        }
        field(8; "Bank Code"; Code[20])
        {
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
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
                PayLines: Record "Payment Line";
                Text0001: Label 'The Account number CANNOT be the same as the Paying Bank Account No.';
            begin
                /*  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Vendor);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Vendor in this document');

                  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Customer);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Customer in this document');

                  IF ("Account Type"= "Account Type"::Vendor) OR  ("Account Type"= "Account Type"::Customer) THEN  BEGIN
                     IF PayLinesExist THEN
                     ERROR('There is already another existing Line for this document');
                  END;
                  */

            end;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = filter(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                Text0001: Label 'The Account number CANNOT be the same as the Paying Bank Account No.';
            begin
                PH.RESET;
                PH.GET(No);
                "Account Name" := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner",
                "Account Type"::"Bank Account"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                IF GLAcc.GET("Account No.") THEN
                                    GLAcc.VALIDATE(GLAcc."No.");
                                "Account Name" := GLAcc.Name;
                                // "Budgetary Control A/C":=GLAcc."Budget Controlled";
                                PH.TESTFIELD("Global Dimension 1 Code");
                                PH.TESTFIELD("Shortcut Dimension 2 Code");
                                //PH.TESTFIELD("Shortcut Dimension 3 Code");

                                //"Global Dimension 1 Code":='';
                                //"Shortcut Dimension 2 Code":='';
                                CALCFIELDS("Council Claim");
                                IF "Council Claim" = TRUE THEN BEGIN
                                    PH.Payee := "Account Name";
                                    PH."Payment Narration" := GLAcc.Name;
                                    PH.MODIFY;
                                END;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                PH.Payee := Vend.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                END;
                                IF PH.Payee = '' THEN BEGIN
                                    PH.Payee := "Account Name";
                                    PH.MODIFY;
                                END;
                                IF PH."On Behalf Of" = '' THEN BEGIN
                                    PH."On Behalf Of" := "Account Name";
                                    PH.MODIFY;
                                END;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                IF BankAcc.GET("Account No.") THEN
                                    "Account Name" := BankAcc.Name;
                                PH.TESTFIELD("Paying Bank Account");
                                IF PH."Paying Bank Account" = "Account No." THEN
                                    ERROR(Text0001);
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::"IC Partner":
                            BEGIN
                                ICPartner.RESET;
                                ICPartner.GET("Account No.");
                                "Account Name" := ICPartner.Name;
                            END;
                    END;
                //Set the application to Invoice if Account type is vendor
                IF "Account Type" = "Account Type"::Vendor THEN
                    "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
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
        field(19; "Posted By"; Code[20])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                CALCFIELDS("Council Claim");
                IF "Council Claim" = TRUE THEN
                    TESTFIELD("Council No.");

                CalculateTax();
                PHead.RESET;
                PHead.SETRANGE(PHead."No.", No);
                IF PHead.FINDFIRST THEN BEGIN
                    IF (PHead.Status = PHead.Status::Approved) OR (PHead.Status = PHead.Status::Posted) OR
                     (PHead.Status = PHead.Status::"Pending Approval") THEN
                        ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
                END;
                TESTFIELD(Committed, FALSE);
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
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(VAT));

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes" WHERE(Type = CONST("W/Tax"));

            trigger OnValidate()
            begin
                //CalculateTax();
            end;
        }
        field(25; "VAT Amount"; Decimal)
        {
        }
        field(26; "Withholding Tax Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(27; "Net Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Currency Factor" <> 0 THEN
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                ELSE
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(29; Payee; Text[100])
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin

                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
                DimVal.SETRANGE(DimVal.Code, "Global Dimension 1 Code");
                IF DimVal.FIND('-') THEN
                    "Function Name" := DimVal.Name
            end;
        }
        field(31; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin

                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
                DimVal.SETRANGE(DimVal.Code, "Branch Code");
                IF DimVal.FIND('-') THEN
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(32; "PO/INV No"; Code[20])
        {
        }
        field(33; "Bank Account No"; Code[20])
        {
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; Option)
        {
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook;
        }
        field(36; Select; Boolean)
        {
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
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
            TableRelation = "Vendor Ledger Entry"."Vendor No." WHERE("Vendor No." = FIELD("Account No."));
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
        }
        field(46; "Surrender Doc. No"; Code[20])
        {
        }
        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                /*
                          IF Amount<=0 THEN
                        ERROR('Please enter the Amount');
                
                       //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(Date,2)));
                        EVALUATE(CurrYR,FORMAT(DATE2DMY(Date,3)));
                        EVALUATE(BudgetDate,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));
                
                          //Get the last day of the month
                
                          LastDay:=CALCDATE('1M', BudgetDate);
                          LastDay:=CALCDATE('-1D',LastDay);
                
                
                        //Get Budget for the G/L
                      IF GenLedSetup.GET THEN BEGIN
                        GLAccount.SETFILTER(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SETRANGE(GLAccount."No.","Vote Book");
                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        {Get the exact Monthly Budget}
                        //Start from first date of the budget.//BudgetDate
                        GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",LastDay);
                
                        IF GLAccount.FIND('-') THEN BEGIN
                         GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         MonthBudget:=GLAccount."Budgeted Amount";
                         Expenses:=GLAccount."Net Change";
                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                         "Total Allocation":=MonthBudget;
                         "Total Expenditure":=Expenses;
                         END;
                
                
                     END;
                
                     CommitmentEntries.RESET;
                     CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                     CommitmentEntries.SETRANGE(CommitmentEntries.Account,"Vote Book");
                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GenLedSetup."Current Budget Start Date",LastDay);
                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                     CommittedAmount:=CommitmentEntries."Committed Amount";
                
                     "Total Commitments":=CommittedAmount;
                     Balance:=BudgetAvailable-CommittedAmount;
                     "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                     MODIFY;
                     {
                     IF CommittedAmount+Amount>BudgetAvailable THEN
                        ERROR('%1,%2,%3,%4','You have Exceeded Budget for G/L Account No',"Vote Book",'by',
                        ABS(BudgetAvailable-(CommittedAmount+Amount)));
                      }
                     //End of Confirming whether Budget Allows Posting
                */

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
        field(55; "Supplier Invoice No."; Code[30])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(57; "Imprest Request No"; Code[20])
        {

            trigger OnValidate()
            begin

                /*
                          TotAmt:=0;
                     //On Delete/Change of Request No. then Clear from Imprest Details
                     IF ("Imprest Request No"='') OR ("Imprest Request No"<>xRec."Imprest Request No") THEN
                        LoadImprestDetails.RESET;
                        LoadImprestDetails.SETRANGE(LoadImprestDetails.No,No);
                        IF LoadImprestDetails.FIND('-') THEN BEGIN
                           LoadImprestDetails.DELETEALL;
                           Amount:=TotAmt;
                           "Net Amount":=Amount;
                           MODIFY;
                
                        END;
                     //New Imprest Details
                     ImprestReqDet.RESET;
                     ImprestReqDet.SETRANGE(ImprestReqDet.No,"Imprest Request No");
                     IF ImprestReqDet.FIND('-') THEN BEGIN
                     REPEAT
                         LoadImprestDetails.INIT;
                         LoadImprestDetails.No:=No;
                         LoadImprestDetails.Date:=ImprestReqDet."Account No:";
                         LoadImprestDetails.Type:=ImprestReqDet."Account Name";
                         LoadImprestDetails."Pay Mode":=ImprestReqDet.Amount;
                         LoadImprestDetails."Cheque No":=ImprestReqDet."Due Date";
                         LoadImprestDetails."Cheque Date":=ImprestReqDet."Imprest Holder";
                         LoadImprestDetails.INSERT;
                         TotAmt:=TotAmt+ImprestReqDet.Amount;
                     UNTIL ImprestReqDet.NEXT=0;
                         Amount:=TotAmt;
                         "Account No.":=ImprestReqDet."Imprest Holder";
                         "Net Amount":=Amount;
                         MODIFY;
                     END;
                {
                       //ImprestDetForm.GETRECORD(LoadImprestDetails);
                }
                      */

            end;
        }
        field(58; "Batched Imprest Tot"; Decimal)
        {
            FieldClass = Normal;
        }
        field(59; "Function Name"; Text[30])
        {
        }
        field(60; "Budget Center Name"; Text[150])
        {
        }
        field(61; "Farmer Purchase No"; Code[20])
        {
        }
        field(62; "Transporter Ananlysis No"; Code[20])
        {
        }
        field(63; "User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(64; "Journal Template"; Code[20])
        {
        }
        field(65; "Journal Batch"; Code[20])
        {
        }
        field(66; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(67; "Require Surrender"; Boolean)
        {
            Editable = false;
        }
        field(68; "Commited Ammount"; Decimal)
        {
            FieldClass = FlowFilter;
        }
        field(69; "Select to Surrender"; Boolean)
        {
        }
        field(71; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(72; "ID Number"; Code[8])
        {
        }
        field(73; "VAT Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                /*"VAT Amount":=(Amount * 100);
                "VAT Amount":=Amount-("VAT Amount"/(100 + "VAT Rate"));*/

            end;
        }
        field(74; "Amount With VAT"; Decimal)
        {
        }
        field(75; "Currency Code"; Code[20])
        {
        }
        field(76; "Exchange Rate"; Decimal)
        {
        }
        field(77; "Currency Reciprical"; Decimal)
        {
        }
        field(78; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "VAT Product Posting Group".Code;
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

            trigger OnValidate()
            begin
                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
                DimVal.SETRANGE(DimVal.Code, "Shortcut Dimension 2 Code");
                IF DimVal.FIND('-') THEN
                    "Budget Center Name" := DimVal.Name
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
                DimVal.SETRANGE(DimVal."Global Dimension No.", 2);
                DimVal.SETRANGE(DimVal.Code, "Shortcut Dimension 2 Code");
                IF DimVal.FIND('-') THEN
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Currency Factor" <> 0 THEN
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                ELSE
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(85; "NetAmount LCY"; Decimal)
        {
        }
        field(86; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(87; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                VendLedgEntry: Record 25;
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                ApplyVendEntries: Page "Apply Vendor Entries";
            begin
                //CODEUNIT.RUN(CODEUNIT::"Payment Voucher Apply",Rec);

                IF (Rec."Account Type" <> Rec."Account Type"::Customer) AND (Rec."Account Type" <> Rec."Account Type"::Vendor) THEN
                    ERROR('You cannot apply to %1', "Account Type");

                //WITH Rec DO BEGIN
                Amount := 0;
                VALIDATE(Amount);
                PayToVendorNo := "Account No.";
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                VendLedgEntry.SETRANGE("Vendor No.", PayToVendorNo);
                VendLedgEntry.SETRANGE(Open, TRUE);
                IF "Applies-to ID" = '' THEN
                    "Applies-to ID" := No;
                IF "Applies-to ID" = '' THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION(No), FIELDCAPTION("Applies-to ID"));
                //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                //  ApplyVendEntries.SetPVLine(Rec,VendLedgEntry,Rec.FIELDNO("Applies-to ID"));
                ApplyVendEntries.SETRECORD(VendLedgEntry);
                ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                ApplyVendEntries.LOOKUPMODE(TRUE);
                OK := ApplyVendEntries.RUNMODAL = ACTION::LookupOK;
                CLEAR(ApplyVendEntries);
                IF NOT OK THEN
                    EXIT;
                VendLedgEntry.RESET;
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                VendLedgEntry.SETRANGE("Vendor No.", PayToVendorNo);
                VendLedgEntry.SETRANGE(Open, TRUE);
                VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                IF VendLedgEntry.FIND('-') THEN BEGIN
                    "Applies-to Doc. Type" := 0;
                    "Applies-to Doc. No." := '';
                END ELSE
                    "Applies-to ID" := '';
                //END;

                //Calculate  Total To Apply
                VendLedgEntry.RESET;
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, "Applies-to ID");
                VendLedgEntry.SETRANGE("Vendor No.", PayToVendorNo);
                VendLedgEntry.SETRANGE(Open, TRUE);
                //  VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
                IF VendLedgEntry.FIND('-') THEN BEGIN
                    VendLedgEntry.CALCSUMS("Amount to Apply");
                    Amount := ABS(VendLedgEntry."Amount to Apply");
                    VALIDATE(Amount);
                END;
            end;

            trigger OnValidate()
            begin
                //IF "Applies-to Doc. No." <> '' THEN
                //TESTFIELD("Bal. Account No.",'');

                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                END ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    ELSE
                        IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(88; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record 25;
            begin
                //IF "Applies-to ID" <> '' THEN
                //  TESTFIELD("Bal. Account No.",'');
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    VendLedgEntry.SETRANGE("Applies-to ID", xRec."Applies-to ID");
                    IF VendLedgEntry.FINDFIRST THEN
                        //  VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,0,0,'');
                        VendLedgEntry.RESET;
                END;
            end;
        }
        field(90; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(Retention));

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(91; "Retention  Amount"; Decimal)
        {
        }
        field(92; "Retention Rate"; Decimal)
        {
        }
        field(93; "W/Tax Rate"; Decimal)
        {
        }
        field(94; "Vendor Bank Account"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));

            trigger OnValidate()
            begin
                VBank.RESET;
                VBank.SETRANGE(VBank."Vendor No.", "Account No.");
                VBank.SETRANGE(VBank.Code, "Vendor Bank Account");
                IF VBank.FIND('-') THEN BEGIN
                    "EFT Bank Account No" := VBank."Bank Account No.";
                    "EFT Bank Code" := VBank.Code;
                    "EFT Account Name" := VBank.Name;
                    "EFT Branch No." := VBank."Bank Branch No.";
                END;
            end;
        }
        field(95; "EFT Bank Account No"; Code[20])
        {
        }
        field(96; "EFT Bank Code"; Code[20])
        {
        }
        field(97; "EFT Account Name"; Text[50])
        {
        }
        field(98; "EFT Branch No."; Code[20])
        {
        }
        field(99; "Document Type"; Option)
        {
            OptionCaption = ' ,Imprest,Claim';
            OptionMembers = " ",Imprest,Claim;
        }
        field(100; "Document No"; Code[20])
        {

            trigger OnValidate()
            begin
                /* IF "Document Type"="Document Type"::Imprest THEN BEGIN
                  ImprestLines.RESET;
                 ImprestLines.SETRANGE(ImprestLines.No,"Document No");
                 ImprestLines.SETRANGE(ImprestLines."Account No:","Account No.");
                 IF ImprestLines.FIND('-') THEN BEGIN
                 "Account No.":=ImprestLines."Account No:";
                 "Account Name":=ImprestLines."Account Name";
                  Amount:=ImprestLines.Amount;
                 "Net Amount":=ImprestLines.Amount;
                 VALIDATE(Amount);
                 VALIDATE("Net Amount");
                 END ELSE
                 IF "Document Type"="Document Type"::Claim THEN BEGIN
                 PayLine.RESET;
                 PayLine.SETRANGE(PayLine.No,"Document No");
                 PayLine.SETRANGE(PayLine."Account No.","Document Line");
                 IF PayLine.FIND('-') THEN
                 "Account No.":=PayLine."Account No.";
                 "Account Name":=PayLine."Account Name";
                 Amount:=PayLine.Amount;
                 "Net Amount":=PayLine."Net Amount";
                 VALIDATE(Amount);
                 VALIDATE("Net Amount");
                   END;
                 END;
                //END;
                 */

            end;
        }
        field(101; "Document Line"; Code[20])
        {

            trigger OnValidate()
            begin
                /*IF "Document Type"="Document Type"::Imprest THEN BEGIN
                 ImprestLines.RESET;
                ImprestLines.SETRANGE(ImprestLines.No,"Document No");
                ImprestLines.SETRANGE(ImprestLines."Account No:","Document Line");
                IF ImprestLines.FIND('-') THEN BEGIN
                "Account No.":=ImprestLines."Imprest Holder";
                "Account Name":=ImprestLines."Account Name";
                 Amount:=ImprestLines.Amount;
                "Net Amount":=ImprestLines.Amount;
                VALIDATE(Amount);
                VALIDATE("Net Amount");
                END;
                END;
                IF "Document Type"="Document Type"::Claim THEN BEGIN
                PayLine.RESET;
                PayLine.SETRANGE(PayLine.No,"Document No");
                PayLine.SETRANGE(PayLine."Account No.","Document Line");
                IF PayLine.FIND('-') THEN BEGIN
                "Account No.":=PayLine."Account No.";
                "Account Name":=PayLine."Account Name";
                Amount:=PayLine.Amount;
                "Net Amount":=PayLine."Net Amount";
                VALIDATE(Amount);
                VALIDATE("Net Amount");
                  END;
                END;*/
                //END;

            end;
        }
        field(5002; "PAYE Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(5003; "PAYE Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(PAYE));
        }
        field(50001; "Budgeted Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("Account No."),
                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                               "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
                                                               "Budget Name" = FIELD("Budget Name")));
            FieldClass = FlowField;
        }
        field(50002; "Actual Expenditure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("Account No."),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                        "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));

        }
        // field(50003;"Committed Amount";Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = Sum(Committment.Amount WHERE ("G/L Account No." = FIELD("Account No."),
        //                                                 "Shortcut Dimension 1 Code"=FIELD("Global Dimension 1 Code"),
        //                                                 "Shortcut Dimension 2 Code"=FIELD("Shortcut Dimension 2 Code"),
        //                                                 Budget=FIELD("Budget Name")));

        // }
        field(50004; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50005; "Budget Balance"; Decimal)
        {
        }
        field(50006; "VAT Withheld Amount"; Decimal)
        {
        }
        field(50007; "VAT Withheld Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(VAT));
        }
        field(50008; "VAT Six % Rate"; Decimal)
        {
        }
        field(50009; "Not Vatable"; Boolean)
        {
        }
        field(50010; "Council No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                IF CouncilRec.GET("Council No.") THEN
                    "Account Name" := CouncilRec.Name;

                PH.GET(No);
                CALCFIELDS("Council Claim");
                IF "Council Claim" = TRUE THEN BEGIN
                    GLAcc.GET("Account No.");
                    PH.Payee := "Account Name";
                    PH."Payment Narration" := GLAcc.Name;
                    PH.MODIFY;
                END;
            end;
        }
        field(50011; "Council Claim"; Boolean)
        {
            CalcFormula = Lookup("Receipts and Payment Types"."Council Claim?" WHERE(Code = FIELD(Type)));
            FieldClass = FlowField;
        }
        field(50012; "Telephone Allowance"; Boolean)
        {
            CalcFormula = Lookup("Receipts and Payment Types"."Telephone Allowance?" WHERE(Code = FIELD(Type)));
            FieldClass = FlowField;
        }
        field(50013; "PAYE Rate"; Decimal)
        {
        }
        field(50014; "Medical Claim Type"; Option)
        {
            OptionCaption = ' ,Student,Employee';
            OptionMembers = " ",Student,Employee;
        }
        field(50015; "Medical Ref. No"; Code[20])
        {
        }
        field(50016; "Payment Status"; Option)
        {
            CalcFormula = Lookup("Payments Header".Status WHERE("No." = FIELD(No)));
            FieldClass = FlowField;
            OptionCaption = 'Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(50017; Commission; Code[20])
        {
            TableRelation = "Tariff Codes".Code WHERE(Type = CONST(Commision));

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(50018; "Commision Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                // CalculateTax();
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", No, Type, "Account No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "VAT Amount", "Withholding Tax Amount", "Net Amount", "NetAmount LCY", "Retention  Amount", "PAYE Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        PHead.RESET;
        PHead.SETRANGE(PHead."No.",No);
         IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
            (PHead.Status=PHead.Status::"Pending Approval") THEN
               ERROR('You Cannot Delete this record its already approved/posted/Send for Approval');
         END;
          TESTFIELD(Committed,FALSE);
         */

    end;

    trigger OnInsert()
    begin

        IF No = '' THEN BEGIN
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Normal Payments No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, No, "No. Series");
        END;
        PHead.RESET;
        PHead.SETRANGE(PHead."No.", No);
        IF PHead.FINDFIRST THEN BEGIN
            Date := PHead.Date;
            PHead.TESTFIELD("Responsibility Center");
            "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
            "Currency Code" := PHead."Currency Code";
            "Currency Factor" := PHead."Currency Factor";
            "Payment Type" := PHead."Payment Type";
        END;
        //
        PHead.RESET;
        PHead.SETRANGE(PHead."No.", No);
        IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status = PHead.Status::Approved) OR (PHead.Status = PHead.Status::Posted) OR
             (PHead.Status = PHead.Status::"Pending Approval") THEN
                ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
        END;
        TESTFIELD(Committed, FALSE);
    end;

    trigger OnModify()
    begin
        /*
        PHead.RESET;
        PHead.SETRANGE(PHead."No.",No);
         IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
             (PHead.Status=PHead.Status::"Pending Approval") THEN
               ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
         END;
          TESTFIELD(Committed,FALSE);
         */

    end;

    var
        PH: Record "Payments Header";
        VLedgEntry: Record 25;
        ICPartner: Record 413;
        FPurch: Record 122;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Office User Template";
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
        GenLedSetup: Record "Cash Office Setup";
        "Total Budget": Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        PHead: Record "Payments Header";
        VendLedgEntry: Record 25;
        VendEntrySetApplID: Codeunit 111;
        GenJnlApply: Codeunit 225;
        GenJnILine: Record 81;
        VBank: Record 288;
        PayLine: Record "Payment Line";
        ApplyVendEntries: Page 233;
        CouncilRec: Record 23;
    //Committment: Committment;

    //[Scope('Internal')]
    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        VendLedgEntry: Record 25;
    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.", VendorNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
            IF VendLedgEntry."Amount to Apply" = 0 THEN BEGIN
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            END ELSE
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        END;
    end;

    //[Scope('Internal')]
    procedure CalculateTax()
    var
        CalculationType: Option VAT,"W/Tax",Retention,PAYE;
        TaxCalc: Codeunit "Tax Calculation 2";
        TotalTax: Decimal;
    begin
        "VAT Amount" := 0;
        "Retention  Amount" := 0;
        TotalTax := 0;
        "Net Amount" := 0;
        "Commision Amount" := 0; //"PAYE Amount":=0;,"Withholding Tax Amount":=0;
        IF Amount <> 0 THEN BEGIN
            IF "VAT Rate" <> 0 THEN BEGIN
                //  "VAT Amount":=TaxCalc.CalculateTax(Rec,CalculationType::VAT);
                "VAT Amount" := ("VAT Rate" / 116) * Amount;
                // TotalTax:=TotalTax+"VAT Amount"
            END;

            /* IF "W/Tax Rate"<>0 THEN BEGIN
              "Withholding Tax Amount":=TaxCalc.CalculateTax(Rec,CalculationType::"W/Tax");
              TotalTax:=TotalTax+ "Withholding Tax Amount"
             END;
             */

            IF "VAT Withheld Code" <> '' THEN BEGIN
                //ERROR('Test'+"VAT Withheld Code");
                "VAT Withheld Amount" := 0;
                // "VAT Withheld Amount":=("VAT Amount"*("VAT Six % Rate")/100);
                "VAT Withheld Amount" := ROUND((Amount * "VAT Six % Rate") / 116, 1, '=');
                TotalTax := TotalTax + "VAT Withheld Amount"
            END;


            IF "Withholding Tax Code" <> '' THEN BEGIN
                // "Withholding Tax Amount":=ROUND(TaxCalc.CalculateTax(Rec,CalculationType::"W/Tax"),1,'>');
                IF "Not Vatable" = FALSE THEN
                    "Withholding Tax Amount" := ROUND((("W/Tax Rate" / 116) * Amount), 1, '=')
                ELSE
                    "Withholding Tax Amount" := ROUND((("W/Tax Rate" / 100) * Amount), 1, '=');


                TotalTax := TotalTax + "Withholding Tax Amount"
            END;

            /*IF "Retention Rate"<>0 THEN BEGIN
             "Retention  Amount":=TaxCalc.CalculateTax(Rec,CalculationType::Retention);
             TotalTax:=TotalTax+"Retention  Amount"
            END; */

            IF "Retention Code" <> '' THEN BEGIN
                // "Retention  Amount":=TaxCalc.CalculateTax(Rec,CalculationType::Retention);
                "Retention  Amount" := ROUND((("Retention Rate" / 100) * Amount), 1, '=');
                TotalTax := TotalTax + "Retention  Amount"
            END;

            IF Commission <> '' THEN BEGIN
                // CALCFIELDS("Commision Amount");
                "Commision Amount" := (0.07 * Amount);

                "Net Amount" := Amount - "Commision Amount";

            END;

            IF "PAYE Code" <> '' THEN BEGIN
                CALCFIELDS("Telephone Allowance");
                IF "Telephone Allowance" = TRUE THEN
                    "PAYE Amount" := (0.3 * Amount) * 0.3
                ELSE
                    "PAYE Amount" := (0.3 * Amount);

                // "PAYE Amount":=TaxCalc.CalculateTax(Rec,CalculationType::PAYE);
                // RecPayTypes.RESET;
                // RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                // IF RecPayTypes.FIND('-') THEN
                //   IF RecPayTypes."Use PAYE Table"=TRUE THEN
                //    "PAYE Amount":=prPayroll.fnGetEmployeePaye(Amount)-1162;

                TotalTax := TotalTax + "PAYE Amount";
            END;

        END;


        "Net Amount" := Amount - TotalTax;
        VALIDATE("Net Amount");

    end;

    //[Scope('Internal')]
    procedure PayLinesExist(): Boolean
    var
        PayLine: Record "Payment Line";
    begin
        PayLine.RESET;
        //PayLine.SETRANGE(No,No);
        EXIT(PayLine.FINDFIRST);
    end;
}
