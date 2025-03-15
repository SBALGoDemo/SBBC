// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1803 - Missing Multi Entity Ledger Entries
pageextension 50050 "OBF-Posted Purch. Inv. Lines" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("OBF-Header Subsidiary";Rec."OBF-Header Subsidiary")
            {
                ApplicationArea = all;                
            }
            field("OBF-Is Multi-Entity";Rec."OBF-Is Multi-Entity")
            {
                ApplicationArea = all;                
            }
            field("OBF-Multi-Entity Entries";Rec."OBF-Multi-Entity Entries")
            {
                ApplicationArea = all;                
            }
        }
    }

}