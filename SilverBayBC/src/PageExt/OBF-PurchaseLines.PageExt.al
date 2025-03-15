// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
pageextension 50111 "OBF-Purchase Lines" extends "Purchase Lines"
{
    layout
    {       
        addafter("Reserved Qty. (Base)")
        {
            field("OBF-Reserved Qty. (Base)"; Rec."OBF-Reserved Qty. (Base)")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
            {
                ApplicationArea = all;
            }
        }
    }
}