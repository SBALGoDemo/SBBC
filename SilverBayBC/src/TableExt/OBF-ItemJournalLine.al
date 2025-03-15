tableextension 50000 "OBF-ItemJournalLine" extends "Item Journal Line"
{
    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2370 - Add Custom Site Code column to Purchase Journal and Item Journal
    /// </summary>
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            begin
                SubDimension.UpdateDimSetIDForSubDimension('SITE', "OBF-Site Code", Rec."Dimension Set ID");
            end;
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            begin
                SubDimension.UpdateDimSetIDForSubDimension('CIP', "OBF-CIP Code", Rec."Dimension Set ID");
            end;
        }
    }

    var
        SubDimension: Codeunit "OBF-Sub Dimension";
}