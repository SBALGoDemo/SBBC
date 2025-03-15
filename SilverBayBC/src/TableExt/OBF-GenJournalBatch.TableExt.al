// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2035 - Set Default Value for "Bank Payment Type" in the Payment Journal   
tableextension 50025 "OBF-Gen. Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "OBF-Def. Bank Payment Type"; Enum "Bank Payment Type")
        {
            Caption = 'Default Bank Payment Type';
            trigger OnValidate()
            begin
                if Rec."OBF-Def. Bank Payment Type" <> Rec."OBF-Def. Bank Payment Type"::" " then
                    Rec.TestField("Journal Template Name",'PAYMENT');               
            end;
        }
    }
}