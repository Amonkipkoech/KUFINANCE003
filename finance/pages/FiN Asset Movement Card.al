page 52178781 "Fin Assets Movement Reg. Card"
{

    PageType = Card;
    PromotedActionCategories = 'New,process,Report,Approve';
    SourceTable = "Fin-Asset Movement Register";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
ShowCaption = false;
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
            action("View Entries")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                RunObject = Page "Fin-Assets Movent Ledger";
                RunPageLink = "Asset No." = field("Asset No.");
            }

        }
    }
}