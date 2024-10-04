page 52178788 "PRL-Journals"
{
    PageType = List;
    Editable = false;
    CardPageId = "Payroll Journal Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payroll Journal Batches";
    SourceTableView = where(Status = filter(Verified));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(payrollPeriod; Rec.payrollPeriod)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the payrollPeriod field.';
                }
                field(periodName; Rec.periodName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the periodName field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(dateCreated; Rec.dateCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the dateCreated field.';
                }
                field(createdBy; Rec.createdBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the createdBy field.';
                }
                field("Verified By"; Rec."Verified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verified By field.';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}