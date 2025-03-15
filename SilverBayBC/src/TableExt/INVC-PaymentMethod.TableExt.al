// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
tableextension 50121 "INVC Payment Method" extends "Payment Method"
{
    fields
    {
        field(50120; "INVC WF Export Type"; Enum "INVC Wells Fargo Payment Type")
        {
            Caption = 'Wells Fargo Payment Export Type';
        }
    }
}