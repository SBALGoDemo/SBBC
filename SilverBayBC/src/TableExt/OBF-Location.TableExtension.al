// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
tableextension 50072 "OBF-Location" extends Location
{
    fields
    {
        field(50000; "OBF-EDI Enabled"; Boolean)
        {
            Caption = 'EDI Enabled';
            trigger OnValidate();
            var
                SalesEvents: Codeunit "OBF-Sales Events";
            begin
                if "OBF-EDI Enabled" then
                    SalesEvents.UpdateCustomEDIFieldsForLocation(Rec.Code);
            end;
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1892 - Create new SBS Non Corp Company in Business Central
    fieldgroups
    {
        addlast(DropDown; "Name 2") { }
    }
    
}