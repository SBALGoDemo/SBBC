// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1705 - Add "Coupa Lookup ID" to Dimension Value table
pageextension 50020 "OBF-Dimension Values" extends "Dimension Values"
{
    layout
    {
        addafter(Name) 
        {
            field("OBF-Coupa Lookup ID";Rec."OBF-Coupa Lookup ID")
            {
                ApplicationArea = all;
            }
        }      
    }

}