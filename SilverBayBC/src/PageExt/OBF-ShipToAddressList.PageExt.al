// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List and Ship-to Address page
pageextension 50047 "OBF-Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addafter(Name)
        {
            field("OBF-Ship-to Broker";Rec."OBF-Ship-to Broker")
            {
                ApplicationArea = all;
            }
        }
    }
}