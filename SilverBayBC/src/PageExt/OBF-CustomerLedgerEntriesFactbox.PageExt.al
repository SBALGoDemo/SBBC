// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2373 - Add Memo to Posted Sales Invoices List
pageextension 50049 "OBF-Cust. Ledger Entry Factbox" extends "Customer Ledger Entry Factbox"
{
    layout
    {
        addafter(DocumentHeading)
        {
            field("OBF-Memo";Rec."OBF-Memo")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }
}
