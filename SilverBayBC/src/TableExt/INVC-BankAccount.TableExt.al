// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
tableextension 50120 "INVC Bank Account" extends "Bank Account"
{
    fields
    {
        field(50000; "INVC Export WF Payment File"; Boolean)
        {
            Caption = 'Export Payments to Wells Fargo Format';
        }
        field(50002; "INVC Last WF Export File"; Text[30])
        {
            Caption = 'Last Wells Fargo Export File';
        }
    }
}