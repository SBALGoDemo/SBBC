// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
page 50044 "OBF-Certification List"
{
    Caption = 'Certification List';
    CardPageID = "OBF-Certification Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "OBF-Certification";
    SourceTableView = SORTING("Presentation Order");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Code";
                ShowAsTree = true;
                field("Code";Rec.Code)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for the Certification.';

                    trigger OnValidate();
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the Certification.';
                }
                field("Parent Certification";Rec."Parent Certification")
                {
                    Visible = false;
                }
                field(Indentation;Rec.Indentation)
                {
                    Visible = false;
                }
                field("Presentation Order";Rec."Presentation Order")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnAfterGetRecord();
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnDeleteRecord() : Boolean;
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    var
        StyleTxt : Text;
}