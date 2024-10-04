/* page 68184 "HMS-Treatment History List"
{
    CardPageID = "HMS Treatment Form History";
    Editable = false;
    PageType = List;
    SourceTable = Table61407;
    SourceTableView = WHERE (Status = CONST (Completed));

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Treatment No."; "Treatment No.")
                {
                    Caption = 'Treatment No.';
                }
                field("Treatment Location"; "Treatment Location")
                {
                }
                field("Treatment Type"; "Treatment Type")
                {
                }
                field(Direct; Direct)
                {
                }
                field("Link No."; "Link No.")
                {
                }
                field("Treatment Date"; "Treatment Date")
                {
                }
                field("Treatment Time"; "Treatment Time")
                {
                }
                field("Doctor ID"; "Doctor ID")
                {
                }
                field("Patient No."; "Patient No.")
                {
                }
                field("Student No."; "Student No.")
                {
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                }
                field("Treatment Remarks"; "Treatment Remarks")
                {
                }
                field("Employee No."; "Employee No.")
                {
                    Caption = 'PF No.';
                    Editable = false;
                }
                field("Employee No.2"; "Employee No.")
                {
                    Editable = false;
                }
                field("Relative No."; "Relative No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("&Treatment Details")
            {
                Caption = '&Treatment Details';
                Image = Ledger;
                action(Processes)
                {
                    Caption = 'Processes';
                    Image = Production;
                    Promoted = true;
                    RunObject = Page 68569;
                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Signs)
                {
                    Caption = 'Signs';
                    Image = RegisteredDocs;
                    Promoted = true;
                    RunObject = Page 68653;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Symptoms)
                {
                    Caption = 'Symptoms';
                    Image = RegisterPick;
                    Promoted = true;
                    RunObject = Page 68654;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(History)
                {
                    Caption = 'History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page 68656;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action("Laboratory Needs")
                {
                    Caption = 'Laboratory Needs';
                    Image = TestFile;
                    Promoted = true;
                    RunObject = Page 68571;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action("Radiology Needs")
                {
                    Caption = 'Radiology Needs';
                    Image = ReleaseShipment;
                    Promoted = true;
                    RunObject = Page 68572;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Diagmnosis)
                {
                    Caption = 'Diagmnosis';
                    Image = AnalysisView;
                    Promoted = true;
                    RunObject = Page 68573;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Injections)
                {
                    Caption = 'Injections';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page 68570;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Prescriptions)
                {
                    Caption = 'Prescriptions';
                    Image = ItemAvailability;
                    Promoted = true;
                    RunObject = Page 68574;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Referrals)
                {
                    Caption = 'Referrals';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page 68576;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
                action(Admissions)
                {
                    Caption = 'Admissions';
                    Image = Account;
                    Promoted = true;
                    RunObject = Page 68575;
                                    RunPageLink = Treatment No.=FIELD(Treatment No.);
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

 */