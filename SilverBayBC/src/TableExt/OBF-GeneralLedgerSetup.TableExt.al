tableextension 50026 "OBF-General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - Block Invalid Subsidiary Site Combinations
        field(50000; "OBF-Block Invalid Sub and Site"; Boolean)
        {
            Caption = 'Block Invalid Subsidiary and Site Combination';
        }
    }
}