// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50080 "OBF-SO Workflow Step Lookup"
{
    Caption = 'Select the Next Step';
    Editable = false;
    PageType = List;
    SourceTable = "OBF-SO Workflow Step";
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Step No."; Rec."Step No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Width = 30;
                }
                field("Assigned to User"; Rec."Assigned to User")
                {
                    ApplicationArea = All;
                    Width = 20;
                }
            }
        }
    }
}