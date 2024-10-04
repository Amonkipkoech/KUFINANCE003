page 52178747 "FIN-Posted Receipts list"
{
    CardPageID = "FIN-Posted Receipt UP";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "FIN-Receipts Header";
    SourceTableView = WHERE(Posted = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = All;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Print No."; Rec."Print No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                }
                field("Register No."; Rec."Register No.")
                {
                    ApplicationArea = All;
                }
                field("Student/staff No"; Rec."Student/staff No")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = All;
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ApplicationArea = All;
                }
                field("Patient Appointment No"; Rec."Patient Appointment No")
                {
                    ApplicationArea = All;
                }
                field("Surrender No"; Rec."Surrender No")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Posted Receipt Card")
            {
                Image = PostedDeposit;
                RunObject = Page "FIN-Posted Receipt UP";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(reporting)
        {
            // action("Receipt Report")
            // {
            //     Image = Report2;
            //     Promoted = true;
            //     RunObject = Report 60004;
            // }
        }
    }
}
