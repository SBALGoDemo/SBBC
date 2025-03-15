// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50079 "OBF-SO Workflow Steps Listpart"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "OBF-SO Workflow Step";
    Caption = 'SO Workflow Steps';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                    StyleExpr = CurrentStep;
                    Width = 30;
                }
                field("Assigned to User Name";Rec."Assigned to User Name")
                {
                    ApplicationArea = All;
                    Width = 20;
                }
                field(Completed;Rec.Completed)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CurrentStep := Rec."Current Step";
    end;

    var
        CurrentStep : Boolean;

}