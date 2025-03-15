// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50004 "OBF-Rebate Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "OBF-Rebate Line";
    SourceTableView = SORTING("Rebate Code", "Line No.");
    Caption = 'Rebate Subform';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address Code"; Rec."Ship-to Address Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Rebate Value"; Rec."Rebate Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}