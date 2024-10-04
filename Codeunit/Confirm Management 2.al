codeunit 52178706 "Confirm Management 2"
{

    trigger OnRun()
    begin
    end;

    procedure ConfirmProcess(ConfirmQuestion: Text; DefaultButton: Boolean): Boolean
    begin
        IF NOT GUIALLOWED THEN
            EXIT(DefaultButton);
        EXIT(CONFIRM(ConfirmQuestion, DefaultButton));
    end;

    procedure ConfirmProcessUI(ConfirmQuestion: Text; DefaultButton: Boolean): Boolean
    begin
        IF NOT GUIALLOWED THEN
            EXIT(FALSE);
        EXIT(CONFIRM(ConfirmQuestion, DefaultButton));
    end;
}
