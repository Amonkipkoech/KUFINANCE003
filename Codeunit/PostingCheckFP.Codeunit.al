codeunit 52178711 "Posting Check FP"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        Post: Boolean;
        blnState: Boolean;
        blnJrnlState: Boolean;
        FromNo: Code[20];
        ToNo: Code[20];

    procedure SetCheck(var blnPost: Boolean)
    begin
        Post := blnPost;
    end;


    procedure GetCheck() blnPost: Boolean
    begin
        blnPost := Post;
    end;


    procedure ResetState()
    begin
        blnState := FALSE;
        FromNo := '';
        ToNo := '';
    end;


    procedure SetState(Post: Boolean)
    begin
        blnState := Post;
    end;


    procedure GetState() ActState: Boolean
    begin
        ActState := blnState;
        EXIT(ActState);
    end;


    procedure FromEntryNo(var FromNoReg: Code[20])
    begin
        FromNo := FromNoReg;
    end;


    procedure ToEntryNo(var ToNoReg: Code[20])
    begin
        ToNo := ToNoReg;
    end;


    procedure GetFromRegNo() FromRegisterNo: Code[20]
    begin
        FromRegisterNo := FromNo;
    end;


    procedure GetToRegNo() ToRegisterNo: Code[20]
    begin
        ToRegisterNo := ToNo;
    end;
}

