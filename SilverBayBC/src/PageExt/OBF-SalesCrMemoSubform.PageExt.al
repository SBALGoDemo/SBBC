// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1741 - Sales Credit Memo Issues
pageextension 50026 "OBF-Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn=Description;
        }
        modify("Shortcut Dimension 1 Code") { Editable = false; }
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
        }
        
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addlast(Control1)
        {
            field("OBF-Off-Inv. Rebate Unit Rate"; Rec."OBF-Off-Inv. Rebate Unit Rate")
            {
                ApplicationArea = all;
            }
            field("OBF-Off Invoice Rebate Amount"; Rec."OBF-Off Invoice Rebate Amount")
            {
                ApplicationArea = all;
            }
        }           
    }
}