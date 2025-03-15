// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50033 "OBF-Netsuite Sales Hist. List"
{
    Caption = 'Netsuite Sales History List';
    ApplicationArea = Basic, Suite;
    CardPageID = "OBF-Netsuite Sales Hist. Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Posted Sales Invoices';
    SourceTable = "OBF-Netsuite Sales Inv. Header";
    SourceTableView = sorting("Posting Date")
                      order(Descending);
    UsageCategory = History;

    AboutTitle = 'About Netsuite Sales History List';
    AboutText = 'This Netsuite Sales History List is a copy of the historical invoices from Netsuite.';

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
                field("Document Type";Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }                
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
            }
        }
    }
}