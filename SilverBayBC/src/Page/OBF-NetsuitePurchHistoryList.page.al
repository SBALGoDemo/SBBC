// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50037 "OBF-Netsuite Purch. Hist. List"
{
    Caption = 'Netsuite Purchase History List';
    ApplicationArea = Basic, Suite;
    CardPageID = "OBF-Netsuite Purch. Hist. Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Posted Purchase Invoices';
    SourceTable = "OBF-Netsuite Purch Inv. Header";
    SourceTableView = sorting("Posting Date")
                      order(Descending);
    UsageCategory = History;

    AboutTitle = 'About posted Purchase invoice details';
    AboutText = 'This Purchase invoice is a copy of an historical invoice from Netsuite.';

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
                    AboutTitle = 'The final invoice number (No.)';
                    AboutText = 'This is the invoice number uniquely identifying each posted sale. Your Vendors see this number on the invoices they receive from you.';
                    ToolTip = 'Specifies the posted Purchase invoice number. Each posted Purchase invoice gets a unique number. Typically, the number is generated based on a number series.';
                }
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }                
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor No.';
                    ToolTip = 'Specifies the number of the Vendor the invoice concerns.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Name';
                    ToolTip = 'Specifies the name of the Vendor that you shipped the items on the invoice to.';
                }
            }
        }
        area(Factboxes)
        {
            
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction();
                begin
                    
                end;
            }
        }
    }
}