report 52178714 "RFQ Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/RFQReport.rdl';

    dataset
    {
        dataitem("PROC-Quotation Request Vendors"; "PROC-Quotation Request Vendors")
        {
            RequestFilterFields = "Vendor No.";
            column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No__; "PROC-Quotation Request Vendors"."Document No.")
            {
            }
            column(VendorName; "PROC-Quotation Request Vendors"."Vendor Name")
            {
            }
            column(VendNos; "PROC-Quotation Request Vendors"."Vendor No.")
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
            column(Purchase_Quote_Header___Expected_Closing_Date_; "PROC-Purchase Quote Header"."Expected Closing Date")
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
            column(MMUCaption; 'TMUC')
            {
            }
            column(UNIVERSITYCaption; UNIVERSITYCaptionLbl)
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
            dataitem("PROC-Purchase Quote Header"; "PROC-Purchase Quote Header")
            {
                DataItemLink = "No." = FIELD("Document No.");
                column(Purchase_Quote_Header_Document_Type; "Document Type")
                {
                }
                column(Purchase_Quote_Header_No_; "No.")
                {
                }
                column(PostingDescription_PurchaseQuoteHeader; "PROC-Purchase Quote Header"."Posting Description")
                {
                }
                column(ExpectedClosingDate_PurchaseQuoteHeader; "PROC-Purchase Quote Header"."Expected Closing Date")
                {
                }
                column(DeptName; DeptName)
                {
                }
                dataitem("PROC-Purchase Quote Line"; "PROC-Purchase Quote Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    column(DocNos; "PROC-Quotation Request Vendors"."Document No.")
                    {
                    }
                    column(VenNaem; "PROC-Quotation Request Vendors"."Vendor Name")
                    {
                    }
                    column(VenNos; "PROC-Quotation Request Vendors"."Vendor No.")
                    {
                    }
                    column(PQITMNO; "PROC-Purchase Quote Line"."No.")
                    {
                    }
                    column(Uom; "Unit of Measure")
                    {
                    }
                    column(qty; Quantity)
                    {
                    }
                    column(Desc; "Description 2")
                    {
                    }
                    column(Desc1; "PROC-Purchase Quote Line".Description)
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
                    DimRec.SETRANGE(DimRec.Code, "PROC-Purchase Quote Header"."Shortcut Dimension 2 Code");
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
                vendor.SETRANGE(vendor."No.", "PROC-Quotation Request Vendors"."Vendor No.");
                IF vendor.FIND('-') THEN
                    vendAddress := vendor.Address;
                Pcode := vendor."Post Code";
                City := vendor.City;

                Quote.RESET;
                Quote.SETRANGE(Quote."No.", "PROC-Quotation Request Vendors"."Document No.");
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
        DocDesc: Text[30];
        DocDate: Date;
        DocNo: Integer;
        vendAddress: Text[50];
        Quote: Record "PROC-Purchase Quote Header";
        vendor: Record Vendor;
        info: Record "Company Information";
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
        TMUCCaptionLbl: Label 'TMUC';
        UNIVERSITYCaptionLbl: Label 'UNIVERSITY';
        PROCUREMENT_DEPARTMENTCaptionLbl: Label 'PROCUREMENT DEPARTMENT';
        Total_CostCaptionLbl: Label 'Total Cost';
        Expected_Closing_Date_CaptionLbl: Label 'Expected Closing Date:';
        For_Official_UseCaptionLbl: Label 'For Official Use';
        Designation_____________________________________Date_____________________________________CaptionLbl: Label '...................................... Designation:..................................  Date:....................................';
        Opened_By_CaptionLbl: Label 'Opened By:';
        Designation_____________________________________Date_____________________________________Caption_Control1102755019Lbl: Label '..................................... Designation:..................................  Date:....................................';
        Checked_By_CaptionLbl: Label 'Checked By:';
        DeptName: Text[100];
        DimRec: Record "Dimension Value";


    procedure SetRportFilt(DocType: Option "Quotation Request","Open Tender","Restricted Tender"; "DocNo.": Code[20])
    begin
        "PROC-Quotation Request Vendors".SETFILTER("Document Type", FORMAT(DocType));
        "PROC-Quotation Request Vendors".SETFILTER("Document No.", "DocNo.");
    end;
}