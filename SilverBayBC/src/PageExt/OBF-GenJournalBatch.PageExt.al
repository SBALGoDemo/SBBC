// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2035 - Set Default Value for "Bank Payment Type" in the Payment Journal   
pageextension 50046 "OBF-General Journal Batches" extends "General Journal Batches"
{
    layout
    {
        addafter("Bal. Account Type")
        {
            field("OBF-Def. Bank Payment Type"; Rec."OBF-Def. Bank Payment Type")
            {
                ToolTip = 'Set a default Bank Payment Type for the journal batch.';
                ApplicationArea = all;
            }
        }
    }
}