// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50068 "OBF-Change Log Entries"
{
    Caption = 'Change Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Change Log Entry";
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            field("Primary Key Field 1 Value"; Rec."Primary Key Field 1 Value")
            {
                ApplicationArea = All;
            }
            field("Primary Key Field 2 Value"; Rec."Primary Key Field 2 Value")
            {
                ApplicationArea = All;
            }

            repeater(Group)
            {
                field("Table Caption"; Rec."Table Caption")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                }
                field("Date and Time"; Rec."Date and Time")
                {
                    ApplicationArea = All;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Type of Change"; Rec."Type of Change")
                {
                    ApplicationArea = All;
                }
                field("Old Value"; Rec."Old Value")
                {
                    ApplicationArea = All;
                }
                field("New Value"; Rec."New Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}