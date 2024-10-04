page 52178779 "Fin Assets Movement Register"
{
    Caption = 'Asset Movement';
    PageType = List;
    ApplicationArea = All;
    CardPageId = "Fin Assets Movement Reg. Card";
    PromotedActionCategories = 'New,Process,Reports,Approval Requests';
    UsageCategory = Lists;
    SourceTable = "Fin-Asset Movement Register";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ToolTip = 'Specifies the value of the Asset No. field.';
                    ApplicationArea = All;
                }
                field("Asset Name"; Rec."Asset Name")
                {
                    ToolTip = 'Specifies the value of the Asset Name field.';
                    ApplicationArea = All;
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Date field.';
                    ApplicationArea = All;
                }
                field("Old Location"; Rec."Old Location")
                {
                    ToolTip = 'Specifies the value of the Old Location field.';
                    ApplicationArea = All;
                }
                field("Ciurrent Location"; Rec."Current Location")
                {
                    ToolTip = 'Specifies the value of the Ciurrent Location field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
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
            // action("Send Approval Request")
            // {
            //     Caption = 'Send Approval Request';
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            // }
            // action("Cancel Approval Request")
            // {
            //     Caption = 'Cancel Approval Request';
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            // }
            separator(action1000)
            {

            }
            action("View Entries")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                RunObject = Page "Fin-Assets Movent Ledger";
                RunPageLink = "Asset No." = field("Asset No.");
            }
            separator(action1001)
            {

            }
            action("Approved")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Pending);

                    Rec."Approval DateTime" := CreateDateTime(Today, Time);
                    Rec.Status := Rec.Status::Approved;
                    Rec."Approved By" := UserId;
                    Rec.Modify();

                end;
            }
        }
    }
}