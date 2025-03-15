// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
page 50043 "OBF-Certification Card"
{
    Caption = 'Certification Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "OBF-Certification";
    ApplicationArea = All;
    
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Rec.Code)
                {
                    NotBlank = true;
                    ToolTip = 'Specifies the Certification.';
                }
                field(Name;Rec.Name)
                {
                    ToolTip = 'Specifies a description of the Certification.';
                }
                field("Parent Certification";Rec."Parent Certification")
                {

                    trigger OnValidate();
                    var
                        NewParentCertificationCode : Code[20];
                    begin
                    end;
                }
                field(Indentation;Rec.Indentation)
                {
                }
                field("Presentation Order";Rec."Presentation Order")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Enabled = (NOT Rec."Has Children");
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Delete the record.';

                trigger OnAction();
                begin
                    if Confirm(StrSubstNo(DeleteQst,Rec.Code)) then
                      Rec.Delete(true);
                end;
            }
        }
    }

    var
        DeleteQst : Label 'Delete %1?', Comment='%1 - Certification name';
        UpdateCertificationsPresentationOrder : Boolean;
}

