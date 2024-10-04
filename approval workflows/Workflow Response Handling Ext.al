codeunit 52178712 "Workflow Response Handling Ext"
{

    trigger OnRun()
    begin

    end;

    ///////////////////************ RE-OPEN DOCUMENT *******//////////////////////

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        paymentVoucher: Record "FIN-Payments Header";
        imprestHeader: Record "FIN-Imprest Header";
        interBankTransfer: Record "FIN-InterBank Transfers";
        StaffClaims: Record "FIN-Staff Claims Header";
        StoreRequisition: Record "PROC-Store Requistion Header";
        PurchaseRequisition: Record "Purchase Header";
        ImprestSurrender: Record "FIN-Imprest Surr. Header";
        ProcurementPlan: Record "PROC-Procurement Plan Header";
    begin
        case RecRef.Number of
            database::"FIN-Payments Header":
                begin
                    RecRef.SetTable(paymentVoucher);
                    paymentVoucher.Status := paymentVoucher.Status::Pending;
                    paymentVoucher.Modify();
                    Handled := true;
                end;
            database::"FIN-Imprest Header":
                begin
                    RecRef.SetTable(imprestHeader);
                    imprestHeader.Status := imprestHeader.Status::Pending;
                    imprestHeader.Modify();
                    Handled := true;
                end;
            database::"FIN-InterBank Transfers":
                begin
                    RecRef.SetTable(interBankTransfer);
                    interBankTransfer.Status := interBankTransfer.Status::Pending;
                    interBankTransfer.Modify();
                    Handled := true;
                end;
            database::"FIN-Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaims);
                    StaffClaims.Status := StaffClaims.Status::Pending;
                    StaffClaims.Modify();
                    Handled := true;
                end;
            database::"PROC-Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequisition);
                    StoreRequisition.Status := StoreRequisition.Status::Open;
                    StoreRequisition.Modify();
                    Handled := true;
                end;
            database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseRequisition);
                    PurchaseRequisition.Status := PurchaseRequisition.Status::Open;
                    PurchaseRequisition.Modify();
                    Handled := true;
                end;
            database::"FIN-Imprest Surr. Header":
                begin
                    RecRef.SetTable(ImprestSurrender);
                    ImprestSurrender.Status := ImprestSurrender.Status::Pending;
                    ImprestSurrender.Modify();
                    Handled := true;
                end;
            database::"PROC-Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlan);
                    ProcurementPlan.Status := ProcurementPlan.Status::Pending;
                    ProcurementPlan.Modify();
                    Handled := true;
                end;
        end;
    end;

    ///////////////////************ SET STATUS TO APPROVED/RELEASED*******//////////////////////

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        paymentVoucher: Record "FIN-Payments Header";
        imprestHeader: Record "FIN-Imprest Header";
        interBankTransfer: Record "FIN-InterBank Transfers";
        StaffClaims: Record "FIN-Staff Claims Header";
        StoreRequisition: Record "PROC-Store Requistion Header";
        PurchaseRequisition: Record "Purchase Header";
        ImprestSurrender: Record "FIN-Imprest Surr. Header";
        ProcurementPlan: Record "PROC-Procurement Plan Header";

    begin
        case RecRef.Number of
            database::"FIN-Payments Header":
                begin
                    RecRef.SetTable(paymentVoucher);
                    paymentVoucher.Status := paymentVoucher.Status::Approved;
                    paymentVoucher.Modify();
                    Handled := true;
                end;
            database::"FIN-Imprest Header":
                begin
                    RecRef.SetTable(imprestHeader);
                    imprestHeader.Status := imprestHeader.Status::Approved;
                    imprestHeader.Modify();
                    Handled := true;
                end;
            database::"FIN-InterBank Transfers":
                begin
                    RecRef.SetTable(interBankTransfer);
                    interBankTransfer.Status := interBankTransfer.Status::Approved;
                    interBankTransfer.Modify();
                    Handled := true;
                end;
            database::"FIN-Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaims);
                    StaffClaims.Status := StaffClaims.Status::Approved;
                    StaffClaims.Modify();
                    Handled := true;
                end;
            database::"PROC-Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequisition);
                    StoreRequisition.Status := StoreRequisition.Status::Released;
                    StoreRequisition.Modify();
                    Handled := true;
                end;
            database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseRequisition);
                    PurchaseRequisition.Status := PurchaseRequisition.Status::Released;
                    PurchaseRequisition.Modify();
                    Handled := true;
                end;
            database::"FIN-Imprest Surr. Header":
                begin
                    RecRef.SetTable(ImprestSurrender);
                    ImprestSurrender.Status := ImprestSurrender.Status::Approved;
                    ImprestSurrender.Modify();
                    Handled := true;
                end;
            database::"PROC-Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlan);
                    ProcurementPlan.Status := ProcurementPlan.Status::Approved;
                    ProcurementPlan.Modify();
                    Handled := true;
                end;
        end;
    end;

    ///////////////////************ SET STATUS TO PENDING APPROVAL *******//////////////////////
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        paymentVoucher: Record "FIN-Payments Header";
        imprestHeader: Record "FIN-Imprest Header";
        interBankTransfer: Record "FIN-InterBank Transfers";
        StaffClaims: Record "FIN-Staff Claims Header";
        StoreRequisition: Record "PROC-Store Requistion Header";
        purchaseRequisition: Record "Purchase Header";
        ImprestSurrender: Record "FIN-Imprest Surr. Header";
        ProcurementPlan: Record "PROC-Procurement Plan Header";

    begin
        case RecRef.Number of
            database::"FIN-Payments Header":
                begin
                    RecRef.SetTable(paymentVoucher);
                    paymentVoucher.Status := paymentVoucher.Status::"Pending Approval";
                    paymentVoucher.Modify();
                    IsHandled := true;
                end;
            database::"FIN-Imprest Header":
                begin
                    RecRef.SetTable(imprestHeader);
                    imprestHeader.Status := imprestHeader.Status::"Pending Approval";
                    imprestHeader.Modify();
                    IsHandled := true;
                end;
            database::"FIN-InterBank Transfers":
                begin
                    RecRef.SetTable(interBankTransfer);
                    interBankTransfer.Status := interBankTransfer.Status::"Pending Approval";
                    interBankTransfer.Modify();
                    IsHandled := true;
                end;
            database::"FIN-Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaims);
                    StaffClaims.Status := StaffClaims.Status::"Pending Approval";
                    StaffClaims.Modify();
                    IsHandled := true;
                end;
            database::"PROC-Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequisition);
                    StoreRequisition.Status := StoreRequisition.Status::"Pending Approval";
                    StoreRequisition.Modify();
                    IsHandled := true;
                end;

            database::"Purchase Header":
                begin
                    RecRef.SetTable(purchaseRequisition);
                    purchaseRequisition.Status := purchaseRequisition.Status::"Pending Approval";
                    purchaseRequisition.Modify();
                    IsHandled := true;
                end;
            database::"FIN-Imprest Surr. Header":
                begin
                    RecRef.SetTable(ImprestSurrender);
                    ImprestSurrender.Status := ImprestSurrender.Status::"Pending Approval";
                    ImprestSurrender.Modify();
                    IsHandled := true;
                end;

            database::"PROC-Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlan);
                    ProcurementPlan.Status := ProcurementPlan.Status::"Pending Approval";
                    ProcurementPlan.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    //////////////////////***************************subscribe to publisher integration event*************/////////////////////////////

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkFlowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkFlowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        WorkFlowEventHandlingCust: Codeunit "Workflow Event Handling Ext";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendPaymentVoucherForApprovalCode());//pv
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestForApprovalCode());//imprest
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendInterBankTransfersForApprovalCode());//interbank
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendStaffClaimForApprovalCode());//staff claim
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendStoreRequisitionForApprovalCode());//store requisition    
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendPurchaseRequisitionForApprovalCode());//purch requisition    
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestSurrenderForApprovalCode());//Imprest surrender   
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendProcurementPlanForApprovalCode());//Imprest surrender   

                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendPaymentVoucherForApprovalCode());//pv
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestForApprovalCode());//imprest
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendInterBankTransfersForApprovalCode());//interbank
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendStaffClaimForApprovalCode());//staff claim
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendStoreRequisitionForApprovalCode());//store requisition         
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendPurchaseRequisitionForApprovalCode());//purchase requisition         
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendImprestSurrenderForApprovalCode());//imprest surrender        
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkFlowEventHandlingCust.RunWorkFlowOnSendProcurementPlanForApprovalCode());//imprest surrender        

                end;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelPaymentVoucherForApprovalCode());//pv
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestForApprovalCode());//imprest
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelInterbankTransferForApprovalCode());//interbank
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelStaffClaimForApprovalCode());//staff claim
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelStoreRequisitionForApprovalCode());//store requisition           
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode());//purhase requisition 
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestSurrenderForApprovalCode());//Imprest surrender         
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelProcurementPlanForApprovalCode());//Imprest surrender         


                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelPaymentVoucherForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelInterbankTransferForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelStaffClaimForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelStoreRequisitionForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelImprestSurrenderForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkFlowEventHandlingCust.RunWorkFlowOnCancelProcurementPlanForApprovalCode());//Imprest surrender         


                end;
        end;

    end;
}

