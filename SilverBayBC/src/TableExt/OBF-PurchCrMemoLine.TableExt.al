// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50023 "OBF-Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
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
                         
    }
}