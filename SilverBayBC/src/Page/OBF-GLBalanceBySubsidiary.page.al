//https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
page 50113 "OBF-GL Bal. by Subsidiary"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "OBF-G/L Bal. by Subs. Site";
    Caption = 'G/L Balance by Subsidiary';
    Editable = true;
    DelayedInsert = true;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control50000)
            {
                ShowCaption = false;
                field("G/L Account No.";Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account Name";Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                }
                field(SubsidiaryCode; Rec."Subsidiary Code")
                {
                    ApplicationArea = All;
                }
                field(SubsidiaryName; Rec."Subsidiary Name")
                {
                    ApplicationArea = All;
                }
                field("Balance at Date for Subsidiary";Rec."Balance at Date for Subsidiary")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetGLEntrySiteCode)
            {
                Caption = 'Set G/L Entry Site Code';
                Promoted = true;
                PromotedCategory = Process;
                Image = "Report";
                trigger OnAction()
                var
                    OnUpgrade : Codeunit "OBF-OnUpgrade";
                begin
                    OnUpgrade.SetGLEntrySiteCode();
                end;
            }
            action(SetGLEntrySiteCode2)
            {
                Caption = 'Set G/L Entry Site Code 2';
                Visible = false;
                Image = "Report";
                trigger OnAction()
                var
                    OnUpgrade : Codeunit "OBF-OnUpgrade";
                begin
                    OnUpgrade.SetGLEntrySiteCode2();
                end;
            }  
            action(AddRows)
            {
                Caption = 'Add Rows';
                Promoted = true;
                PromotedCategory = Process;
                Image = "Report";
                trigger OnAction()

                begin
                    Rec.SetData();
                end;
            } 
        }
    }
    trigger OnOpenPage()
    begin 
        Rec.SetFilter("Balance at Date for Subsidiary",'<>0');
        Rec.SetFilter("Site Code",'%1','');
    end;

}