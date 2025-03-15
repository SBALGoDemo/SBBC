// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50036 "OBF-Netsuite Purch. Hist. Card"
{
    Caption = 'Netsuite Purchase History Card';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "OBF-Netsuite Purch Inv. Header";

    AboutTitle = 'About posted Purchase invoice details';
    AboutText = 'This Purchase invoice is a copy of an historical invoice from Netsuite.';

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
                field("Vendor No.";Rec."Vendor No.")  
                {
                    ApplicationArea = Basic, Suite; 
                    Importance = Promoted;
                    Editable = false;
                    TableRelation = Vendor;
                }           
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor';
                    Editable = false;
                    Importance = Promoted;
                    TableRelation = Vendor.Name;
                    ToolTip = 'Specifies the name of the Vendor that you received the invoice from.';
                }
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                } 
            }
            part(PurchaseInvLines; "OBF-Netsuite Pur Hist Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
}