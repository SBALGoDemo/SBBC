// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
pageextension 50027 "OBF-Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn=Description;
        }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Amount Including VAT") {Visible = false; }
        modify("Location Code") {Visible = false; }

        moveafter("Line Amount";"Shortcut Dimension 2 Code")
        addafter("Line Amount")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code";Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692 - Create a Purchase Invoice Line Export for Fishermen for Northscope
            field("OBF-Fisherman Reference Code";Rec."OBF-Fisherman Reference Code")
            {
                ApplicationArea = all;
            } 
            field("OBF-Expense Item";Rec."OBF-Expense Item")
            {
                ApplicationArea = all;
            }
            field("OBF-Expense Quantity";Rec."OBF-Expense Quantity")
            {
                ApplicationArea = all;
            }
            field("OBF-Expense Rate";Rec."OBF-Expense Rate")
            {
                ApplicationArea = all;
            } 
        }                
    }
}