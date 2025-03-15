// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50084 "OBF-Workflow Group Members"
{
    Caption = 'Workflow User Group Members';
    PageType = List;
    SourceTable = "Workflow User Group Member";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Workflow User Group Code"; Rec."Workflow User Group Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}