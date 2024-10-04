codeunit 52178718 "Workflow Setup Ext"
{

    trigger OnRun()
    begin

    end;

    var
        workflowSetup: Codeunit 1502;

        //pv
        PaymentVoucherWorkflowCategoryTxt: TextConst ENU = 'CDW';
        PaymentVoucherWorkflowCategoryDescTxt: TextConst ENU = 'Payment Voucher Document';
        PaymentVoucherApprovalWorkflowCodeTxt: TextConst ENU = 'CAPW';
        PaymentVoucherApprovalWorkfowDescTxt: TextConst ENU = 'Payment Voucher Approval Workflow';

        //imprest
        ImprestWorkflowCategoryTxt: TextConst ENU = 'IMPREST';
        ImprestWorkflowCategoryDescTxt: TextConst ENU = 'Imprest  Document';
        ImprestApprovalWorkflowCodeTxt: TextConst ENU = 'IMPREST';
        ImprestApprovalWorkfowDescTxt: TextConst ENU = 'Imprest Approval Workflow';
        //Interbank transfer
        InterBankWorkflowCategoryTxt: TextConst ENU = 'InterBank Transfer';
        InterBankWorkflowCategoryDescTxt: TextConst ENU = 'InterBank Transfer  Document';
        InterBankApprovalWorkflowCodeTxt: TextConst ENU = 'InterBank Tranfer';
        InterbankApprovalWorkfowDescTxt: TextConst ENU = 'InterBank Transfer Approval Workflow';

        //Interbank transfer
        StaffClaimWorkflowCategoryTxt: TextConst ENU = 'Staff Claim';
        StaffClaimWorkflowCategoryDescTxt: TextConst ENU = 'Staff Claim  Document';
        StaffClaimApprovalWorkflowCodeTxt: TextConst ENU = 'Staff Claim';
        StaffClaimApprovalWorkfowDescTxt: TextConst ENU = 'Staff Claim Approval Workflow';

        //Store Requisition
        StoreRequisitionWorkflowCategoryTxt: TextConst ENU = 'Store Requisition';
        StoreRequisitionWorkflowCategoryDescTxt: TextConst ENU = 'Store Requisition Document';
        StoreRequisitionApprovalWorkflowCodeTxt: TextConst ENU = 'Store Requisition';
        StoreRequisitionApprovalWorkfowDescTxt: TextConst ENU = 'Store Requisition Approval Workflow';

        //purchase Requisition
        PurchaseRequisitionWorkflowCategoryTxt: TextConst ENU = 'Purchase Requisition';
        PurchaseRequisitionWorkflowCategoryDescTxt: TextConst ENU = 'Purchase Requisition Document';
        PurchaseRequisitionApprovalWorkflowCodeTxt: TextConst ENU = 'Purchase Requisition';
        PurchaseRequisitionApprovalWorkfowDescTxt: TextConst ENU = 'Purchase Requisition Approval Workflow';

        //Surrender imprest
        ImprestSurrenderWorkflowCategoryTxt: TextConst ENU = 'Imprest Surrender';
        ImprestSurrenderWorkflowCategoryDescTxt: TextConst ENU = 'Imprest Surrender Document';
        ImprestSurrenderApprovalWorkflowCodeTxt: TextConst ENU = 'Imprest Surrender';
        ImprestSurrenderApprovalWorkfowDescTxt: TextConst ENU = 'Imprest Surrender Approval Workflow';

        //Procurement Plan
        ProcurementPlanWorkflowCategoryTxt: TextConst ENU = 'Procurement Planr';
        ProcurementPlanWorkflowCategoryDescTxt: TextConst ENU = 'Procurement Plan Document';
        ProcurementPlanApprovalWorkflowCodeTxt: TextConst ENU = 'Procurement Plan';
        ProcurementPlanApprovalWorkfowDescTxt: TextConst ENU = 'Procurement Plan Approval Workflow';

        //type condition report text
        PaymentVoucherTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="FIN-Payments Header">%1</DataItem></DataItems></ReportParameters>';
        ImprestTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="Fin-Imprest Header">%1</DataItem></DataItems></ReportParameters>';
        InterBankTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="FIN-InterBank Transfers">%1</DataItem></DataItems></ReportParameters>';
        StaffClaimTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="FIN-Staff Claims Header">%1</DataItem></DataItems></ReportParameters>';
        StoreRequisitionTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="PROC-Store Requistion Header">%1</DataItem></DataItems></ReportParameters>';
        PurchaseRequisitionTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="Purchase Header">%1</DataItem></DataItems></ReportParameters>';
        ImprestSurrenderTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="FIN-Imprest Surr. Header">%1</DataItem></DataItems></ReportParameters>';
        ProcurementPlanTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name="PROC-Procurement Plan Header">%1</DataItem></DataItems></ReportParameters>';



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        workflowSetup.InsertWorkflowCategory(PaymentVoucherWorkflowCategoryTxt, PaymentVoucherWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(ImprestWorkflowCategoryTxt, ImprestWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(InterBankWorkflowCategoryTxt, InterBankWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(StaffClaimWorkflowCategoryTxt, StaffClaimWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(StoreRequisitionWorkflowCategoryTxt, StoreRequisitionWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(PurchaseRequisitionWorkflowCategoryTxt, PurchaseRequisitionWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(ImprestSurrenderWorkflowCategoryTxt, ImprestSurrenderWorkflowCategoryDescTxt);
        workflowSetup.InsertWorkflowCategory(ProcurementPlanWorkflowCategoryTxt, ProcurementPlanWorkflowCategoryDescTxt);

    end;

    ////////////////////************ADD WORKFLOW TABLE RELATIONS***********************/////////////////
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalTableRelations()
    var
        ApprovalEntry: Record 454;

    begin
        workflowSetup.InsertTableRelation(Database::"FIN-Payments Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"FIN-Imprest Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"FIN-InterBank Transfers", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"FIN-Staff Claims Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"PROC-Store Requistion Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"Purchase Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"FIN-Imprest Surr. Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"PROC-Procurement Plan Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertApprovalWorkflowTemplate();
    end;

    local procedure InsertApprovalWorkflowTemplate()
    var
        Workflow: Record 1501;
    begin
        InsertApprovalWorkflowDetail(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);

        workflowSetup.InsertWorkflowTemplate(Workflow, PaymentVoucherApprovalWorkflowCodeTxt, PaymentVoucherApprovalWorkfowDescTxt, PaymentVoucherWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, ImprestApprovalWorkflowCodeTxt, ImprestApprovalWorkfowDescTxt, ImprestWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, InterBankApprovalWorkflowCodeTxt, InterBankApprovalWorkfowDescTxt, InterBankWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, StaffClaimApprovalWorkflowCodeTxt, StaffClaimApprovalWorkfowDescTxt, StaffClaimWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, StoreRequisitionApprovalWorkflowCodeTxt, StoreRequisitionApprovalWorkfowDescTxt, StoreRequisitionWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, PurchaseRequisitionApprovalWorkflowCodeTxt, PurchaseRequisitionApprovalWorkfowDescTxt, PurchaseRequisitionWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, ImprestSurrenderApprovalWorkfowDescTxt, ImprestSurrenderApprovalWorkfowDescTxt, ImprestSurrenderWorkflowCategoryTxt);
        workflowSetup.InsertWorkflowTemplate(Workflow, ProcurementPlanApprovalWorkfowDescTxt, ProcurementPlanApprovalWorkfowDescTxt, ProcurementPlanWorkflowCategoryTxt);

    end;

    local procedure InsertApprovalWorkflowDetail(var workflow: Record 1501)
    var
        WorkflowStepArgument: Record 1523;
        BlankDateFormula: DateFormula;
        WorkFlowEventHandlingCust: Codeunit "Workflow Event Handling Ext";
        WorkflowResponseHandling: Codeunit 1521;
        PaymentVoucher: Record "Fin-Payments Header";
        imprestHeader: Record "FIN-Imprest Header";
        interbankTransfer: Record "FIN-InterBank Transfers";
        staffClaims: Record "FIN-Staff Claims Header";
        StoreRequisition: Record "PROC-Store Requistion Header";
        purchaseRequisition: Record "Purchase Header";
        imprestSurrender: Record "FIN-Imprest Surr. Header";
        ProcurementPlan: Record "PROC-Procurement Plan Header";

    begin
        workflowSetup.PopulateWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0, '', BlankDateFormula, TRUE);
        //pv
        workflowSetup.InsertDocApprovalWorkflowSteps(
            workflow,
         BuildPaymentVoucherTypeConditions(PaymentVoucher.Status::Pending),
         WorkFlowEventHandlingCust.RunWorkFlowOnSendPaymentVoucherForApprovalCode,
         BuildPaymentVoucherTypeConditions(PaymentVoucher.Status::"Pending Approval"),
         WorkFlowEventHandlingCust.RunWorkFlowOnCancelPaymentVoucherForApprovalCode,
         WorkflowStepArgument, TRUE
        );

        //imprest
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildImprestTypeConditions(imprestHeader.Status::Pending),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestForApprovalCode,
                 BuildImprestTypeConditions(imprestHeader.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestForApprovalCode,
                 WorkflowStepArgument, TRUE
                );
        //inter bank
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildInterBankTransferTypeConditions(interbankTransfer.Status::Pending),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendInterBankTransfersForApprovalCode(),
                 BuildInterBankTransferTypeConditions(interbankTransfer.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelInterbankTransferForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );
        //Staff claim
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildStaffClaimTypeConditions(staffClaims.Status::Pending),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendStaffClaimForApprovalCode(),
                 BuildStaffClaimTypeConditions(staffClaims.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelStaffClaimForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );
        //Store requisition
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildStoreRequisitionTypeConditions(StoreRequisition.Status::Open),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendStoreRequisitionForApprovalCode(),
                 BuildStoreRequisitionTypeConditions(StoreRequisition.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelStoreRequisitionForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );

        //purchase requisition
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildPurchaseRequisitionTypeConditions(PurchaseRequisition.Status::Open),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendPurchaseRequisitionForApprovalCode(),
                 BuildPurchaseRequisitionTypeConditions(PurchaseRequisition.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );

        //imprest surrender
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildImrestSurrenderTypeConditions(imprestSurrender.Status::Pending),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendPurchaseRequisitionForApprovalCode(),
                 BuildImrestSurrenderTypeConditions(imprestSurrender.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestSurrenderForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );

        //Procurement plan
        workflowSetup.InsertDocApprovalWorkflowSteps(
                    workflow,
                 BuildProcurementPlanTypeConditions(ProcurementPlan.Status::Pending),
                 WorkFlowEventHandlingCust.RunWorkFlowOnSendProcurementPlanForApprovalCode(),
                 BuildProcurementPlanTypeConditions(ProcurementPlan.Status::"Pending Approval"),
                 WorkFlowEventHandlingCust.RunWorkFlowOnCancelProcurementPlanForApprovalCode(),
                 WorkflowStepArgument, TRUE
                );
    end;

    ///////////////////////**********************TYPE CONDITIONS***************////////////////
    /// PV
    local procedure BuildPaymentVoucherTypeConditions(Status: Integer): Text
    var
        PyamentVoucher: Record "FIN-Payments Header";
    begin
        PyamentVoucher.SetRange(Status, Status);
        exit(StrSubstNo(PaymentVoucherTypeCondTxt, workflowSetup.Encode(PyamentVoucher.GetView(false))))
    end;


    //IMPREST
    local procedure BuildImprestTypeConditions(Status: Integer): Text
    var
        imprestHeader: Record "FIN-Imprest Header";
    begin
        imprestHeader.SetRange(Status, Status);
        exit(StrSubstNo(ImprestTypeCondTxt, workflowSetup.Encode(imprestHeader.GetView(false))))
    end;
    //Staff Claims
    local procedure BuildStaffClaimTypeConditions(Status: Integer): Text
    var
        StaffClaims: Record "FIN-Staff Claims Header";
    begin
        StaffClaims.SetRange(Status, Status);
        exit(StrSubstNo(StaffClaimTypeCondTxt, workflowSetup.Encode(StaffClaims.GetView(false))))
    end;

    //InterBank
    local procedure BuildInterBankTransferTypeConditions(Status: Integer): Text
    var
        InterBankTransfer: Record "FIN-InterBank Transfers";
    begin
        InterBankTransfer.SetRange(Status, Status);
        exit(StrSubstNo(InterBankTypeCondTxt, workflowSetup.Encode(InterBankTransfer.GetView(false))))
    end;

    //Store requisition
    local procedure BuildStoreRequisitionTypeConditions(Status: Integer): Text
    var
        StoreRequisition: Record "PROC-Store Requistion Header";
    begin
        StoreRequisition.SetRange(Status, Status);
        exit(StrSubstNo(StoreRequisitionTypeCondTxt, workflowSetup.Encode(StoreRequisition.GetView(false))))
    end;

    //Purchsase requisition
    local procedure BuildPurchaseRequisitionTypeConditions(Status: Integer): Text
    var
        PurchaseRequisition: Record "Purchase Header";
    begin
        PurchaseRequisition.SetRange(Status, Status);
        exit(StrSubstNo(PurchaseRequisitionTypeCondTxt, workflowSetup.Encode(PurchaseRequisition.GetView(false))))
    end;

    //Imprest surrender
    local procedure BuildImrestSurrenderTypeConditions(Status: Integer): Text
    var
        ImprestSurrender: Record "FIN-Imprest Surr. Header";
    begin
        ImprestSurrender.SetRange(Status, Status);
        exit(StrSubstNo(ImprestSurrenderTypeCondTxt, workflowSetup.Encode(ImprestSurrender.GetView(false))))
    end;

    //Imprest surrender
    local procedure BuildProcurementPlanTypeConditions(Status: Integer): Text
    var
        ProcurementPlan: Record "PROC-Procurement Plan Header";
    begin
        ProcurementPlan.SetRange(Status, Status);
        exit(StrSubstNo(ProcurementPlanTypeCondTxt, workflowSetup.Encode(ProcurementPlan.GetView(false))))
    end;
}