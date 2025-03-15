// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
page 50042 "OBF-Item Certifications"
{
    PageType = List;
    SourceTable = "OBF-Item Certification";
    Caption = 'Item Certifications';
    DataCaptionFields = "Certification Code","Certification Name";

    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Certification Code";Rec."Certification Code")
                {
                }
                field("Certification Name";Rec."Certification Name")
                {
                }
            }
        }
    }
}

