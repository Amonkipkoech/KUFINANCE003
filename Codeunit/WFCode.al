codeunit 52178708 WFCode
{
    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        SendPVSReq: TextConst ENU = 'Approval Request for PVS is requested', ENG = 'Approval Request for PVS is requested';
        AppReqPVS: TextConst ENU = 'Approval Request for PVS is approved', ENG = 'Approval Request for PVS is approved';
        RejReqPVS: TextConst ENU = 'Approval Request for PVS is rejected', ENG = 'Approval Request for PVS is rejected';
        DelReqPVS: TextConst ENU = 'Approval Request for PVS is delegated', ENG = 'Approval Request for PVS is delegated';
        SendForPendAppTxt: TextConst ENU = 'Status of PVS changed to Pending approval', ENG = 'Status of PVS changed to Pending approval';
        ReleasePVSTxt: TextConst ENU = 'Release PVS', ENG = 'Release PVS';
        ReOpenPVSTxt: TextConst ENU = 'ReOpen PVS', ENG = 'ReOpen PVS';

    procedure RunWorkflowOnSendPVSApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPVSApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Management 2", 'OnSendPVSforApproval', '', false, false)]
    procedure RunWorkflowOnSendPVSApproval(var PVS: Record "FIN-Payments Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendPVSApprovalCode(), PVS);
    end;

    procedure RunWorkflowOnApprovePVSApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprovePVSApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    procedure RunWorkflowOnApprovePVSApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprovePVSApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnRejectPVSApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectPVSApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure RunWorkflowOnRejectPVSApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectPVSApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnDelegatePVSApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegatePVSApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    procedure RunWorkflowOnDelegatePVSApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegatePVSApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure SetStatusToPendingApprovalCodePVS(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApprovalPVS'));
    end;

    procedure SetStatusToPendingApprovalPVS(var Variant: Variant)
    var
        RecRef: RecordRef;
        PVS: Record "FIN-Payments Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"FIN-Payments Header":
                begin
                    RecRef.SetTable(PVS);
                    PVS.Validate(Status, PVS.Status::"Pending Approval");
                    PVS.Modify();
                    Variant := PVS;
                end;
        end;
    end;

    procedure ReleasePVSCode(): Code[128]
    begin
        exit(UpperCase('ReleasePVS'));
    end;

    procedure ReleasePVS(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PVS: Record "FIN-Payments Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReleasePVS(Variant);
                end;
            DATABASE::"FIN-Payments Header":
                begin
                    RecRef.SetTable(PVS);
                    PVS.Validate(Status, PVS.Status::Approved);
                    PVS.Modify();
                    Variant := PVS;
                end;
        end;
    end;

    procedure ReOpenPVSCode(): Code[128]
    begin
        exit(UpperCase('ReOpenPVS'));
    end;

    procedure ReOpenPVS(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PVS: Record "FIN-Payments Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpenPVS(Variant);
                end;
            DATABASE::"FIN-Payments Header":
                begin
                    RecRef.SetTable(PVS);
                    PVS.Validate(Status, PVS.Status::Open);
                    PVS.Modify();
                    Variant := PVS;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddPVSEventToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPVSApprovalCode(), Database::"FIN-Payments Header", SendPVSReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprovePVSApprovalCode(), Database::"Approval Entry", AppReqPVS, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectPVSApprovalCode(), Database::"Approval Entry", RejReqPVS, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegatePVSApprovalCode(), Database::"Approval Entry", DelReqPVS, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    procedure AddPVSRespToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodePVS(), 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReleasePVSCode(), 0, ReleasePVSTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenPVSCode(), 0, ReOpenPVSTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForPVS(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of
                SetStatusToPendingApprovalCodePVS():
                    begin
                        SetStatusToPendingApprovalPVS(Variant);
                        ResponseExecuted := true;
                    end;
                ReleasePVSCode():
                    begin
                        ReleasePVS(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenPVSCode():
                    begin
                        ReOpenPVS(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;
}