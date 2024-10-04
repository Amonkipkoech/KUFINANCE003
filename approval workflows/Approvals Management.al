codeunit 52178713 "Approval Mgmnt. Ext"
{

    trigger OnRun()
    begin

    end;

    var
        WorkflowMngnt: Codeunit 1501;
        WorkFlowEventHandlingCust: Codeunit "Workflow Event Handling Ext";
        NoWorkFlowEnabledErr: TextConst ENU = 'No Approval WorkFlow for this record type is enabled';
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NothingToApproveErr: TextConst ENU = 'Lines Must Contain Record(s)';


    /////////////////////////////*******************ACTION TRIGGERS*******************************/////////////////////////
    /// 
    /// START OF PV
    [IntegrationEvent(false, false)]
    procedure OnSendPaymentVoucherForApproval(var PaymentVoucher: Record "FIN-Payments Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPaymentVoucherForApproval(var PaymentVoucher: Record "FIN-Payments Header")
    begin

    end;
    /// END OF PV TRIGGERS



    /// START OF IMPREST TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendImprestForApproval(var ImprestHeader: Record "FIN-Imprest Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelImprestForApproval(var ImprestHeader: Record "FIN-Imprest Header")
    begin

    end;
    /// END OF IMPREST TRIGGERS



    /// START OF INTERBANK TRANASFERS TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendInterbankTransferForApproval(var InterBankTransfers: Record "FIN-InterBank Transfers")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelInterbankTransferForApproval(var InterBankTransfers: Record "FIN-InterBank Transfers")
    begin

    end;

    /// END OF INTERBANK TRANASFERS TRIGGERS


    ////// START OF STAFF CLAIM TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendStaffClaimForApproval(var StaffClaims: Record "FIN-Staff Claims Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStaffClaimForApproval(var StaffClaims: Record "FIN-Staff Claims Header")
    begin

    end;
    /// END OF STAFF CLAIM TRIGGERS


    /// START OF RECEIPT TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendReceiptsForApproval(var FinReceipts: Record "FIN-Receipts Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelReceiptForApproval(var FinReceipts: Record "FIN-Receipts Header")
    begin

    end;
    /// END OF RECEIPT TRANSFERS TRIGGERS


    /// START OF STORE REQ TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendStoreRequisitionForApproval(var StoreRequisition: Record "PROC-Store Requistion Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStoreRequisitionForApproval(var StoreRequisition: Record "PROC-Store Requistion Header")
    begin

    end;

    /// END OF STORE REQ TRANSFERS TRIGGERS


    /// /// START OF purchase requisition TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseRequisitionForApproval(var PurchaseRequisition: Record "Purchase Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseRequisitionForApproval(var PurchaseRequisition: Record "Purchase Header")
    begin

    end;

    /// END OF STORE REQ TRANSFERS TRIGGERS
    /// 
    /// /// START OF IMPREST surrrender TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendImprestSurrenderForApproval(var ImprestSurrender: Record "FIN-Imprest Surr. Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelImprestSurrenderForApproval(var ImprestSurrender: Record "FIN-Imprest Surr. Header")
    begin

    end;

    //PROC-Procurement Plan Header
    /// END OF IMPREST TRIGGERS
    /// 
    /// /// START OF ProcurmentPlan TRIGGERS
    [IntegrationEvent(false, false)]
    procedure OnSendProcurementPlanForApproval(var ProcurementPlan: Record "PROC-Procurement Plan Header")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelProcurementPlanForApproval(var ProcurementPlan: Record "PROC-Procurement Plan Header")
    begin

    end;

    //PROC-Procurement Plan Header
    /// END OF ProcurmentPlan

    /////////////////////////////*******************END OF ACTION TRIGGERS*******************************/////////////////////////


    //////////////////////***************************Check if workflow is activated*************/////////////////////////////
    //PV FUNCTIONS
    procedure ChecPaymentVoucherApprovalPossible(var PayHeader: Record "FIN-Payments Header"): Boolean
    begin
        if not IsPaymentVoucherApprovalWorkFlowEnable(PayHeader) then
            Error(NoWorkflowEnabledErr);

        if not PayHeader.PayLinesExist then
            Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsPaymentVoucherApprovalWorkFlowEnable(var PayHeader: Record "FIN-Payments Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(PayHeader, WorkFlowEventHandlingCust.RunWorkFlowOnSendPaymentVoucherForApprovalCode));
    end;

    procedure CheckPaymentVoucherApprovalWorkflowEnabled(var PayHeader: Record "FIN-Payments Header"): Boolean
    begin
        if PayHeader.Status <> PayHeader.Status::Pending then
            exit(false);

        exit(IsPaymentVoucherApprovalWorkFlowEnable(PayHeader));
    end;
    //END PV FUNCTIONS


    //IMPREST FUNCTIONS
    procedure CheckImprestApprovalPossible(var ImprestHeader: Record "FIN-Imprest Header"): Boolean
    begin
        if not IsImprestApprovalWorkFlowEnable(ImprestHeader) then
            Error(NoWorkflowEnabledErr);

        // if not ImprestHeader.ImpLinesExist then
        //     Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsImprestApprovalWorkFlowEnable(var ImprestHeader: Record "FIN-Imprest Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(ImprestHeader, WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestForApprovalCode));
    end;

    procedure CheckImprestApprovalWorkflowEnabled(var ImprestHeader: Record "FIN-Imprest Header"): Boolean
    begin
        if ImprestHeader.Status <> ImprestHeader.Status::Pending then
            exit(false);

        exit(IsImprestApprovalWorkFlowEnable(ImprestHeader));
    end;
    //END IMPREST FUNCTIONS

    //INTERBANK TRANFERS FUNCTIONS
    procedure CheckInterBankTransferApprovalPossible(var InterBankTransfers: Record "FIN-InterBank Transfers"): Boolean
    begin
        if not IsInterBankTransferApprovalWorkFlowEnable(InterBankTransfers) then
            Error(NoWorkflowEnabledErr);


        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsInterBankTransferApprovalWorkFlowEnable(var InterBankTransfers: Record "FIN-InterBank Transfers"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(InterBankTransfers, WorkFlowEventHandlingCust.RunWorkFlowOnSendInterBankTransfersForApprovalCode));
    end;

    procedure CheckInterBankTransferApprovalWorkflowEnabled(var InterBankTransfers: Record "FIN-InterBank Transfers"): Boolean
    begin
        if InterBankTransfers.Status <> InterBankTransfers.Status::Pending then
            exit(false);

        exit(IsInterBankTransferApprovalWorkFlowEnable(InterBankTransfers));
    end;
    //END INTERBANK TRANSFERS FUNCTIONS


    //STAFF CLAIMS FUNCTIONS
    procedure CheckStaffClaimApprovalPossible(var StaffClaims: Record "FIN-Staff Claims Header"): Boolean
    begin
        if not IsStaffClaimApprovalWorkFlowEnable(StaffClaims) then
            Error(NoWorkflowEnabledErr);

        if not StaffClaims.ClaimLines() then
            Error(NothingToApproveErr);


        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;

    procedure IsStaffClaimApprovalWorkFlowEnable(var StaffClaims: Record "FIN-Staff Claims Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(StaffClaims, WorkFlowEventHandlingCust.RunWorkFlowOnSendStaffClaimForApprovalCode));
    end;

    procedure CheckStaffClaimApprovalWorkflowEnabled(var StaffClaims: Record "FIN-Staff Claims Header"): Boolean
    begin
        if StaffClaims.Status <> StaffClaims.Status::Pending then
            exit(false);

        exit(IsStaffClaimApprovalWorkFlowEnable(StaffClaims));
    end;
    //END STAFF CLAIMS FUNCTIONS


    //Store REQUISITION FUNCTIONS
    procedure CheckStoreRequisitionApprovalPossible(var StoreRequisition: Record "PROC-Store Requistion Header"): Boolean
    begin
        if not IsStoreRequisitionApprovalWorkFlowEnable(StoreRequisition) then
            Error(NoWorkflowEnabledErr);

        // if not StoreRequisition.RequisitionLinesExist() then
        //     Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsStoreRequisitionApprovalWorkFlowEnable(var StoreRequisition: Record "PROC-Store Requistion Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(StoreRequisition, WorkFlowEventHandlingCust.RunWorkFlowOnSendStoreRequisitionForApprovalCode));
    end;

    procedure CheckStoreRequisitionApprovalWorkflowEnabled(var StoreRequisition: Record "PROC-Store Requistion Header"): Boolean
    begin
        if StoreRequisition.Status <> StoreRequisition.Status::Open then
            exit(false);

        exit(IsStoreRequisitionApprovalWorkFlowEnable(StoreRequisition));
    end;
    //END STORE REQUISITION FUNCTIONS

    //purchase REQUISITION FUNCTIONS
    procedure CheckPurchaseRequisitionApprovalPossible(var PurchaseRequisition: Record "Purchase Header"): Boolean
    begin
        if not IsPurchaseRequisitionApprovalWorkFlowEnable(PurchaseRequisition) then
            Error(NoWorkflowEnabledErr);

        // if not StoreRequisition.RequisitionLinesExist() then
        //     Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsPurchaseRequisitionApprovalWorkFlowEnable(var PurchaseRequisition: Record "Purchase Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(PurchaseRequisition, WorkFlowEventHandlingCust.RunWorkFlowOnSendPurchaseRequisitionForApprovalCode));
    end;

    procedure CheckPurchaseRequisitionApprovalWorkflowEnabled(var PurchaseRequisition: Record "Purchase Header"): Boolean
    begin
        if PurchaseRequisition.Status <> PurchaseRequisition.Status::Open then
            exit(false);

        exit(IsPurchaseRequisitionApprovalWorkFlowEnable(PurchaseRequisition));
    end;
    //END STORE REQUISITION FUNCTIONS


    //IMPREST SURRENDER FUNCTIONS
    procedure CheckImprestSurrenderApprovalPossible(var ImprestSurrender: Record "FIN-Imprest Surr. Header"): Boolean
    begin

        if not IsImprestSurrenderApprovalWorkFlowEnable(ImprestSurrender) then
            Error(NoWorkflowEnabledErr);

        if not ImprestSurrender.SurrenderLinesExist then
            Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsImprestSurrenderApprovalWorkFlowEnable(var ImprestSurrender: Record "FIN-Imprest Surr. Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(ImprestSurrender, WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestSurrenderForApprovalCode()));
    end;

    procedure CheckImprestSurrenderApprovalWorkflowEnabled(var ImprestSurrender: Record "FIN-Imprest Surr. Header"): Boolean
    begin
        if ImprestSurrender.Status <> ImprestSurrender.Status::Pending then
            exit(false);

        exit(IsImprestSurrenderApprovalWorkFlowEnable(ImprestSurrender));
    end;
    //END IMPREST FUNCTIONS

    //procurement Plans
    procedure CheckProcurementPlanApprovalPossible(var ProcurementPlan: Record "PROC-Procurement Plan Header"): Boolean
    begin

        if not IsprocurementPlanApprovalWorkFlowEnable(ProcurementPlan) then
            Error(NoWorkflowEnabledErr);

        if not ProcurementPlan.PlanLinesExist then
            Error(NothingToApproveErr);

        // OnAfterCheckPaymentVoucherPossible(PayHeader);

        exit(true);
    end;


    procedure IsProcurementPlanApprovalWorkFlowEnable(var ProcurementPlan: Record "PROC-Procurement Plan Header"): Boolean
    begin
        exit(WorkflowMngnt.CanExecuteWorkflow(ProcurementPlan, WorkFlowEventHandlingCust.RunWorkFlowOnSendProcurementPlanForApprovalCode()));
    end;

    procedure CheckProcurementPlanApprovalWorkflowEnabled(var ProcurementPlan: Record "PROC-Procurement Plan Header"): Boolean
    begin
        if ProcurementPlan.Status <> ProcurementPlan.Status::Pending then
            exit(false);

        exit(IsProcurementPlanApprovalWorkFlowEnable(ProcurementPlan));
    end;
    //END IMPREST FUNCTIONS
    //////////////////////***************************End Check if workflow is activated*************/////////////////////////////



    ///////////////////////**************************POPULATE APPROVAL ENTRY AGRUMENT*****************////////////////////
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry";
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        payHeader: Record "Fin-Payments Header";
        imprestHeader: Record "FIN-Imprest Header";
        InterBankTransfers: Record "FIN-InterBank Transfers";
        StaffClaims: Record "FIN-Staff Claims Header";
        StoreRequisition: Record "PROC-Store Requistion Header";
        PurchaseRequisition: Record "Purchase Header";
        ImprestSurrender: Record "FIN-Imprest Surr. Header";
        ProcurementPlan: Record "PROC-Procurement Plan Header";
    begin
        case
            RecRef.Number of
            Database::"FIN-Payments Header":
                begin
                    RecRef.SetTable(payHeader);
                    ApprovalEntryArgument."Document No." := payHeader."No.";
                end;
            Database::"FIN-Imprest Header":
                begin
                    RecRef.SetTable(imprestHeader);
                    ApprovalEntryArgument."Document No." := imprestHeader."No.";
                end;
            Database::"FIN-InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    ApprovalEntryArgument."Document No." := InterBankTransfers.No;
                end;
            Database::"FIN-Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaims);
                    ApprovalEntryArgument."Document No." := StaffClaims."No.";
                end;
            Database::"PROC-Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequisition);
                    ApprovalEntryArgument."Document No." := StoreRequisition."No.";
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseRequisition);
                    ApprovalEntryArgument."Document No." := PurchaseRequisition."No.";
                end;
            Database::"FIN-Imprest Surr. Header":
                begin
                    RecRef.SetTable(ImprestSurrender);
                    ApprovalEntryArgument."Document No." := ImprestSurrender.No;
                end;
            Database::"PROC-Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlan);
                    ApprovalEntryArgument."Document No." := ProcurementPlan."Budget Name";
                end;
        end;
    end;

    //////////////////////**************************END OF POPULATE APPROVAL ENTRY AGRUMENT*****************////////////////////



    //ADDEDD LATER
    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckPaymentVoucherPossible(var PaymentVoucher: Record "FIN-Payments Header")
    begin
    end;

}