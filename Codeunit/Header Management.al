codeunit 52178710 "Header Management"
{

    procedure GetBankAccount(ReceiptNo: Code[20]) myCode: Code[20]
    var
        ReceiptHeader: Record "FIN-Receipts Header";
    begin
        if ReceiptHeader.Get(ReceiptNo) then
            exit(ReceiptHeader."Bank Code")
        else
            exit('');
    end;

    procedure GetChequeNo(ReceiptNo: Code[20]) myCode: Code[20]
    var
        ReceiptHeader: Record "FIN-Receipts Header";
    begin
        if ReceiptHeader.Get(ReceiptNo) then
            exit(ReceiptHeader."Cheque No.")
        else
            exit('');
    end;

    procedure GetAmount(ReceiptNo: Code[20]) myDecimal: Decimal;
    var
        ReceiptHeader: Record "FIN-Receipts Header";
    begin
        if ReceiptHeader.Get(ReceiptNo) then
            exit(ReceiptHeader."Amount Recieved")
        else
            exit(0);
    end;

    procedure GetTotalAmount(ReceiptNo: Code[20]) myDecimal: Decimal;
    var
        ReceiptHeader: Record "FIN-Receipts Header";
    begin
        if ReceiptHeader.Get(ReceiptNo) then
            exit(ReceiptHeader."Amount Recieved")
        else
            exit(0);
    end;

}
