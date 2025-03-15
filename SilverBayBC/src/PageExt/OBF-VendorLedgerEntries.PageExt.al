// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50045 "OBF-Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2018 - Make memo field available on customer and vender ledgers
    layout
    {
        addafter("Document No.")
        {
            field("OBF-Memo"; Rec."OBF-Memo")
            {
                ApplicationArea = all;
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    actions
    {
        addfirst(processing)
        {
            action(SendRemittanceAdviceToFactbox)
            {
                Caption = 'Send Remittance Advice (ZD)';
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'This action sends the Remittance Advice Entries using the Zetadocs vendor rules and puts a copy in the Documents Factbox';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.TestField("Document Type", Rec."Document Type"::Payment);
                    Rec.OBF_SendRemittanceAdviceEntries();
                end;
            }
        }
    }

}