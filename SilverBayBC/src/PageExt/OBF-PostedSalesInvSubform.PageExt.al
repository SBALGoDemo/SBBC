// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50019 "OBF-Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn=Description;
        }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }

        moveafter("Line Amount";"Shortcut Dimension 2 Code")
        addbefore("Shortcut Dimension 2 Code")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
            field("OBF-MSC Certification";Rec."OBF-MSC Certification")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("OBF-RFM Certification";Rec."OBF-RFM Certification")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addafter("ShortcutDimCode[8]")
        {
            field(RebateUnitAmount; RebateUnitAmount)
            {
                ApplicationArea = all;
                Caption = 'Off-Inv. Rebate Unit Rate';
            }
            field("OBF-Off Invoice Rebate Amount"; Rec."OBF-Off Invoice Rebate Amount")
            {
                ApplicationArea = all;
                Caption = 'Off-Invoice Rebate Amount';
            }
        }           
    }

    var
        RebateUnitAmount: Text[50];

    trigger OnAfterGetRecord();
    var
        RebateManagement: Codeunit "OBF-Rebate Management";
    begin
        RebateUnitAmount := RebateManagement.CalculateOffInvoicePerLb(Rec."OBF-Off Invoice Rebate Amount", Rec."OBF-Line Net Weight")
    end;
}