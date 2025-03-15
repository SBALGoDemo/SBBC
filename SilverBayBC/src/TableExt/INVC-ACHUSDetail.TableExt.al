// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1868 - Add comments to CoBank ACH
tableextension 50500 "INVC ACH US Detail" extends "ACH US Detail"
{
    fields
    {
        field(50500; "INVC Pmt. Information 1"; Text[80])
        {
            Caption = 'Payment Information 1';
        }

        field(50888; "INVC Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}