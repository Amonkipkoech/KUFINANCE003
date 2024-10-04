report 52178702 "Consolidate Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Procurement/reportlayouts/Consolidate Procurement Plan.rdl';

    dataset
    {
        dataitem("PROC-Procurement Plan Lines"; "PROC-Procurement Plan Lines")
        {
            RequestFilterFields = "Budget Name", Type, Category, "Procurement Plan Period", Department;
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Procurement_Plan_Lines__Budget_Name_; "Budget Name")
            {
            }
            column(Procurement_Plan_Lines_Department; Department)
            {
            }
            column(Procurement_Plan_Lines_Type; Type)
            {
            }
            column(Procurement_Plan_Lines__Type_No_; "Type No")
            {
            }
            column(Procurement_Plan_Lines_Description; Description)
            {
            }
            column(Procurement_Plan_Lines_Quantity; Quantity)
            {
            }
            column(Procurement_Plan_Lines__Unit_Cost_; "Unit Cost")
            {
            }
            column(Procurement_Plan_Lines_Amount; Amount)
            {
            }
            column(Procurement_Plan_Lines_Amount_Control1102755000; Amount)
            {
            }
            column(Procurement_Plan_Lines_Quantity_Control1102755007; Quantity)
            {
            }
            column(Procurement_Plan_LinesCaption; Procurement_Plan_LinesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Procurement_Plan_Lines__Budget_Name_Caption; FieldCaption("Budget Name"))
            {
            }
            column(Procurement_Plan_Lines_DepartmentCaption; FieldCaption(Department))
            {
            }
            column(Procurement_Plan_Lines_TypeCaption; FieldCaption(Type))
            {
            }
            column(Procurement_Plan_Lines__Type_No_Caption; FieldCaption("Type No"))
            {
            }
            column(Procurement_Plan_Lines_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Procurement_Plan_Lines_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Procurement_Plan_Lines__Unit_Cost_Caption; FieldCaption("Unit Cost"))
            {
            }
            column(Procurement_Plan_Lines_AmountCaption; FieldCaption(Amount))
            {
            }
            column(Procurement_Plan_Lines_Campus; Campus)
            {
            }
            column(Procurement_Plan_Lines_Procurement_Plan_Period; "Procurement Plan Period")
            {
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

    var
        Procurement_Plan_LinesCaptionLbl: Label 'Procurement Plan Lines';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

