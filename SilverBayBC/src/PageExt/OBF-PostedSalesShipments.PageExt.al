// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
pageextension 50034 "OBF-Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                Visible = true;
                ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
            }
            field("OBF-FOB Location";Rec."OBF-FOB Location")
            {
                ApplicationArea = all;
                Visible = true;
             }
        }
        moveafter("Sell-to Customer Name";"External Document No.")
        modify("External Document No.") 
        { 
            Visible = true;
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        modify("Shortcut Dimension 2 Code") {Visible = false;}
        modify("Currency Code") {Visible = false;}
        modify("Location Code") {Visible = false;}
    } 
}