// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
pageextension 50001 "OBF-Item Card" extends "Item Card"
{
    layout
    {
        moveafter("Item Category Code"; "Net Weight")

        addfirst(FactBoxes)
        {
            part("OBF-Item Certification Factbox";"OBF-Item Certification Factbox")
            {
                ApplicationArea = all;
                SubPageLink = "Item No." = FIELD("No.");
            }

        }
    }
    
    actions
    {
        addlast(Navigation_Item)
        {
            action(ItemCertifications)
            {
                Caption = 'Item Certifications';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                var
                    ItemCertification : Record "OBF-Item Certification";
                begin
                    ItemCertification.SetRange("Item No.", Rec."No.");
                    Page.Run(Page::"OBF-Item Certifications", ItemCertification)
                end;
            }
        }
    }

}