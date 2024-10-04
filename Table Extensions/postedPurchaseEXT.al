tableextension 52178723 postedPurchRecipt extends "Purch. Rcpt. Header"
{
    fields
    {
        //     field(50000; "Delivery Note No."; code[20])
        //     {

        //     }
        //     field(50001; "Receiving Staff ID"; Code[20])
        //     {
        //         TableRelation = "HRM-Employee (D)"."No.";
        //         trigger OnValidate()
        //         var
        //             hrm: Record "HRM-Employee (D)";
        //         begin
        //             hrm.Reset();
        //             hrm.SetRange("No.", Rec."Receiving Staff ID");
        //             if hrm.Find('-') then begin
        //                 "Receiving Staff Id Name" := hrm."First Name" + ' ' + hrm."Last Name";
        //             end;
        //         end;
        //     }
        //     field(50002; "Receiving Staff Id Name"; text[200])
        //     {

        //     }

    }
}