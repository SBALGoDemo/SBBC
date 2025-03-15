// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Page Cleanup
pageextension 50036 "OBF-Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        moveafter("Document No.";"Your Reference","External Document No.")
        modify("External Document No.") {Visible = true; Caption = 'Customer PO';}

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1776 - Add Memo field to Deposit Page 
        modify("Your Reference") {Visible = true;}
        addafter("Your Reference")
        {
            field("OBF-Memo";Rec."OBF-Memo")
            {
                ApplicationArea = all;
                Editable = true;
                Enabled = true;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addafter("Error Description")
        {
            field("OBF-Rebate Code"; Rec."OBF-Rebate Code")
            {
                ApplicationArea = all;
                Caption = 'Rebate Code';
                Editable = false;
            }
            field("OBF-Rebate Ledger Entry No."; Rec."OBF-Rebate Ledger Entry No.")
            {
                Visible = false;
                ApplicationArea = all;
                Caption = 'Rebate Ledger Entry No.';
                Editable = false;
            }
        }
        
    }
    actions
    {
        addlast(Navigation)
        {
            action(SetYourReference)
            {
                Caption = 'Set Your Reference';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                var
                    CUOnUpgrade: Codeunit "OBF-OnUpgrade";
                begin
                    CUOnUpgrade.SetCustLedgerEntryYourReference();                   
                end; 
            }
        }
    }
}