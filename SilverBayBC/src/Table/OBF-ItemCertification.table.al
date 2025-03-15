// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
table 50023 "OBF-Item Certification"
{

    fields
    {
        field(1;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2;"Item Description";Text[100])
        {
            Caption = 'Item Description';
            CalcFormula = Lookup(Item.Description where ("No."=field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Certification Code";Code[20])
        {
            Caption = 'Certification Code';
            TableRelation = "OBF-Certification" where ("Parent Certification"=const('SUSTAINABILITY'));
        }
        field(4;"Certification Name";Text[50])
        {
            Caption = 'Certification Name';
            CalcFormula = Lookup("OBF-Certification".Name where (Code=field("Certification Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Item No.","Certification Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Certification Code","Certification Name")
        {
        }
    }
}

