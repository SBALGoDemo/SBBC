// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
pageextension 50121 "INVC Bank Account" extends "Bank Account Card"
{
    layout
    {
        addbefore("Export Format")
        {
            field("INVC Export Wells Fargo Checks"; Rec."INVC Export WF Payment File")
            {
                ApplicationArea = All;
            }
            field("INVC Last WF Export File"; Rec."INVC Last WF Export File")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}