report 52178727 "Goods Receipt (GRN)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/GoodsReceiptNoteGRN.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(prh; "Purch. Rcpt. Header")
        {
            column(No_; prh."No.")
            {
            }
            column(Project_User; prh."Buy-from Vendor No.")
            {
            }
            column(SupplierS; prh."Pay-to Vendor No.")
            {
            }
            column(Address; prh."Pay-to Address")
            {
            }
            column(Date; prh."Posting Date")
            {
            }
            column(LPO_LSO; prh."Order No.")
            {
            }
            column(VendInvNo; VendInvNo)
            {
            }
            column(Supplier_Name; prh."Pay-to Name")
            {
            }
            column(DeliveryNoteNo; DeliveryNoteNo)
            {
            }
            column(TotalCost; TotalCost)
            {
            }
            column(log; companyinfo.Picture)
            {
            }
            column(Name; companyinfo.Name)
            {
            }
            column(CAddress; companyinfo.Address)
            {
            }
            column(Mail; companyinfo."E-Mail")
            {
            }
            column(Url; companyinfo."Home Page")
            {
            }
            column(VendorShipmentNo; prh."Vendor Shipment No.")
            {
            }
            column(DeptCode; prh."Shortcut Dimension 2 Code")
            {
            }
            // column(Receiving_Staff_ID; "Receiving Staff ID")
            // {

            // }
            // column(Receiving_Staff_Id_Name; "Receiving Staff Id Name")
            // {

            // }
            dataitem(prl; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(ItemNo; prl."No.")
                {
                }
                column(Description; prl.Description)
                {
                }
                column(UnitofMeasure; prl."Unit of Measure")
                {
                }
                column(unit; prl."Unit of Measure")
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(CityOrdered; prl."Location Code")
                {
                }
                column(CityReceived; prl."Location Code")
                {
                }
                column(UnitCost; prl."Direct Unit Cost")
                {
                }
                column(QuantityOrdered; prl.Quantity)
                {
                }
                column(Total; (prl."Direct Unit Cost") * (prl.Quantity))
                {
                }
                column(QuantityReceived; prl."Quantity Invoiced")
                {
                }
                column(bal; prl.Quantity - prl."Quantity Invoiced")
                {
                }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {

                }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {

                }
            }
            dataitem(AppEntry; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = FILTER(Approved));
                column(approverIDa; AppEntry."Approver ID")
                {
                }
                column(DateModified; AppEntry."Last Date-Time Modified")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                /* donorCode:='';
                
                 dimSetEntry.RESET;
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Set ID","Purch. Rcpt. Header Replica"."Dimension Set ID");
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Code",'DONOR');
                 IF dimSetEntry.FIND('-') THEN BEGIN
                   donorCode:=dimSetEntry."Dimension Value Code";
                 END;
                
                 dimSetEntry.RESET;
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Set ID","Purch. Rcpt. Header Replica"."Dimension Set ID");
                 dimSetEntry.SETRANGE(dimSetEntry."Dimension Code",'PROJECT');
                 IF dimSetEntry.FIND('-') THEN BEGIN
                   ProjectCode:=dimSetEntry."Dimension Value Code";
                 END;
                 */
                VendInvNo := '';
                DeliveryNoteNo := '';

                PO.RESET;
                PO.SETRANGE(PO."Order No.", prh."Order No.");
                IF PO.FIND('-') THEN BEGIN
                    VendInvNo := PO."Vendor Invoice No.";
                END;
                /*
                TotalCost:=0 ;
                objGRNLN.RESET;
                objGRNLN.SETRANGE(objGRNLN."Document No.","No.");
                IF objGRNLN.FIND('-') THEN REPEAT
                 TotalCost:=TotalCost+(objGRNLN.Quantity*objGRNLN."Unit Cost (LCY)");
                UNTIL objGRNLN.NEXT=0;
                
                InspectionLn.RESET;
                InspectionLn.SETRANGE(InspectionLn."Purchase Order No.","Purch. Rcpt. Header Replica"."Order No.");
                IF InspectionLn.FIND('-') THEN BEGIN
                  DeliveryNoteNo:=InspectionLn."Delivery Note";
                END;
                
                 objLogos.RESET;
                 objLogos.SETRANGE(objLogos.Code,donorCode);
                 IF objLogos.FIND('-') THEN BEGIN
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END ELSE BEGIN
                    objLogos.SETRANGE(objLogos.Default,TRUE);
                    objLogos.CALCFIELDS(objLogos.Picture);
                 END;
                
                //CheckReport.InitTextVariable();
                //CheckReport.FormatNoText(NumberText,"Total Net Amount",'');
                 */

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

    trigger OnPreReport()
    begin
        companyinfo.GET;
        companyinfo.CALCFIELDS(companyinfo.Picture);
    end;

    var
        // objLogos: Record "61016";
        Amount: Decimal;
        CheckReport: Report Check;
        NumberText: array[2] of Text;
        dimSetEntry: Record "Dimension Set Entry";
        donorCode: Code[50];
        ProjectCode: Code[50];
        PO: Record "Purch. Inv. Header";
        VendInvNo: Code[50];
        DeliveryNoteNo: Code[10];
        TotalCost: Decimal;
        objGRNLN: Record "Purch. Rcpt. Line";
        companyinfo: Record "Company Information";
        bal: Decimal;
}