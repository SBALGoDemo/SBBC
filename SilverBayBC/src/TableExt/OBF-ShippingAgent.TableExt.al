// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
tableextension 50095 "OBF-Item Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(50000; "OBF-Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }
}