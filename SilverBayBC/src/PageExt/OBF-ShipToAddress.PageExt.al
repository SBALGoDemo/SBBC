// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List and Ship-to Address page
pageextension 50060 "OBF-Ship-to Address" extends "Ship-to Address"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1316 - Autonumber New Ship-to Addresses
        modify(Code)
        {
            Editable = false;
        }
        modify(Name)
        {
            QuickEntry = false;
        }
                
        addafter(Name)
        {
            field("OBF-Ship-to Broker";Rec."OBF-Ship-to Broker")
            {
                ApplicationArea = all;
                QuickEntry = true;
            }
        }
    }

}