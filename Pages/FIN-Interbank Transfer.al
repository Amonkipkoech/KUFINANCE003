page 52178718 "FIN-Interbank Transfer"
{
    CardPageID = "FIN-Bank & Cash Trans. Req. UP";
    PageType = List;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Action,Navigation,Process,Request Approval,Approval,Post,Report,Print/send';
    SourceTable = "FIN-InterBank Transfers";
    SourceTableView = WHERE(Posted = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }

                field("Receiving Account"; Rec."Receiving Account")
                {
                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }


                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                }


                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Paying Account"; Rec."Paying Account")
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
            action("Posted Interbank Transfers")
            {
                RunObject = Page "FIN-Posted Interbank Trans2";
                RunPageLink = No = FIELD(No);
                ApplicationArea = All;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rcpt.RESET;
        Rcpt.SETRANGE(Rcpt.Posted, FALSE);
        Rcpt.SETRANGE(Rcpt."Created By", USERID);
        IF Rcpt.COUNT > 0 THEN BEGIN
            IF CONFIRM('There are still some unposted imprest Surrenders. Continue?', FALSE) = FALSE THEN BEGIN
                ERROR('There are still some unposted imprest Surrenders. Please utilise them first');
            END;
        END;
    end;

    var
        Rcpt: Record "FIN-InterBank Transfers";
}
