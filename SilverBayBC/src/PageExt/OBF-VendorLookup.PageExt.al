// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692-Create a Purchase Invoice Line Export for Fishermen for Northscope
pageextension 50014 "OBF-Vendor Lookup" extends "Vendor Lookup"
{
    layout
    {
        addafter(Name)
        {
            field("Our Account No.";Rec."Our Account No.")
            {
                ApplicationArea = all;
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
        modify("Purchaser Code")
        {
            Visible = false;
        }           
    }
    
}