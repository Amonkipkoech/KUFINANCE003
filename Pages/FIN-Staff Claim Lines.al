page 52178739 "FIN-Staff Claim Lines"
{
    PageType = ListPart;
    SourceTable = "FIN-Staff Claim Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Advance Type"; Rec."Advance Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        RecPay.RESET;
                        RecPay.SETRANGE(RecPay.Code, Rec."Advance Type");
                        if RecPay.FIND('-') THEN BEGIN
                            // "Lecturer No"VISIBLE:=TRUE;
                            //"Lecturer NoVisible" := TRUE;
                        END;
                    end;
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
                    // trigger OnLookup(var Text: Text): Boolean
                    // begin
                    //     Rec.VALIDATE("Account Name");
                    // end;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Lecturer No"; Rec."Lecturer No")
                {
                    //ApplicationArea = All;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Semester Code"; Rec."Semester Code")
                {
                    // ApplicationArea = All;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    //ApplicationArea = All;
                    Visible = false;
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
                field("Claim Receipt No"; Rec."Claim Receipt No")
                {
                    ApplicationArea = All;
                }
                field("Expenditure Date"; Rec."Expenditure Date")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Caption = 'Expenditure Description';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        PayHeader: Record "FIN-Payments Header";
        PayLine: Record "FIN-Payment Line";
        Bal: Decimal;
        RecPay: Record "FIN-Receipts and Payment Types";
}
