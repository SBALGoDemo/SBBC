// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50030 "OBF-Netsuite Sales History"
{
    PageType = List;
    UsageCategory = History;
    AutoSplitKey = true;
    Caption = 'Netsuite Sales History';
    Editable = false;
    LinksAllowed = false;
    SourceTable = "OBF-Netsuite Sales Inv. Line";
    SourceTableView = sorting("Sell-to Customer No.")
                    order(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No.";Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer Name";Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                                field("Document Type";Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No.";Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }                
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
    actions
    {
        area(processing)
        {
            action(SetData)
            {
                Caption = 'Set Data';
                Image = SetPriorities;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                begin
                    Rec.SetCustomerAndPostingDate();                  
                end; 
            }
        }
    }
}