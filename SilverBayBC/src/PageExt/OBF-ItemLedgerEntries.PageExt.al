// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1756 - Item Sales report
pageextension 50033 "OBF-Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
        moveafter("Global Dimension 1 Code"; "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")

        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        addafter("Lot No.")
        {
            field("OBF-Net Weight";Rec."OBF-Net Weight")
            {
                ApplicationArea = all;
            }
        }

       // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
        addafter(Quantity)
        {
            field("OBF-Quantity (Source UOM)";Rec."OBF-Quantity (Source UOM)")
            {
                ApplicationArea = all;
            }
        }

    }
}