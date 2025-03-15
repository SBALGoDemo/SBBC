// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
page 50039 "OBF-Item Certification Factbox"
{
    PageType = ListPart;
    SourceTable = "OBF-Item Certification";
    Caption = 'Item Certifications';
    ApplicationArea = all;
    Editable = false;
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