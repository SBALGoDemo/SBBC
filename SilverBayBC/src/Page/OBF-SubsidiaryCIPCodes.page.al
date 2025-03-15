// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1666 - Create CIP Dimension Lookup based on Subsidiary
page 50059 "OBF-Subsidiary CIP Codes"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "OBF-Subsidiary CIP";
    Caption = 'Subsidiary CIP Codes';
    Editable = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(Control50000)
                {
                    field(SubsidiaryCode; Rec."Subsidiary Code")
                    {
                        ApplicationArea = All;
                    }
                    field(SubsidiaryName; Rec."Subsidiary Name")
                    {
                        ApplicationArea = All;
                    }
                    field(ChildDimensionName; Rec."CIP Code")
                    {
                        ApplicationArea = All;
                    }
                    field(SiteName; Rec."CIP Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

}