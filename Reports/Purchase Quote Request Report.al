report 52178732 "Purchase Quote Report"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Reports/SSR/PurchaseQuoteRequestReport.rdl';

    dataset
    {
        dataitem(QVendors; "PROC-Quotation Request Vendors")
        {
            RequestFilterFields = "Vendor No.";
            column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No__; QVendors."Document No.")
            {
            }
            column(VendorName; QVendors."Vendor Name")
            {
            }
            column(vendAddress______Pcode; vendAddress + '-' + Pcode)
            {
            }
            column(TODAY; TODAY)
            {
            }
            column(info_Name; info.Name)
            {
            }
            column(info_PhoneNo; info."Phone No.")
            {

            }
            column(info_EMail; info."E-Mail")
            {
            }
            column(info_HomePage; info."Home Page")
            {
            }
            column(info_Address_____info__Post_Code_; info.Address + '-' + info."Post Code")
            {
            }
            column(City; City)
            {
            }
            column(info_City; info.City)
            {
            }
            column(CompanyLogo; info.Picture)
            {
            }
            column(Purchase_Quote_Header___Expected_Closing_Date_; QVendors."Expected Closing Date")
            {
            }
            column(Days_to_DeliverCaption; Days_to_DeliverCaptionLbl)
            {
            }
            column(BrandCaption; BrandCaptionLbl)
            {
            }
            column(Unit_PriceCaption; Unit_PriceCaptionLbl)
            {
            }
            column(QtyCaption; QtyCaptionLbl)
            {
            }
            column(UnitCaption; UnitCaptionLbl)
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(CodeCaption; CodeCaptionLbl)
            {
            }
            column(Buyer_s_Destination_and_Address_Caption; Buyer_s_Destination_and_Address_CaptionLbl)
            {
            }
            column(From_Caption; From_CaptionLbl)
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(Quotation_No__Caption; Quotation_No__CaptionLbl)
            {
            }
            column(Seller_s_Name_and_Address_Caption; Seller_s_Name_and_Address_CaptionLbl)
            {
            }
            column(To_Caption; To_CaptionLbl)
            {
            }
            column(REQUEST_FOR_QUOTATION_FORMCaption; REQUEST_FOR_QUOTATION_FORMCaptionLbl)
            {
            }
            column(Authorized_by_Caption; Authorized_by_CaptionLbl)
            {
            }
            column(Procurement_Officer_____________________________________________________________Caption; Procurement_Officer_____________________________________________________________CaptionLbl)
            {
            }
            column(PLEASE_GIVE_US_URGENT_QUOTATIONS_FOR_THE_FOLLOWING_GOODS_AND_SERVICES_Caption; PLEASE_GIVE_US_URGENT_QUOTATIONS_FOR_THE_FOLLOWING_GOODS_AND_SERVICES_CaptionLbl)
            {
            }
            column(MMUCaption; '')
            {
            }
            column(UniversityCaption; UniversityCaptionLbl)
            {
            }
            column(PROCUREMENT_DEPARTMENTCaption; PROCUREMENT_DEPARTMENTCaptionLbl)
            {
            }
            column(Total_CostCaption; Total_CostCaptionLbl)
            {
            }
            column(Expected_Closing_Date_Caption; Expected_Closing_Date_CaptionLbl)
            {
            }
            column(Quotation_Request_Vendors_Document_Type; "Document Type")
            {
            }
            column(Quotation_Request_Vendors_Vendor_No_; "Vendor No.")
            {
            }
            dataitem(PurchQuote; "PROC-Purchase Quote Header")
            {
                DataItemLink = "No." = FIELD("Document No."),
                               "Document Type" = FIELD("Document Type");
                column(Purchase_Quote_Header_Document_Type; "Document Type")
                {
                }
                column(Purchase_Quote_Header_No_; "No.")
                {
                }
                column(PostingDescription_PurchaseQuoteHeader; PurchQuote."Posting Description")
                {
                }
                column(ExpectedClosingDate_PurchaseQuoteHeader; PurchQuote."Expected Closing Date")
                {
                }
                column(DeptName; DeptName)
                {
                }
                dataitem(PurchLine; "PROC-Purchase Quote Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    column(Purchase_Quote_Line__Purchase_Quote_Line___No__; PurchLine."No.")
                    {
                    }
                    column(Purchase_Quote_Line__Unit_of_Measure_; "Unit of Measure")
                    {
                    }
                    column(Purchase_Quote_Line_Quantity; Quantity)
                    {
                    }
                    column(Purchase_Quote_Line__Description_2_; "Description 2")
                    {
                    }
                    column(For_Official_UseCaption; For_Official_UseCaptionLbl)
                    {
                    }
                    column(Designation_____________________________________Date_____________________________________Caption; Designation_____________________________________Date_____________________________________CaptionLbl)
                    {
                    }
                    column(Opened_By_Caption; Opened_By_CaptionLbl)
                    {
                    }
                    column(Designation_____________________________________Date_____________________________________Caption_Control1102755019; Designation_____________________________________Date_____________________________________Caption_Control1102755019Lbl)
                    {
                    }
                    column(THIS_QUOTATION_IS_SUBJECT_TO_PUBLIC_PROCUREMENT_AND_DISPOSAL_ACT_2005Caption; 'THIS_QUOTATION_IS_SUBJECT_TO_PUBLIC_PROCUREMENT_AND_DISPOSAL_ACT_2005CaptionLbl')
                    {
                    }
                    column(i___Your_Prices_must_be_valid_for_at_least_90_days_and_include_16__VAT_where_chargeable_Caption; 'i___Your_Prices_must_be_valid_for_at_least_90_days_and_include_16__VAT_where_chargeable_CaptionLbl')
                    {
                    }
                    column(ii___You_should_submit_samples_and__or_catalogue_for_technical_evaluation_where_possible_Caption; 'ii___You_should_submit_samples_and__or_catalogue_for_technical_evaluation_where_possible_CaptionLbl')
                    {
                    }
                    column(DataItem1102755035; 'iii___Quote_in_black_ink__stamp__sign_this_form_and_drop_sealed_envelope_marked_with_No__in_the_question_box_at_procurement_oLbl')
                    {
                    }
                    column(iv___The_University_transacts_business_using_Local_Purchase_Orders__LPO__Only_Caption; 'iv___The_University_transacts_business_using_Local_Purchase_Orders__LPO__Only_CaptionLbl')
                    {
                    }
                    column(v___Goods_should_be_delivered_to_User_Department_immediately_after_issue_of_the_LPO_Caption; 'v___Goods_should_be_delivered_to_User_Department_immediately_after_issue_of_the_LPO_CaptionLbl')
                    {
                    }
                    column(vi___The_deliveries_should_be_accompanied_by_a_delivery_note_and_a_Tax___ETR_Legal_ReceiptCaption; 'vi___The_deliveries_should_be_accompanied_by_a_delivery_note_and_a_Tax___ETR_Legal_ReceiptCaptionLbl')
                    {
                    }
                    column(DataItem1102755040; 'vii___Payments_for_goods_and_services_shall_be_made_only_after_complete_delivery_or_successful_perfomance_of_the_contract_CapLbl')
                    {
                    }
                    column(DataItem1102755041; 'SUPPLIER_S_SIGN_AND_STAMP_______________________________________________________DATE_________________________________________Lbl')
                    {
                    }
                    column(Checked_By_Caption; Checked_By_CaptionLbl)
                    {
                    }
                    column(Purchase_Quote_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Purchase_Quote_Line_Document_No_; "Document No.")
                    {
                    }
                    column(Purchase_Quote_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Purchase_Quote_Line_Description; Description)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    DimRec.RESET;
                    DimRec.SETRANGE(DimRec.Code, PurchQuote."Shortcut Dimension 2 Code");
                    IF DimRec.FIND('-') THEN
                        DeptName := DimRec.Name;
                end;

                trigger OnPreDataItem()
                begin
                    info.RESET;
                    info.GET();
                    info.CALCFIELDS(Picture);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                vendor.RESET;
                vendor.SETRANGE(vendor."No.", QVendors."Vendor No.");
                IF vendor.FIND('-') THEN
                    vendAddress := vendor.Address;
                Pcode := vendor."Post Code";
                City := vendor.City;

                Quote.RESET;
                Quote.SETRANGE(Quote."No.", QVendors."Document No.");
                Quote.SETRANGE(Quote."Document Type", Quote."Document Type"::"Quotation Request");
                IF Quote.FIND('-') THEN
                    DocDesc := Quote."Posting Description";
                //    DocDesc:=
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
        DocDesc: Text[100];
        DocDate: Date;
        DocNo: Integer;
        vendAddress: Text[50];
        Quote: Record "PROC-Purchase Quote Header";
        vendor: Record "Vendor";
        info: Record 79;
        Pcode: Code[20];
        City: Code[20];
        Days_to_DeliverCaptionLbl: Label 'Days to Deliver';
        BrandCaptionLbl: Label 'Brand';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        QtyCaptionLbl: Label 'Qty';
        UnitCaptionLbl: Label 'Unit';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        CodeCaptionLbl: Label 'Code';
        Buyer_s_Destination_and_Address_CaptionLbl: Label 'Buyer''s Destination and Address:';
        From_CaptionLbl: Label 'From:';
        Date_CaptionLbl: Label 'Date:';
        Quotation_No__CaptionLbl: Label 'Quotation No.:';
        Seller_s_Name_and_Address_CaptionLbl: Label 'Seller''s Name and Address:';
        To_CaptionLbl: Label 'To:';
        REQUEST_FOR_QUOTATION_FORMCaptionLbl: Label 'REQUEST FOR QUOTATION FORM';
        Authorized_by_CaptionLbl: Label 'Authorized by:';
        Procurement_Officer_____________________________________________________________CaptionLbl: Label 'Procurement Officer.............................................................';
        PLEASE_GIVE_US_URGENT_QUOTATIONS_FOR_THE_FOLLOWING_GOODS_AND_SERVICES_CaptionLbl: Label 'PLEASE GIVE US URGENT QUOTATIONS FOR THE FOLLOWING GOODS AND SERVICES:';
        kilimamboCaptionLbl: Label 'MASENO UNIVERSITY';
        UniversityCaptionLbl: Label 'University';
        PROCUREMENT_DEPARTMENTCaptionLbl: Label 'PROCUREMENT DEPARTMENT';
        Total_CostCaptionLbl: Label 'Total Cost';
        Expected_Closing_Date_CaptionLbl: Label 'Expected Closing Date:';
        For_Official_UseCaptionLbl: Label 'For Official Use';
        Designation_____________________________________Date_____________________________________CaptionLbl: Label '...................................... Designation:..................................  Date:....................................';
        Opened_By_CaptionLbl: Label 'Opened By:';
        Designation_____________________________________Date_____________________________________Caption_Control1102755019Lbl: Label '..................................... Designation:..................................  Date:....................................';
        // THIS_QUOTATION_IS_SUBJECT_TO_PUBLIC_PROCUREMENT_AND_DISPOSAL_ACT_2005CaptionLbl: Label 'THIS QUOTATION IS SUBJECT TO PUBLIC PROCUREMENT AND DISPOSAL ACT 2005';
        // i___Your_Prices_must_be_valid_for_at_least_90_days_and_include_16__VAT_where_chargeable_CaptionLbl: Label 'i.  Your Prices must be valid for at least 90 days and include 16% VAT where chargeable.';
        // ii___You_should_submit_samples_and__or_catalogue_for_technical_evaluation_where_possible_CaptionLbl: Label 'ii.  You should submit samples and /or catalogue for technical evaluation where possible.';
        // iii___Quote_in_black_ink__stamp__sign_this_form_and_drop_sealed_envelope_marked_with_No__in_the_question_box_at_procurement_oLbl: Label 'iii.  Quote in black ink, stamp, sign this form and drop sealed envelope marked with No. in the question box at procurement office.';
        // iv___The_University_transacts_business_using_Local_Purchase_Orders__LPO__Only_CaptionLbl: Label 'iv.  The University transacts business using Local Purchase Orders (LPO) Only.';
        // v___Goods_should_be_delivered_to_User_Department_immediately_after_issue_of_the_LPO_CaptionLbl: Label 'v.  Goods should be delivered to User Department immediately after issue of the LPO.';
        // vi___The_deliveries_should_be_accompanied_by_a_delivery_note_and_a_Tax___ETR_Legal_ReceiptCaptionLbl: Label 'vi.  The deliveries should be accompanied by a delivery note and a Tax + ETR Legal Receipt';
        // vii___Payments_for_goods_and_services_shall_be_made_only_after_complete_delivery_or_successful_perfomance_of_the_contract_CapLbl: Label 'vii.  Payments for goods and services shall be made only after complete delivery or successful perfomance of the contract.';
        // SUPPLIER_S_SIGN_AND_STAMP_______________________________________________________DATE_________________________________________Lbl: Label 'SUPPLIER''S SIGN AND STAMP.......................................................DATE........................................................';
        Checked_By_CaptionLbl: Label 'Checked By:';
        DeptName: Text[100];
        DimRec: Record "Dimension Value";

    //[Scope('Internal')]
    procedure SetRportFilt(DocType: Option "Quotation Request",Quote,"Open Tender","Restricted Tender"; "DocNo.": Code[20])
    begin
        PurchQuote.SETFILTER("Document Type", FORMAT(DocType));
        PurchQuote.SETFILTER("No.", "DocNo.");
    end;
}