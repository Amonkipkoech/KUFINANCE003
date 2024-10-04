page 52178773 "PROC-Procurement Plan Header"
{
    PageType = Card;
    SourceTable = "PROC-Procurement Plan Header";



    layout
    {

        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = All;
                }

                field("Campus Code"; Rec."Campus Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Dim.Reset;
                        Dim.SetRange(Dim.Code, Rec."Department Code");
                        if Dim.Find('-') then begin
                            DptName := Dim.Name;
                        end;
                    end;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                }
                field(DptName; DptName)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("Procurement Plan Period"; Rec."Procurement Plan Period")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }

            }
            part(Control1102755005; "PROC-Procurement Plan Lines")
            {
                SubPageLink = "Budget Name" = FIELD("Budget Name"),
                              Department = FIELD("Department Code"),
                              Campus = FIELD("Campus Code"),
                              "Procurement Plan Period" = FIELD("Procurement Plan Period");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                action("Send Approval")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Approval Request';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = SendApprovalRequest;
                    trigger OnAction()
                    var
                        AppMnt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        AppMnt.CheckProcurementPlanApprovalPossible(Rec);
                        AppMnt.OnSendProcurementPlanForApproval(Rec);
                    end;

                }
                action("Cancel Approval")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Request';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = CancelApprovalRequest;
                    trigger OnAction()
                    var
                        AppMnt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        AppMnt.OnCancelProcurementPlanForApproval(Rec);

                    end;

                }
            }
        }
        area(Reporting)
        {
            action("Procurement Plan")
            {
                Caption = ' Consolidated Procurement Plan/Costing';
                ApplicationArea = Basic, Suite;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    planLines: Record "PROC-Procurement Plan Lines";

                begin

                    planLines.Reset();
                    planLines.SetRange("Budget Name", Rec."Budget Name");
                    planLines.SetRange(Department, Rec."Department Code");
                    if planLines.FindFirst() then
                        Report.Run(52178702, true, true, planLines);
                end;
            }
            action("Procurement Plan Report")
            {
                Caption = 'Procurment Plan';
                ApplicationArea = Basic, Suite;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    planLines: Record "PROC-Procurement Plan Lines";

                begin

                    planLines.Reset();
                    planLines.SetRange("Budget Name", Rec."Budget Name");
                    planLines.SetRange(Department, Rec."Department Code");
                    if planLines.FindFirst() then
                        Report.Run(52178701, true, true, planLines);
                end;
            }
        }
    }

    var
        DptName: Text[50];
        Dim: Record "Dimension Value";
}

