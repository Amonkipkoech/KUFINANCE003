report 52178738 "Purchase Requisitions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/PurchaseRequisition.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(ph; "Purchase Header")
        {
            column(No_PurchaseHeader; ph."No.")
            {
            }
            column(PaytoName_PurchaseHeader; ph."Pay-to Name")
            {
            }
            column(PostingDescription_PurchaseHeader; ph."Posting Description")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeader; ph."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeader; ph."Shortcut Dimension 2 Code")
            {
            }
            column(PostingDate_PurchaseHeader; ph."Posting Date")
            {
            }
            column(SugestedSupplierNo; ph."Buy-from Vendor No.")
            {
            }
            column(SuggestedSuppName; ph."Buy-from Vendor Name")
            {
            }
            column(BuyFromAddress; ph."Buy-from Address" + ',' + ph."Buy-from Address 2" + '-' + ph."Buy-from City")
            {
            }
            column(BuyFromContact; ph."Buy-from Post Code")
            {
            }
            column(Dept; ph."Shortcut Dimension 2 Code")
            {
            }
            column(ReqDate; ph."Requested Receipt Date")
            {
            }
            column(sign1; usersetup1."User Signature")
            {
            }
            column(sign2; usersetup2."User Signature")
            {
            }
            column(sign3; usersetup3."User Signature")
            {
            }
            column(sign4; usersetup4."User Signature")
            {
            }
            column(datetime1; signDate1)
            {
            }
            column(datetime2; signDate2)
            {
            }
            column(datetime3; signDate3)
            {
            }
            column(datetime4; signDate4)
            {
            }
            column(AppTitle1; usersetup1."Approval Title")
            {
            }
            column(AppTitle2; usersetup2."Approval Title")
            {
            }
            column(AppTitle3; usersetup3."Approval Title")
            {
            }
            column(AppTitle4; usersetup4."Approval Title")
            {
            }
            column(logo; info.Picture)
            {

            }
            column(name; info.Name)
            {

            }
            column(name2; info."Name 2")
            {

            }
            column(Address; info.Address)
            {

            }
            column(Address2; info."Address 2")
            {

            }
            column(mail; info."E-Mail")
            {

            }
            column(url; info."Home Page")
            {

            }
            column(Assigned_User_ID; "Assigned User ID")
            {

            }
            dataitem(pl; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                column(Type_PurchaseLine; pl.Type)
                {
                }
                column(No_PurchaseLine; pl."No.")
                {
                }
                column(Description_PurchaseLine; pl.Description)
                {
                }
                column(UnitofMeasure_PurchaseLine; pl."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine; pl.Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine; pl."Direct Unit Cost")
                {
                }
                column(Amount_PurchaseLine; pl.Amount)
                {
                }
                column(employeeNames; employeeNames)
                {

                }
            }

            trigger OnAfterGetRecord()
            begin
                hrEmp.Reset();
                hrEmp.SetRange(hrEmp."No.", ph."Assigned User ID");
                if hrEmp.Find('-') then begin
                    employeeNames := hrEmp."First Name" + ' ' + hrEmp."Middle Name" + ' ' + hrEmp."Last Name";
                end;
                counted := 0;
                AppReq.RESET;
                AppReq.SETRANGE("Document No.", ph."No.");
                AppReq.SETRANGE("Approved The Document", TRUE);
                IF AppReq.FIND('-') THEN BEGIN
                    REPEAT
                    BEGIN
                        counted := counted + 1;
                        IF counted = 1 THEN BEGIN
                            usersetup1.RESET;
                            usersetup1.SETRANGE(usersetup1."User ID", AppReq."Approver ID");
                            IF usersetup1.FIND('-') THEN BEGIN
                                usersetup1.CALCFIELDS("User Signature");
                                signDate1 := AppReq."Last Date-Time Modified";
                            END;
                        END ELSE
                            IF counted = 2 THEN BEGIN
                                usersetup2.RESET;
                                usersetup2.SETRANGE(usersetup2."User ID", AppReq."Approver ID");
                                IF usersetup2.FIND('-') THEN BEGIN
                                    usersetup2.CALCFIELDS("User Signature");
                                    signDate2 := AppReq."Last Date-Time Modified";
                                END;
                            END ELSE
                                IF counted = 3 THEN BEGIN
                                    usersetup3.RESET;
                                    usersetup3.SETRANGE(usersetup3."User ID", AppReq."Approver ID");
                                    IF usersetup3.FIND('-') THEN BEGIN
                                        usersetup3.CALCFIELDS("User Signature");
                                        signDate3 := AppReq."Last Date-Time Modified";
                                    END;
                                END ELSE
                                    IF counted = 4 THEN BEGIN
                                        usersetup4.RESET;
                                        usersetup4.SETRANGE(usersetup4."User ID", AppReq."Approver ID");
                                        IF usersetup4.FIND('-') THEN BEGIN
                                            usersetup4.CALCFIELDS("User Signature");
                                            signDate4 := AppReq."Last Date-Time Modified";
                                        END;
                                    END;

                    END;
                    UNTIL AppReq.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                info.Get();
                info.CalcFields(Picture);
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
        AppReq: Record "Approval Entry";
        info: Record "Company Information";
        counted: Integer;
        usersetup1: Record "User Setup";
        usersetup2: Record "User Setup";
        usersetup3: Record "User Setup";
        usersetup4: Record "User Setup";
        signDate1: DateTime;
        signDate2: DateTime;
        signDate3: DateTime;
        signDate4: DateTime;
        hrEmp: Record "HRM-Employee (D)";
        employeeNames: Text;
}
