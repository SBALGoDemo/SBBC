// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup

pageextension 50013 "OBF-Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        movebefore("Due Date";"Payment Terms Code")
        moveafter("Vendor Invoice No.";"Shortcut Dimension 1 Code")
        modify("Buy-from Contact") {Visible=false;}
        addafter("Vendor Invoice No.")
        {
            field("OBF-Coupa Internal Invoice ID";Rec."OBF-Coupa Internal Invoice ID")
            {
                ApplicationArea = all;
            }
        }
    }
}