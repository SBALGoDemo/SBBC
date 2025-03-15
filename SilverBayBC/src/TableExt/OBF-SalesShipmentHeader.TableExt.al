// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices  
tableextension 50014 "OBF-Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {  
        field(50000; "OBF-FOB Location"; Code[20])
        {
            Caption = 'Point of Title Transfer';
            TableRelation = "OBF-FOB Location";
            DataClassification = CustomerContent;
        }

    }
}
