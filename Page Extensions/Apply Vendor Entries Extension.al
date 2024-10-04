pageextension 52178707 "Apply Vendor Entries Extension" extends "Apply Vendor Entries"
{
    layout
    {

    }

    actions
    {

    }
    procedure "SetPVLine-Delete"(NewPVLine: Record "FIN-Payment Line"; ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record "FIN-Payments Header";
    begin
        PVLine := NewPVLine;

        IF PVLine."Account Type" = PVLine."Account Type"::Vendor THEN
            ApplyingAmount := PVLine.Amount;
        //IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
        ApplyingAmount := PVLine.Amount;
        //Get Payments Header
        PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.", NewPVLine.No);
        IF PaymentHeader.FIND('-') THEN BEGIN
            ApplnDate := PaymentHeader.Date;
            ApplnCurrencyCode := PaymentHeader."Currency Code";
            CalcType := CalcType::PV;
        END;
        CASE ApplnTypeSelect OF
            NewPVLine.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            NewPVLine.FIELDNO("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        END;

        SetApplyingVendLedgEntry;
    end;

    procedure SetPVLine(NewPVLine: Record "FIN-Payment Line"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record "FIN-Payments Header";
    begin
        PVLine := NewPVLine;
        Rec.COPYFILTERS(NewVendLedgEntry);

        ApplyingAmount := PVLine.Amount;

        PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.", NewPVLine.No);

        IF PaymentHeader.FIND('-') THEN BEGIN
            ApplnDate := PaymentHeader.Date;
            ApplnCurrencyCode := PaymentHeader."Currency Code";
            CalcType := CalcType::PV;
        END;

        CASE ApplnTypeSelect OF
            NewPVLine.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            NewPVLine.FIELDNO("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        END;

        SetApplyingVendLedgEntry;
    end;

    var
        PVLine: Record "FIN-Payment Line";

}