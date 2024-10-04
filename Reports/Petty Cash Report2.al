report 52178740 "Petty Cash Report2"
{
    Caption = 'Payment Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/PettyCashReport2.rdl';

    dataset
    {
        dataitem("FIN-Payments Header"; "FIN-Payments Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(BankCriteria_PaymentsHeader; "Bank Criteria")
            {
            }
            column(DOCNAME; DOCNAME)
            {
            }
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            column(CompInfoName; CompInfo.Name)
            {
            }
            column(CompInfoAddress; CompInfo.Address)
            {
            }
            column(CompInfoAddress2; CompInfo."Address 2")
            {
            }
            column(CompInfoPostCode; CompInfo."Post Code")
            {
            }
            column(CompInfoCity; CompInfo.City)
            {
            }
            column(CompInfoPhoneNo; CompInfo."Phone No.")
            {
            }
            column(CompInfoEMail; CompInfo."E-Mail")
            {
            }
            column(CompInfoHomePage; CompInfo."Home Page")
            {
            }
            column(Payments_Header__No__; "No.")
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(StrCopyText; StrCopyText)
            {
            }
            column(Payments_Header__Cheque_No__; "Cheque No.")
            {
            }
            column(Payments_Header_Payee; Payee)
            {
            }
            column(Adress1; CompInfo.Address + ', ' + CompInfo.City)
            {
            }
            column(Payments_Header__Payments_Header__Date; "FIN-Payments Header".Date)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Payments_Header__Shortcut_Dimenssion_2_Code_; "Shortcut Dimension 2 Code")
            {
            }
            column(BankName_PaymentsHeader; "Bank Name")
            {
            }
            column(USERID; UserId)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(TTotal; TTotal)
            {
            }
            column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(CurrCode_Control1102756010; CurrCode)
            {
            }
            column(CurrCode_Control1102756012; CurrCode)
            {
            }
            column(Approved_; 'Approved')
            {
                AutoFormatType = 1;
            }
            column(cashier; Cashier)
            {
            }
            column(Approval_Status_____; 'Approval Status' + ':')
            {
                AutoFormatType = 1;
            }
            column(TIME_PRINTED_____FORMAT_TIME__Control1102755003; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4__Control1102755004; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(USERID_Control1102755012; UserId)
            {
            }
            column(NumberText_1__Control1102755016; NumberText[1])
            {
            }
            column(TTotal_Control1102755034; TTotal)
            {
            }
            column(CurrCode_Control1102755035; CurrCode)
            {
            }
            column(CurrCode_Control1102755037; CurrCode)
            {
            }
            column(VATCaption; VATCaptionLbl)
            {
            }
            column(PAYMENT_DETAILSCaption; PAYMENT_DETAILSCaptionLbl)
            {
            }
            column(AMOUNTCaption; AMOUNTCaptionLbl)
            {
            }
            column(NET_AMOUNTCaption; NET_AMOUNTCaptionLbl)
            {
            }
            column(W_TAXCaption; W_TAXCaptionLbl)
            {
            }
            column(Document_No___Caption; Document_No___CaptionLbl)
            {
            }
            column(Currency_Caption; Currency_CaptionLbl)
            {
            }
            column(Payment_To_Caption; Payment_To_CaptionLbl)
            {
            }
            column(Document_Date_Caption; Document_Date_CaptionLbl)
            {
            }
            column(Cheque_No__Caption; Cheque_No__CaptionLbl)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(Payments_Header__Shortcut_Dimension_2_Code_Caption; FieldCaption("Shortcut Dimension 2 Code"))
            {
            }
            column(R_CENTERCaption; R_CENTERCaptionLbl)
            {
            }
            column(PROJECTCaption; PROJECTCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Printed_By_Caption; Printed_By_CaptionLbl)
            {
            }
            column(Amount_in_wordsCaption; Amount_in_wordsCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(RecipientCaption; RecipientCaptionLbl)
            {
            }
            column(Signature_Caption; Signature_CaptionLbl)
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(name; name)
            {
            }
            column(PaymentNarration_PaymentsHeader; "FIN-Payments Header"."Payment Narration")
            {
            }
            column(names; "name+")
            {
            }
            column(addr; addr)
            {
            }
            column(email; email)
            {
            }
            column(PIN; PIN)
            {
            }
            column(VAT; VAT)
            {
            }
            column(lpo; no)
            {
            }
            column(ret; ret)
            {
            }
            column(appliedinv; appliedinv)
            {
            }
            column(co; confir)
            {
            }
            column(next1; next1)
            {
            }
            column(DATE; dat)
            {
            }
            column(CHECKED; checked)
            {
            }
            column(PREPARED; PREPARE)
            {
            }
            column(APPROVED; appr)
            {
            }
            column(com; confirma)
            {
            }
            // column(internal;internal)
            // {
            // }
            column(paymentapp; paymentapp)
            {
            }
            column(md; md)
            {
            }
            column(authorized; Authorized)
            {
            }
            column(emptystr; emptystr)
            {
            }
            column(Name_Caption; Name_CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755013; EmptyStringCaption_Control1102755013Lbl)
            {
            }
            column(Amount_in_wordsCaption_Control1102755021; Amount_in_wordsCaption_Control1102755021Lbl)
            {
            }
            column(Printed_By_Caption_Control1102755026; Printed_By_Caption_Control1102755026Lbl)
            {
            }
            column(finance_controller; fincont)
            {
            }
            column(Accountant; accntnt)
            {
            }
            column(TotalPAYE; "FIN-Payments Header"."Total PAYE Amount")
            {
            }
            column(TotalVATWithholdingAmount_PaymentsHeader; "FIN-Payments Header"."Total VAT Withholding Amount")
            {
            }
            column(TotalCaption_Control1102755033; TotalCaption_Control1102755033Lbl)
            {
            }
            column(Paymode; "FIN-Payments Header"."Pay Mode")
            {
            }
            column(Narration; "FIN-Payments Header"."Payment Narration")
            {
            }
            column(payeeNo; "FIN-Payments Header".Payee)
            {
            }
            column(VendNo; "FIN-Payments Header"."Vendor No.")
            {
            }
            column(VendName; "FIN-Payments Header"."Vendor Name")
            {
            }
            column(On_Behalf_Of; "On Behalf Of")
            {

            }
            column(Paying_Bank_Account; "Paying Bank Account")
            {

            }

            column(vendAddr; vends.Address + ' ' + vends."Address 2" + ', ' + vends.City)
            {
            }
            dataitem("<Payment Line>"; "FIN-Payment Line")
            {
                DataItemLink = No = FIELD("No.");
                DataItemTableView = SORTING("Line No.", No, Type) ORDER(Ascending);
                column(Payment_Line__Net_Amount__; "Net Amount")
                {
                }
                column(Payment_Line_Amount; Amount)
                {
                }

                column(Transaction_Name_______Account_No________Account_Name_____; "Transaction Name" + '[' + "Account No." + ':' + "Account Name" + ']')
                {
                }
                column(Payment_Line__Withholding_Tax_Amount_; "Withholding Tax Amount")
                {
                }
                column(Account_Name; "Account Name")
                {

                }
                column(ID; id)
                {
                }
                column(Payment_Line__VAT_Amount_; "VAT Amount")
                {
                }
                column(Department; "Global Dimension 1 Code")
                {
                }
                column(witheld6; "VAT Withheld Amount")
                {
                }
                column(Projects; "Shortcut Dimension 2 Code")
                {
                }
                column(Payment_Line_Line_No_; "Line No.")
                {
                }
                column(Payment_Line_No; No)
                {
                }
                column(Retention; "Retention  Amount")
                {
                }
                column(Payment_Line_Type; Type)
                {
                }
                column(PAYEAmount_PaymentLine; "<Payment Line>"."PAYE Amount")
                {
                }
                column(Account; "<Payment Line>"."Account No.")
                {
                }
                column(VATWithheldAmount_PaymentLine; "<Payment Line>"."VAT Withheld Amount")
                {
                }
                column(payee; "<Payment Line>".Payee)
                {
                }
                column(Ac_Charged; payTypes."G/L Account")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENTS');
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;

                    TTotal := TTotal + "Net Amount";

                    payTypes.Reset;
                    payTypes.SetRange(payTypes.Code, "<Payment Line>".Type);
                    if payTypes.Find('-') then begin
                    end;
                end;
            }
            dataitem(Total; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    /*CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NumberText,TTotal,'');*/

                end;
            }
            dataitem(Summary; "FIN-Payment Line")
            {
                DataItemLink = No = FIELD("No.");
                DataItemTableView = SORTING("Line No.", No, Type) ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENTS');
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;

                    STotal := STotal + "Net Amount";
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            }
            dataitem("FIN-CshMgt Application"; "FIN-CshMgt Application")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line Number") ORDER(Ascending) WHERE("Document Type" = CONST(PV));
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = CONST(Approved), "Approved The Document" = FILTER(true));
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified")
                {
                }
                dataitem("User Setup"; "User Setup")
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(Signature_UserSetup; "User Setup"."User Signature")
                    {
                    }
                    column(ApprovalDesignation_UserSetup; "User Setup"."Approval Title")
                    {
                    }
                }

                trigger OnPreDataItem()
                begin
                    "Approval Entry".SetRange("Approval Entry".Status, "Approval Entry".Status::Approved)
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);


                if vends.Get("FIN-Payments Header"."Vendor No.") then begin
                end;
                StrCopyText := '';
                if "No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;
                TTotal := 0;

                if "FIN-Payments Header"."Payment Type" = "FIN-Payments Header"."Payment Type"::Normal then
                    DOCNAME := 'PAYMENT VOUCHER'
                else
                    DOCNAME := 'PETTY CASH VOUCHER';

                //Set currcode to Default if blank
                GLSetup.Get();
                if "FIN-Payments Header"."Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "FIN-Payments Header"."Currency Code";

                //For Inv Curr Code
                if "FIN-Payments Header"."Invoice Currency Code" = '' then begin
                    InvoiceCurrCode := GLSetup."LCY Code";
                end else
                    InvoiceCurrCode := "FIN-Payments Header"."Invoice Currency Code";

                //End;
                CalcFields("Total Payment Amount", "Total Witholding Tax Amount", "FIN-Payments Header"."Total Net Amount");
                // CheckReport.InitTextVariable();
                // CheckReport.FormatNoText(NumberText,("FIN-Payments Header"."Total Net Amount"),'');
            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview = false then begin
                    "No. Printed" := "No. Printed" + 1;
                    Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FieldNo("No.");
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
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
        StrCopyText: Text[30];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimVal: Record "Dimension Value";
        DimValName: Text[100];
        TTotal: Decimal;
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        STotal: Decimal;
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
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
        addr: Label 'P.O. BOX 390, MARAGOLI';
        email: Label 'P.O. BOX 390, MARAGOLI';
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
        // internal: Label 'Internal Audit Manage';
        paymentapp: Label 'Payment Approved:';
        md: Label 'Managing Director:';
        Authorized: Label 'Authorized.';
        emptystr: Label '========================================================================================================================================';
        id: Label 'ID No:';
        accntnt: Label 'Accountant:';
        fincont: Label 'Financial Controller:';
        payTypes: Record "FIN-Receipts and Payment Types";
        vends: Record Vendor;
}