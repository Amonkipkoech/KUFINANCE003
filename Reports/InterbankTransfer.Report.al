report 52178736 "Interbank Transfers"

{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSRInterbankDetails.rdl';

    dataset
    {
        dataitem(interTransfer; "FIN-InterBank Transfers")
        {
            DataItemTableView = SORTING(No);
            RequestFilterFields = No;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(CompInfo_Address2; CompInfo."Address 2")
            {
            }
            column(CompInfo_Home_Page; CompInfo."Home Page")
            {
            }
            column(CompInfo_EMail; CompInfo."E-Mail")
            {
            }
            column(InterBank_Transfers_Date; Date)
            {
            }
            column(InterBank_Transfers_No; No)
            {
            }
            column(InterBank_Transfers_Status; Status)
            {
            }
            column(InterBank_Transfers__Receipt_Resp_Centre_; "Receipt Resp Centre")
            {
            }
            column(Receiving_Account_______Receiving_Bank_Account_Name_; "Receiving Account" + ':' + "Receiving Bank Account Name")
            {
            }
            column(InterBank_Transfers__Currency_Code_Destination_; "Currency Code Destination")
            {
            }
            column(InterBank_Transfers__Amount_2_; "Amount 2")
            {
            }
            column(InterBank_Transfers__Exch__Rate_Destination_; "Exch. Rate Destination")
            {
            }
            column(InterBank_Transfers__Request_Amt_LCY_; "Request Amt LCY")
            {
            }
            column(InterBank_Transfers__Sending_Resp_Centre_; "Sending Resp Centre")
            {
            }
            column(Paying_Account_______Paying__Bank_Account_Name_; "Paying Account" + ':' + "Paying  Bank Account Name")
            {
            }
            column(InterBank_Transfers__Currency_Code_Source_; "Currency Code Source")
            {
            }
            column(InterBank_Transfers_Amount; Amount)
            {
            }
            column(InterBank_Transfers__Exch__Rate_Source_; "Exch. Rate Source")
            {
            }
            column(InterBank_Transfers__Pay_Amt_LCY_; "Pay Amt LCY")
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PAGENO)
            // {
            // }
            column(Bank_and_Cash_TransferCaption; Bank_and_Cash_TransferCaptionLbl)
            {
            }
            column(InterBank_Transfers_DateCaption; FIELDCAPTION(Date))
            {
            }
            column(InterBank_Transfers_NoCaption; FIELDCAPTION(No))
            {
            }
            column(InterBank_Transfers_StatusCaption; FIELDCAPTION(Status))
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(InterBank_Transfers__Receipt_Resp_Centre_Caption; FIELDCAPTION("Receipt Resp Centre"))
            {
            }
            column(Receiving_BankCaption; Receiving_BankCaptionLbl)
            {
            }
            column(Currency_CodeCaption; Currency_CodeCaptionLbl)
            {
            }
            column(ExternalDocNo; interTransfer."External Doc No.")
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(InterBank_Transfers__Exch__Rate_Destination_Caption; FIELDCAPTION("Exch. Rate Destination"))
            {
            }
            column(InterBank_Transfers__Request_Amt_LCY_Caption; FIELDCAPTION("Request Amt LCY"))
            {
            }
            column(InterBank_Transfers__Sending_Resp_Centre_Caption; FIELDCAPTION("Sending Resp Centre"))
            {
            }
            column(Paying_BankCaption; Paying_BankCaptionLbl)
            {
            }
            column(Currency_CodeCaption_Control1102756045; Currency_CodeCaption_Control1102756045Lbl)
            {
            }
            column(InterBank_Transfers_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(InterBank_Transfers__Exch__Rate_Source_Caption; FIELDCAPTION("Exch. Rate Source"))
            {
            }
            column(Transferred_Amt_LCYCaption; Transferred_Amt_LCYCaptionLbl)
            {
            }
            column(Request_DetailsCaption; Request_DetailsCaptionLbl)
            {
            }
            column(Source_DetailsCaption; Source_DetailsCaptionLbl)
            {
            }
            column(Signature_Caption; Signature_CaptionLbl)
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(Name_Caption; Name_CaptionLbl)
            {
            }
            column(Name_Caption_Control1102756018; Name_Caption_Control1102756018Lbl)
            {
            }
            column(CreatedBy_InterBankTransfers; interTransfer."Created By")
            {
            }
            column(Date_Caption_Control1102756019; Date_Caption_Control1102756019Lbl)
            {
            }
            column(Signature_Caption_Control1102756022; Signature_Caption_Control1102756022Lbl)
            {
            }
            column(AuthorisationsCaption; AuthorisationsCaptionLbl)
            {
            }
            column(AuthorisationsCaption_Control1102756028; AuthorisationsCaption_Control1102756028Lbl)
            {
            }
            column(Signature_Caption_Control1102756031; Signature_Caption_Control1102756031Lbl)
            {
            }
            column(Date_Caption_Control1102756034; Date_Caption_Control1102756034Lbl)
            {
            }
            column(Name_Caption_Control1102756037; Name_Caption_Control1102756037Lbl)
            {
            }
            column(RecipientCaption; RecipientCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102756003; EmptyStringCaption_Control1102756003Lbl)
            {
            }
            column(EmptyStringCaption_Control1102756043; EmptyStringCaption_Control1102756043Lbl)
            {
            }
            dataitem(AppEntry; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD(No);
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(ApproverID_ApprovalEntry; AppEntry."Approver ID")
                {
                }
                column(LastDateTimeModified_ApprovalEntry; AppEntry."Last Date-Time Modified")
                {
                }
                dataitem(userSetup; "User Setup")
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(Signature_UserSetup; userSetup."User Signature")
                    {
                    }
                    column(ApprovalDesignation_UserSetup; userSetup."Approval Title")
                    {
                    }
                }

                trigger OnPreDataItem()
                begin
                    AppEntry.SETRANGE(AppEntry.Status, AppEntry.Status::Approved)
                end;
            }
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

    trigger OnPreReport()
    begin
        IF CompInfo.GET() THEN
            CompInfo.CALCFIELDS(CompInfo.Picture);
    end;

    var
        Bank_and_Cash_TransferCaptionLbl: Label 'Bank and Cash Transfer';
        EmptyStringCaptionLbl: Label '===============================================================================================================================================';
        Receiving_BankCaptionLbl: Label 'Receiving Bank';
        Currency_CodeCaptionLbl: Label 'Currency Code';
        AmountCaptionLbl: Label 'Amount';
        Paying_BankCaptionLbl: Label 'Paying Bank';
        Currency_CodeCaption_Control1102756045Lbl: Label 'Currency Code';
        Transferred_Amt_LCYCaptionLbl: Label 'Transferred Amt LCY';
        Request_DetailsCaptionLbl: Label 'Request Details';
        Source_DetailsCaptionLbl: Label 'Source Details';
        Signature_CaptionLbl: Label 'Signature:';
        Date_CaptionLbl: Label 'Date:';
        Name_CaptionLbl: Label 'Name:';
        Name_Caption_Control1102756018Lbl: Label 'Name:';
        Date_Caption_Control1102756019Lbl: Label 'Date:';
        Signature_Caption_Control1102756022Lbl: Label 'Signature:';
        AuthorisationsCaptionLbl: Label 'Authorisations';
        AuthorisationsCaption_Control1102756028Lbl: Label 'Authorisations';
        Signature_Caption_Control1102756031Lbl: Label 'Signature:';
        Date_Caption_Control1102756034Lbl: Label 'Date:';
        Name_Caption_Control1102756037Lbl: Label 'Name:';
        RecipientCaptionLbl: Label 'Recipient';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        EmptyStringCaption_Control1102756003Lbl: Label '===============================================================================================================================================';
        EmptyStringCaption_Control1102756043Lbl: Label '===============================================================================================================================================';
        CompInfo: Record "Company Information";
}
