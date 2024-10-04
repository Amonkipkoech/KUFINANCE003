page 52178741 "Apply Vendor Entries 2"
{
    Caption = 'Apply Vendor Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SourceTable = "Vendor Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("ApplyingVendLedgEntry.""Posting Date"""; ApplyingVendLedgEntry."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Document Type"""; ApplyingVendLedgEntry."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    //OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ToolTip = 'Specifies the document type of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Document No."""; ApplyingVendLedgEntry."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the document number of the entry to be applied.';
                }
                field(ApplyingVendorNo; ApplyingVendLedgEntry."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor No.';
                    Editable = false;
                    ToolTip = 'Specifies the vendor number of the entry to be applied.';
                    Visible = false;
                }
                field(ApplyingDescription; ApplyingVendLedgEntry.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the entry to be applied.';
                    Visible = false;
                }
                field("ApplyingVendLedgEntry.""Currency Code"""; ApplyingVendLedgEntry."Currency Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the currency code of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.Amount"; ApplyingVendLedgEntry.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Remaining Amount"""; ApplyingVendLedgEntry."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the entry to be applied.';
                }
            }
            repeater(Control1)
            {
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = AppliesToIDVisible;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the external document number that was entered on the purchase header or journal line.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("CalcApplnRemainingAmount(""Remaining Amount"")"; CalcApplnRemainingAmount(Rec."Remaining Amount"))
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Remaining Amount';
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Amount to Apply"; Rec."Amount to Apply")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount to apply.';

                    trigger OnValidate()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);

                        IF (xRec."Amount to Apply" = 0) OR (Rec."Amount to Apply" = 0) AND
                           (ApplnType = ApplnType::"Applies-to ID")
                        THEN
                            SetVendApplId;
                        Rec.GET(Rec."Entry No.");
                        AmounttoApplyOnAfterValidate;
                    end;
                }
                field("CalcApplnAmounttoApply(Rec.""Amount to Apply"")"; CalcApplnAmounttoApply(Rec."Amount to Apply"))
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Amount to Apply';
                    ToolTip = 'Specifies the amount to apply.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field("CalcApplnRemainingAmount(Rec.""Remaining Pmt. Disc. Possible"")"; CalcApplnRemainingAmount(Rec."Remaining Pmt. Disc. Possible"))
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Pmt. Disc. Possible';
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the entry to be applied is positive.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the entry.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the entry.';
                }
            }
            group(More)
            {
                fixed(__________)
                {
                    group("Appln. Currency")
                    {
                        Caption = 'Appln. Currency';
                        field(ApplnCurrencyCode; ApplnCurrencyCode)
                        {
                            ApplicationArea = Suite;
                            Editable = false;
                            ShowCaption = false;
                            TableRelation = Currency;
                            ToolTip = 'Specifies the currency code that the amount will be applied in, in case of different currencies.';
                        }
                    }
                    group("Amount to Apply ")
                    {
                        Caption = 'Amount to Apply';
                        field(AmountToApply; AppliedAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Amount to Apply';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the amounts on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Pmt. Disc. Amount")
                    {
                        Caption = 'Pmt. Disc. Amount';
                        field("-PmtDiscAmount"; -PmtDiscAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Amount';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the payment discount amounts granted on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group(Rounding)
                    {
                        Caption = 'Rounding';
                        field(ApplnRounding; ApplnRounding)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Rounding';
                            Editable = false;
                            ToolTip = 'Specifies the rounding difference when you apply entries in different currencies to one another. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Applied Amount")
                    {
                        Caption = 'Applied Amount';
                        field(AppliedAmount; AppliedAmount + (-PmtDiscAmount) + ApplnRounding)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Applied Amount';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the amounts in the Amount to Apply field, Pmt. Disc. Amount field, and the Rounding. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Available Amount")
                    {
                        Caption = 'Available Amount';
                        field(ApplyingAmount; ApplyingAmount)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Available Amount';
                            Editable = false;
                            ToolTip = 'Specifies the amount of the journal entry, purchase credit memo, or current vendor ledger entry that you have selected as the applying entry.';
                        }
                    }
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field(ControlBalance; AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding)
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies any extra amount that will remain after the application.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page 62;
                    RunPageOnRec = true;
                    ToolTip = 'View the ledger entries that have been applied to this record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;


                    RunObject = Page 574;
                    RunPageLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Vendor Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry.';
                }
                action(Navigate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                    Visible = NOT IsOfficeAddin;

                    trigger OnAction()
                    begin
                        Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                        Navigate.RUN;
                    end;
                }
            }
        }
        area(processing)
        {

            // group("&Application")
            // {
            //     Caption = '&Application';
            //     Image = Apply;
            action(ActionSetAppliesToID)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                Caption = 'Set Applies-to ID';
                Image = SelectLineToApply;
                ShortCutKey = 'Shift+F11';

                ToolTip = 'Set the Applies-to ID field on the posted entry to automatically be filled in with the document number of the entry in the journal.';

                trigger OnAction()
                begin
                    IF (CalcType = CalcType::GenJnlLine) AND (ApplnType = ApplnType::"Applies-to Doc. No.") THEN
                        ERROR(CannotSetAppliesToIDErr);

                    SetVendApplId;
                end;
            }
            action(ActionPostApplication)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                Caption = 'Post Application';
                Ellipsis = true;
                Image = PostApplication;
                ShortCutKey = 'F9';
                ToolTip = 'Define the document number of the ledger entry to use to perform the application. In addition, you specify the Posting Date for the application.';

                trigger OnAction()
                begin
                    PostDirectApplication(FALSE);
                end;
            }
            action(Preview)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                begin
                    PostDirectApplication(TRUE);
                end;
            }
            separator("-")
            {
                Caption = '-';
            }
            action("Show Only Selected Entries to Be Applied")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                Caption = 'Show Only Selected Entries to Be Applied';
                Image = ShowSelected;
                ToolTip = 'View the selected ledger entries that will be applied to the specified record.';

                trigger OnAction()
                begin
                    ShowAppliedEntries := NOT ShowAppliedEntries;
                    IF ShowAppliedEntries THEN
                        IF CalcType = CalcType::GenJnlLine THEN
                            Rec.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID")
                        ELSE BEGIN
                            VendEntryApplID := USERID;
                            IF VendEntryApplID = '' THEN
                                VendEntryApplID := '***';
                            Rec.SETRANGE("Applies-to ID", VendEntryApplID);
                        END
                    ELSE
                        Rec.SETRANGE("Applies-to ID");
                end;
            }
            // }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
            CalcApplnAmount;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnInit()
    begin
        AppliesToIDVisible := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
        IF Rec."Applies-to ID" <> xRec."Applies-to ID" THEN
            CalcApplnAmount;
        EXIT(FALSE);
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            Vend.GET(Rec."Vendor No.");
            ApplnCurrencyCode := Vend."Currency Code";
            FindApplyingEntry;
        END;

        AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";

        GLSetup.GET;

        IF CalcType = CalcType::GenJnlLine THEN
            CalcApplnAmount;
        PostingDone := FALSE;
        IsOfficeAddin := OfficeMgt.IsPopOut;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
        IF ApplnType = ApplnType::"Applies-to Doc. No." THEN BEGIN
            IF OK AND (ApplyingVendLedgEntry."Posting Date" < Rec."Posting Date") THEN BEGIN
                OK := FALSE;
                ERROR(
                  EarlierPostingDateErr, ApplyingVendLedgEntry."Document Type", ApplyingVendLedgEntry."Document No.",
                  Rec."Document Type", Rec."Document No.");
            END;
            IF OK THEN BEGIN
                IF Rec."Amount to Apply" = 0 THEN
                    Rec."Amount to Apply" := Rec."Remaining Amount";
                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
            END;
        END;

        IF CheckActionPerformed THEN BEGIN
            Rec := ApplyingVendLedgEntry;
            Rec."Applying Entry" := FALSE;
            IF AppliesToID = '' THEN BEGIN
                Rec."Applies-to ID" := '';
                Rec."Amount to Apply" := 0;
            END;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
        END;
    end;

    var
        //ApplyingVendLedgEntry: Record "Vendor Ledger Entry";
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit 225;
        PurchPost: Codeunit 90;
        PaymentToleranceMgt: Codeunit 426;
        Navigate: Page 344;
        GenJnlLineApply: Boolean;
        AppliedAmount: Decimal;
        ApplyingAmount: Decimal;
        PmtDiscAmount: Decimal;
        ApplnDate: Date;
        ApplnCurrencyCode: Code[10];
        ApplnRoundingPrecision: Decimal;
        ApplnRounding: Decimal;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        AmountRoundingPrecision: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        StyleTxt: Text;
        CalcType: Option Direct,GenJnlLine,PurchHeader,PV;
        VendEntryApplID: Code[50];
        AppliesToID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        Text002: Label 'You must select an applying entry before you can post the application.';
        Text003: Label 'You must post the application from the window where you entered the applying entry.';
        CannotSetAppliesToIDErr: Label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        ShowAppliedEntries: Boolean;
        OK: Boolean;
        EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        PostingDone: Boolean;
        [InDataSet]
        AppliesToIDVisible: Boolean;
        ActionPerformed: Boolean;
        Text012: Label 'The application was successfully posted.';
        Text013: Label 'The %1 entered must not be before the %1 on the %2.';
        Text019: Label 'Post application process has been canceled.';
        IsOfficeAddin: Boolean;
        PVLine: Record "FIN-Payment Line";

    //[Scope('Internal')]
    procedure SetGenJnlLine(NewGenJnlLine: Record 81; ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;
        GenJnlLineApply := TRUE;

        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
            ApplyingAmount := GenJnlLine.Amount;
        IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
            ApplyingAmount := -GenJnlLine.Amount;
        ApplnDate := GenJnlLine."Posting Date";
        ApplnCurrencyCode := GenJnlLine."Currency Code";
        CalcType := CalcType::GenJnlLine;

        CASE ApplnTypeSelect OF
            GenJnlLine.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            GenJnlLine.FIELDNO("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        END;

        SetApplyingVendLedgEntry;
    end;

    //[Scope('Internal')]
    procedure SetPurch(NewPurchHeader: Record "Purchase Header"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    var
        SalesTaxCalculate: Codeunit 398;
        //SalesTaxAmountLine: Record "Sales Tax Amount Line" temporary;
        PurchLine: Record "Purchase Line";
    begin
        PurchHeader := NewPurchHeader;
        Rec.COPYFILTERS(NewVendLedgEntry);

        PurchPost.SumPurchLines(
          PurchHeader, 0, TotalPurchLine, TotalPurchLineLCY,
          VATAmount, VATAmountText);

        //SalesTaxAmountLine.DELETEALL;
        // IF PurchHeader."Tax Area Code" <> '' THEN BEGIN
        //     SalesTaxCalculate.StartSalesTaxCalculation;
        //     Rec.SETRANGE("Document Type", PurchHeader."Document Type");
        //     Rec.SETRANGE("Document No.", PurchHeader."No.");
        //     IF Rec.FIND('-') THEN
        //         REPEAT
        //             IF Type <> 0 THEN
        //                 SalesTaxCalculate.AddPurchLine(PurchLine);
        //         UNTIL Rec.NEXT = 0;
        //     SalesTaxCalculate.EndSalesTaxCalculation(PurchHeader."Posting Date");
        //     SalesTaxCalculate.GetSalesTaxAmountLineTable(SalesTaxAmountLine);
        //     TotalPurchLine."Amount Including VAT" := TotalPurchLine."Amount Including VAT" + SalesTaxAmountLine.GetTotalTaxAmount;
        // END;

        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::"Return Order",
          PurchHeader."Document Type"::"Credit Memo":
                ApplyingAmount := TotalPurchLine."Amount Including VAT"
            ELSE
                ApplyingAmount := -TotalPurchLine."Amount Including VAT";
        END;

        ApplnDate := PurchHeader."Posting Date";
        ApplnCurrencyCode := PurchHeader."Currency Code";
        CalcType := CalcType::PurchHeader;

        CASE ApplnTypeSelect OF
            PurchHeader.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            PurchHeader.FIELDNO("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        END;

        SetApplyingVendLedgEntry;
    end;

    //[Scope('Internal')]
    procedure SetVendLedgEntry(NewVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        Rec := NewVendLedgEntry;
    end;

    //[Scope('Internal')]
    procedure SetApplyingVendLedgEntry()
    var
        Vendor: Record Vendor;
    begin
        CASE CalcType OF
            CalcType::PurchHeader:
                BEGIN
                    ApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
                    IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order" THEN
                        ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type"::"Credit Memo"
                    ELSE
                        ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type";
                    ApplyingVendLedgEntry."Document No." := PurchHeader."No.";
                    ApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
                    ApplyingVendLedgEntry.Description := PurchHeader."Posting Description";
                    ApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
                    IF ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::"Credit Memo" THEN BEGIN
                        ApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
                        ApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
                    END ELSE BEGIN
                        ApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
                        ApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
                    END;
                    CalcApplnAmount;
                END;
            CalcType::Direct:
                BEGIN
                    IF Rec."Applying Entry" THEN BEGIN
                        IF ApplyingVendLedgEntry."Entry No." <> 0 THEN
                            VendLedgEntry := ApplyingVendLedgEntry;
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
                        IF Rec."Applies-to ID" = '' THEN
                            SetVendApplId;
                        Rec.CALCFIELDS(Amount);
                        ApplyingVendLedgEntry := Rec;
                        IF VendLedgEntry."Entry No." <> 0 THEN BEGIN
                            Rec := VendLedgEntry;
                            Rec."Applying Entry" := FALSE;
                            SetVendApplId;
                        END;
                        Rec.SETFILTER("Entry No.", '<> %1', ApplyingVendLedgEntry."Entry No.");
                        ApplyingAmount := ApplyingVendLedgEntry."Remaining Amount";
                        ApplnDate := ApplyingVendLedgEntry."Posting Date";
                        ApplnCurrencyCode := ApplyingVendLedgEntry."Currency Code";
                    END;
                    CalcApplnAmount;
                END;
            CalcType::GenJnlLine:
                BEGIN
                    ApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                    ApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
                    ApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
                    IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN BEGIN
                        ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
                        Vendor.GET(ApplyingVendLedgEntry."Vendor No.");
                        ApplyingVendLedgEntry.Description := Vendor.Name;
                    END ELSE BEGIN
                        ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
                        ApplyingVendLedgEntry.Description := GenJnlLine.Description;
                    END;
                    ApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
                    ApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
                    ApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
                    CalcApplnAmount;
                END;
        END;
    end;

    //[Scope('Internal')]
    procedure SetVendApplId()
    begin
        IF (CalcType = CalcType::GenJnlLine) AND (ApplyingVendLedgEntry."Posting Date" < Rec."Posting Date") THEN
            ERROR(
              EarlierPostingDateErr, ApplyingVendLedgEntry."Document Type", ApplyingVendLedgEntry."Document No.",
              Rec."Document Type", Rec."Document No.");

        IF ApplyingVendLedgEntry."Entry No." <> 0 THEN
            GenJnlApply.CheckAgainstApplnCurrency(
              ApplnCurrencyCode, Rec."Currency Code", GenJnlLine."Account Type"::Vendor, TRUE);

        VendLedgEntry.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(VendLedgEntry);
        IF GenJnlLineApply THEN
            VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, GenJnlLine."Applies-to ID")
        ELSE

            //Added for PV
            IF CalcType = CalcType::PV THEN
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PVLine."Applies-to ID")
            ELSE //Added for PV
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PurchHeader."Applies-to ID");


        ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
        CalcApplnAmount;
    end;

    local procedure CalcApplnAmount()
    begin
        AppliedAmount := 0;
        PmtDiscAmount := 0;
        DifferentCurrenciesInAppln := FALSE;

        CASE CalcType OF
            CalcType::Direct:
                BEGIN
                    FindAmountRounding;
                    VendEntryApplID := USERID;
                    IF VendEntryApplID = '' THEN
                        VendEntryApplID := '***';

                    VendLedgEntry := ApplyingVendLedgEntry;

                    AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                    AppliedVendLedgEntry.SETRANGE("Vendor No.", Rec."Vendor No.");
                    AppliedVendLedgEntry.SETRANGE(Open, TRUE);
                    IF AppliesToID = '' THEN
                        AppliedVendLedgEntry.SETRANGE("Applies-to ID", VendEntryApplID)
                    ELSE
                        AppliedVendLedgEntry.SETRANGE("Applies-to ID", AppliesToID);

                    IF ApplyingVendLedgEntry."Entry No." <> 0 THEN BEGIN
                        VendLedgEntry.CALCFIELDS("Remaining Amount");
                        AppliedVendLedgEntry.SETFILTER("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                    END;

                    HandlChosenEntries(0,
                      VendLedgEntry."Remaining Amount",
                      VendLedgEntry."Currency Code",
                      VendLedgEntry."Posting Date");
                END;
            CalcType::GenJnlLine:
                BEGIN
                    FindAmountRounding;
                    IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
                        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);

                    CASE ApplnType OF
                        ApplnType::"Applies-to Doc. No.":
                            BEGIN
                                AppliedVendLedgEntry := Rec;
                                AppliedVendLedgEntry.CALCFIELDS("Remaining Amount");
                                IF AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode THEN BEGIN
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");
                                    AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Pmt. Disc. Possible");
                                    AppliedVendLedgEntry."Amount to Apply" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Amount to Apply");
                                END;

                                IF AppliedVendLedgEntry."Amount to Apply" <> 0 THEN
                                    AppliedAmount := ROUND(AppliedVendLedgEntry."Amount to Apply", AmountRoundingPrecision)
                                ELSE
                                    AppliedAmount := ROUND(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
                                     GenJnlLine, AppliedVendLedgEntry, 0, FALSE) AND
                                   ((ABS(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                                     ABS(AppliedAmount - AppliedVendLedgEntry."Remaining Pmt. Disc. Possible")) OR
                                    (GenJnlLine.Amount = 0))
                                THEN
                                    PmtDiscAmount := AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";

                                IF NOT DifferentCurrenciesInAppln THEN
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                CheckRounding;
                            END;
                        ApplnType::"Applies-to ID":
                            BEGIN
                                GenJnlLine2 := GenJnlLine;
                                AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SETRANGE("Vendor No.", GenJnlLine."Account No.");
                                AppliedVendLedgEntry.SETRANGE(Open, TRUE);
                                AppliedVendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");

                                HandlChosenEntries(1,
                                  GenJnlLine2.Amount,
                                  GenJnlLine2."Currency Code",
                                  GenJnlLine2."Posting Date");
                            END;
                    END;
                END;
            CalcType::PurchHeader:
                BEGIN
                    FindAmountRounding;

                    CASE ApplnType OF
                        ApplnType::"Applies-to Doc. No.":
                            BEGIN
                                AppliedVendLedgEntry := Rec;
                                AppliedVendLedgEntry.CALCFIELDS("Remaining Amount");

                                IF AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode THEN
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");

                                AppliedAmount := AppliedAmount + ROUND(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                IF NOT DifferentCurrenciesInAppln THEN
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                CheckRounding;
                            END;
                        ApplnType::"Applies-to ID":
                            BEGIN
                                AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SETRANGE("Vendor No.", PurchHeader."Pay-to Vendor No.");
                                AppliedVendLedgEntry.SETRANGE(Open, TRUE);
                                AppliedVendLedgEntry.SETRANGE("Applies-to ID", PurchHeader."Applies-to ID");

                                HandlChosenEntries(2,
                                  ApplyingAmount,
                                  ApplnCurrencyCode,
                                  ApplnDate);
                            END;
                    END;
                END;
        END;
    end;

    local procedure CalcApplnRemainingAmount(Amount: Decimal): Decimal
    var
        ApplnRemainingAmount: Decimal;
    begin
        ValidExchRate := TRUE;
        IF ApplnCurrencyCode = Rec."Currency Code" THEN
            EXIT(Amount);

        IF ApplnDate = 0D THEN
            ApplnDate := Rec."Posting Date";
        ApplnRemainingAmount :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, Amount, ValidExchRate);
        EXIT(ApplnRemainingAmount);
    end;

    local procedure CalcApplnAmounttoApply(AmounttoApply: Decimal): Decimal
    var
        ApplnAmountToApply: Decimal;
    begin
        ValidExchRate := TRUE;

        IF ApplnCurrencyCode = Rec."Currency Code" THEN
            EXIT(AmounttoApply);

        IF ApplnDate = 0D THEN
            ApplnDate := Rec."Posting Date";
        ApplnAmountToApply :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, AmounttoApply, ValidExchRate);
        EXIT(ApplnAmountToApply);
    end;

    local procedure FindAmountRounding()
    begin
        IF ApplnCurrencyCode = '' THEN BEGIN
            Currency.INIT;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
        END ELSE
            IF ApplnCurrencyCode <> Currency.Code THEN
                Currency.GET(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    local procedure CheckRounding()
    begin
        ApplnRounding := 0;

        CASE CalcType OF
            CalcType::PurchHeader:
                EXIT;
            CalcType::GenJnlLine:
                IF (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) AND
                   (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
                THEN
                    EXIT;
        END;

        IF ApplnCurrencyCode = '' THEN
            ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
        ELSE BEGIN
            IF ApplnCurrencyCode <> Rec."Currency Code" THEN
                Currency.GET(ApplnCurrencyCode);
            ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        END;

        IF (ABS((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) AND DifferentCurrenciesInAppln THEN
            ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    end;

    //[Scope('Internal')]
    procedure GetVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            VendEntryApplID := USERID;
            IF VendEntryApplID = '' THEN
                VendEntryApplID := '***';

            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
            VendLedgEntry.SETRANGE("Vendor No.", Rec."Vendor No.");
            IF AppliesToID = '' THEN
                VendLedgEntry.SETRANGE("Applies-to ID", VendEntryApplID)
            ELSE
                VendLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE("Applying Entry", TRUE);
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                VendLedgEntry.CALCFIELDS(Amount, "Remaining Amount");
                ApplyingVendLedgEntry := VendLedgEntry;
                Rec.SETFILTER("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                ApplyingAmount := VendLedgEntry."Remaining Amount";
                ApplnDate := VendLedgEntry."Posting Date";
                ApplnCurrencyCode := VendLedgEntry."Currency Code";
            END;
            CalcApplnAmount;
        END;
    end;

    local procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,PurchHeader; CurrentAmount: Decimal; CurrencyCode: Code[10]; PostingDate: Date)
    var
        AppliedVendLedgEntryTemp: Record "Vendor Ledger Entry" temporary;

        //AppliedVendLedgEntryTemp: Record "Vendor Ledger Entry";
        PossiblePmtdisc: Decimal;
        OldPmtdisc: Decimal;
        CorrectionAmount: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
    begin
        IF AppliedVendLedgEntry.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
                AppliedVendLedgEntryTemp.INSERT;
            UNTIL AppliedVendLedgEntry.NEXT = 0;
        END ELSE
            EXIT;

        FromZeroGenJnl := (CurrentAmount = 0) AND (Type = Type::GenJnlLine);

        REPEAT
            IF NOT FromZeroGenJnl THEN
                AppliedVendLedgEntryTemp.SETRANGE(Positive, CurrentAmount < 0);
            IF AppliedVendLedgEntryTemp.FINDFIRST THEN BEGIN
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedVendLedgEntryTemp, PostingDate);

                CASE Type OF
                    Type::Direct:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry, AppliedVendLedgEntryTemp, 0, FALSE, FALSE);
                    Type::GenJnlLine:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2, AppliedVendLedgEntryTemp, 0, FALSE)
                    ELSE
                        CanUseDisc := FALSE;
                END;

                IF CanUseDisc AND
                   (ABS(AppliedVendLedgEntryTemp."Amount to Apply") >= ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                      AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                THEN BEGIN
                    IF (ABS(CurrentAmount) > ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                          AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                    THEN BEGIN
                        PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                        CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                          AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    END ELSE
                        IF (ABS(CurrentAmount) = ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                              AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                        THEN BEGIN
                            PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                              AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            AppliedAmount := AppliedAmount + CorrectionAmount;
                        END ELSE
                            IF FromZeroGenJnl THEN BEGIN
                                PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                CurrentAmount := CurrentAmount +
                                  AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            END ELSE BEGIN
                                IF (CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" <= 0) <> (CurrentAmount <= 0) THEN BEGIN
                                    PmtDiscAmount := PmtDiscAmount + PossiblePmtdisc;
                                    AppliedAmount := AppliedAmount + CorrectionAmount;
                                END;
                                CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                PossiblePmtdisc := AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            END;
                END ELSE BEGIN
                    IF ((CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply") * CurrentAmount) >= 0 THEN
                        AppliedAmount := AppliedAmount + CorrectionAmount;
                    CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply";
                END;
            END ELSE BEGIN
                AppliedVendLedgEntryTemp.SETRANGE(Positive);
                AppliedVendLedgEntryTemp.FINDFIRST;
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedVendLedgEntryTemp, PostingDate);
            END;

            IF OldPmtdisc <> PmtDiscAmount THEN
                AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Remaining Amount"
            ELSE
                AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Amount to Apply";
            OldPmtdisc := PmtDiscAmount;

            IF PossiblePmtdisc <> 0 THEN
                CorrectionAmount := AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Amount to Apply"
            ELSE
                CorrectionAmount := 0;

            IF NOT DifferentCurrenciesInAppln THEN
                DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntryTemp."Currency Code";

            AppliedVendLedgEntryTemp.DELETE;
            AppliedVendLedgEntryTemp.SETRANGE(Positive);

        UNTIL NOT AppliedVendLedgEntryTemp.FINDFIRST;
        PmtDiscAmount += PossiblePmtdisc;
        CheckRounding;
    end;

    local procedure AmounttoApplyOnAfterValidate()
    begin
        IF ApplnType <> ApplnType::"Applies-to Doc. No." THEN BEGIN
            CalcApplnAmount;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure RecalcApplnAmount()
    begin
        CurrPage.UPDATE(TRUE);
        CalcApplnAmount;
    end;

    local procedure LookupOKOnPush()
    begin
        OK := TRUE;
    end;

    local procedure PostDirectApplication(PreviewMode: Boolean)
    var
        VendEntryApplyPostedEntries: Codeunit 227;
        PostApplication: Page 579;
        ApplicationDate: Date;
        NewApplicationDate: Date;
        NewDocumentNo: Code[20];
    begin
        IF CalcType = CalcType::Direct THEN BEGIN
            IF ApplyingVendLedgEntry."Entry No." <> 0 THEN BEGIN
                Rec := ApplyingVendLedgEntry;
                ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);

                PostApplication.SetValues(Rec."Document No.", ApplicationDate);
                IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
                    PostApplication.GetValues(NewDocumentNo, NewApplicationDate);
                    IF NewApplicationDate < ApplicationDate THEN
                        ERROR(Text013, Rec.FIELDCAPTION("Posting Date"), Rec.TABLECAPTION);
                END ELSE
                    ERROR(Text019);

                IF PreviewMode THEN
                    VendEntryApplyPostedEntries.PreviewApply(Rec, NewDocumentNo, NewApplicationDate)
                ELSE
                    VendEntryApplyPostedEntries.Apply(Rec, NewDocumentNo, NewApplicationDate);

                IF NOT PreviewMode THEN BEGIN
                    MESSAGE(Text012);
                    PostingDone := TRUE;
                    CurrPage.CLOSE;
                END;
            END ELSE
                ERROR(Text002);
        END ELSE
            ERROR(Text003);
    end;

    local procedure CheckActionPerformed(): Boolean
    begin
        IF ActionPerformed THEN
            EXIT(FALSE);
        IF (NOT (CalcType = CalcType::Direct) AND NOT OK AND NOT PostingDone) OR
           (ApplnType = ApplnType::"Applies-to Doc. No.")
        THEN
            EXIT(FALSE);
        EXIT(CalcType = CalcType::Direct);
    end;

    //[Scope('Internal')]
    procedure SetAppliesToID(AppliesToID2: Code[50])
    begin
        AppliesToID := AppliesToID2;
    end;

    local procedure ExchangeAmountsOnLedgerEntry(Type: Option Direct,GenJnlLine,PurchHeader; CurrencyCode: Code[10]; var CalcVendLedgEntry: Record "Vendor Ledger Entry"; PostingDate: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcVendLedgEntry.CALCFIELDS("Remaining Amount");

        IF Type = Type::Direct THEN
            CalculateCurrency := ApplyingVendLedgEntry."Entry No." <> 0
        ELSE
            CalculateCurrency := TRUE;

        IF (CurrencyCode <> CalcVendLedgEntry."Currency Code") AND CalculateCurrency THEN BEGIN
            CalcVendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Amount",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Pmt. Disc. Possible",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcVendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Amount to Apply",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
        END;
    end;

    //[Scope('Internal')]
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
        END;
        CASE ApplnTypeSelect OF
            NewPVLine.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            NewPVLine.FIELDNO("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        END;

        SetApplyingVendLedgEntry;
    end;

    //[Scope('Internal')]
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
}