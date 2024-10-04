report 52178711 "Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SSR/ConsolidatedProcurementPlan.rdl';
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(ProcLines; "PROC-Procurement Plan Lines")
        {
            RequestFilterFields = "Budget Name";
            column(BudgetName; ProcLines."Budget Name")
            {
            }
            column(Dptmnt; ProcLines.Department)
            {
            }
            column(CampusCode; ProcLines.Campus)
            {
            }
            column(PlanPeriod; ProcLines."Procurement Plan Period")
            {
            }
            column(No; ProcLines."Type No")
            {
            }
            column(Description; ProcLines.Description)
            {
            }
            column(Quantity; ProcLines.Quantity)
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(Total; TotalQuantity)
            {
            }
            column(Amount; ProcLines.Amount)
            {
            }
            column(Unit; ProcLines.Unit)
            {
            }
            column(Category; ProcLines.Category)
            {
            }
            column(unitcost; ProcLines."Unit Cost")
            {
            }
            column(preference; ProcLines.Prefence)
            {
            }
            column(Reservation; ProcLines.Reservation)
            {
            }
            column(Q1; Q1)
            {
            }
            column(Q2; Q2)
            {
            }
            column(Q3; Q3)
            {
            }
            column(Q4; Q4)
            {
            }
            column(Category_ProcurementPlanLines; ProcLines.Category)
            {
            }
            column(A1; A1)
            {
            }
            column(A2; A2)
            {
            }
            column(A3; A3)
            {
            }
            column(A4; A4)
            {
            }
            column(Qty; TQ)
            {
            }
            column(EstCost; TU)
            {
            }
            column(TotaAmount; TA)
            {
            }
            column(BudgetAmount; Budgt)
            {
            }
            column(Methods; ProcLines."Procurement Method")
            {
            }
            column(Sourceoffunds; ProcLines."Source of Funds")
            {
            }
            column(TimeProcess; ProcLines."Time process")
            {
            }
            column(InviteAdvertiseTender; ProcLines."Bid Opening")
            {
            }
            column(EvaluateTender; ProcLines."Evaluate tender")
            {
            }
            column(CommitteeSigning; ProcLines.Committee)
            {
            }
            column(ContractSigning; ProcLines."Contract Signing")
            {
            }
            column(TotalTimetocontract; ProcLines."Total time to contract")
            {
            }
            column(TotalTimeForcompletionofcontract; ProcLines."Total time to completion")
            {
            }
            column(OpenTender; ProcLines."Open Tender")
            {
            }
            column(Notification; ProcLines.notification)
            {
            }
            column(AdvertiseTender_PROCProcurementPlanLines; ProcLines."Advertise Tender")
            {
            }
            column(BidOpening_PROCProcurementPlanLines; ProcLines."Bid Opening")
            {
            }
            column(BidEvaluation_PROCProcurementPlanLines; ProcLines."Bid Evaluation")
            {
            }
            column(TenderAward_PROCProcurementPlanLines; ProcLines."Tender Award")
            {
            }
            column(Planneddays_PROCProcurementPlanLines; ProcLines."Planned days")
            {
            }
            column(ActualDays_PROCProcurementPlanLines; ProcLines."Actual Days")
            {
            }
            column(VariancebetweenDays_PROCProcurementPlanLines; ProcLines."Variance between Days")
            {
            }
            column(Citizen; ProcLines.Citizen)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DimVal.RESET;
                DimVal.SETRANGE(DimVal.Code, ProcLines.Department);
                IF DimVal.FIND('-') THEN BEGIN
                    DeptName := DimVal.Name;
                END;
#pragma warning disable AL0667
                CurrReport.CREATETOTALS(ProcLines.Quantity);
#pragma warning restore AL0667

                Q1 := 0;
                Q2 := 0;
                Q3 := 0;
                Q4 := 0;
                A1 := 0;
                A2 := 0;
                A3 := 0;
                A4 := 0;
                TQ := 0;
                TU := 0;
                TA := 0;

                ProcPlanLine.RESET;
                ProcPlanLine.SETRANGE(ProcPlanLine."Budget Name", ProcLines."Budget Name");
                ProcPlanLine.SETRANGE(ProcPlanLine."Type No", ProcLines."Type No");
                IF ProcPlanLine.FIND('-') THEN BEGIN
                    REPEAT
                        TQ := TQ + ProcPlanLine.Quantity;
                        TU := ProcPlanLine."Unit Cost";
                        TA := TA + ProcPlanLine.Amount;

                        IF ProcPlanLine."Procurement Plan Period" = 'Q1' THEN BEGIN
                            Q1 := Q1 + ProcPlanLine.Quantity;
                            A1 := A1 + ProcPlanLine.Amount;
                        END;
                        IF ProcPlanLine."Procurement Plan Period" = 'Q2' THEN BEGIN
                            Q2 := Q2 + ProcPlanLine.Quantity;
                            A2 := A2 + ProcPlanLine.Amount;
                        END;
                        IF ProcPlanLine."Procurement Plan Period" = 'Q3' THEN BEGIN
                            Q3 := Q3 + ProcPlanLine.Quantity;
                            A3 := A3 + ProcPlanLine.Amount;
                        END;
                        IF ProcPlanLine."Procurement Plan Period" = 'Q4' THEN BEGIN
                            Q4 := Q4 + ProcPlanLine.Quantity;
                            A4 := A4 + ProcPlanLine.Amount;
                        END;
                    UNTIL ProcPlanLine.NEXT = 0;
                END;

                IF GL.GET(ProcLines."Type No") THEN BEGIN
                    GL.SETFILTER(GL."Global Dimension 2 Filter", ProcLines.Department);
                    GL.CALCFIELDS(GL."Budgeted Amount");
                    Budgt := GL."Budgeted Amount";
                END;
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
        DimVal: Record 349;
        ItemNo: Code[20];
        Description: Text[250];
        Quantity: Decimal;
        TotalQuantity: Decimal;
        PlanLines: Record "PROC-Procurement Plan Lines";
        DeptName: Text[250];
        Total: Decimal;
        ProcPlanLine: Record "PROC-Procurement Plan Lines";
        Q1: Decimal;
        Q2: Decimal;
        Q3: Decimal;
        Q5: Decimal;
        Q6: Decimal;
        Q4: Decimal;
        A1: Decimal;
        A2: Decimal;
        A3: Decimal;
        A4: Decimal;
        TQ: Decimal;
        TU: Decimal;
        TA: Decimal;
        Budgt: Decimal;
        GL: Record "G/L Account";
}

