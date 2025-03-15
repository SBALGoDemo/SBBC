// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
table 50024 "OBF-Certification"
{
    Caption = 'Certification';
    LookupPageID = "OBF-Certification List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate();
            begin
                SetIndentation;
            end;
        }
        field(2; "Parent Certification"; Code[20])
        {
            Caption = 'Parent Certification';
            TableRelation = "OBF-Certification";

            trigger OnValidate();
            var
                Certification: Record "OBF-Certification";
                ParentCertification: Code[20];
            begin
                SetIndentation;
            end;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(9; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(10; "Presentation Order"; Integer)
        {
            Caption = 'Presentation Order';
        }
        field(11; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Parent Certification")
        {
        }
        key(Key3; "Presentation Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Has Children" then
            ERROR(DeleteWithChildrenErr);
    end;

    var
        DeleteWithChildrenErr: Label 'You cannot delete this Certification because it has child Certifications.';


    procedure HasChildren(): Boolean;
    var
        Certification: Record "OBF-Certification";
    begin
        Certification.SetRange("Parent Certification", Code);
        exit(not Certification.ISEMPTY)
    end;


    procedure GetStyleText(): Text;
    begin
        if Indentation = 0 then
            exit('Strong');

        if "Has Children" then
            exit('Strong');

        exit('');
    end;

    local procedure SetIndentation();
    begin
        if "Parent Certification" = '' then
            Indentation := 0
        else
            Indentation := 1;
    end;
}

