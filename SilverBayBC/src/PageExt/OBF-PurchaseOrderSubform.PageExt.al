pageextension 50071 OBF_PurchaseOrderSubform extends "Purchase Order Subform"
{

    layout
    {
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }

        addafter(Description)
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code"; Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
        }        
    }
 
    actions
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1889 - Import Item Charge Assignment by Item Ledger Entry
        addafter(ItemChargeAssignment)
        {
            action("OBF-ItemChargeAssignment_ItemLedger")
            {
                AccessByPermission = TableData "Item Charge" = R;
                ApplicationArea = ItemCharges;
                Caption = 'Item Charge Assignment-Item &Ledger';
                Image = ItemCosts;
                Enabled = Rec.Type = Rec.Type::"Charge (Item)";
                ToolTip = 'Record additional direct costs, for example for freight. This action is available only for Charge (Item) line types.';
                Visible = false;
                trigger OnAction()
                begin
                    Rec.OBF_ShowItemChargeAssgnt();
                    //SetItemChargeFieldsStyle();
                end;
            }
        }
        // addfirst("F&unctions")
        // {
        //     action("OBF-Assign Lot No.")
        //     {
        //         ApplicationArea = ItemTracking;
        //         Caption = 'Assign &Lot No. (Shift+Alt+L)';
        //         Image = Lot;
        //         ToolTip = 'Automatically assign the required lot numbers from predefined number series.  Open Item Tracking if Lot No. already assigned or negative quantity.';
        //         ShortcutKey = 'Shift+Alt+L';

        //         trigger OnAction()
        //         begin
        //             AssignLotOrOpenItemTracking();
        //         end;
        //     }
        // }

        // addlast("&Line")
        // {
        //     // https://odydev.visualstudio.com/ThePlan/_workitems/edit/630 - Issue with reservations on cancelled purchase orders
        //     Action(SOReservations)
        //     {
        //         ApplicationArea = All;
        //         CaptionML = ENU = 'SO Reservations';
        //         Image = Lot;
        //         trigger OnAction();
        //         begin
        //             ShowSalesOrderReservations;
        //         end;
        //     }
        // }


    }
    var
        OBFAssignLotOrOpenTrackingText: Text;
        AdditionalFieldsEditable: Boolean;

    trigger OnAfterGetRecord();
    begin
        //SetAssignOrOpenTrackingText();
        SetAdditionalFieldsEditable();
    end;

    // trigger OnModifyRecord(): Boolean
    // begin 
    //     if Rec.Quantity = xRec.Quantity then
    //         exit(true);

    //     SetAssignOrOpenTrackingText();
    //     exit(true);
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin 
        OBFAssignLotOrOpenTrackingText := '';
    end;

  
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/630 - Issue with reservations on cancelled purchase orders
    // local procedure ShowSalesOrderReservations();
    // var
    //     SalesLineswithReservations: Page "OBF-SO Reservations for PO";
    // begin
    //     SalesLineswithReservations.SetPurchaseInfo(Rec."Document No.", Rec."Line No.");
    //     SalesLineswithReservations.RUN;
    // end;

    // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1186 - Item Tracking     
    // local procedure SpecialOpenItemTrackingLines();
    // var
    //     SpecialTrackingMgmt: codeunit "OBF-Special Item Tracking Mgmt";
    // begin
    //     TestField(Type, Type::Item);
    //     TestField("No.");

    //     TestField("Quantity (Base)");

    //     SpecialTrackingMgmt.PurchaseCallItemTracking(Rec);
    // end;

    // local procedure SetAssignOrOpenTrackingText()
    // begin
    //     if (Type <> Type::Item) or (Quantity = 0) then
    //         OBFAssignLotOrOpenTrackingText := ''
    //     else if (Rec."OBF-Lot No." = '') and (Quantity > 0) then
    //         OBFAssignLotOrOpenTrackingText := 'Assign Lot (Shift+Alt+L)'
    //     else
    //         OBFAssignLotOrOpenTrackingText := 'Open Tracking';
    // end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1186 - Item Tracking
    // procedure OpenItemTrackingLines_NegativeQty(var Rec: Record "Purchase Line");
    // var
    //     SpecialItemTrackingMgmt: Codeunit "OBF-Special Item Tracking Mgmt";
    // begin
    //     SpecialItemTrackingMgmt.CallItemTracking_PurchaseLine_NegativeQty(Rec);
    // end;

    procedure SetAdditionalFieldsEditable()
    begin 
        AdditionalFieldsEditable := Rec.Quantity > 0;
    end;

    // procedure AssignLotOrOpenItemTracking()
    // begin 
    //     if Rec.Quantity > 0 then begin
    //         if Rec."OBF-Lot No." = '' then
    //             Rec.AssignNewLotNo()
    //         else
    //             SpecialOpenItemTrackingLines;
    //         SetAssignOrOpenTrackingText();
    //         CurrPage.Update();
    //     end else begin
    //         OpenItemTrackingLines_NegativeQty(Rec);
    //         CurrPage.Update(false);
    //     end;
    // end;

}