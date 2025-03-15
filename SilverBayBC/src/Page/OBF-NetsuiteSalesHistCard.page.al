// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50032 "OBF-Netsuite Sales Hist. Card"
{
    Caption = 'Netsuite Sales History Card';
    InsertAllowed = false;
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "OBF-Netsuite Sales Inv. Header";

    AboutTitle = 'About Netsuite Sales History Card';
    AboutText = 'This Netsuite Sales History Card is a copy of an historical invoice from Netsuite.';
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sell-to Customer No.";Rec."Sell-to Customer No.")  
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    Editable = false;
                    Importance = Promoted;
                    TableRelation = Customer;
                }             
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Editable = false;
                    Importance = Promoted;
                    TableRelation = Customer.Name;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                } 
            }
            part(SalesInvLines; "OBF-Netsuite Sal Hist Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
}