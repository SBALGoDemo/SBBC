// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
table 50030 "OBF-Subsidiary Site"
{
    DataClassification = CustomerContent;
    Caption = 'Subsidiary Site';
    DataCaptionFields = "Subsidiary Code", "Site Code";
    DrillDownPageID = "OBF-Subsidiary Sites";
    LookupPageID = "OBF-Subsidiary Sites";

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
        field(7; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SITE'));
            Caption = 'Site Code';
        }
        field(8; "Site Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Name';
            Editable = false;
        }
        field(9; "Site Code Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Blocked where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Code Blocked';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Subsidiary Code", "Site Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Site Code", "Site Name")
        {
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code
    trigger OnInsert()
    var
        GLAccount: Record "G/L Account";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
    begin
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.FindSet();
        repeat
            if not GLBalBySubsSite.Get(GLAccount."No.", Rec."Subsidiary Code", '') then begin
                GLBalBySubsSite.Init();
                GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                GLBalBySubsSite."Subsidiary Code" := Rec."Subsidiary Code";
                GLBalBySubsSite."Site Code" := '';
                GLBalBySubsSite.Insert();
            end;
            if not GLBalBySubsSite.Get(GLAccount."No.", Rec."Subsidiary Code", Rec."Site Code") then begin
                GLBalBySubsSite.Init();
                GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                GLBalBySubsSite."Subsidiary Code" := Rec."Subsidiary Code";
                GLBalBySubsSite."Site Code" := Rec."Site Code";
                GLBalBySubsSite.Insert();
            end;
        until (GLAccount.Next() = 0);
    end;

    trigger OnModify()
    begin

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code
    trigger OnDelete()
    var
        GLAccount: Record "G/L Account";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
    begin
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.FindSet();
        repeat
            if GLBalBySubsSite.Get(GLAccount."No.", Rec."Subsidiary Code", Rec."Site Code") then
                GLBalBySubsSite.Delete();
        until (GLAccount.Next() = 0);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code
    trigger OnRename()
    var
        GLAccount: Record "G/L Account";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
    begin
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.FindSet();
        repeat
            if GLBalBySubsSite.Get(GLAccount."No.", xRec."Subsidiary Code", xRec."Site Code") then begin
                GLBalBySubsSite.Delete();

                GLBalBySubsSite.Init();
                GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                GLBalBySubsSite."Subsidiary Code" := Rec."Subsidiary Code";
                GLBalBySubsSite."Site Code" := Rec."Site Code";
                GLBalBySubsSite.Insert();
            end;
        until (GLAccount.Next() = 0);
    end;

}