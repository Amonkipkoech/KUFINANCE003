page 52178711 "FIN-Imprest Details UP"
{
    PageType = ListPart;
    SourceTable = "FIN-Imprest Lines";

    layout
    {
        area(content)
        {
            repeater(__________________)
            {
                field("Advance Type"; Rec."Advance Type")
                {
                    ApplicationArea = All;
                }
                field(No; Rec.No)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Budget For"; Rec."Budget For")
                {
                    ToolTip = 'Specifies the value of the Budget For field.';
                    ApplicationArea = All;
                }
                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*{Get the total amount paid}
                        Bal:=0;
                        
                        PayHeader.RESET;
                        PayHeader.SETRANGE(PayHeader."Line No.",No);
                        IF PayHeader.FINDFIRST THEN
                          BEGIN
                            PayLine.RESET;
                            PayLine.SETRANGE(PayLine.No,PayHeader."Line No.");
                            IF PayLine.FIND('-') THEN
                              BEGIN
                                REPEAT
                                  Bal:=Bal + PayLine."Pay Mode";
                                UNTIL PayLine.NEXT=0;
                              END;
                          END;
                        //Bal:=Bal + Amount;
                        
                        IF Bal > PayHeader.Amount THEN
                          BEGIN
                            ERROR('Please ensure that the amount inserted does not exceed the amount in the header');
                          END;
                          */

                    end;
                }
                field("Imprest Holder"; Rec."Imprest Holder")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Budgetary Control A/C"; Rec."Budgetary Control A/C")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Check Line Budget")
            {
                Caption = 'Check Line Budget';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    "G/L Vote".RESET;
                    "G/L Vote".SETFILTER("G/L Vote"."No.", Rec."Account No:");
                    "G/L Vote".SETFILTER("G/L Vote"."Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");

                    // IF "G/L Vote".FIND('-') THEN
                    REPORT.RUN(50129, TRUE, TRUE, "G/L Vote");
                end;
            }
        }
    }

    var
        //PayHeader: Record "61732";
        PayLine: Record "FIN-Receipt Line q";
        Bal: Decimal;
        "G/L Vote": Record "G/L Account";
        ImprestHeader: Record "FIN-Imprest Header";
}
