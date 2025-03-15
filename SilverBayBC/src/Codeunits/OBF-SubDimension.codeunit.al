// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
codeunit 50001 "OBF-Sub Dimension"
{
    trigger OnRun()
    begin
      
    end;
   
    [EventSubscriber(ObjectType::Page, Page::"Edit Dimension Set Entries", 'OnAfterValidateEvent', 'DimensionValueCode', false, false)]
    local procedure EditDimensionSetEntries_DimensionValueCode_OnAfterValidate(var Rec : Record "Dimension Set Entry";var xRec : Record "Dimension Set Entry");
    begin
        if Rec."Dimension Code" in ['SITE','CIP','SUBSIDIARY'] then
            Error('You must specify the SUBSIDIARY, SITE and CIP dimensions on the Document or Journal Page.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Edit Dimension Set Entries", 'OnDeleteRecordEvent', '', false, false)]
    local procedure EditDimensionSetEntries_DimensionValueCode_OnDelete(var Rec : Record "Dimension Set Entry";var AllowDelete : Boolean);
    begin
        if Rec."Dimension Code" in ['SITE','CIP','SUBSIDIARY'] then
            Error('You must specify the SUBSIDIARY, SITE and CIP dimensions on the Document or Journal Page.');
    end;

    procedure RemoveDimensionFromDimSetID(DimensionCode: Code[20];var DimensionSetID: Integer)
    var
        DimMgt: Codeunit DimensionManagement;
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        Modified: Boolean;
    begin
        DimMgt.GetDimensionSet(DimensionSetEntry,DimensionSetID);
        if DimensionSetEntry.Get(DimensionSetID,DimensionCode) then begin 
            DimensionSetEntry.Delete();      
            DimensionSetID := DimMgt.GetDimensionSetID(DimensionSetEntry);
        end;
    end;

    procedure RemoveSubDimensionsFromDimSetID(var DimSetID: Integer)
    var
        DimMgt: Codeunit DimensionManagement;
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        Modified: Boolean;
    begin
        DimMgt.GetDimensionSet(DimensionSetEntry,DimSetID);
        Modified := false;
        if DimensionSetEntry.Get(DimSetID,'SITE') then begin 
            DimensionSetEntry.Delete();
            Modified := true;     
        end;
        if DimensionSetEntry.Get(DimSetID,'CIP') then begin 
            DimensionSetEntry.Delete();
            Modified := true;     
        end;
        if Modified then
            DimSetID := DimMgt.GetDimensionSetID(DimensionSetEntry);
    end;


    procedure UpdateDimSetIDForSubDimension(DimensionCode: Code[20];DimensionValue: Code[20]; var DimensionSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        SubDimension: Codeunit "OBF-Sub Dimension";
    begin
        if DimensionValue = '' then
            SubDimension.RemoveDimensionFromDimSetID(DimensionCode,DimensionSetID) 
        else begin 
            DimensionSetEntry.init();
            DimensionSetEntry.validate("Dimension Code", DimensionCode);
            DimensionSetEntry.validate("Dimension Value Code", DimensionValue);
            DimensionSetEntry.Insert();
            UpdateDimensionSetEntry(DimensionSetID, DimensionSetEntry);
        end;        
    end;

    procedure UpdateDimensionSetEntry(var DimSetID: Integer; var DimensionSetEntryToAdd: Record "Dimension Set Entry" temporary)
    var
        DimMgt: Codeunit DimensionManagement;
        NewDimensionSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(NewDimensionSetEntry, DimSetID);
        if DimensionSetEntryToAdd.FindSet() then
            repeat
                if NewDimensionSetEntry.Get(DimSetID, DimensionSetEntryToAdd."Dimension Code") then begin
                    NewDimensionSetEntry.validate("Dimension Value Code", DimensionSetEntryToAdd."Dimension Value Code");
                    NewDimensionSetEntry.Modify();
                end else begin
                    NewDimensionSetEntry := DimensionSetEntryToAdd;
                    NewDimensionSetEntry."Dimension Set ID" := DimSetID;
                    NewDimensionSetEntry.Insert();
                end;
            until DimensionSetEntryToAdd.Next() = 0;
        DimSetID := DimMgt.GetDimensionSetID(NewDimensionSetEntry);
    end;

}