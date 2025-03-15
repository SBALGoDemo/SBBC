// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
tableextension 50017 "OBF-GL Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Global Dimension 1 Code"));
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50010; "OBF-Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            TableRelation = "OBF-Rebate Header";
        }
        field(50011; "OBF-Rebate Ledger Entry No."; Integer)
        {
            Caption = 'Rebate Ledger Entry No.';
            TableRelation = "OBF-Rebate Ledger Entry";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - G/L Entry Invalid Subsidiary and Site Combinations
        field(52000; "OBF-Site Code Issue"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code Issue';
        }

    }
    
}