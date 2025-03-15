// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50031 "OBF-Sales Lines" extends "Sales Lines"
{
    layout
    {
        addafter("Qty. to Ship")
        {
            field("OBF-Allocated Quantity"; Rec."OBF-Allocated Quantity")
            {
                ToolTipML = ENU = 'This is the quantity that is allocated to lots in Item Tracking.';
                ApplicationArea = all;
            }
            field("OBF-Line Net Weight";Rec."OBF-Line Net Weight")
            {
                ApplicationArea = all;
            }            
        }
    }
}