pageextension 52178712 "Purchase order Ext" extends "Purchase Order"
{
    layout
    {
        modify("Buy-from")
        {
            Visible = false;
        }
        modify("Buy-from Address")
        {
            Visible = false;
        }
        modify("Buy-from Address 2")
        {
            Visible = false;
        }
        modify("Buy-from City")
        {
            Visible = false;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify(BuyFromContactEmail)
        {
            Visible = false;
        }
        modify(Status)
        {
            Editable = false;
        }
        modify("No.")
        {
            Editable = false;
        }
        modify("Assigned User ID")
        {
            Editable = false;
        }
        addafter("Buy-from")
        {
            // field("LPO No."; Rec."LPO No.")
            // {
            //     ApplicationArea = All;
            // }
            field(Department; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Project Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
            }



        }
        addafter(Status)
        {
            field("Delivery Status"; Rec."Delivery Status")
            {
                ApplicationArea = All;
            }




        }
    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                // CommitBudget();
            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //    ExpenseBudget();
            end;
        }

        addbefore(Print)
        {
            action("Print Order")
            {
                ApplicationArea = Suite;
                Caption = 'Print Order';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                // PromotedCategory = Category5;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    REPORT.RUN(52178731, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }

        addbefore(SendCustom)
        {
            action("Print LPO")
            {
                ApplicationArea = All;
                Caption = 'Print LPO';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader := Rec;
                    Rec.RESET;
                    Rec.SETFILTER("No.", Rec."No.");
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    REPORT.RUN(52178890, TRUE, TRUE, Rec);
                    Rec.RESET;
                end;
            }
        }

    }
    local procedure CommitBudget()
    var
        GLAccount: Record 15;
        DimensionValue: Record 349;
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory)) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        //Rec.TESTFIELD("Shortcut Dimension 1 Code");
        //Get Current Lines to loop through
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETFILTER(Type, '%1|%2|%3', PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset", PurchaseLine.Type::"G/L Account");
        IF PurchaseLine.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Check if budget exists
                CLEAR(GLAccountz);
                PurchaseLine.TESTFIELD("No.");
                IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
                    Item.RESET;
                    Item.SETRANGE("No.", PurchaseLine."No.");
                    IF Item.FIND('-') THEN;
                    Item.TESTFIELD("Item G/L Budget Account");
                    GLAccountz := Item."Item G/L Budget Account";
                END ELSE
                    IF PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" THEN BEGIN
                        FixedAsset.RESET;
                        FixedAsset.SETRANGE("No.", PurchaseLine."No.");
                        IF FixedAsset.FIND('-') THEN BEGIN
                            FixedAsset.TESTFIELD("FA Posting Group");
                            FAPostingGroup.RESET;
                            FAPostingGroup.SETRANGE(Code, FixedAsset."FA Posting Group");
                            IF FAPostingGroup.FIND('-') THEN BEGIN
                                FAPostingGroup.TESTFIELD("Acquisition Cost Account");
                                GLAccountz := FAPostingGroup."Acquisition Cost Account";
                            END;
                        END;
                    END ELSE
                        IF PurchaseLine.Type = PurchaseLine.Type::"G/L Account" THEN BEGIN
                            GLAccountz := PurchaseLine."No.";
                        END;
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", GLAccountz);
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 1 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                FINBudgetEntries.RESET;
                FINBudgetEntries.SETRANGE("Budget Name", BCSetup."Current Budget Code");
                FINBudgetEntries.SETRANGE("G/L Account No.", GLAccountz);
                FINBudgetEntries.SETRANGE("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                FINBudgetEntries.SETFILTER("Transaction Type", '%1|%2|%3', FINBudgetEntries."Transaction Type"::Expense, FINBudgetEntries."Transaction Type"::Commitment
                , FINBudgetEntries."Transaction Type"::Allocation);
                FINBudgetEntries.SETFILTER("Commitment Status", '%1|%2',
                FINBudgetEntries."Commitment Status"::" ", FINBudgetEntries."Commitment Status"::Commitment);
                FINBudgetEntries.SETFILTER(Date, PostBudgetEnties.GetBudgetStartAndEndDates(Rec."Order Date"));
                IF FINBudgetEntries.FIND('-') THEN BEGIN
                    IF FINBudgetEntries.CALCSUMS(Amount) THEN BEGIN
                        IF FINBudgetEntries.Amount > 0 THEN BEGIN
                            IF (PurchaseLine."Line Amount" > FINBudgetEntries.Amount) THEN ERROR('Less Funds, Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                            // Commit Budget Here
                            PostBudgetEnties.CheckBudgetAvailability(GLAccountz, Rec."Order Date", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code",
                            PurchaseLine."Line Amount", PurchaseLine.Description, 'LPO', Rec."No." + PurchaseLine."No.", PurchaseLine."Description 2");
                        END ELSE
                            ERROR('No allocation for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
                    END;
                END ELSE
                    ERROR('Missing Budget for  Account:' + GLAccount.Name + ', Department:' + DimensionValue.Name);
            END;
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    local procedure ExpenseBudget()
    var
        GLAccount: Record 15;
        DimensionValue: Record 349;
        PostBudgetEnties: Codeunit "Post Budget Enties";
    begin
        BCSetup.GET;
        IF NOT ((BCSetup.Mandatory) AND (BCSetup."LPO Budget Mandatory")) THEN EXIT;
        BCSetup.TESTFIELD("Current Budget Code");
        Rec.TESTFIELD("Shortcut Dimension 2 Code");
        //Get Current Lines to loop through
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETFILTER(Type, '%1|%2|%3', PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset", PurchaseLine.Type::"G/L Account");
        IF PurchaseLine.FIND('-') THEN BEGIN
            REPEAT
            BEGIN
                // Expense Budget Here
                CLEAR(GLAccountz);
                PurchaseLine.TESTFIELD("No.");
                IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
                    Item.RESET;
                    Item.SETRANGE("No.", PurchaseLine."No.");
                    IF Item.FIND('-') THEN;
                    Item.TESTFIELD("Item G/L Budget Account");
                    GLAccountz := Item."Item G/L Budget Account";
                END ELSE
                    IF PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" THEN BEGIN
                        FixedAsset.RESET;
                        FixedAsset.SETRANGE("No.", PurchaseLine."No.");
                        IF FixedAsset.FIND('-') THEN BEGIN
                            FixedAsset.TESTFIELD("FA Posting Group");
                            FAPostingGroup.RESET;
                            FAPostingGroup.SETRANGE(Code, FixedAsset."FA Posting Group");
                            IF FAPostingGroup.FIND('-') THEN BEGIN
                                FAPostingGroup.TESTFIELD("Acquisition Cost Account");
                                GLAccountz := FAPostingGroup."Acquisition Cost Account";
                            END;
                        END;
                    END ELSE
                        IF PurchaseLine.Type = PurchaseLine.Type::"G/L Account" THEN BEGIN
                            GLAccountz := PurchaseLine."No.";
                        END;
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", GLAccountz);
                IF GLAccount.FIND('-') THEN GLAccount.TESTFIELD(Name);
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FIND('-') THEN DimensionValue.TESTFIELD(Name);
                IF (PurchaseLine."Line Amount" > 0) THEN BEGIN
                    // Commit Budget Here
                    PostBudgetEnties.ExpenseBudget(GLAccountz, Rec."Order Date", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code",
                    PurchaseLine."Line Amount", PurchaseLine.Description, USERID, TODAY, 'LPO', Rec."No." + PurchaseLine."No.", PurchaseLine."Description 2");
                END;
            END;
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    var
        BCSetup: Record "FIN-Budgetary Control Setup";
        FINBudgetEntries: Record "FIN-Budget Entries";
        PurchaseLine: Record "Purchase Line";
        GLAccountz: Code[20];
        FixedAsset: Record "Fixed Asset";
        item: Record Item;
        FAPostingGroup: Record "FA Posting Group";

    trigger OnOpenPage()
    begin
        //Rec."Assigned User ID" := UserId;
       // Rec.Modify();
    end;
}