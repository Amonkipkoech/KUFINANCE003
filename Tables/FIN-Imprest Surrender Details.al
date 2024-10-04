table 52178704 "FIN-Imprest Surrender Details"
{

    fields
    {
        field(1; "Surrender Doc No."; Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = filter('Yes'));

            trigger OnValidate()
            begin
                /*
                IF GLAcc.GET("Account No:") THEN
                 "Account Name":=GLAcc.Name;
                 GLAcc.TESTFIELD("Direct Posting",TRUE);
                IF Pay.GET("Surrender Doc No.") THEN BEGIN
                 IF Pay."Account No."<>'' THEN
                "Imprest Holder":=Pay."Account No."
                  ELSE
                  ERROR('Please Enter the Customer/Account Number');
                END;
                 */

            end;
        }
        field(3; "Account Name"; Text[50])
        {
            Editable = true;
        }
        field(4; Amount; Decimal)
        {
            Editable = true;
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; "Imprest Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Actual Spent" > Amount THEN
                    ERROR('The Actual Spent Cannot be more than the Issued Amount');
                IF "Currency Factor" <> 0 THEN
                    "Amount LCY" := "Actual Spent" / "Currency Factor"
                ELSE
                    "Amount LCY" := "Actual Spent";
            end;
        }
        field(8; "Apply to"; Code[20])
        {
            Editable = false;
        }
        field(9; "Apply to ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "Surrender Date"; Date)
        {
            Editable = false;
        }
        field(11; Surrendered; Boolean)
        {
            Editable = false;
        }
        field(12; "Cash Receipt No"; Code[20])
        {
            TableRelation = "FIN-Receipts Header"."No.";

            trigger OnValidate()
            begin
                /*CustLedger.RESET;
                CustLedger.SETRANGE(CustLedger."Document No.","Cash Receipt No");
                CustLedger.SETRANGE(CustLedger."Source Code",'CASHRECJNL');
                CustLedger.SETRANGE(CustLedger.Open,TRUE);
                IF CustLedger.FIND('-') THEN
                 "Cash Receipt Amount":=ABS(CustLedger.Amount)
                ELSE BEGIN
                   "Cash Receipt Amount":=0;
                   MESSAGE();
                END;*/
                //"Cust. Ledger Entry"."Document No." WHERE (Source Code=CONST(CASHRECJNL),Open=CONST(Yes),Customer No.=FIELD(Account No:))

                IF ReceiptH.GET("Cash Receipt No") THEN
                    "Cash Receipt Amount" := ReceiptH."Amount Recieved";

            end;
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15; "Dept. Vch. No."; Code[20])
        {
        }
        field(16; "Cash Surrender Amt"; Decimal)
        {
        }
        field(17; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18; "Doc No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("FIN-Imprest Surr. Header"."Imprest Issue Doc. No" WHERE(No = FIELD("Surrender Doc No.")));
            Editable = false;

        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(23; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(24; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = Dimension;
        }
        field(25; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = Dimension;
        }
        field(26; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = Dimension;
        }
        field(27; "VAT Prod. Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28; "Imprest Type"; Code[20])
        {
            TableRelation = "FIN-Receipts and Payment Types".Code WHERE(Type = CONST(Imprest));
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
        field(88; "Cash Surrender Amt LCY"; Decimal)
        {
        }
        field(89; "Imprest Req Amt LCY"; Decimal)
        {
        }
        field(90; "Cash Receipt Amount"; Decimal)
        {
        }
        field(50000; "Cheque/Deposit Slip No"; Code[20])
        {

            trigger OnValidate()
            begin
                //heckSlipDetails();
            end;
        }
        field(50001; "Cheque/Deposit Slip Date"; Date)
        {

            trigger OnValidate()
            begin
                /*
                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Cheque Reject Period","Cheque/Deposit Slip Date")<=TODAY THEN
                  BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                  END;
                
                
                CheckSlipDetails();
                */

            end;
        }
        field(50002; "Cheque/Deposit Slip Type"; Option)
        {
            OptionMembers = " "," Local","Up Country";
        }
        field(50003; "Cheque/Deposit Slip Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50004; "Cash Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,Custom3';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,Custom3;
        }
        field(50005; "Over Expenditure"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Account No:")
        {
            Clustered = true;
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Pay.RESET;
        Pay.SETRANGE(Pay.No, "Surrender Doc No.");
        IF Pay.FIND('-') THEN
            IF (Pay.Status = Pay.Status::Posted) OR (Pay.Status = Pay.Status::"Pending Approval")
            OR (Pay.Status = Pay.Status::Approved) THEN
                ERROR('This Document is already Send for Approval/Approved or Posted');
    end;

    trigger OnModify()
    begin
        Pay.RESET;
        Pay.SETRANGE(Pay.No, "Surrender Doc No.");
        IF Pay.FIND('-') THEN
            IF (Pay.Status = Pay.Status::Posted) OR (Pay.Status = Pay.Status::"Pending Approval")
            OR (Pay.Status = Pay.Status::Approved) THEN
                ERROR('This Document is already Send for Approval/Approved or Posted');
    end;

    var
        GLAcc: Record 15;
        Pay: Record "FIN-Imprest Surr. Header";
        Dim: Record 348;
        CustLedger: Record 21;
        Text000: Label 'Receipt No %1 Is already Used in Another Document';
        ReceiptH: Record "FIN-Receipts Header";
}