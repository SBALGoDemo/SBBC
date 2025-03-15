// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1705 - Add "Coupa Lookup ID" to Dimension Value table
tableextension 50015 "OBF-Dimension Value" extends "Dimension Value"
{
    fields
    {
        field(50000; "OBF-Coupa Lookup ID"; Code[20])
        {
            Caption = 'Coupa Lookup ID';   
            DataClassification = CustomerContent;
        }     
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1727 - Payment Imports
    procedure FindSubsidiaryFromCoupaID(CoupaID: Code[20]): Code[20]
    var
        DimensionValue: Record "Dimension Value";
        SubsidiaryName: Text[24];
    begin
        if CoupaID = '' then
            exit('');

        if StrLen(CoupaID) = 1 then
            CoupaID := '0'+CoupaID;

        if StrLen(CoupaID) > 2 then
            exit('*** INVALID '+CoupaID);
        DimensionValue.SetRange("Dimension Code", 'SUBSIDIARY');
        DimensionValue.SetRange("OBF-Coupa Lookup ID",CoupaID);
        DimensionValue.SetRange(Blocked, false);
        if DimensionValue.Count > 1 then
            exit('*** MULTIPLE ***')
        else
            if DimensionValue.FindFirst() then
                exit(DimensionValue.Code)
            else
                exit('');
    end;    
}