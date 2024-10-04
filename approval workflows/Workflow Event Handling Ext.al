codeunit 52178717 "Workflow Event Handling Ext"
{
    trigger OnRun()
    begin

    end;

    var
        WorkFlowManagement: Codeunit "Workflow Management";
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
        //PV
        PaymentVoucherSentForApprovalEventDescTxt: TextConst ENU = 'Approval of Payment Voucher Document is Requested';
        PaymentVoucherReleasedEventDescTxt: Label 'A payment document is approved.';
        PaymentVoucherApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of Payment Voucher Document is Canceled';

        //IMPREST
        ImprestSentForApprovalEventDescTxt: TextConst ENU = 'Approval of Imprest Document is Requested';

        ImprestApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of Imprest Document is Canceled';

        //INTER BANK TRANSFERS
        InterBankTransferSentForApprovalEventDescTxt: TextConst ENU = 'Approval of InterBank Transfer Document is Requested';

        InterBankTransferApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of InterBank Transfer Document is Canceled';

        // Store Requisition
        StoreRequisitionSentForApprovalEventDescTxt: TextConst ENU = 'Approval of Store Requisition Document is Requested';

        StoreRequisitionferApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of Store Requisition Document is Canceled';

        // Staff claims
        StaffClaimSentForApprovalEventDescTxt: TextConst ENU = 'Approval of Staff Claim Document is Requested';

        StaffClaimApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of Staff Claim Document is Canceled';

        // Purchase Requisition
        PurchaseRequisitionSentForApprovalEventDescTxt: TextConst ENU = 'Approval of  Purchase Requisition Document is Requested';

        PurchaseRequisitionApprovalRequestCancelEventDescTxt: TextConst ENU = 'Approval of  Purchase Requisition Document is Canceled';

        //imprest surrender
        ImprestSurrenderSentForApprovalEventDescTxt: TextConst ENU = 'Approval of a Imprest Surrender is requested';

        ImprestSurrenderApprovalRequestCancelEventDescTxt: TextConst ENU = 'An Approval of a Imprest Surrender is canceled';

        //Procurement Plan
        ProcurementPlanSentForApprovalEventDescTxt: TextConst ENU = 'Approval of a Procurement Plan is requested';

        ProcurementPlanApprovalRequestCancelEventDescTxt: TextConst ENU = 'An Approval of a Procurement Plan is canceled';


    ///////////////////////////////***************************SEND APPROVAL REQUEST*******************************/////////////////////////////

    //PV
    procedure RunWorkFlowOnSendPaymentVoucherForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendPaymentVoucherForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendPaymentVoucherForApproval', '', true, true)]
    procedure RunWorkFlowOnSendPaymentVoucherForApproval(var PaymentVoucher: Record "FIN-Payments Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendPaymentVoucherForApprovalCode, PaymentVoucher);
    end;

    //IMPREST
    procedure RunWorkFlowOnSendImprestForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendImprestForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendImprestForApproval', '', true, true)]
    procedure RunWorkFlowOnSendImprestForApproval(var imprestHeader: Record "FIN-Imprest Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendImprestForApprovalCode, imprestHeader);
    end;

    //INTER BANK TRANSFERS
    procedure RunWorkFlowOnSendInterBankTransfersForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendInterBankTransferForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendInterBankTransferForApproval', '', true, true)]
    procedure RunWorkFlowOnSendInterBankTransfersForApproval(var InterBankTransfers: Record "FIN-InterBank Transfers")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendInterBankTransfersForApprovalCode(), InterBankTransfers);
    end;

    //Staff claims
    procedure RunWorkFlowOnSendStaffClaimForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnStaffClaimForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendStaffClaimForApproval', '', true, true)]
    procedure RunWorkFlowOnSendStaffClaimForApproval(var StaffClaims: Record "FIN-Staff Claims Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendStaffClaimForApprovalCode, StaffClaims);
    end;

    //Store Requisition
    procedure RunWorkFlowOnSendStoreRequisitionForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnStoreRequisitionForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendStoreRequisitionForApproval', '', true, true)]
    procedure RunWorkFlowOnSendStoreRequisitionForApproval(var StoreRequisition: Record "PROC-Store Requistion Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendStoreRequisitionForApprovalCode, StoreRequisition);
    end;
    //Purchase Requisition
    procedure RunWorkFlowOnSendPurchaseRequisitionForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnPurchaseRequisitionForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendPurchaseRequisitionForApproval', '', true, true)]
    procedure RunWorkFlowOnSendPurchaseRequisitionForApproval(var PurchaseRequisition: Record "Purchase Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendPurchaseRequisitionForApprovalCode, PurchaseRequisition);
    end;

    //Imprest surrender
    procedure RunWorkFlowOnSendImprestSurrenderForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendImprestSurrenderForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendImprestSurrenderForApproval', '', true, true)]
    procedure RunWorkFlowOnSendImprestSurrenderForApproval(var ImprestSurrender: Record "FIN-Imprest Surr. Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendImprestSurrenderForApprovalCode, ImprestSurrender);
    end;

    //Procurement Plan
    procedure RunWorkFlowOnSendProcurementPlanForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendProcurementPlanForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnSendProcurementPlanForApproval', '', true, true)]
    procedure RunWorkFlowOnSendProcurementPlanForApproval(var ProcurementPlan: Record "PROC-Procurement Plan Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnSendProcurementPlanForApprovalCode, ProcurementPlan);
    end;
    ////////////////////////////////***************************CANCEL APPROVAL REQUEST*************///////////////////////////////////////////////
    //payment voucher
    procedure RunWorkFlowOnCancelPaymentVoucherForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelPaymentVoucherForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelPaymentVoucherForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelPaymentVoucherForApproval(var PaymentVoucher: Record "FIN-Payments Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelPaymentVoucherForApprovalCode, PaymentVoucher);
    end;

    //Imprest
    procedure RunWorkFlowOnCancelImprestForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelImprestForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelImprestForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelImprestForApproval(var ImprestHeader: Record "FIN-Imprest Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelImprestForApprovalCode, ImprestHeader);
    end;

    //Staff claim
    procedure RunWorkFlowOnCancelStaffClaimForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelStaffClaimForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelStaffClaimForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelStaffClaimForApproval(var StaffClaims: Record "FIN-Staff Claims Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelStaffClaimForApprovalCode, StaffClaims);
    end;

    //Store Requisition
    procedure RunWorkFlowOnCancelStoreRequisitionForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelStoreRequisitionForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelStoreRequisitionForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelStoreRequisitionForApproval(var StoreRequisition: Record "PROC-Store Requistion Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelStoreRequisitionForApprovalCode(), StoreRequisition);

    end;

    //Interbank transfer
    procedure RunWorkFlowOnCancelInterbankTransferForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelInterbankTransferForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelInterbankTransferForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelInterbankTransferForApproval(var InterBankTransfers: Record "FIN-InterBank Transfers")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelInterbankTransferForApprovalCode, InterBankTransfers);

    end;

    //purchase requisition
    procedure RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelPurchaseRequisitionForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelPurchaseRequisitionForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelPurchaseRequisitionForApproval(var PurchaseRequisition: Record "Purchase Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode, PurchaseRequisition);

    end;

    //imprest surrender

    procedure RunWorkFlowOnCancelImprestSurrenderForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelImprestSurrenderForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelImprestSurrenderForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelImprestSurrenderForApproval(var ImprestSurrender: Record "FIN-Imprest Surr. Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelImprestSurrenderForApprovalCode, ImprestSurrender);

    end;

    //procurement plan

    procedure RunWorkFlowOnCancelProcurementPlanForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnCancelProcurementPlanForApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmnt. Ext", 'OnCancelProcurementPlanForApproval', '', true, true)]
    procedure RunWorkFlowOnCancelProcurementPlanForApproval(var ProcurementPlan: Record "PROC-Procurement Plan Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkFlowOnCancelProcurementPlanForApprovalCode, ProcurementPlan);

    end;
    //////////////////////***************************ADD EVENT TO LIBRARY*************/////////////////////////////
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        //pv
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendPaymentVoucherForApprovalCode, Database::"FIN-Payments Header", PaymentVoucherSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelPaymentVoucherForApprovalCode, Database::"FIN-Payments Header", PaymentVoucherApprovalRequestCancelEventDescTxt, 0, false);
        //imrpest
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendImprestForApprovalCode, Database::"FIN-Imprest Header", ImprestSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelImprestForApprovalCode, Database::"FIN-Imprest Header", ImprestApprovalRequestCancelEventDescTxt, 0, false);
        //interbank transfers
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendInterBankTransfersForApprovalCode, Database::"FIN-InterBank Transfers", InterBankTransferSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelInterbankTransferForApprovalCode, Database::"FIN-InterBank Transfers", InterBankTransferApprovalRequestCancelEventDescTxt, 0, false);
        //Staff claims
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendStaffClaimForApprovalCode, Database::"FIN-Staff Claims Header", StaffClaimSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelStaffClaimForApprovalCode, Database::"FIN-Staff Claims Header", StaffClaimApprovalRequestCancelEventDescTxt, 0, false);
        //Store requisition
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendStoreRequisitionForApprovalCode(), Database::"PROC-Store Requistion Header", StoreRequisitionSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelStoreRequisitionForApprovalCode(), Database::"PROC-Store Requistion Header", StoreRequisitionferApprovalRequestCancelEventDescTxt, 0, false);

        //purchase requisition
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendPurchaseRequisitionForApprovalCode(), Database::"Purchase Header", PurchaseRequisitionSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode(), Database::"Purchase Header", PurchaseRequisitionApprovalRequestCancelEventDescTxt, 0, false);

        //Imprest Surrender
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendImprestSurrenderForApprovalCode(), Database::"FIN-Imprest Surr. Header", ImprestSurrenderSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelImprestSurrenderForApprovalCode(), Database::"FIN-Imprest Surr. Header", ImprestSurrenderApprovalRequestCancelEventDescTxt, 0, false);
        //Imprest procurement plan
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendProcurementPlanForApprovalCode(), Database::"PROC-Procurement Plan Header", ProcurementPlanSentForApprovalEventDescTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnCancelProcurementPlanForApprovalCode(), Database::"PROC-Procurement Plan Header", ProcurementPlanApprovalRequestCancelEventDescTxt, 0, false);


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkFlowOnCancelPaymentVoucherForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelPaymentVoucherForApprovalCode, RunWorkFlowOnSendPaymentVoucherForApprovalCode);
            RunWorkFlowOnCancelImprestForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelImprestForApprovalCode, RunWorkFlowOnSendImprestForApprovalCode);
            RunWorkFlowOnCancelInterbankTransferForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelInterbankTransferForApprovalCode, RunWorkFlowOnSendInterBankTransfersForApprovalCode());
            RunWorkFlowOnCancelStaffClaimForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelStaffClaimForApprovalCode, RunWorkFlowOnSendStaffClaimForApprovalCode());
            RunWorkFlowOnCancelStoreRequisitionForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelStoreRequisitionForApprovalCode, RunWorkFlowOnSendStoreRequisitionForApprovalCode());
            RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelPurchaseRequisitionForApprovalCode, RunWorkFlowOnSendPurchaseRequisitionForApprovalCode());
            RunWorkFlowOnCancelImprestSurrenderForApprovalCode():
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelImprestSurrenderForApprovalCode, RunWorkFlowOnSendImprestSurrenderForApprovalCode());

            RunWorkFlowOnCancelProcurementPlanForApprovalCode():
                WorkFlowEventHandling.AddEventPredecessor(RunWorkFlowOnCancelProcurementPlanForApprovalCode, RunWorkFlowOnSendProcurementPlanForApprovalCode());


            WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendPaymentVoucherForApprovalCode);
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendImprestForApprovalCode);
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendInterBankTransfersForApprovalCode());
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendStaffClaimForApprovalCode());
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendStoreRequisitionForApprovalCode());
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendPurchaseRequisitionForApprovalCode());
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendImprestSurrenderForApprovalCode());
                    WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkFlowOnSendProcurementPlanForApprovalCode());

                end;

        end
    end;

}