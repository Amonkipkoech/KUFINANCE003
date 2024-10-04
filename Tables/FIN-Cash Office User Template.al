table 52178711 "FIN-Cash Office User Template"
{
    DataCaptionFields = UserID;
    //DrillDownPageID = 68579;
    //LookupPageID = 68579;

    fields
    {
        field(1; UserID; Code[30])
        {
            Description = 'Stores the reference of the user in the database';
            NotBlank = true;

            trigger OnLookup()
            begin
                LoginMgt.LookupUserID(UserID);
            end;

            trigger OnValidate()
            begin
                LoginMgt.ValidateUserID(UserID);
            end;
        }
        field(2; "Receipt Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(3; "Receipt Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SETRANGE(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same batch.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(4; "Payment Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the payment journal template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(5; "Payment Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the payment journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SETRANGE(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same batch.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(6; "Petty Cash Template"; Code[20])
        {
            Description = 'Stores the reference to the petty cash payment voucher in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(7; "Petty Cash Batch"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Petty Cash Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Petty Cash Template", "Petty Cash Template");
                UserTemp.SETRANGE(UserTemp."Petty Cash Batch", "Petty Cash Batch");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same batch.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(8; "Inter Bank Template Name"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(9; "Inter Bank Batch Name"; Code[20])
        {
            Description = 'Stores the reference to the inter bank transfer batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Inter Bank Template Name"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Inter Bank Template Name", "Inter Bank Template Name");
                UserTemp.SETRANGE(UserTemp."Inter Bank Batch Name", "Inter Bank Batch Name");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same batch.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(10; "Default Receipts Bank"; Code[20])
        {
            Description = 'Stores the reference to the default receipts bank deposit account';
            TableRelation = "Bank Account"."No." WHERE("Bank Type" = FILTER(Cash | 'Chq Collection'));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Default Receipts Bank", "Default Receipts Bank");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same bank.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(11; "Default Payment Bank"; Code[20])
        {
            Description = 'Stores the reference to the default payments bank deposit account';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Default Payment Bank", "Default Payment Bank");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same bank.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(12; "Default Petty Cash Bank"; Code[20])
        {
            Description = 'Stores the reference to the default petty cash account in the database';
            TableRelation = "Bank Account"."No.";
            // WHERE("Bank Type" = CONST(Cash))
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Default Petty Cash Bank", "Default Petty Cash Bank");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same bank.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(13; "Max. Cash Collection"; Decimal)
        {
        }
        field(14; "Max. Cheque Collection"; Decimal)
        {
        }
        field(15; "Max. Deposit Slip Collection"; Decimal)
        {
        }
        field(16; "Supervisor ID"; Code[20])
        {
            Description = 'Stores the reference for the supervisor for the specific teller';

            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID("Supervisor ID");
            end;

            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID("Supervisor ID");
            end;
        }
        field(17; "Bank Pay In Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(18; "Bank Pay In Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bank Pay In Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.RESET;
                UserTemp.SETRANGE(UserTemp."Bank Pay In Journal Template", "Bank Pay In Journal Template");
                UserTemp.SETRANGE(UserTemp."Bank Pay In Journal Batch", "Bank Pay In Journal Batch");
                IF UserTemp.FINDFIRST THEN BEGIN
                    REPEAT
                        IF UserTemp.UserID <> Rec.UserID THEN BEGIN
                            ERROR('Please note that another user has been assigned the same batch.');
                        END;
                    UNTIL UserTemp.NEXT = 0;
                END;

            end;
        }
        field(19; "Imprest Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(20; "Imprest  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50000; "Claim Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50001; "Claim  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Claim Template"));
        }
        field(50002; "Advance Template"; Code[20])
        {
            Caption = 'Other Advance Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50003; "Advance  Batch"; Code[20])
        {
            Caption = 'Other Advance  Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Advance Template"));
        }
        field(50004; "Advance Surr Template"; Code[20])
        {
            Caption = 'Other Advance Surr Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50005; "Advance Surr Batch"; Code[20])
        {
            Caption = 'Other Advance Surr Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Advance Surr Template"));
        }
        field(50006; "Direct Cash Sale Bank"; Code[20])
        {
            TableRelation = "Bank Account"."No." WHERE("Bank Type" = FILTER(Cash));
        }
        field(50007; "Direct Sales Inv. Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50008; "Cash Receipt No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50009; "Default Direct Sale Customer"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50010; "Direct Sales External Doc. Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50011; "Default Direct Sales Location"; Code[20])
        {
            //TableRelation = Location.Code WHERE ("Cafeteria Location"=FILTER(Yes));
        }
        field(50012; "Direct Sales Item Category"; Code[20])
        {
            TableRelation = "Item Category";
        }
        field(50013; "Direct Cash Sale Deposit Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50014; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ///ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(50015; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(50016; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(50017; "Direct  Cash Sale Paybill"; Code[20])
        {
            TableRelation = "Bank Account"."No." WHERE("Bank Type" = FILTER(Cash));
        }//"Default Credit Sale Customer")
        field(50018; "Default Credit Sale Customer"; Code[20])
        {
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserTemp: Record "FIN-Cash Office User Template";
        LoginMgt: Codeunit "User Management 2";
}