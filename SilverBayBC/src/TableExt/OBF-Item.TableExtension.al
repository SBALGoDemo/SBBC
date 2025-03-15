tableextension 50020 "OBF-Item" extends Item
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50020; "OBF-Exclude from Weight Calc."; Boolean)
        {
            CaptionML = ENU = 'Exclude from Weight Calculation';
        }
    }
}