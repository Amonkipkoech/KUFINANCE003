page 52178801 "Proc-Contracts Card"
{
    PageType = Card;
    SourceTable = "Proc-Contracts";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Contract Code"; Rec."Contract Code")
                {
                    ApplicationArea = All;

                }
                field("Contract Name"; Rec."Contract Name")
                {
                    ApplicationArea = All;
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Period(In Months)';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }
                field("Service Provider"; Rec."Service Provider")
                {
                    ApplicationArea = All;
                }
                field("Service Provider Name"; Rec."Service Provider Name")
                {
                    ApplicationArea = All;
                }
                field("Service Description"; Rec."Service Description")
                {
                    ApplicationArea = All;
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = All;
                }
                field("Suplier Telephone"; Rec."Suplier Telephone")
                {
                    ApplicationArea = all;
                }
                field("Supplier E-Mail"; Rec."Supplier E-Mail")
                {
                    ApplicationArea = All;
                }
                field("User Department E-mail"; Rec."User Department E-mail")
                {
                    ApplicationArea = All;
                }
                field("Legal Department E-mail"; Rec."Legal Department E-mail")
                {
                    ApplicationArea = All;
                }
                field("DVC Admin Email"; Rec."DVC Admin Email")
                {
                    ApplicationArea = All;
                }

            }
            group(Cancelation)
            {
                field("Cancelation Reason"; Rec."Cancelation Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for contract cancellation';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Contract Executed")
            {
                ApplicationArea = All;
                Image = Completed;

                trigger OnAction()
                begin
                    if Confirm('Was this Contract executed?', false) = false then begin exit end;
                    Rec.TestField("Contract Code");
                    Rec."Contract Status" := Rec."Contract Status"::Executed;
                    Rec.Modify();
                    Message('Contract Excecuted Successfully!!');
                end;
            }
            action("Cancel Contract")
            {
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                begin
                    if Confirm('This action will move this record to cancelled contracts, Make Sure you have Indicated Reason for cancellation', false) = false then begin exit end;
                    Rec.TestField("Contract Code");
                    Rec.TestField("Cancelation Reason");
                    Rec."Contract Status" := Rec."Contract Status"::Cancelled;
                    Rec.Modify();
                    Message('Contract Cancelled Successfully!!');
                end;
            }
        }
    }


}