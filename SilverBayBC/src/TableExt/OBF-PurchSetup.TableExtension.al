// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/609 - Enhanced Add-On Functionality
tableextension 50019 "OBF-Purchases Setup" extends "Purchases & Payables Setup"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
        field(50000; "OBF-Add-on Purchase Order Nos."; Code[20])
        {
            CaptionML = ENU = 'Add-on Purchase Order Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50010; "OBF-Addon Def. Item Ch. Code"; Code[20])
        {
            CaptionML = ENU = 'Default Item Charge Code for Add-ons';
            TableRelation = "Item Charge";
        }
        field(50012; "OBF-Add-on Def. Dist. Method"; Enum "OBF-Addon Distribution Method")
        {
            Caption = 'Default Distribution Method for Add-ons';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1529 - Enable searching Zetadocs by Vendor Invoice No.
        field(50090; "OBF-Enable Zetadocs Metadata"; Boolean)
        {
            Caption = 'Enable Zetadocs Metadata';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
        field(50100; "OBF-Doc. Set for Remit Adv"; Code[20])
        {
            Caption = 'Zetadocs Document Set for Remittance Advice';
            TableRelation = "Zetadocs Document Set";
        }
        field(50110; "OBF-Doc. Set for Order Conf."; Code[20])
        {
            Caption = 'Zetadocs Document Set for Order Confirmation';
            TableRelation = "Zetadocs Document Set";
        }
    }
}