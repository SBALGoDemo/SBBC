pageextension 50000 "OBF-Purchase Journal" extends "Purchase Journal"
{
    layout
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2370 - Add Custom Site Code column to Purchase Journal and Item Journal
        /// </summary>

        addafter(Description)
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code"; Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
        }
    }
}