page 52178800 "Proc-Contract List"
{
    PageType = List;
    CardPageId = "Proc-Contracts Card";
    SourceTable = "Proc-Contracts";
    SourceTableView = where("Contract Status" = filter(Active));
   

    layout
    {
        area(Content)
        {
            repeater(Contracts)
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
                field("Service Provider"; Rec."Service Provider")
                {
                    ApplicationArea = all;
                }
                field("Service Provider Name";Rec."Service Provider Name")
                {
                    ApplicationArea = All;
                }
                field("Service Description";Rec."Service Description")
                {
                    ApplicationArea = All;
                }
                field("Contact Person";Rec."Contact Person")
                {
                    ApplicationArea = All;
                }
                field("Suplier Telephone";Rec."Suplier Telephone")
                {
                    ApplicationArea = All;
                }
                field("Supplier E-Mail";Rec."Supplier E-Mail")
                {
                    ApplicationArea = All;
                }
                field("User Department E-mail";Rec."User Department E-mail")
                {
                    ApplicationArea = All;
                }
                field("DVC Admin Email";Rec."DVC Admin Email")
                {
                    ApplicationArea = All;
                }
                field("Legal Department E-mail";Rec."Legal Department E-mail")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
           
        }
    }

    var
        myInt: Integer;
}