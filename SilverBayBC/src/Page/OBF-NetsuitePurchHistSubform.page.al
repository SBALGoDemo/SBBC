// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50038 "OBF-Netsuite Pur Hist Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "OBF-Netsuite Purch Inv. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity;Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price";Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount;Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subsidiary Code";Rec."Subsidiary Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Site Code";Rec."Site Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}