// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50012 "OBF-Posted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn=Description;
        }
        modify("Unit of Measure Code") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }

        addafter("Shortcut Dimension 1 Code")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code"; Rec."OBF-CIP Code")
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
                         
        }
    }
}