// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50010 "OBF-Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692 - Create a Purchase Invoice Line Export for Fishermen for Northscope
        field(50002; "OBF-Fisherman Reference Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fisherman Reference Code';
        }
        field(50003; "OBF-Expense Item"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Item';
        }
        field(50004; "OBF-Expense Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Quantity';
        }
        field(50005; "OBF-Expense Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Rate';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1803 - Missing Multi Entity Ledger Entries
        field(50010; "OBF-Header Subsidiary"; Code[20])
        {
            Caption = 'Header Subsidiary';
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."Shortcut Dimension 1 Code" where("No." = field("Document No.")));
            Editable = false;
        }
        field(50011; "OBF-Is Multi-Entity"; Boolean)
        {
            Caption = 'Is Multi-Entity';
            FieldClass = FlowField;
            CalcFormula = exist("G/L Entry" where("Document No." = field("Document No."),BssiDuetoDuefrom=const(true)));
            Editable = false;
        }
        field(50012; "OBF-Multi-Entity Entries"; Integer)
        {
            Caption = 'Multi-Entity Entries';
            FieldClass = FlowField;
            CalcFormula = Count("G/L Entry" where("Document No." = field("Document No."),BssiDuetoDuefrom=const(true)));
            Editable = false;
        }
                         
    }
}