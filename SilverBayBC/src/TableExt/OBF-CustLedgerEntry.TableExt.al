// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1776 - Add Memo field to Deposit Page 
tableextension 50016 "OBF-Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "OBF-Memo"; Text[250])
        {
            Caption = 'Memo';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50010; "OBF-Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
        }
        field(50011; "OBF-Rebate Ledger Entry No."; Integer)
        {
            Caption = 'Rebate Ledger Entry No.';
        }
        
    }
}