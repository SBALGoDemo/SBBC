pageextension 50119 "OBF-General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - Block Invalid Subsidiary Site Combinations
        addafter("VAT in Use")
        {
            field("OBF-Block Invalid Sub and Site"; Rec."OBF-Block Invalid Sub and Site")
            {
                ApplicationArea = All;
            }
        }
    }
}