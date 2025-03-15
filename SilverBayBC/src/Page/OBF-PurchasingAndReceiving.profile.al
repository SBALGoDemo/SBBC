// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1254 - Create Custom Profiles for Business Central
profile "OBF-Purchasing and Receiving" 
{
    Caption = 'OBF-Purchasing and Receiving';
    Description = 'OBF-Purchasing and Receiving';
    RoleCenter = "Purchasing Agent Role Center";
    Customizations = "OBF-Purch. Agent Role Center";
}


pagecustomization "OBF-Purch. Agent Role Center" customizes "Purchasing Agent Role Center"
{
    layout
    {
        modify("User Tasks Activities")
        {
            Visible = false;
        }
    }
    actions
    {
        modify("Assembly Orders") {Visible = false;}
        modify("Purchase Quotes") {Visible = false;}
        modify("Purchase Invoices") {Visible = false;}
        modify("Stockkeeping Units") {Visible = false;}
        modify(SubcontractingWorksheets) {Visible = false;}
        modify("Purchase &Quote") {Visible = false;}
        modify("Purchase &Invoice") {Visible = false;}
        modify("Catalog Items") {Visible = false;}

        moveafter(Vendors;Items)

        addfirst(Embedding)
        {
            action(SalesOrdersInProcess)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders in Process';
                Image = "Order";
                RunObject = Page "OBF-Sales Orders in Process";
            }
        }
        addlast(Embedding)
        {
            action(PostedSalesInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Sales Invoices';
                Image = "PostedOrder";
                RunObject = Page "Posted Sales Invoices";
            }
            action(PostedPurchaseInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Invoices';
                Image = "PostedOrder";
                RunObject = Page "Posted Purchase Invoices";
            }
        }
    }
}