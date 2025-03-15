pageextension 50009 "OBF-General Journal" extends "General Journal"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1714 - Show Credit and Debit Amount on Journals and Ledger Entries
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
        addafter(Description)
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code"; Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1786 - Add "Our Account No." to General Journal
        addafter(AccountName)
        {
            field("OBF-Our Account No."; Rec."OBF-Our Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
}