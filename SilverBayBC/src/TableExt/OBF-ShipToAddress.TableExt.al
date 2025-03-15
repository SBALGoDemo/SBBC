// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List and Ship-to Address page
tableextension 50070 "OBF-Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50030; "OBF-Ship-to Broker"; Code[20])
        {
            Caption = 'Broker';
            TableRelation = "Dimension Value".Code where ("Dimension Code"=const('BROKER'));
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1316 - Autonumber New Ship-to Addresses
        field(50040; "OBF-No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        
    }
}