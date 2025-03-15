// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1765 - Need Site Code on Bank Deposit
pageextension 50037 "OBF-Bank Deposit Subform" extends "Bank Deposit Subform"
{
    layout
    {
        modify("ShortcutDimCode[3]") { Editable = false;}
        modify("ShortcutDimCode[4]") { Editable = false;}
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1802 - Posting bank deposits with fees
        addbefore("Credit Amount")
        {
            field("Debit Amount";Rec."Debit Amount")
            {
                ApplicationArea = all;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1776 - Add Memo field to Deposit Page 
        addafter("Document No.")
        {
            field(Comment;Rec.Comment)
            {
                Caption = 'Memo';
                ApplicationArea = all;
            }
            field(Correction;Rec.Correction)
            {
                ApplicationArea = all;
            }
        }
        
    }
}