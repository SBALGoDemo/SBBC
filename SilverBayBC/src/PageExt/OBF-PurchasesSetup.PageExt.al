// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/609 - Enhanced Add-On Functionality
pageextension 50039 "OBF-Purchases Setup" extends "Purchases & Payables Setup"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
        addlast("Number Series")
        {
            field("OBF-Add-on Purchase Order Nos."; Rec."OBF-Add-on Purchase Order Nos.")
            {
                ApplicationArea = all;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/630 - Issue with reservations on cancelled purchase orders
        addafter("Default Accounts")
        {
            group(OBF_Extensions)
            {
                Caption = 'Extensions';
                group(OBF_ExtensionsGroup)
                {
                    Caption = 'Orca Bay Extensions';
                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1529 - Enable searching Zetadocs by Vendor Invoice No.
                    field("OBF-Enable Zetadocs Metadata"; Rec."OBF-Enable Zetadocs Metadata")
                    {
                        ToolTip = 'Enable Zetadocs Metadata for Vendor Invoice No.';
                        ApplicationArea = all;
                    }

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
                    field("OBF-Doc. Set for Remit Adv"; Rec."OBF-Doc. Set for Remit Adv")
                    {
                        ApplicationArea = All;
                    }
                }
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
            group(Addons)
            {
                Caption = 'Add-ons';
                field("OBF-Addon Def. Item Ch. Code"; Rec."OBF-Addon Def. Item Ch. Code")
                {
                    ToolTip = 'This is the Default Item Charge Code for the Create Add-on Purchase Order report';
                    ApplicationArea = All;
                }
                field("OBF-Add-on Def. Dist. Method"; Rec."OBF-Add-on Def. Dist. Method")
                {
                    ToolTip = 'This is the Default Distribution Method for the Create Add-on Purchase Order report';
                    ApplicationArea = All;
                }
            }
        }

    }
}