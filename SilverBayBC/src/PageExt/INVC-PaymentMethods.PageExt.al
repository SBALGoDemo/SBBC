// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
pageextension 50122 "INVC Payment Methods" extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field("INVC WF Export Type"; Rec."INVC WF Export Type")
            {
                ApplicationArea = All;
                Style = Subordinate;
                StyleExpr = Rec."INVC WF Export Type" = Rec."INVC WF Export Type"::None;
            }
        }
    }
}
