// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1776 - Add Memo field to Deposit Page 
pageextension 50040 "OBF-Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        moveafter("Document No.";"Your Reference","External Document No.")
        modify("External Document No.") {Visible = true; Caption = 'Customer PO';}
        modify("Your Reference") {Visible = true;}
        addafter("Your Reference")
        {
            field("OBF-Memo";Rec."OBF-Memo")
            {
                ApplicationArea = all;
            }
        }
    }
}