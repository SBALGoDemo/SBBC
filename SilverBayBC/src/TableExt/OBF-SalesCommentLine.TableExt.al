// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
tableextension 50084 "OBF-Sales Comment Line" extends "Sales Comment Line"
{
    fields
    {
        field(52000; "OBF-Revision No."; Integer)
        {
            Caption = 'Revision No.';
        }       
    }
    keys
    {
        key(Key21;"OBF-Revision No.")
        {
        }
    }
}