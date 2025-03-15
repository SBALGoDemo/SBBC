// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
pageextension 50043 "OBF-Sales Journal" extends "Sales Journal"
{
    layout
    {
        modify(Amount)
        {
            Visible = false;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
            Editable = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
            Editable = false;
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field(BssiEntityID;Rec.BssiEntityID)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }       
        addafter(Description)
        {
            field("OBF-Site Code";Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code";Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }            
        }
    }
}