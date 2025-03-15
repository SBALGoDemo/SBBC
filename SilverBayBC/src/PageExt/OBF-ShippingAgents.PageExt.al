// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
pageextension 50095 "OBF-Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        addafter(Name)
        {
            field("OBF-Vendor No."; Rec."OBF-Vendor No.")
            {
                ApplicationArea = All;                    
            }
        }
    }
}