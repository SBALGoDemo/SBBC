// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
page 50060 "OBF-Subsidiary Sites"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "OBF-Subsidiary Site";
    Caption = 'Subsidiary Sites';
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
                    field(ChildDimensionName; Rec."Site Code")
                    {
                        ApplicationArea = All;
                    }
                    field(SiteName; Rec."Site Name")
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
            action(RunTest)
            {
                Caption = 'Run Test';
                Promoted = true;
                PromotedCategory = Process;
                Image = "Report";
                trigger OnAction()
                var
                    CUTest : Codeunit "OBF-Sub Dimension";
                begin
                    CUTest.Run();
                end;
            }  
        }
    }

}