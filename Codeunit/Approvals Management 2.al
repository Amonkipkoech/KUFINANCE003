codeunit 52178707 "Approvals Management 2"
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    var
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for user ID %1 in the Approval User Setup window.', Comment = 'You must set up an approver for user ID NAVUser in the Approval User Setup window.';
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.';
        SubstituteNotFoundErr: Label 'There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.', Comment = 'There is no substitute for user ID NAVUser in the Approval User Setup window.';
        NoSuitableApproverFoundErr: Label 'No qualified approver was found.';
        DelegateOnlyOpenRequestsErr: Label 'You can only delegate open approval requests.';
        ApproveOnlyOpenRequestsErr: Label 'You can only approve open approval requests.';
        RejectOnlyOpenRequestsErr: Label 'You can only reject open approval entries.';
        ApprovalsDelegatedMsg: Label 'The selected approval requests have been delegated.';
        NoReqToApproveErr: Label 'There is no approval request to approve.';
        NoReqToRejectErr: Label 'There is no approval request to reject.';
        NoReqToDelegateErr: Label 'There is no approval request to delegate.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
        NoApprovalsSentMsg: Label 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
        PendingApprovalForSelectedLinesMsg: Label 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: Label 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
        PurchaserUserNotFoundErr: Label 'The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.', Comment = 'Example: The salesperson/purchaser user ID NAVUser does not exist in the Approval User Setup window for Salesperson/Purchaser code AB.';
        NoApprovalRequestsFoundErr: Label 'No approval requests exist.';
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.', Comment = 'Order 1001 has been automatically approved. The status has been changed to Released.';
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        SalesPrePostCheckErr: Label 'Sales %1 %2 must be approved and released before you can perform this action.', Comment = '%1=document type, %2=document no., e.g. Sales Order 321 must be approved...';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        PurchPrePostCheckErr: Label 'Purchase %1 %2 must be approved and released before you can perform this action.', Comment = '%1=document type, %2=document no., e.g. Purchase Order 321 must be approved...';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ApprovalReqCanceledForSelectedLinesMsg: Label 'The approval request for the selected record has been canceled.';
        PendingJournalBatchApprovalExistsErr: Label 'An approval request already exists.', Comment = '%1 is the Document No. of the journal line';
        ApporvalChainIsUnsupportedMsg: Label 'Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.', Comment = 'Only Direct Approver is supported as Approver Limit Type option for Gen. Journal Batch DEFAULT, CASH. The approval request will be approved automatically.';
        RecHasBeenApprovedMsg: Label '%1 has been approved.', Comment = '%1 = Record Id';
        NoPermissionToDelegateErr: Label 'You do not have permission to delegate one or more of the selected approval requests.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        ApproverChainErr: Label 'No sufficient approver was found in the approver chain.';




    //Working on workflows on PVS
    [IntegrationEvent(false, false)]
    PROCEDURE OnSendPVSforApproval(VAR PVS: Record "FIN-Payments Header");
    begin
    end;

    procedure IsPVSEnabled(var PVS: Record "FIN-Payments Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode;
    begin
        exit(WFMngt.CanExecuteWorkflow(PVS, WFCode.RunWorkflowOnSendPVSApprovalCode()))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        PVS: Record "FIN-Payments Header";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsPVSEnabled(PVS) then
            Error(NoWorkflowEnb);
    end;
}