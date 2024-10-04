page 52178762 "PROC-Store Req. Header CR"
{

    PageType = Card;
    SourceTable = "PROC-Store Requistion Header";
    Caption = 'Requisition Card';


    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = EditInfo;
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = all;
                }
                field("Request date"; Rec."Request date")
                {
                    ApplicationArea = all;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Department Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = all;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        Rec.TestField(Status, Rec.Status::Released);
                    end;
                }
                field("User ID"; Rec."User ID")
                {
                    Caption = 'Created By';
                    ApplicationArea = all;
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    Editable = false;
                    ApplicationArea = all;
                }


            }
            group(Lines)
            {
                Caption = 'Lines';
                part(Control1; "PROC-Store Requisition Line UP")
                {

                    ApplicationArea = all;
                    SubPageLink = "Requistion No" = FIELD("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Post)
            {
                action("Post Store Requisition")
                {
                    Visible = false;
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;
                    ApplicationArea = all;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        PROCPostedStoreRequisitions: Record "PROC-Posted Store Requisitions";
                        PROCPostedSRNLines: Record "PROC-Posted SRN Lines";
                    begin
                        Rec.TestField("Global Dimension 1 Code");
                        Rec.TestField("Responsibility Center");
                        IF NOT LinesExists THEN
                            ERROR('There are no Lines created for this Document');

                        IF Rec.Status = Rec.Status::Posted THEN
                            ERROR('The Document Has Already been Posted');

                        IF Rec.Status <> Rec.Status::Released THEN
                            ERROR('The Document Has not yet been Approved');

                        IF InventorySetup.GET THEN BEGIN
                            //  ERROR('1');
                            InventorySetup.TESTFIELD(InventorySetup."Item Issue Template");
                            InventorySetup.TESTFIELD(InventorySetup."Item Issue Batch");
                            // InventorySetup.TESTFIELD(InventorySetup."SIV Numbers");
                            GenJnline.RESET;
                            GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Issue Template");
                            GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Issue Batch");
                            IF GenJnline.FIND('-') THEN GenJnline.DELETEALL;
                        END ELSE
                            ERROR('Missing Inventory Setup');
                        // Create Posted SRN Header Here
                        PROCPostedStoreRequisitions.INIT;
                        PROCPostedStoreRequisitions."No." := Rec."No.";
                        // PROCPostedStoreRequisitions."MA Number" := Rec."MA Number";
                        PROCPostedStoreRequisitions."SIV Number" := NoSeriesManagement.GetNextNo(InventorySetup."SIV Numbers", TODAY, TRUE);
                        PROCPostedStoreRequisitions."Request date" := Rec."Request date";
                        PROCPostedStoreRequisitions."Required Date" := Rec."Required Date";
                        PROCPostedStoreRequisitions."Requester ID" := Rec."Requester ID";
                        PROCPostedStoreRequisitions."Request Description" := Rec."Request Description";
                        PROCPostedStoreRequisitions."No. Series" := Rec."No. Series";
                        PROCPostedStoreRequisitions.Status := PROCPostedStoreRequisitions.Status::Open;
                        PROCPostedStoreRequisitions."User ID" := Rec."User ID";
                        PROCPostedStoreRequisitions."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        PROCPostedStoreRequisitions."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                        PROCPostedStoreRequisitions."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 3 Code";
                        PROCPostedStoreRequisitions."Shortcut Dimension 4 Code" := Rec."Shortcut Dimension 4 Code";
                        PROCPostedStoreRequisitions."Responsibility Center" := Rec."Responsibility Center";
                        PROCPostedStoreRequisitions."Issuing Store" := Rec."Issuing Store";
                        PROCPostedStoreRequisitions.Status := PROCPostedStoreRequisitions.Status::Posted;
                        PROCPostedStoreRequisitions.INSERT(TRUE);
                        CLEAR(reLineNos);
                        Rec.TESTFIELD("Issuing Store");
                        ReqLine.RESET;
                        ReqLine.SETRANGE(ReqLine."Requistion No", Rec."No.");
                        ReqLine.SETFILTER(ReqLine."Quantity To Issue", '>%1', 0);
                        Rec.TESTFIELD("Issuing Store");
                        IF ReqLine.FIND('-') THEN BEGIN

                            REPEAT
                            BEGIN
                                //Issue
                                LineNo := LineNo + 1000;

                                InventoryItem.Reset();
                                InventoryItem.SetRange("No.", ReqLine."No.");
                                if InventoryItem.FindFirst() then begin
                                    InventoryItem.CalcFields(Inventory);
                                    if InventoryItem.Inventory < ReqLine."Quantity To Issue" then Error('less quantity in stock \ avalable stock %1 \ stock to issue %2', InventoryItem.Inventory, ReqLine."Quantity To Issue");
                                end;

                                GenJnline.INIT;
                                GenJnline."Journal Template Name" := InventorySetup."Item Issue Template";
                                GenJnline."Journal Batch Name" := InventorySetup."Item Issue Batch";
                                GenJnline."Line No." := LineNo;
                                GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
                                GenJnline."Document No." := Rec."No.";
                                GenJnline."Item No." := ReqLine."No.";
                                GenJnline.VALIDATE("Item No.");
                                GenJnline."Location Code" := Rec."Issuing Store";
                                GenJnline.VALIDATE("Location Code");
                                GenJnline."Posting Date" := Rec."Required Date";
                                GenJnline.Description := ReqLine.Description;
                                //GenJnline.Quantity:=ReqLine.Quantity;
                                GenJnline.Quantity := ReqLine."Quantity To Issue";
                                GenJnline."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                                GenJnline."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnline.VALIDATE("Shortcut Dimension 2 Code");
                                GenJnline.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnline.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnline.VALIDATE(Quantity);
                                GenJnline.VALIDATE("Unit Amount");
                                GenJnline."Reason Code" := '221';
                                GenJnline.VALIDATE("Reason Code");

                                GenJnline.INSERT(TRUE);


                                reLineNos := reLineNos + 1;
                                // Insert SR Lines
                                PROCPostedSRNLines.INIT;
                                PROCPostedSRNLines."No." := ReqLine."No.";
                                PROCPostedSRNLines."Requistion No" := PROCPostedStoreRequisitions."No.";
                                PROCPostedSRNLines."SIV Number" := PROCPostedStoreRequisitions."SIV Number";
                                PROCPostedSRNLines."Line No." := reLineNos;
                                PROCPostedSRNLines."Unit Cost" := ReqLine."Unit Cost";
                                PROCPostedSRNLines."Unit of Measure" := ReqLine."Unit of Measure";
                                PROCPostedSRNLines.Type := ReqLine.Type;
                                PROCPostedSRNLines.Description := ReqLine.Description;
                                PROCPostedSRNLines.Quantity := ReqLine.Quantity;
                                PROCPostedSRNLines."Quantity Requested" := ReqLine."Quantity Requested";
                                PROCPostedSRNLines."Quantity To Issue" := ReqLine."Quantity To Issue";
                                PROCPostedSRNLines."Quantity Issued" := ReqLine."Quantity To Issue";
                                PROCPostedSRNLines."Line Amount" := ReqLine."Line Amount";
                                PROCPostedSRNLines."MA Number" := PROCPostedStoreRequisitions."MA Number";
                                PROCPostedSRNLines."Shortcut Dimension 3 Code" := ReqLine."Shortcut Dimension 3 Code";
                                PROCPostedSRNLines."Issuing Store" := ReqLine."Issuing Store";
                                PROCPostedSRNLines.INSERT(TRUE);

                                //  Message('Strq dimValue %1 \\ SIV dimvalue %2', ReqLine."Shortcut Dimension 3 Code", PROCPostedSRNLines."Shortcut Dimension 3 Code");

                                //ReqLine."Quantity Issued" := ReqLine."Quantity Issued" + ReqLine."Quantity To Issue";
                                ReqLine."Quantity Issued" := ReqLine."Quantity To Issue";
                                ReqLine."Quantity To Issue" := 0;

                                IF ReqLine."Quantity Issued" = ReqLine."Quantity Requested" THEN
                                    ReqLine."Request Status" := ReqLine."Request Status"::Closed;
                                ReqLine.MODIFY;
                                //// Populate Posted SIN

                            END;
                            UNTIL ReqLine.NEXT = 0;
                            //Post Entries
                            GenJnline.RESET;
                            GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Issue Template");
                            //
                            GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Issue Batch");
                            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", GenJnline);
                            //End Post entries

                            //Modify All

                            Post := JournlPosted.PostedSuccessfully();
                            IF Post THEN;
                            // ReqLine.MODIFYALL(ReqLine."Request Status",ReqLine."Request Status"::Closed);

                        END;

                        Post := TRUE;
                        ReqLine.RESET;
                        ReqLine.SETRANGE(ReqLine."Requistion No", Rec."No.");
                        IF ReqLine.FIND('-') THEN BEGIN
                            REPEAT
                            BEGIN
                                IF ReqLine."Quantity Issued" <> ReqLine."Quantity Requested" THEN
                                    IF (Post = TRUE) THEN
                                        Post := FALSE;
                            END;
                            UNTIL ReqLine.NEXT = 0;
                        END;
                        IF Post = TRUE THEN BEGIN
                            Rec.Status := Rec.Status::Posted;
                            // Rec."Posted By" := USERID;
                            Rec.MODIFY;
                        END;

                        PROCPostedStoreRequisitions.Status := PROCPostedStoreRequisitions.Status::Posted;
                        PROCPostedStoreRequisitions.MODIFY;
                        CurrPage.UPDATE;

                    end;
                }

            }
            group("&Functions")
            {
                Caption = '&Functions';
                separator(Separator1102755029)
                {
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::"Store Req";
                        //  ApprovalEntries.Setfilters(DATABASE::"PROC-Store Requistion Header", DocumentType, Rec."No.");
                        //  ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    ApplicationArea = all;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                    //ApprovalsMngt: Codeunit "Approval Mgmnt. Ext";
                    begin

                        // ApprovalsMngt.CheckStoreRequisitionApprovalPossible(Rec);
                        // ApprovalsMngt.OnSendStoreRequisitionForApproval(Rec);

                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = all;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;


                    trigger OnAction()
                    var
                    // ApprovalsMngt: Codeunit "Approval Mgmnt. Ext";
                    begin
                        // ApprovalsMngt.OnCancelStoreRequisitionForApproval(Rec);

                    end;
                }

                separator(Separator1102755035)
                {
                }
                action("Check Budget Availlabilty")
                {
                    Caption = 'Check Budget Availlabilty';
                    Image = Check;
                    Promoted = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;
                        if (Rec."Issuing Store" <> 'CENTRAL') and (Rec."Issuing Store" <> 'GENERAL') then
                            Error('This function is only applicable to Central Stores')
;
                        //IF Status=Status::Released THEN
                        //  ERROR('This document has already been released. This functionality is available for open documents only');
                        //IF NOT SomeLinesCommitted THEN BEGIN
                        //   IF NOT CONFIRM( 'Some or All the Lines Are already Committed do you want to continue',TRUE, "Document Type") THEN
                        //        ERROR('Budget Availability Check and Commitment Aborted');
                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::Requisition);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;
                        //END;

                        //IF "Requisition Type"="Requisition Type"::Stationery THEN

                        // Commitment.CheckStaffClaim(Rec)
                        // ELSE
                        // ERROR('Please note that only Stationery Items are voted');

                        Rec.Committed := true;
                        Rec.Modify;
                        Message('Budget Availability Checking Complete');
                    end;
                }
                separator(Separator1102755038)
                {
                }
                action("Cancel Budget Commitments")
                {
                    Caption = 'Cancel Budget Commitments';
                    Image = CancelLine;
                    Promoted = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField(Committed);
                        if not Confirm('Are you sure you want to Cancel All Commitments Done for this document', true) then
                            Error('Budget Availability Check and Commitment Aborted');

                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::Requisition);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;
                        //Tag all the SRN entries as Uncommitted
                        Rec.Committed := false;
                        Rec.Modify;
                        Message('Commitments Cancelled Successfully for Doc. No %1', Rec."No.");
                    end;
                }
                separator(Separator1102755045)
                {
                }


                separator(Separator1102755044)
                {
                }
            }

        }
        area(Reporting)
        {
            group(Reports)
            {
                action("Print/Preview")
                {
                    ApplicationArea = all;
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Released);

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(60001, true, true, Rec);
                        Rec.Reset;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls();
        // OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateControls();
        //"Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");

        Rec."User ID" := UserId;
        //  OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        UpdateControls;
    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        //   ApprovalMgt: Codeunit "Approvals Management-PROC";
        ReqLine: Record "PROC-Store Requistion Lines";
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,"Store Req";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        //todo        MinorAssetsIssue: Record "FIN-Minor Ass. Issue & Returns";
        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "FIN-Budgetary Control Setup";
        DeleteCommitment: Record "FIN-Committment";
        Loc: Record Location;
        //  ApprovalEntries: Page "Approval Entries-MA";
        NoSeriesManagement: Codeunit 396;
        reLineNos: Integer;
        EditInfo: Boolean;
        UserSetup: Record "User Setup";
        InventoryItem: Record Item;


    procedure LinesExists(): Boolean
    var
        PayLines: Record "PROC-Store Requistion Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Requistion No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;


    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Open then
            EditInfo := true
        else begin

        end;

        /* IF Status<>Status::Released THEN BEGIN
         CurrForm."Issue Date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
         CurrForm."Issue Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;
            IF Status=Status::Open THEN BEGIN
         CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
         CurrForm."Request date" .EDITABLE:=TRUE;
         CurrForm."Responsibility Center" .EDITABLE:=TRUE;
         CurrForm."Issuing Store" .EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
         CurrForm."Required Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
         CurrForm."Request Description".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
          CurrForm."Request date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END
         */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;




    // procedure UpdateLines()
    // var
    //     AgriMAHeader: Record "Agri-Material Applic. Header";
    //     AgriMALines: Record "Agri-Material Applic. Lines";
    //     AgriMAFieldsList: Record "Agri-MA Fields List";
    //     totalFieldArea: Record "Agri-MA Fields List";
    //     STRQHeader: Record "PROC-Store Requistion Header";
    //     STRQLines: Record "PROC-Store Requistion Lines";
    //     ReqLine: Integer;

    // begin
    //     STRQHeader.Reset();
    //     STRQHeader.SetRange("No.", Rec."No.");
    //     STRQHeader.SetFilter("MA Number", '<>%1', '');
    //     if STRQHeader.FindFirst() then begin
    //         repeat

    //             STRQLines.Reset();
    //             STRQLines.SetRange("Requistion No", STRQHeader."No.");
    //             if STRQLines.Find('-') then
    //                 STRQLines.DeleteAll();

    //             AgriMAHeader.Reset();
    //             AgriMAHeader.SetRange("MA No.", STRQHeader."MA Number");
    //             if AgriMAHeader.FindFirst() then;

    //             totalFieldArea.Reset();
    //             totalFieldArea.SetRange("MA Number", AgriMAHeader."MA No.");
    //             if totalFieldArea.Find('-') then;
    //             totalFieldArea.CalcSums("Total Area");

    //             AgriMAFieldsList.Reset();
    //             AgriMAFieldsList.SetRange("MA Number", AgriMAHeader."MA No.");
    //             if AgriMAFieldsList.Find('-') then begin

    //                 repeat
    //                     AgriMALines.Reset();
    //                     AgriMALines.SetRange("MA Number", AgriMAHeader."MA No.");
    //                     if AgriMALines.Find('-') then begin
    //                         repeat
    //                             ReqLine := ReqLine + 1;
    //                             STRQLines.Init();
    //                             STRQLines."Line No." := LineNo;
    //                             STRQLines."MA Number" := AgriMAHeader."MA No.";
    //                             STRQLines.Type := STRQLines.Type::Item;
    //                             STRQLines."Issuing Store" := AgriMAHeader."Issuing Store";
    //                             STRQLines."Requistion No" := STRQHeader."No.";
    //                             STRQLines."No." := AgriMALines."Product Code";
    //                             STRQLines.Validate("No.");
    //                             STRQLines.Quantity := AgriMAFieldsList."Total Area" / totalFieldArea."Total Area" * AgriMALines."Total Quantity";
    //                             STRQLines."Shortcut Dimension 3 Code" := AgriMAFieldsList."Field Code";
    //                             STRQLines."Quantity Requested" := STRQLines.Quantity;
    //                             STRQLines."Quantity To Issue" := STRQLines.Quantity;
    //                             IF STRQLines.Insert(true) then
    //                                 Message('Line 1% Update Successfully', LineNo);

    //                         until AgriMALines.Next() = 0;
    //                     end;
    //                 until AgriMAFieldsList.Next() = 0;
    //             end;
    //         until STRQHeader.Next() = 0;
    //     end
    //     else
    //         Message('This STRQ was not generated by MA. MA no is missing');

    // end;

    procedure calculateChemicalFieldArea(): Decimal
    begin

    end;

}

