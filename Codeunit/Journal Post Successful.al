codeunit 52178702 "Journal Post Successful"
{

    trigger OnRun()
    begin
    end;

    procedure PostedSuccessfully() Posted: Boolean
    var
        ValPost: Record "FIN-Value Posting";
    begin

        Posted := FALSE;
        ValPost.RESET;
        ValPost.SETRANGE(ValPost.UserID, USERID);
        ValPost.SETRANGE(ValPost."Value Posting", 1);
        IF ValPost.FIND('-') THEN
            Posted := TRUE;
    end;
}
