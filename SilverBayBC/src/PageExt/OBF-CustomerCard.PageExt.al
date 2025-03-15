// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Page Cleanup
pageextension 50023 "OBF-Customer Card" extends "Customer Card"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1826 - Sales Invoice Enhancements
        modify("VAT Registration No.") { Caption = 'Tax Reg. No./Unified Bus. Identifier'; }
        modify("Tax Exemption No.") { Caption = 'Tax Exemption No./Resale Permit No.'; }

        addafter(Name)
        {
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = all;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List
            field("OBF-Broker";Rec."OBF-Broker")
            {
                ApplicationArea = all;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }

        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        addafter("Salesperson Code")
        {
            field("OBF-Workflow Salesperson Code"; Rec."OBF-Workflow Salesperson Code")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1023 - Assign a Traffic Person on Customer Card
            field("OBF-Workflow Traffic Person"; Rec."OBF-Workflow Traffic Person")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        addafter(Statistics)
        {
            group(OBF_Extension)
            {
                Caption = 'Extension';
                field("OBF-EDI Enabled"; Rec."OBF-EDI Enabled")
                {
                    ApplicationArea = all;
                    Visible = true;
                    Importance = Promoted;
                }
            }
        }

    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
    actions
    {
        addafter("Ledger E&ntries")
        {
            action(NetsuiteSalesHistory)
            {
                Caption = 'Netsuite Sales History';
                Image = History;
                ApplicationArea = all;
                RunObject = Page "OBF-Netsuite Sales History";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = sorting("Sell-to Customer No.")
                                order(descending);
            }
        }
    }
}