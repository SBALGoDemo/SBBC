//https://odydev.visualstudio.com/ThePlan/_workitems/edit/1793 - Add "Qty. per Base UOM" to Item Unit of Measure
pageextension 50133 "OBF-Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        modify("Qty. per Unit of Measure")
        {
            Visible = false;
        }

        addafter("Qty. per Unit of Measure")
        {
            field("OBF-Qty. per Base UOM";Rec."OBF-Qty. per Base UOM")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin 
                    QtyPerUnitOfMeasure := Rec."Qty. per Unit of Measure";
                end;
            }

            field(QtyPerUnitOfMeasure;QtyPerUnitOfMeasure)
            {
                Caption = 'Qty. per Unit of Measure';
                DecimalPlaces = 0:10;
                Editable = false;
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        QtyPerUnitOfMeasure := Rec."Qty. per Unit of Measure";
    end;

    var
        QtyPerUnitOfMeasure: Decimal;
}