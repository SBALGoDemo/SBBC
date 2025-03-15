// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50077 "OBF-Workflow Steps"
{
    Caption = 'Workflow Steps';
    PageType = List;
    SourceTable = "OBF-Workflow Step";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Step No."; Rec."Step No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Width = 30;
                }
                field("Assigned to Type"; Rec."Assigned to Type")
                {
                    ApplicationArea = All;
                }
                field("Assigned to W. User Group"; Rec."Assigned to W. User Group")
                {
                    ApplicationArea = All;
                }
                field("Next Step No."; Rec."Next Step No.")
                {
                    ApplicationArea = All;
                }
                field("Next Step Description"; Rec."Next Step Description")
                {
                    ApplicationArea = All;
                    Width = 30;
                }
                field("Post Invoicing Step"; Rec."Post Invoicing Step")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}