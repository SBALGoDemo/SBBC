// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50030 "OBF-Pstd. Sl. Cr. Mm. Subform" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("OBF-Off Invoice Rebate Amount"; Rec."OBF-Off Invoice Rebate Amount")
            {
                ApplicationArea = all;
                Caption = 'Off-Invoice Rebate Amount';
            }
        }
    }
}