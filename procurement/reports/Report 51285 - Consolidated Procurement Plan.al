report 52178701 "Consolidated Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Procurement/reportlayouts/Consolidated Procurement Plan.rdl';

    dataset
    {
        dataitem("PROC-Procurement Plan Lines"; "PROC-Procurement Plan Lines")
        {
            column(BudgetName; "PROC-Procurement Plan Lines"."Budget Name")
            {
            }
            column(Dptmnt; "PROC-Procurement Plan Lines".Department)
            {
            }
            column(CampusCode; "PROC-Procurement Plan Lines".Campus)
            {
            }
            column(PlanPeriod; "PROC-Procurement Plan Lines"."Procurement Plan Period")
            {
            }
            column(No; "PROC-Procurement Plan Lines"."Type No")
            {
            }
            column(Description; "PROC-Procurement Plan Lines".Description)
            {
            }
            column(Quantity; "PROC-Procurement Plan Lines".Quantity)
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(Total; TotalQuantity)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "PROC-Procurement Plan Lines".Department);
                if DimVal.Find('-') then begin
                    DeptName := DimVal.Name;
                end;
                CurrReport.CreateTotals("PROC-Procurement Plan Lines".Quantity);
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
        DimVal: Record "Dimension Value";
        ItemNo: Code[20];
        Description: Text[250];
        Quantity: Decimal;
        TotalQuantity: Decimal;
        PlanLines: Record "PROC-Procurement Plan Lines";
        DeptName: Text[250];
        Total: Decimal;
}

