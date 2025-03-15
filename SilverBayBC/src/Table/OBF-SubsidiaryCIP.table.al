// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1666 - Create CIP Dimension Lookup based on Subsidiary
table 50031 "OBF-Subsidiary CIP"
{
    DataClassification = CustomerContent;
    Caption = 'Subsidiary CIP Code';
    DataCaptionFields = "Subsidiary Code", "CIP Code";
    DrillDownPageID = "OBF-Subsidiary CIP Codes";
    LookupPageID = "OBF-Subsidiary CIP Codes";

    fields
    {
        field(3; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(4; "Subsidiary Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SUBSIDIARY'), Code = field("Subsidiary Code")));
            Caption = 'Subsidiary Name';
            Editable = false;
        }
        field(7; "CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('CIP'));
            Caption = 'CIP Code';
        }
        field(8; "CIP Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('CIP'), Code = field("CIP Code")));
            Caption = 'CIP Name';
            Editable = false;
        }
        field(9; "CIP Code Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Blocked where("Dimension Code" = const('CIP'), Code = field("CIP Code")));
            Caption = 'CIP Code Blocked';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Subsidiary Code", "CIP Code")
        {
            Clustered = true;
        }
    }
    
    fieldgroups
    {
        fieldgroup(DropDown;"CIP Code","CIP Name")
        {
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}