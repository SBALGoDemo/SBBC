// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Page Cleanup
pageextension 50011 "OBF-Vendor List" extends "Vendor List"
{
    layout
    {

        addafter(Name)
        {
            field("Our Account No.";Rec."Our Account No.")
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
        modify("Vendor Posting Group")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
                   
    }
    
}