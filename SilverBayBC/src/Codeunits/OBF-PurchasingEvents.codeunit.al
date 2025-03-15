codeunit 50051 "OBF-Purchasing Events"
{
    trigger OnRun();
    begin
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnAfterGetItemValues', '', false, false)]
    local procedure ItemChargeAssgntPurch_OnAfterGetItemValues(var TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary; var DecimalArray: array[3] of Decimal)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
    begin
        case TempItemChargeAssgntPurch."Applies-to Doc. Type" of
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Item Ledger Entry":
                begin
                    ItemLedgerEntry.Get(TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                    Item.Get(ItemLedgerEntry."Item No.");
                    DecimalArray[1] := ItemLedgerEntry.Quantity;
                    DecimalArray[2] := Item."Gross Weight";
                    DecimalArray[3] := Item."Unit Volume";
                end;
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/562 - Prevent duplicate lot entry on PO's, Transfers, Returns, etc.
    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertItemLedgerEntry(var Rec: Record "Item Ledger Entry"; RunTrigger: Boolean)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry_OriginalLot: Record "Item Ledger Entry";
        //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
        InventorySetup: Record "Inventory Setup";
        ItemCategory: Record "Item Category";
        Item: Record Item;
        OriginalLotForCreditMemo: Code[50];
        PurchaserCode: Code[20];
        PurchaseOrderNo: Code[20];
        NewReceiptDate: Date;
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Lot No." = '' then
            exit;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        Item.Get(Rec."Item No.");
        Rec."OBF-Net Weight" := Rec.Quantity * Item."Net Weight";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
        if Rec."Qty. per Unit of Measure" <> 0 then
            Rec."OBF-Quantity (Source UOM)" := ROUND(Rec.Quantity / Rec."Qty. per Unit of Measure", 0.00001);

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        // InventorySetup.Get();
        // if InventorySetup."OBF-Enable Lots for Purchaser" then begin
        //     GetPurchaseInfoFromItemLedgerEntry(Rec, PurchaserCode, PurchaseOrderNo, NewReceiptDate);
        //     Rec."OBF-Purchaser Code" := PurchaserCode;
        //     Rec."OBF-Purchase Order No." := PurchaseOrderNo;
        //     Rec."OBF-Receipt Date" := NewReceiptDate;
        // end;

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1398 - Error when posting sales credit memo
        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/610 - Enable Use of Corrective Credit Memos
        // if InventorySetup."OBF-Enable CM Lot Extension" then
        //     if (Rec."Document Type" = Rec."Document Type"::"Sales Credit Memo") then begin
        //         if FindOriginalLotForCreditMemoLot(Rec."Lot No.",OriginalLotForCreditMemo) then
        //             if Rec.Quantity > 0 then begin
        //                 ItemLedgerEntry_OriginalLot.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Serial No.");
        //                 ItemLedgerEntry_OriginalLot.SetRange("Item No.",Rec."Item No.");
        //                 ItemLedgerEntry_OriginalLot.SetRange("Lot No.", OriginalLotForCreditMemo);
        //                 ItemLedgerEntry_OriginalLot.SetFilter(Quantity,'>0');
        //                 if ItemLedgerEntry_OriginalLot.FindFirst() then begin 
        //                     Rec."OBF-Production Date" := ItemLedgerEntry_OriginalLot."OBF-Production Date";

        //                     // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1527 - Missing Inv. Status Data for Sales Credit Memo Lots
        //                     Rec."OBF-Receipt Date" := ItemLedgerEntry_OriginalLot."OBF-Receipt Date";
        //                     Rec."OBF-Purchaser Code" := ItemLedgerEntry_OriginalLot."OBF-Purchaser Code";
        //                     if ItemVariantLotInfo.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Location Code") then begin
        //                         ItemVariantLotInfo.Buyer := ItemLedgerEntry_OriginalLot."OBF-Purchaser Code";
        //                         ItemVariantLotInfo."Vendor No." := ItemLedgerEntry_OriginalLot."Source No.";
        //                         ItemLedgerEntry_OriginalLot.CalcFields("OBF-Vendor Name");
        //                         ItemVariantLotInfo."Vendor Name" := ItemLedgerEntry_OriginalLot."OBF-Vendor Name";
        //                         ItemVariantLotInfo."Receipt Date" := ItemLedgerEntry_OriginalLot."OBF-Receipt Date";
        //                         ItemVariantLotInfo.Modify();
        //                     end; 

        //                 end;
        //             end;
        //         exit;
        //     end;
        // //https://odydev.visualstudio.com/ThePlan/_workitems/edit/610 - End

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/917 - Require Production Dates for all Lots
        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/965 - Exclude Specified Item Categories from Production Date Requirement

        // if ItemCategory.Get(Rec."Item Category Code") then
        //     if ItemCategory."OBF-Req Prod Date for Item Cat" then
        //         if (Rec.Quantity > 0) and (Rec."OBF-Production Date" = 0D) then
        //             Error('For Item %1 Lot %2, the Production Date must not be blank.', Rec."Item No.", Rec."Lot No.");

        // InventorySetup.Get;
        // if InventorySetup."OBF-Enable Prevent Dupl. Lots" then
        //     if Rec.Quantity > 0 then begin
        //         ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Serial No.");
        //         ItemLedgerEntry.SetRange("Lot No.", rec."Lot No.");
        //         If ItemLedgerEntry.FindFirst then
        //             Error('Error Posting Item %1; Lot No. %2 already exists for Item %3', Rec."Item No.", Rec."Lot No.", ItemLedgerEntry."Item No.");
        //     end;

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure AutoCreateVendorRuleForDocSet(VendorNo: Code[20]; DocumentSetNo: Code[20]; UseCustContactIfAvailable: Boolean);
    var
        ZetadocsVendorRule: Record "Zetadocs Vendor Rule";
        SalesSetup: Record "Sales & Receivables Setup";
        Vendor: Record Vendor;
    begin
        if ZetadocsVendorRule.Get(VendorNo, DocumentSetNo) then
            exit;

        SalesSetup.Get;
        Vendor.Get(VendorNo);
        ZetadocsVendorRule."Vendor No." := VendorNo;
        ZetadocsVendorRule."Zd Rule ID No." := DocumentSetNo;
        ZetadocsVendorRule."Contact Option" := ZetadocsVendorRule."Contact Option"::Other;
        if UseCustContactIfAvailable then
            if Vendor."E-Mail" <> '' then begin
                ZetadocsVendorRule."Contact Name" := Vendor.Contact;
                ZetadocsVendorRule."Contact E-Mail" := Vendor."E-Mail";
            end;

        if ZetadocsVendorRule."Contact E-Mail" = '' then begin
            ZetadocsVendorRule."Contact Name" := SalesSetup."OBF-Zetadocs Send Name";
            ZetadocsVendorRule."Contact E-Mail" := SalesSetup."OBF-Zetadocs Send Email";
        end;

        ZetadocsVendorRule."Delivery Method" := ZetadocsVendorRule."Delivery Method"::"E-Mail";
        ZetadocsVendorRule.Insert;
        Commit;
    end;
}