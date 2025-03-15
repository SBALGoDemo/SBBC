// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
table 50025 "OBF-Workflow Step"
{
    DrillDownPageID = "OBF-Workflow Steps";
    LookupPageID = "OBF-Workflow Steps";

    fields
    {
        field(2; "Step No."; Integer)
        {
        }
        field(3; Description; Text[30])
        {
        }
        field(8; "Next Step No."; Integer)
        {
            TableRelation = "OBF-Workflow Step";
        }
        field(9; "Next Step Description"; Text[30])
        {
            CalcFormula = Lookup("OBF-Workflow Step".Description WHERE("Step No." = FIELD("Next Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Assigned to Type"; enum "OBF-Workflow Assigned to Type")
        {
        }        
        field(12; "Assigned to W. User Group"; Code[20])
        {
            Caption = 'Assigned to Workflow User Group';
            TableRelation = "Workflow User Group";
        }
        field(17; "Post Invoicing Step"; Boolean)
        {
            Caption = 'Post Invoicing Step';
        }
    }

    keys
    {
        key(Key1; "Step No.")
        {
        }
    }

    fieldgroups
    {
    }
}