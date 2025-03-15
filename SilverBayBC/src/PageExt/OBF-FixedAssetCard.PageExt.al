// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
pageextension 50004 "OBF-Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addlast(General)
        {
            field("OBF-Site Code";Rec."OBF-Site Code")
            {
                ApplicationArea = All;
            }
            field("OBF-CIP Code";Rec."OBF-CIP Code")
            {
                ApplicationArea = All;
            }
        }
    }
}