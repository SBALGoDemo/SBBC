// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50008 "OBF-Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn=Description;
        }
        modify("Shortcut Dimension 1 Code") { Editable = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Amount Including VAT") {Visible = false; }
        modify("Location Code") {Visible = false; }
        modify("Line Amount") { Editable = false; }

        moveafter("Line Amount";"Shortcut Dimension 2 Code")
        addafter("Line Amount")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
            field("OBF-MSC Certification";Rec."OBF-MSC Certification")
            {
                ApplicationArea = all;
                Editable = CertificationIsEditable;
                trigger OnValidate()
                begin 
                    CurrPage.Update();
                end;
            }
            field("OBF-RFM Certification";Rec."OBF-RFM Certification")
            {
                ApplicationArea = all;
                Editable = CertificationIsEditable;
                trigger OnValidate()
                begin 
                    CurrPage.Update();
                end;
            }
        }
        
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addlast(Control1)
        {
            field("OBF-Off-Inv. Rebate Unit Rate"; Rec."OBF-Off-Inv. Rebate Unit Rate")
            {
                ApplicationArea = all;
            }
            field("OBF-Off Invoice Rebate Amount"; Rec."OBF-Off Invoice Rebate Amount")
            {
                ApplicationArea = all;
            }
        }
         
    }

    trigger OnAfterGetRecord()
    begin 
        CertificationIsEditable := Rec.Type = Rec.Type::Item;
    end;

    var
        CertificationIsEditable: Boolean;
}