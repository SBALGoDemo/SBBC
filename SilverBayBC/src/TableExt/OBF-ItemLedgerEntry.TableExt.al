tableextension 50067 "OBF-Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        field(51001; "OBF-Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
        field(54002; "OBF-Quantity (Source UOM)"; decimal)
        {
            Caption = 'Quantity (Source UOM)';
            DecimalPlaces = 0 : 2;
        }
                
    }
}