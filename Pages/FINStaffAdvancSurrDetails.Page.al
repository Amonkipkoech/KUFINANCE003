page 52178757 "FIN-Staff Advanc Surr. Details"
{
    PageType = ListPart;
    SourceTable = "FIN-Staff Advanc Surr. Details";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Imprest Type"; Rec."Imprest Type")
                {
                    ApplicationArea = All;
                }
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt No"; Rec."Cash Receipt No")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt Amount"; Rec."Cash Receipt Amount")
                {
                    ApplicationArea = All;
                }
                field("Apply to"; Rec."Apply to")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Apply to" := '';
                        Rec."Apply to ID" := '';

                        //Amt:=0;

                        Custledger.RESET;
                        Custledger.SETCURRENTKEY(Custledger."Customer No.", Open, "Document No.");
                        Custledger.SETRANGE(Custledger."Customer No.", Rec."Advance Holder");
                        Custledger.SETRANGE(Open, TRUE);
                        //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                        Custledger.CALCFIELDS(Custledger.Amount);
                        IF PAGE.RUNMODAL(25, Custledger) = ACTION::LookupOK THEN BEGIN

                            IF Custledger."Applies-to ID" <> '' THEN BEGIN
                                Custledger1.RESET;
                                Custledger1.SETCURRENTKEY(Custledger1."Customer No.", Open, "Applies-to ID");
                                Custledger1.SETRANGE(Custledger1."Customer No.", Rec."Advance Holder");
                                Custledger1.SETRANGE(Open, TRUE);
                                //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                                Custledger1.SETRANGE("Applies-to ID", Custledger."Applies-to ID");
                                IF Custledger1.FIND('-') THEN BEGIN
                                    REPEAT
                                        Custledger1.CALCFIELDS(Custledger1.Amount);
                                        Amt := Amt + ABS(Custledger1.Amount);
                                    UNTIL Custledger1.NEXT = 0;
                                END;

                                IF Amt <> Amt THEN
                                    //ERROR('Amount is not equal to the amount applied on the application form');
                                    /*Amount:=Amt;
                                    VALIDATE(Amount);*/
                           Rec."Apply to" := Custledger."Document No.";
                                Rec."Apply to ID" := Custledger."Applies-to ID";
                            END ELSE BEGIN
                                IF Rec.Amount <> ABS(Custledger.Amount) THEN
                                    Custledger.CALCFIELDS(Custledger."Remaining Amount");

                                /*Amount:=ABS(CustLedger."Remaining Amount");
                                 VALIDATE(Amount);*/
                                //ERROR('Amount is not equal to the amount applied on the application form');

                                Rec."Apply to" := Custledger."Document No.";
                                Rec."Apply to ID" := Custledger."Applies-to ID";

                            END;
                        END;

                        IF Rec."Apply to ID" <> '' THEN
                            Rec."Apply to" := '';

                        Rec.VALIDATE(Amount);

                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Difference Owed"; Rec."Difference Owed")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        Custledger: Record 21;
        Custledger1: Record 21;
        Amt: Decimal;
}

