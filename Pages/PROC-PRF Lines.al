page 52178705 "PROC-PRF Lines"
{
    PageType = Card;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type 2" = CONST(Requisition),
                            "RFQ Created" = filter(false),
                           "Document Type" = CONST(Quote));

    layout
    {
        area(content)
        {
            repeater(_______________)
            {
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type 2"; Rec."Document Type 2")
                {
                    ApplicationArea = All;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("RFQ Created"; Rec."RFQ Created")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Quotation Lines")
            {
                Caption = 'Create Quotation Lines';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*PQLines.RESET;
                    PQLines.SETRANGE(PQLines."Document No.","RFQ No.");
                    IF PQLines.FIND('-') THEN
                    ERROR('The Lines you have selected exist in another RFQ please delete the lines before reselecting again');
                    */// now use  getsrfq
                    Rec.RESET;
                    Rec.SETRANGE(Select, TRUE);
                    //SETRANGE(Status,Status::Released);
                    Rec.SETRANGE("RFQ Created", FALSE);
                    Rec.SETRANGE("Document Type 2", Rec."Document Type 2"::Requisition);
                    IF Rec.FIND('-') THEN BEGIN
                        REPEAT
                            PQLines.INIT;
                            PQLines."Document Type" := Rec."Document Type";
                            PQLines."Document No." := getsrfq;
                            PQLines."Line No." := Rec."Line No.";
                            //PQLines.Type := Type;
                            PQLines."No." := Rec."No.";
                            PQLines."Location Code" := PQLines."Location Code";
                            PQLines."Expected Receipt Date" := Rec."Expected Receipt Date";
                            PQLines.Description := Rec.Description;
                            PQLines."Unit of Measure" := Rec."Unit of Measure";
                            PQLines.Quantity := Rec.Quantity;
                            PQLines.Amount := Rec.Amount;
                            PQLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            PQLines."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PQLines."Unit Cost" := Rec."Unit Cost";
                            PQLines."Line Amount" := Rec."Line Amount";
                            PQLines."Order Date" := Rec."Order Date";
                            Rec."Line Created" := TRUE;
                            PQLines.INSERT;
                            Rec."RFQ No." := getsrfq;
                            Rec.MODIFY;
                        UNTIL Rec.NEXT = 0;
                    END;

                    IF CONFIRM('All Lines Successfully Selected, Exit Window?', TRUE) = TRUE THEN BEGIN
                        CurrPage.CLOSE();



                    END;

                end;
            }
        }
    }

    var
        PQLines: Record "PROC-Purchase Quote Line";
        rfqno: Code[10];
        getsrfq: Code[10];


    procedure GetRFQ(RFQ: Code[10])
    begin
        getsrfq := RFQ;
    end;
}