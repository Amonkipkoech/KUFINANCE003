pageextension 52178700 "Purchasing Agent Role Center" extends "Purchasing Agent Role Center"
{
    actions
    {
        addbefore("Purchase &Quote")
        {
            action("Internal Requisitions")
            {
                ApplicationArea = Suite;
                Caption = 'Procurement Plan';
                RunObject = Page "PROC-Procurement Plan List";
                ToolTip = 'Create purchase requisition from departments.';
            }
        }
        addbefore("Purchase &Quote")
        {
            action("Purchase Requisitions")
            {
                ApplicationArea = Suite;
                Caption = 'Internal Requisitions';
                RunObject = Page "FIN-Purchase Requisition";
                ToolTip = 'Create purchase requisition from departments.';
            }
        }
        addafter("Purchase Requisitions")
        {
            action(FRQs)
            {
                Image = Purchase;
                ApplicationArea = Suite;
                Caption = 'RFQs';
                RunObject = Page "PROC-Purchase Quote List";
                ToolTip = 'Create purchase requisition from departments.';
            }
            action(Quotes)
            {
                Image = Purchase;
                ApplicationArea = Suite;
                Caption = 'Quotes';
                RunObject = Page "Proc-Purchase Quotes List";
                ToolTip = 'Create purchase Quotes from Vendors.';

            }
        }
        modify("Purchase &Order")
        {
            Visible = false;
        }
        modify("Purchase &Quote")
        {
            Visible = false;
        }
        addafter("Purchase &Invoice")
        {
            action("Procurement &Order")
            {
                ApplicationArea = Suite;
                Caption = 'Procurement &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order List";
                ToolTip = 'Create a new purchase order.';
            }
        }
    }
}
