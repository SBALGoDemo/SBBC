// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup

pageextension 50005 "OBF-Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {      
        movebefore("Due Date";"Payment Terms Code")
        moveafter("Vendor Invoice No.";"Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code";"Shortcut Dimension 2 Code")
        modify("Buy-from Contact") {Visible=false;}
    }
}