report 52178729 "Imprest Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/ImprestAccountingRequest.rdl';

    dataset
    {
        dataitem(ImprestHeader; "FIN-Imprest Header")
        {
            column(No_ImprestHeader; ImprestHeader."No.")
            {
            }
            column(Date_ImprestHeader; Format(ImprestHeader.Date))
            {
            }
            column(CurrencyFactor_ImprestHeader; ImprestHeader."Currency Factor")
            {
            }
            column(CurrencyCode_ImprestHeader; ImprestHeader."Currency Code")
            {
            }
            column(Payee_ImprestHeader; ImprestHeader.Payee)
            {
            }
            column(OnBehalfOf_ImprestHeader; ImprestHeader."On Behalf Of")
            {
            }
            column(Cashier_ImprestHeader; ImprestHeader.Cashier)
            {
            }
            column(Posted_ImprestHeader; ImprestHeader.Posted)
            {
            }
            column(DatePosted_ImprestHeader; FORMAT(ImprestHeader."Date Posted"))
            {
            }
            column(TimePosted_ImprestHeader; FORMAT(ImprestHeader."Time Posted"))
            {
            }
            column(PostedBy_ImprestHeader; ImprestHeader."Posted By")
            {
            }
            column(TotalPaymentAmount_ImprestHeader; ImprestHeader."Total Payment Amount")
            {
            }
            column(PayingBankAccount_ImprestHeader; ImprestHeader."Paying Bank Account")
            {
            }
            column(GlobalDimension1Code_ImprestHeader; ImprestHeader."Global Dimension 1 Code")
            {
            }
            column(Status_ImprestHeader; ImprestHeader.Status)
            {
            }
            column(PaymentType_ImprestHeader; ImprestHeader."Payment Type")
            {
            }
            column(ShortcutDimension2Code_ImprestHeader; ImprestHeader."Shortcut Dimension 2 Code")
            {
            }
            column(FunctionName_ImprestHeader; ImprestHeader."Function Name")
            {
            }
            column(BudgetCenterName_ImprestHeader; ImprestHeader."Budget Center Name")
            {
            }
            column(BankName_ImprestHeader; ImprestHeader."Bank Name")
            {
            }
            column(NoSeries_ImprestHeader; ImprestHeader."No. Series")
            {
            }
            column(Select_ImprestHeader; ImprestHeader.Select)
            {
            }
            column(TotalVATAmount_ImprestHeader; ImprestHeader."Total VAT Amount")
            {
            }
            column(TotalWitholdingTaxAmount_ImprestHeader; ImprestHeader."Total Witholding Tax Amount")
            {
            }
            column(TotalNetAmount_ImprestHeader; ImprestHeader."Total Net Amount")
            {
            }
            column(CurrentStatus_ImprestHeader; ImprestHeader."Current Status")
            {
            }
            column(ChequeNo_ImprestHeader; ImprestHeader."Cheque No.")
            {
            }
            column(PayMode_ImprestHeader; ImprestHeader."Pay Mode")
            {
            }
            column(PaymentReleaseDate_ImprestHeader; FORMAT(ImprestHeader."Payment Release Date"))
            {
            }
            column(NoPrinted_ImprestHeader; ImprestHeader."No. Printed")
            {
            }
            column(VATBaseAmount_ImprestHeader; ImprestHeader."VAT Base Amount")
            {
            }
            column(ExchangeRate_ImprestHeader; ImprestHeader."Exchange Rate")
            {
            }
            column(CurrencyReciprical_ImprestHeader; ImprestHeader."Currency Reciprical")
            {
            }
            column(CurrentSourceACBal_ImprestHeader; ImprestHeader."Current Source A/C Bal.")
            {
            }
            column(CancellationRemarks_ImprestHeader; ImprestHeader."Cancellation Remarks")
            {
            }
            column(RegisterNumber_ImprestHeader; ImprestHeader."Register Number")
            {
            }
            column(FromEntryNo_ImprestHeader; ImprestHeader."From Entry No.")
            {
            }
            column(ToEntryNo_ImprestHeader; ImprestHeader."To Entry No.")
            {
            }
            column(InvoiceCurrencyCode_ImprestHeader; ImprestHeader."Invoice Currency Code")
            {
            }
            column(TotalNetAmountLCY_ImprestHeader; ImprestHeader."Total Net Amount LCY")
            {
            }
            column(DocumentType_ImprestHeader; ImprestHeader."Document Type")
            {
            }
            column(ShortcutDimension3Code_ImprestHeader; ImprestHeader."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_ImprestHeader; ImprestHeader."Shortcut Dimension 4 Code")
            {
            }
            column(Dim3_ImprestHeader; ImprestHeader.Dim3)
            {
            }
            column(Dim4_ImprestHeader; ImprestHeader.Dim4)
            {
            }
            column(ResponsibilityCenter_ImprestHeader; ImprestHeader."Responsibility Center")
            {
            }
            column(AccountType_ImprestHeader; ImprestHeader."Account Type")
            {
            }
            column(AccountNo_ImprestHeader; ImprestHeader."Account No.")
            {
            }
            column(SurrenderStatus_ImprestHeader; ImprestHeader."Surrender Status")
            {
            }
            column(Purpose_ImprestHeader; ImprestHeader.Purpose)
            {
            }
            column(PaymentVoucherNo_ImprestHeader; ImprestHeader."Payment Voucher No")
            {
            }
            column(SerialNo_ImprestHeader; ImprestHeader."Serial No.")
            {
            }
            column(BudgetedAmount_ImprestHeader; ImprestHeader."Budgeted Amount")
            {
            }
            column(ActualExpenditure_ImprestHeader; ImprestHeader."Actual Expenditure")
            {
            }
            column(CommittedAmount_ImprestHeader; ImprestHeader."Committed Amount")
            {
            }
            column(BudgetBalance_ImprestHeader; ImprestHeader."Budget Balance")
            {
            }
            column(RequestedBy_ImprestHeader; ImprestHeader."Requested By")
            {
            }
            column(CompLogo; CompInf.Picture)
            {
            }
            column(CompName; CompInf.Name)
            {
            }
            column(address; CompInf.Address)
            {

            }
            column(address2; CompInf."Address 2")
            {

            }
            column(mail; CompInf."E-Mail")
            {

            }
            column(Url; CompInf."Home Page")
            {

            }
            column(NumberText_1_; NumberText[1])
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompInf.GET;
                CompInf.CALCFIELDS(CompInf.Picture);

                // CheckReport.InitTextVariable();
                // CheckReport.FormatNoText(NumberText, "Total Net Amount", '');

                InitTextVariable;
                FormatNoText(NumberText, "Total Net Amount", CurrencyCodeText);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInf: Record "Company Information";
        CheckReport: Report 1401;
        NumberText: array[2] of Text[1024];
        StrCopyText: Text[30];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimVal: Record "Dimension Value";
        DimValName: Text[100];
        TTotal: Decimal;
        STotal: Decimal;
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record 98;
        DOCNAME: Text[30];
        CompInfo: Record "Company Information";
        VATCaptionLbl: Label 'VAT';
        PAYMENT_DETAILSCaptionLbl: Label 'PAYMENT DETAILS';
        AMOUNTCaptionLbl: Label 'AMOUNT';
        NET_AMOUNTCaptionLbl: Label 'NET AMOUNT';
        W_TAXCaptionLbl: Label 'W/TAX';
        Document_No___CaptionLbl: Label 'Document No. :';
        Currency_CaptionLbl: Label 'Currency:';
        Payment_To_CaptionLbl: Label 'Payment To:';
        Document_Date_CaptionLbl: Label 'Document Date:';
        Cheque_No__CaptionLbl: Label 'Cheque No.:';
        R_CENTERCaptionLbl: Label 'R.CENTER';
        PROJECTCaptionLbl: Label 'PROJECT';
        TotalCaptionLbl: Label 'Total';
        Printed_By_CaptionLbl: Label 'Printed By:';
        Amount_in_wordsCaptionLbl: Label 'Amount in words';
        EmptyStringCaptionLbl: Label '================================================================================================================================================================================================';
        RecipientCaptionLbl: Label 'Recipient';
        Signature_CaptionLbl: Label 'Signature:';
        Date_CaptionLbl: Label 'Date:';
        Name_CaptionLbl: Label 'Name:';
        EmptyStringCaption_Control1102755013Lbl: Label '================================================================================================================================================================================================';
        Amount_in_wordsCaption_Control1102755021Lbl: Label 'Amount in words';
        Printed_By_Caption_Control1102755026Lbl: Label 'Printed By:';
        TotalCaption_Control1102755033Lbl: Label 'Total';
        name: Label 'THE KENYATTA INTERNATIONAL CONFERENCE CENTRE';
        "name+": Label '(CORPORATION)';
        addr: Label 'Private Bag, Tel.+020 2046895 / 0722814900';
        email: Label 'MASENO,Kenya.Email info@kicc.co.ke,Website:www.kicc.co.ke';
        PIN: Label 'PIN:';
        VAT: Label 'VAT:';
        no: Label 'L.P.O/L.S.O';
        ret: Label 'Retention';
        appliedinv: Label 'Applied Invoice(s) Details';
        confir: Label 'I confirm accuracy and authenticity of the payment and that this expenditure has been entered in the votebook and is sufficiently covered.';
        next1: Label 'has been entered in the votebook and is sufficiently covered.';
        dat: Label 'DATE:.';
        PREPARE: Label 'PREPARE .';
        checked: Label 'CHECKED .';
        appr: Label 'APPROVED .';
        confirma: Label 'CONFIRMED .';
        internals: Label 'Internal Audit Manage';
        paymentapp: Label 'Payment Approved:';
        md: Label 'Managing Director:';
        Authorized: Label 'Authorized.';
        emptystr: Label '========================================================================================================================================';
        id: Label 'ID No:';
        accntnt: Label 'Accountant:';
        fincont: Label 'Financial Controller:';
        payTypes: Record "FIN-Receipts and Payment Types";
        vends: Record Vendor;
        NumberTextOne: Text;
        NumberTextTwo: Text;
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        BankName: Text[100];
        Banks: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        CurrencyCodeText: Code[10];
        Users: Record User;
        UserName: Text[130];
        Desc: Text[70];
        GLEntry: Record "G/L Entry";
        Text000: Label 'Preview is not allowed.';
        TXT002: Label '%1, %2 %3';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode = '' then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' KENYA SHILLINGS');
            if No <> 0 then begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                //Translate KOBO to words
                if (No * 100) > 0 then begin
                    No := No * 100;
                    for Exponent := 4 downto 1 do begin
                        PrintExponent := false;
                        Ones := No div Power(1000, Exponent - 1);
                        Hundreds := Ones div 100;
                        Tens := (Ones mod 100) div 10;
                        Ones := Ones mod 10;
                        if Hundreds > 0 then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                        end;
                        if Tens >= 2 then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                            if Ones > 0 then
                                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                        end else
                            if (Tens * 10 + Ones) > 0 then
                                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                        if PrintExponent and (Exponent > 1) then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                        No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
                    end;
                end;
                //
                //AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + ' KOBO');
                AddToNoText(NoText, NoTextIndex, PrintExponent, ' CENTS');
            end;
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ONLY****');
        end;
        if CurrencyCode <> '' then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
            if No <> 0 then begin
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                AddToNoText(NoText, NoTextIndex, PrintExponent, Format(No * 100) + ' CENTS');
            end;
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ONLY');
        end;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;
}
