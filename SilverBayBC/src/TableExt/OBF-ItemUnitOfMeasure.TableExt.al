//https://odydev.visualstudio.com/ThePlan/_workitems/edit/1793 - Add "Qty. per Base UOM" to Item Unit of Measure
tableextension 50021 "OBF-Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        field(50000;"OBF-Qty. per Base UOM";Decimal)
        {
            Caption = 'Qty. per Base UOM';
            DecimalPlaces = 0:15;
            InitValue = 1;

            trigger OnValidate()
            begin 
                Validate("Qty. per Unit of Measure", Round(1 / "OBF-Qty. per Base UOM",0.0000000001));
            end;
        }
    }
}