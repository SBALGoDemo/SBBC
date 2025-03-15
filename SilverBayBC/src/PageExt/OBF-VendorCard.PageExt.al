// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50010 "OBF-Vendor Card" extends "Vendor Card"
{
    layout
    {
        modify("Name 2")
        {
            Visible = true;
        }
        moveafter("Name 2";"Our Account No.", "Vendor Posting Group")
        addafter("Name 2")
        {
            field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;                
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
            field("OBF-Site Code";Rec."OBF-Site Code")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;                
            }
            
        }
    } 

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
    actions
    {
        addafter("Ledger E&ntries")
        {
            action(NetsuitePurchaseHistory)
            {
                Caption = 'Netsuite Purchase History';
                Image = History;
                ApplicationArea = all;
                RunObject = Page "OBF-Netsuite Purchase History";
                RunPageLink = "Vendor No." = field("No.");
                RunPageView = sorting("Vendor No.")
                                order(descending);
            }
        }
    } 
}