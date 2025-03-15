// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50006 "OBF-Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        modify(PurchDetailLine)
        {
            FreezeColumn="No.";
        }
        modify("Location Code") { Visible = false; }
        modify("Unit of Measure Code") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1713 - Disappearing Site and CIP Issue
        addafter(Description)
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code"; Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
        }
        
        addafter("Line Amount")
        {

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