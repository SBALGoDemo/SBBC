// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Purchase Invoices
tableextension 50011 "OBF-Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "OBF-FOB Location"; Code[20])
        {
            Caption = 'Point of Title Transfer';
            TableRelation = "OBF-FOB Location";
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
        field(50001; "OBF-Coupa Updated Flag"; Boolean)
        {
            Caption = 'Coupa Updated Flag';
            DataClassification = CustomerContent;
        }
        field(50002; "OBF-Coupa Internal Invoice ID"; Code[20])
        {
            Caption = 'Coupa Internal Invoice ID';
            DataClassification = CustomerContent;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1908 - Taxes not populating on Fisherman Export
        field(50021; "OBF-Fisherman Reference Exists"; Boolean)
        {
            Caption = 'Fisherman Reference Exists';
            FieldClass = FlowField;
            CalcFormula = exist ("Purch. Inv. Line" where("Document No." = field("No."),"OBF-Fisherman Reference Code"=FILTER(<>'')));
        }  
        field(50022; "OBF-Fisherman Ref. Tax Flag"; Boolean)
        {
            Caption = 'Fisherman Reference Tax Flag';
            FieldClass = FlowField;
            CalcFormula = exist ("Purch. Inv. Line" where("Document No." = field("No."),"OBF-Fisherman Reference Code"=FILTER(''),Amount=FILTER('<>0')));
        }
              
    }
}
