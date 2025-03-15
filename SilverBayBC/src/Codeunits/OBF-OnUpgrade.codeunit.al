codeunit 50062 "OBF-OnUpgrade"
{
    Subtype = Upgrade;
    Permissions = TableData "Sales Shipment Header" = RIMD, tabledata "Item Ledger Entry" = RIMD, tabledata "Cust. Ledger Entry" = RIMD, tabledata "G/L Entry" = RIMD, tabledata "Purch. Inv. Header" = RM;

    trigger OnUpgradePerCompany();
    begin
        // SetItemNetWeightForLbs();
        // SetSalesLineNetWeight();
        InitPurchaseSetupCustomFields();
        InitSalesSetupCustomFields();
        UpdateQuantitySourceUOM();

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2208 - Mark Post Purch Inv 114946 as Exported to Coupa
        // Mark Invoice 114946 as exported to Coupa (remove/comment after data is updated)
        MarkPurchaseInvoiceAsExportedToCoupa('114946');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1756 - Item Sales report
    procedure SetSalesShipmentHeaderFOBLocation()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Num: Integer;
    begin
        SalesShipmentHeader.SetFilter("OBF-FOB Location", '%1', '');
        SalesShipmentHeader.SetFilter("Your Reference", '<>%1', '');
        if SalesShipmentHeader.FindSet() then
            repeat
                SalesInvoiceHeader.SetRange("Your Reference", SalesShipmentHeader."Your Reference");
                if SalesInvoiceHeader.Count = 1 then begin
                    SalesInvoiceHeader.FindFirst();
                    SalesShipmentHeader."OBF-FOB Location" := SalesInvoiceHeader."OBF-FOB Location";
                    SalesShipmentHeader.Modify();
                    Num += 1;
                end
            until (SalesShipmentHeader.Next() = 0);
        Message('%1 records updated', Num);
    end;

    procedure SetItemLedgerEntryDescription()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        Num: Integer;
    begin
        ItemLedgerEntry.SetFilter(Description, '%1', '');
        ItemLedgerEntry.FindSet();
        repeat
            Item.Get(ItemLedgerEntry."Item No.");
            ItemLedgerEntry.Description := Item.Description;
            ItemLedgerEntry.Modify();
            Num += 1;
        until (ItemLedgerEntry.Next() = 0);
        Message('%1 records updated', Num);
    end;

    procedure SetCustLedgerEntryYourReference()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Num: Integer;
    begin
        CustLedgerEntry.SetFilter("Your Reference", '%1', '');
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry."Your Reference" := CustLedgerEntry."Document No.";
                CustLedgerEntry.Modify();
                Num += 1;
            until (CustLedgerEntry.Next() = 0);
        Message('%1 records updated', Num);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
    procedure SetGLEntrySiteCode()
    var
        GLEntry: Record "G/L Entry";
        Num: Integer;
    begin
        GLEntry.SetFilter("OBF-Site Code", '%1', '');
        GLEntry.SetFilter("Shortcut Dimension 3 Code", '<>%1', '');
        if GLEntry.FindSet() then
            repeat
                GLEntry.CalcFields("Shortcut Dimension 3 Code");
                GLEntry."OBF-Site Code" := GLEntry."Shortcut Dimension 3 Code";
                GLEntry.Modify();
                Num += 1;
            until (GLEntry.Next() = 0);
        Message('# of records updated %1', Num);
    end;

    procedure SetGLEntrySiteCode2()
    var
        GLEntry: Record "G/L Entry";
        GLEntryTemp: Record "G/L Entry" temporary;
        Num: Integer;
    begin
        if GLEntry.FindSet() then
            repeat
                GLEntry.CalcFields("Shortcut Dimension 3 Code");
                if GLEntry."Shortcut Dimension 3 Code" <> GLEntry."OBF-Site Code" then begin
                    GLEntry."OBF-Site Code" := GLEntry."Shortcut Dimension 3 Code";
                    GLEntryTemp := GLEntry;
                    GLEntryTemp.Insert();
                end;

            until (GLEntry.Next() = 0);

        if GLEntryTemp.FindSet() then
            repeat
                GLEntry.Get(GLEntryTemp."Entry No.");
                GLEntry."OBF-Site Code" := GLEntryTemp."OBF-Site Code";
                GLEntry.Modify();
                Num += 1;
            until (GLEntryTemp.Next() = 0);

        Message('# of records updated %1', Num);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - G/L Entry Invalid Subsidiary and Site Combinations
    procedure SetSiteCodeIssue()
    var
        GLEntry: Record "G/L Entry";
        SubsidiarySite: Record "OBF-Subsidiary Site";
        IsModified: Boolean;
        NumUpdated: Integer;
        April2024: Date;
    begin
        Evaluate(April2024, '04/01/2024');
        GLEntry.SetFilter("Shortcut Dimension 3 Code", '<>%1', '');
        GLEntry.SetFilter("Posting Date", '>=%1', April2024);
        GLEntry.FindSet();
        repeat
            IsModified := false;
            GLEntry.CalcFields("Shortcut Dimension 3 Code");
            if not SubsidiarySite.Get(GLEntry."Global Dimension 1 Code", GLEntry."Shortcut Dimension 3 Code") then begin
                if not GLEntry."OBF-Site Code Issue" then begin
                    GLEntry."OBF-Site Code Issue" := true;
                    IsModified := true;
                end;
            end else if GLEntry."OBF-Site Code Issue" then begin
                GLEntry."OBF-Site Code Issue" := false;
                IsModified := true;
            end;
            if IsModified then begin
                GLEntry.Modify();
                NumUpdated += 1;
            end;
        until GLEntry.Next() = 0;
        Message('Num Updated = %1', NumUpdated);
    end;

    procedure SetSalesLineNetWeight();
    var
        SalesLine: Record "Sales Line";
        SalesLineCopy: Record "Sales Line";
        SalesEvents: Codeunit "OBF-Sales Events";
        Num: Integer;
    begin
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("OBF-Line Net Weight", 0.0);
        SalesLine.SetRange("Unit of Measure Code", 'LB');
        SalesLine.SetFilter(Quantity, '<>0');
        if SalesLine.FindSet then
            repeat
                SalesLineCopy := SalesLine;
                SalesLineCopy."Net Weight" := 1.0;
                SalesEvents.SetLineNetWeight(SalesLineCopy);
                SalesLineCopy.Modify;
            until (SalesLine.Next = 0);
    end;

    procedure SetItemNetWeightForLbs()
    var
        Item: Record Item;
    begin
        Item.SetRange("Base Unit of Measure", 'LB');
        Item.SetFilter("Net Weight", '<>%1', 1.0);
        if Item.FindSet() then
            repeat
                Item."Net Weight" := 1.0;
                Item.Modify();
            until (Item.Next() = 0);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure InitPurchaseSetupCustomFields();
    var
        PurchSetup: record "Purchases & Payables Setup";
    begin
        PurchSetup.Get;
        PurchSetup."OBF-Enable Zetadocs Metadata" := true;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1539 - Enable Zetadocs Send Remittance Advice from Vendor Ledger Entries
        PurchSetup."OBF-Doc. Set for Remit Adv" := 'ZD00022';

        PurchSetup.Modify;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    procedure InitSalesSetupCustomFields();
    var
        SalesSetup: record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        // SalesSetup."OBF-Submit to Shipping Step" := 10;
        // SalesSetup."OBF-Shipping Release Step" := 20;
        // SalesSetup."OBF-Cold Storage Step" := 30;
        // SalesSetup."OBF-Posting Step" := 100;
        // SalesSetup."OBF-Post Invoicing W. Step" := 200;
        // SalesSetup."OBF-Enable Dup. Rebate Check" := true;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
        SalesSetup."OBF-Zetadocs Send Email" := 'ZetadocsSend@OrcaBayFoods.com';
        SalesSetup."OBF-Zetadocs Send Name" := 'Zetadocs Send';
        SalesSetup."OBF-Doc. Set for Order Conf." := 'ZD00006';
        SalesSetup."OBF-Doc. Set for Shipping Rel." := 'ZD00030';
        SalesSetup."OBF-Doc. Set for Invoice" := 'ZD00007';

        // SalesSetup."OBF-Rebate Nos." := 'REBATEPROG';
        // SalesSetup."OBF-Rebate Document Nos." := 'REBATEDOC';
        // SalesSetup."OBF-Rebate Expense Account" := '4521';
        // SalesSetup."OBF-Rebate Acc. Offset Account" := '1210';
        // SalesSetup."OBF-Rebate Default UOM" := 'LB';
        // SalesSetup."OBF-Rebate Jnl. Template" := 'SALES';
        // SalesSetup."OBF-Rebate Jnl. Batch" := 'REBATE';
        SalesSetup.Modify;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
    procedure UpdateQuantitySourceUOM()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("OBF-Quantity (Source UOM)", 0);
        if ItemLedgerEntry.FindSet() then
            repeat
                ItemLedgerEntry."OBF-Quantity (Source UOM)" := ROUND(ItemLedgerEntry.Quantity / ItemLedgerEntry."Qty. per Unit of Measure", 0.00001);
                ItemLedgerEntry.Modify();
            until (ItemLedgerEntry.Next() = 0);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2208 - Mark Post Purch Inv 114946 as Exported to Coupa
    procedure MarkPurchaseInvoiceAsExportedToCoupa(InvoiceNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchInvHeader.Get(InvoiceNo) then begin
            PurchInvHeader."OBF-Coupa Updated Flag" := true;
            PurchInvHeader.Modify();
        end;
    end;

}