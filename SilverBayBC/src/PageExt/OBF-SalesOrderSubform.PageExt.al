// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50042 "OBF-Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify(Control1)
        {
            FreezeColumn = Description;
        }
        modify("Shortcut Dimension 1 Code") { Editable = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Amount Including VAT") { Visible = false; }
        modify("Line Amount") { Editable = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1863 - Customize Sales Order page for Silver Bay
        modify("IC Partner Code") { Visible = false; }
        // modify(BssiAllocationTemplateId) {Visible = false; }
        modify("Qty. to Assemble to Order") { Visible = false; }
        modify("Reserved Quantity") { Visible = false; }
        modify("Item Charge Qty. to Handle") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - EDI - Silver Bay
        addafter(Quantity)
        {
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
            field("OBF-Allocated Quantity"; Rec."OBF-Allocated Quantity")
            {
                ApplicationArea = all;
                ToolTipML = ENU = 'This is the quantity that is allocated to lots in Item Tracking.';
            }
            field("OBF-Item Type"; Rec."OBF-Item Type")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("OBF-Item Tracking Code"; Rec."OBF-Item Tracking Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("OBF-Lot Number"; Rec."OBF-Lot Number")
            {
                ApplicationArea = all;
            }
        }

        moveafter("Line Amount"; "Shortcut Dimension 2 Code")
        addafter("Line Amount")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
            field("OBF-MSC Certification"; Rec."OBF-MSC Certification")
            {
                ApplicationArea = all;
                Editable = CertificationIsEditable;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("OBF-RFM Certification"; Rec."OBF-RFM Certification")
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

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1863 - Customize Sales Order page for Silver Bay
    actions
    {
        moveafter("Item Availability by"; ItemTrackingLines)
    }

    trigger OnAfterGetRecord()
    begin
        CertificationIsEditable := Rec.Type = Rec.Type::Item;
    end;

    var
        CertificationIsEditable: Boolean;
}