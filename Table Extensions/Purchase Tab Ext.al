tableextension 52178707 "Purchase header ext" extends "Purchase Header"
{
    fields
    {
        
        modify("Request for Quote No.")
        {

            TableRelation = "PROC-Quotation Request Vendors"."Document No." WHERE("Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnBeforeValidate()
            var
                RFQ: Record "PROC-Purchase Quote Line";
                RFQ_Line: Record "PROC-Purchase Quote Line";
                countedRec: Integer;
                PurchLine: Record "Purchase Line";
            begin
                //CHECK WHETHER HAS LINES AND DELETE
                IF NOT CONFIRM('If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?', FALSE)
                THEN
                    ERROR('You have selected to abort the process');

                PurchLine.RESET;
                PurchLine.SETRANGE(PurchLine."Document No.", "No.");
                PurchLine.DELETEALL;

                RFQ_Line.RESET;
                RFQ_Line.SETRANGE(RFQ_Line."Document No.", "Request for Quote No.");
                IF RFQ_Line.FIND('-') THEN BEGIN
                    REPEAT
                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document No.", "No.");
                        IF PurchLine.FIND('-') THEN BEGIN
                            countedRec := PurchLine.COUNT + 1;
                        END ELSE
                            countedRec := 1;
                        PurchLine.INIT;
                        PurchLine."Document Type" := PurchLine."Document Type"::Quote;
                        PurchLine."Document No." := "No.";
                        PurchLine."Line No." := countedRec;
#pragma warning disable AL0603
                        PurchLine.Type := RFQ_Line.Type;
#pragma warning restore AL0603
                        //  PurchLine."Document Type 2":="Document Type 2";
                        PurchLine."No." := RFQ_Line."No.";
                        PurchLine."RFQ No." := RFQ_Line."Document No.";
                        PurchLine.VALIDATE("No.");
                        PurchLine."Location Code" := RFQ_Line."Location Code";
                        PurchLine.VALIDATE("Location Code");
                        PurchLine.Quantity := RFQ_Line.Quantity;
                        PurchLine."Description 2" := RFQ_Line."Description 2";
                        PurchLine.VALIDATE(Quantity);
                        PurchLine."Direct Unit Cost" := RFQ_Line."Direct Unit Cost";
                        PurchLine.VALIDATE("Direct Unit Cost");
                        PurchLine.Amount := RFQ_Line.Amount;
                        PurchLine.INSERT;
                    UNTIL RFQ_Line.NEXT = 0;
                END;


            end;
        }
    }
}
