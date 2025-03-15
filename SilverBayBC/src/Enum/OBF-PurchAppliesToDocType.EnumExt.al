// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
enumextension 50000 "OBF-Purch. Applies-to Doc Type" extends "Purchase Applies-to Document Type"
{    
    value(50000; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(50001; "Item Ledger Entry")
    {
        Caption = 'Item Ledger Entry';
    }
}