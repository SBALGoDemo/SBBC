// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
codeunit 50069 "OBF-ZD Capture Modifications"
{
    var
        InvalidCharacters: Label '-&#(),./''';
        ReplaceWithCharacters: Label '_________';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Zetadocs Customize", 'OnBeforeArchive', '', true, true)]
    procedure OnBeforeArchive(var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive")
    var
        RecRef: RecordRef;
        RecID: RecordId;
        Item: Record Item;
        ZDGeneralSettings: Record "Zetadocs General Settings";
        PurchSetup: Record "Purchases & Payables Setup";
        TableNo: Integer;
        ReportID: Integer;
        Folders: Text;
        FileName: Text;
        DocumentType: Text;
    begin
        onBeforeArchiveHandler.GetRecordId(RecId);
        RecRef.Get(RecID);
        TableNo := RecId.TableNo;
        ZDGeneralSettings.Get;
        PurchSetup.Get();

        // Change where to archive depending on the type of record
        case TableNo of
            27: // Item
                begin
                    if (Item.Get(RecId)) then begin
                        //onBeforeArchiveHandler.AddOrUpdateMetadata('Item_x0020_Description', Format(Item.Description));
                        SetItemArchiveMetadata(RecRef, onBeforeArchiveHandler);
                        Folders := SetItemArchiveLocation(RecRef);
                    end;
                end;
            18, 21: // Customer
                begin
                    Folders := SetCustomerArchiveLocation(RecRef, TableNo);
                end;

            23, 288: // Vendor
                begin
                    Folders := SetVendorArchiveLocation(RecRef, TableNo);
                end;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1539 - Enable Zetadocs Send Remittance Advice from Vendor Ledger Entries
            25: // Vendor Ledger Entries
                begin
                    if PurchSetup."OBF-Enable Zetadocs Metadata" then begin
                        onBeforeArchiveHandler.GetFileName(FileName);
                        SetVendorLedgerEntryArchiveMetadata(RecRef, onBeforeArchiveHandler);
                        Folders := SetVendorLedgerEntriesArchiveLocation(RecRef);
                    end;
                end;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1526 - Fix Zetadocs Folders for various documents 
            36, 110, 112, 114: // Sales Documents
                begin
                    onBeforeArchiveHandler.GetFileName(FileName);
                    SetSalesOrderArchiveMetadata(RecRef, onBeforeArchiveHandler);
                    Folders := SetSalesOrderArchiveLocation(RecRef, FileName);
                end;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1526 - Fix Zetadocs Folders for various documents 
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1520 - Enable Zetadocs Send for Purchasing Documents
            38, 120, 122, 124: // Purchase Documents
                begin
                    onBeforeArchiveHandler.GetFileName(FileName);
                    SetPurchaseOrderArchiveMetadata(RecRef, onBeforeArchiveHandler);
                    Folders := SetPurchaseOrderArchiveLocation(RecRef, FileName);
                end;

            // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
            1690, 1691: // Bank Deposits
                begin
                    Folders := SetBankDepositArchiveLocation(RecRef, TableNo);
                end;

            // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
            50600: // Journal2Zetadocs
                begin
                    if PurchSetup."OBF-Enable Zetadocs Metadata" then begin
                        onBeforeArchiveHandler.GetFileName(FileName);
                        SetJournaltoZetadocsArchiveMetadata(RecRef, onBeforeArchiveHandler);
                        Folders := SetJournaltoZetadocsArchiveLocation(RecRef, FileName);
                    end;
                end;

            // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
            17: // G/L Entries
                begin
                    Folders := SetGLEntriesArchiveLocation(RecRef);
                end;

        end;
        onBeforeArchiveHandler.SetSubFolders(Folders);
        onBeforeArchiveHandler.SetTargetLibrary(zdGeneralSettings."Target Library");
    end;

    local procedure SetItemArchiveMetadata(RecRef: RecordRef; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive");
    var
        Item: Record Item;
    begin
        InsertMetadataFromFieldNo('Item_x0020_Description', RecRef, Item.FieldNo(Description), onBeforeArchiveHandler);
    end;

    local procedure SetSalesOrderArchiveMetadata(RecRef: RecordRef; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive") ArchiveLocation: Text;
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if (RecRef.Number = 36) then
            if not (Format(RecRef.Field(SalesHeader.FieldNo("Document Type"))) in ['Order', 'Invoice']) then
                exit;

        case RecRef.Number of
            36:
                InsertMetadataFromFieldNo('Order_x0020_No_x002e_', RecRef, SalesHeader.FieldNo("No."), onBeforeArchiveHandler);
            112:
                InsertMetadataFromFieldNo('Order_x0020_No_x002e_', RecRef, SalesInvoiceHeader.FieldNo("Order No."), onBeforeArchiveHandler);
        end;

        InsertMetadataFromFieldNo('Document_x0020_Date', RecRef, SalesHeader.FieldNo("Document Date"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Salesperson_x0020_Code', RecRef, SalesHeader.FieldNo("Salesperson Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Location_x0020_Code', RecRef, SalesHeader.FieldNo("Location Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Country', RecRef, SalesHeader.FieldNo("Sell-to Country/Region Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('External_x0020_Document_x0020_No_x002e_', RecRef, SalesHeader.FieldNo("External Document No."), onBeforeArchiveHandler);
        if RecRef.Number in [36, 112] then
            InsertMetadataFromFieldNo('Shipping_x0020_Agent', RecRef, SalesHeader.FieldNo("Shipping Agent Code"), onBeforeArchiveHandler);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1529 - Enable searching Zetadocs by Vendor Invoice No.
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1526 - Fix Zetadocs Folders for various documents 
    local procedure SetPurchaseOrderArchiveMetadata(RecRef: RecordRef; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive");
    var
        PurchaseHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get();
        case RecRef.Number of
            38:
                begin // Purchase Order
                    InsertMetadataFromFieldNo('Order_x0020_No_x002e_', RecRef, PurchaseHeader.FieldNo("No."), onBeforeArchiveHandler);
                    if PurchSetup."OBF-Enable Zetadocs Metadata" then
                        InsertMetadataFromFieldNo('Vendor_x0020_Invoice_x0020_No_x002e_', RecRef, PurchaseHeader.FieldNo("Vendor Invoice No."), onBeforeArchiveHandler);
                end;
            120:
                begin // Purch. Rcpt. Header
                    InsertMetadataFromFieldNo('Order_x0020_No_x002e_', RecRef, PurchRcptHeader.FieldNo("Order No."), onBeforeArchiveHandler);
                end;
            122:
                begin  // Purch. Inv. Header
                    InsertMetadataFromFieldNo('Order_x0020_No_x002e_', RecRef, PurchInvHeader.FieldNo("Order No."), onBeforeArchiveHandler);
                    if PurchSetup."OBF-Enable Zetadocs Metadata" then
                        InsertMetadataFromFieldNo('Vendor_x0020_Invoice_x0020_No_x002e_', RecRef, PurchaseHeader.FieldNo("Vendor Invoice No."), onBeforeArchiveHandler);
                end;
        end;

        InsertMetadataFromFieldNo('Document_x0020_Date', RecRef, PurchaseHeader.FieldNo("Document Date"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Purchaser_x0020_Code', RecRef, PurchaseHeader.FieldNo("Purchaser Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Location_x0020_Code', RecRef, PurchaseHeader.FieldNo("Location Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Country', RecRef, PurchaseHeader.FieldNo("Buy-from Country/Region Code"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Expected_x0020_Receipt_x0020_Date', RecRef, PurchaseHeader.FieldNo("Expected Receipt Date"), onBeforeArchiveHandler);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1539 - Enable Zetadocs Send Remittance Advice from Vendor Ledger Entries
    local procedure SetJournaltoZetadocsArchiveMetadata(RecRef: RecordRef; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive");
    var
    // JournaltoZetadocs: Record JournaltoZetadocs;
    // GenJournalLine: Record "Gen. Journal Line";
    // RecRefForGenJournalLine: RecordRef;
    // RecID: RecordId;
    begin
        // JournaltoZetadocs.Get(RecRef.RecordId);
        // if GenJournalLine.get(JournaltoZetadocs."Journal Template Name",JournaltoZetadocs."Journal Batch Name",JournaltoZetadocs."Line No.") then begin 
        //     RecID := GenJournalLine.RecordId;
        //     RecRefForGenJournalLine.Get(RecID);
        //     if ( GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor ) then begin 
        //         //InsertMetadataFromFieldNo('Document_x0020_No_x002e_', RecRefForGenJournalLine, GenJournalLine.FieldNo("Document No."), onBeforeArchiveHandler);
        //         InsertMetadataFromFieldNo('Vendor_x0020_No_x002e_', RecRefForGenJournalLine, GenJournalLine.FieldNo("Account No."), onBeforeArchiveHandler);
        //         InsertMetadataFromFieldNo('Document_x0020_Date', RecRefForGenJournalLine, GenJournalLine.FieldNo("Document Date"), onBeforeArchiveHandler);
        //     end;
        // end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1539 - Enable Zetadocs Send Remittance Advice from Vendor Ledger Entries
    local procedure SetVendorLedgerEntryArchiveMetadata(RecRef: RecordRef; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive");
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        InsertMetadataFromFieldNo('Vendor_x0020_No', RecRef, VendorLedgerEntry.FieldNo("Vendor No."), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Document_x0020_Date', RecRef, VendorLedgerEntry.FieldNo("Document Date"), onBeforeArchiveHandler);
        InsertMetadataFromFieldNo('Purchaser_x0020_Code', RecRef, VendorLedgerEntry.FieldNo("Purchaser Code"), onBeforeArchiveHandler);
    end;


    local procedure InsertMetadataFromFieldNo(MetadataName: Text; RecRef: RecordRef; FieldNo: Integer; var onBeforeArchiveHandler: Codeunit "Zetadocs OnBeforeArchive");
    var
        fRef: FieldRef;
    begin
        fRef := RecRef.Field(FieldNo);
        onBeforeArchiveHandler.AddOrUpdateMetadata(MetadataName, Format(fRef.Value));
    end;


    local procedure SetVendorArchiveLocation(RecRef: RecordRef; TableNo: Integer) ArchiveLocation: Text;
    var
        TopLevelVendorArchiveLocation: Text;
    begin
        TopLevelVendorArchiveLocation := SetTopLevelVendorArchiveLocation(RecRef, TableNo);
        ArchiveLocation := TopLevelVendorArchiveLocation + Format(WORKDATE, 0, '<Year4>');
    end;

    // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
    procedure SetTopLevelVendorArchiveLocation(RecRef: RecordRef; TableNo: Integer) TopLevelArchiveLocation: Text;
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        fRef: FieldRef;
        VendorNo: Code[20];
        VendorName: Text[100];
        VendorBankAccountCode: Code[20];
    begin
        fRef := RecRef.Field(Vendor.FieldNo("No."));
        VendorNo := fRef.Value;
        if Vendor.Get(VendorNo) then
            VendorName := ConvertStr(Vendor.Name, InvalidCharacters, ReplaceWithCharacters)
        else
            VendorName := VendorNo;
        TrimLeadingAndTrailingSpaces(VendorName);
        TopLevelArchiveLocation := 'Vendors/' + VendorName;

        case TableNo of
            23:
                TopLevelArchiveLocation := TopLevelArchiveLocation + '/Vendor Documents/';
            288:
                begin
                    fRef := RecRef.Field(VendorBankAccount.FieldNo(Code));
                    VendorBankAccountCode := fRef.Value;
                    TopLevelArchiveLocation := TopLevelArchiveLocation + '/Vendor Bank Accounts/' + VendorBankAccountCode + '/';
                end;
        end;

    end;

    // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
    procedure SetCustomerArchiveLocation(RecRef: RecordRef; TableNo: Integer) TopLevelArchiveLocation: Text;
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        fRef: FieldRef;
        CustomerName: Text[100];
        DocumentType: Text[50];
        DocumentNo: Text[20];
    begin
        case TableNo of
            18:
                fRef := RecRef.Field(Customer.FieldNo(Name));
            21:
                begin
                    fRef := RecRef.Field(CustLedgerEntry.FieldNo("Customer Name"));
                    CustLedgerEntry.Get(RecRef.RecordId);
                    DocumentType := Format(CustLedgerEntry."Document Type");
                    if DocumentType = ' ' then
                        DocumentType := 'Journal Entry';
                    DocumentNo := CustLedgerEntry."Document No.";
                    DocumentNo := ConvertStr(DocumentNo, InvalidCharacters, ReplaceWithCharacters);
                    TrimLeadingAndTrailingSpaces(DocumentNo);
                end;
        end;
        CustomerName := fRef.Value;
        CustomerName := ConvertStr(CustomerName, InvalidCharacters, ReplaceWithCharacters);
        TrimLeadingAndTrailingSpaces(CustomerName);
        case TableNo of
            18:
                TopLevelArchiveLocation := 'Customers/' + CustomerName + '/Customer Documents/' + Format(WORKDATE, 0, '<Year4>');
            21:
                TopLevelArchiveLocation := 'Customers/' + CustomerName + '/' + DocumentType + '/' + DocumentNo + '/';
        end;
    end;

    local procedure SetItemArchiveLocation(RecRef: RecordRef) ArchiveLocation: Text;
    var
        ItemNo: Code[20];
        LotNo: Code[20];
        TopLevelItemArchiveLocation: Text;
        TypeOfDocument: Text[100];
        OrdinalTypeOfDocument: Integer;
        ZDAddItemDocType: Page "OBF-ZD Add Item Doc. Type";
        Item: Record Item;
        RecID: RecordId;
        Folders: Text;
        fRef: FieldRef;
    begin
        fRef := RecRef.Field(Item.FieldNo("No."));
        ItemNo := fRef.Value;
        Item.Get(ItemNo);
        TopLevelItemArchiveLocation := SetTopLevelItemArchiveLocation(RecRef, ItemNo);

        ZDAddItemDocType.AddTitleInfo(Format(RecId) + ' Item No.: ' + Format(Item.Description));
        ZDAddItemDocType.RunModal();
        TypeOfDocument := ZDAddItemDocType.GetAddText();
        OrdinalTypeOfDocument := ZDAddItemDocType.GetOrdinalValue();

        // if OrdinalTypeOfDocument in [2, 3, 4] then
        //     GetLotNoFromList(ItemNo, LotNo);

        ArchiveLocation := TopLevelItemArchiveLocation + TypeOfDocument;
        if LotNo <> '' then
            ArchiveLocation += '/Lots/' + LotNo;
    end;

    procedure SetTopLevelItemArchiveLocation(RecRef: RecordRef; var ItemNo: Code[20]) TopLevelArchiveLocation: Text;
    var
        fRef: FieldRef;
        Item: Record Item;
        ItemCategoryRec: Record "Item Category";
        ItemParentCategoryRec: Record "Item Category";
        ItemCategory: Text[100];
        ItemSubcategory: Text[100];
        ItemCatCode: Code[20];
        LotNo: Code[20];
        ItemDesc: Text[100];
    begin
        fRef := RecRef.Field(Item.FieldNo("No."));
        ItemNo := fRef.Value;

        fRef := RecRef.Field(Item.FieldNo("Item Category Code"));
        ItemCatCode := fRef.Value;
        ItemCategory := ItemCatCode;
        ItemSubcategory := 'None';
        if ItemCatCode = '' then
            ItemCategory := 'None'
        else
            if ItemCategoryRec.Get(ItemCatCode) then begin
                ItemCategoryRec.TESTField(Description);
                if ItemCategoryRec."Parent Category" = '' then
                    ItemCategory := ItemCategoryRec.Description
                else begin
                    ItemSubcategory := ItemCategoryRec.Description;
                    if ItemParentCategoryRec.Get(ItemCategoryRec."Parent Category") then
                        ItemParentCategoryRec.TESTField(Description);
                    ItemCategory := ItemParentCategoryRec.Description;
                end;
            end;

        ItemCategory := ConvertStr(ItemCategory, '/', '_');
        ItemSubcategory := ConvertStr(ItemSubcategory, '/', '_');

        TopLevelArchiveLocation := 'Items/' + ItemCategory + '/' + ItemSubcategory + '/' + ItemNo + '/';
    end;

    procedure SetSalesOrderArchiveLocation(RecRef: RecordRef; FileName: Text) ArchiveLocation: Text;
    var
        fRef: FieldRef;
        SalesHeader: Record "Sales Header";
        ZDAddSalesDocType: page "OBF-ZD Add Sales Doc. Type";
        TypeOfDocument: Text[100];
        TopLevelSOArchiveLocation: Text;
        SellToCustomerName: Text;
        FileName2: Text;
    begin
        TopLevelSOArchiveLocation := SetTopLevelSalesOrderArchiveLocation(RecRef);
        if not GuiAllowed then begin
            FileName2 := CopyStr(FileName, 1, 2);
            case FileName2 of
                'CO':
                    TypeOfDocument := 'Order Confirmation';
                'SH', 'RE':
                    TypeOfDocument := 'Shipment Document';
                'SI':
                    TypeOfDocument := 'Invoice';
                'SC':
                    TypeOfDocument := 'Credit Memo';
                else
                    TypeOfDocument := 'Other';
            end;
        end else begin
            fRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer Name"));
            SellToCustomerName := fRef.Value;
            ZDAddSalesDocType.AddTitleInfo(Format(RecRef.RecordId) + ' Customer ' + SellToCustomerName);
            ZDAddSalesDocType.RunModal();
            TypeOfDocument := ZDAddSalesDocType.GetAddText;
        end;

        ArchiveLocation := TopLevelSOArchiveLocation + TypeOfDocument;
    end;

    procedure SetTopLevelSalesOrderArchiveLocation(RecRef: RecordRef) TopLevelArchiveLocation: Text;
    var
        RecID: RecordID;
        fRef: FieldRef;
        CustomerName: Text[100];
        DocumentNo: Code[20];
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        RecID := RecRef.RecordId;

        fRef := RecRef.Field(SalesHeader.FieldNo("Sell-to Customer Name"));
        CustomerName := fRef.Value;
        CustomerName := ConvertStr(CustomerName, InvalidCharacters, ReplaceWithCharacters);
        TrimLeadingAndTrailingSpaces(CustomerName);

        case RecID.TableNo of
            36:
                fRef := RecRef.Field(SalesHeader.FieldNo("No."));
            110, 112:
                fRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Order No."));
            114:
                fRef := RecRef.Field(SalesCrMemoHeader.FieldNo("No."));
        end;
        DocumentNo := fRef.Value;

        if DocumentNo = '' then begin
            fRef := RecRef.Field(SalesInvoiceHeader.FieldNo("No."));
            DocumentNo := Format(fRef.Value);
        end;

        TopLevelArchiveLocation := 'Customers/' + CustomerName + '/SO Folders/' + DocumentNo + '/';
    end;

    procedure SetPurchaseOrderArchiveLocation(RecRef: RecordRef; FileName: Text) ArchiveLocation: Text;
    var
        fRef: FieldRef;
        PurchaseHeader: Record "Purchase Header";
        ZDAddPurchaseDocType: page "OBF-ZD Add Purchase Doc. Type";
        TypeOfDocument: Text[100];
        TopLevelPOArchiveLocation: Text;
        BuyFromVendorName: Text;
        FileName2: Text;
    begin
        TopLevelPOArchiveLocation := SetTopLevelPurchaseOrderArchiveLocation(RecRef);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1520 - Enable Zetadocs Send for Purchasing Documents
        if not GuiAllowed then begin
            FileName2 := CopyStr(FileName, 1, 2);
            case FileName2 of
                'PO', 'PA', 'SB':
                    TypeOfDocument := 'Order Confirmation';
                'PP':
                    TypeOfDocument := 'Receipt';
                'PI':
                    TypeOfDocument := 'Invoice';
                'PC':
                    TypeOfDocument := 'Credit Memo';
                else
                    TypeOfDocument := 'Other';
            end;
        end else begin

            fRef := RecRef.Field(PurchaseHeader.FieldNo("Buy-from Vendor Name"));
            BuyFromVendorName := fRef.Value;
            ZDAddPurchaseDocType.AddTitleInfo(Format(RecRef.RecordId) + ' Vendor ' + BuyFromVendorName);
            ZDAddPurchaseDocType.RunModal();
            TypeOfDocument := ZDAddPurchaseDocType.GetAddText;
        end;
        ArchiveLocation := TopLevelPOArchiveLocation + TypeOfDocument;
    end;


    // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
    procedure SetBankDepositArchiveLocation(RecRef: RecordRef; TableNo: Integer) ArchiveLocation: Text;
    var
        BankDepositHeader: Record "Bank Deposit Header";
        PostedBankDepositHeader: Record "Posted Bank Deposit Header";
        BankDepositLine: Record "Gen. Journal Line";
        PostedBankDepositLine: Record "Posted Bank Deposit Line";
        Customer: Record Customer;
        CustomerName: Text[100];
        DepositNo: Code[20];
    begin
        CustomerName := '';
        DepositNo := '';
        case TableNo of
            1690:
                Begin
                    BankDepositHeader.Get(RecRef.RecordId);
                    DepositNo := BankDepositHeader."No.";
                    BankDepositLine.SetRange("Journal Template Name", 'BNKDEPOSIT');
                    BankDepositLine.SetRange("Journal Batch Name", 'BNKDEPOSIT');
                    BankDepositLine.SetRange("Account Type", BankDepositLine."Account Type"::Customer);
                    if BankDepositLine.Count = 1 then begin
                        BankDepositLine.FindFirst();
                        if Customer.Get(BankDepositLine."Account No.") then
                            CustomerName := Customer.Name;
                    end;
                End;

            1691:
                Begin
                    PostedBankDepositHeader.Get(RecRef.RecordId);
                    DepositNo := PostedBankDepositHeader."No.";
                    PostedBankDepositLine.SetRange("Bank Deposit No.", PostedBankDepositHeader."No.");
                    PostedBankDepositLine.SetRange("Account Type", PostedBankDepositLine."Account Type"::Customer);
                    if PostedBankDepositLine.Count = 1 then begin
                        PostedBankDepositLine.FindFirst();
                        if Customer.Get(PostedBankDepositLine."Account No.") then
                            CustomerName := Customer.Name;
                    end;
                End;
        end;

        if CustomerName <> '' then begin
            CustomerName := ConvertStr(CustomerName, InvalidCharacters, ReplaceWithCharacters);
            TrimLeadingAndTrailingSpaces(CustomerName);
            ArchiveLocation := 'Customers/' + CustomerName + '/Bank Deposits/' + DepositNo + '/';
        end else
            ArchiveLocation := 'Bank Deposits/' + Format(WORKDATE, 0, '<Year4>') + '/' + DepositNo + '/';

    end;

    // https:// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1993 - Add Custom Sharepoint Folders code for Zetadocs Journals
    procedure SetJournaltoZetadocsArchiveLocation(RecRef: RecordRef; FileName: Text) ArchiveLocation: Text;
    begin
        ArchiveLocation := SetTopLevelJournaltoZetadocsArchiveLocation(RecRef);
    end;

    procedure SetTopLevelJournaltoZetadocsArchiveLocation(RecRef: RecordRef) TopLevelArchiveLocation: Text;
    var
    // JournaltoZetadocs: Record JournaltoZetadocs;
    // GenJournalLine: Record "Gen. Journal Line";
    // Vendor: Record Vendor;
    // Customer: Record Customer;
    // RecID: RecordID;
    // fRef: FieldRef;
    // VendorName: Text[100];
    // CustomerName: Text[100];
    // DocumentType: Code[20];
    // DocumentNo: Code[20];
    begin
        // CustomerName := '';
        // VendorName := '';
        // DocumentType := '';
        // JournaltoZetadocs.Get(RecRef.RecordId);
        // DocumentNo := JournaltoZetadocs."Document No.";
        // GenJournalLine.SetRange("Journal Template Name",JournaltoZetadocs."Journal Template Name");
        // GenJournalLine.SetRange("Journal Batch Name",JournaltoZetadocs."Journal Batch Name");
        // GenJournalLine.SetRange("Document No.",JournaltoZetadocs."Document No.");
        // GenJournalLine.SetRange("Posting Date",JournaltoZetadocs."Posting Date");
        // GenJournalLine.SetFilter("Account Type",'%1|%2',GenJournalLine."Account Type"::Customer,GenJournalLine."Account Type"::Vendor);
        // if GenJournalLine.Count = 1 then begin 
        //     GenJournalLine.FindFirst();
        //     DocumentType := Format(GenJournalLine."Document Type");
        //     if ( GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor ) and Vendor.get(GenJournalLine."Account No.") then 
        //         VendorName := Vendor.Name
        //     else if ( GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer ) and Customer.get(GenJournalLine."Account No.") then
        //         CustomerName := Customer.Name;
        // end;

        // if ( VendorName = '' ) and ( CustomerName = '' ) then begin
        //     GenJournalLine.SetRange("Account Type");
        //     GenJournalLine.SetFilter("Bal. Account Type",'%1|%2',GenJournalLine."Bal. Account Type"::Customer,GenJournalLine."Bal. Account Type"::Vendor);
        //     if GenJournalLine.Count = 1 then begin 
        //         GenJournalLine.FindFirst();
        //         DocumentType := Format(GenJournalLine."Document Type");
        //         if ( GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor ) and Vendor.get(GenJournalLine."Bal. Account No.") then 
        //             VendorName := Vendor.Name
        //         else if ( GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Customer ) and Customer.get(GenJournalLine."Bal. Account No.") then
        //             CustomerName := Customer.Name;
        //     end;
        // end;

        // if DocumentType = '' then
        //     DocumentType := JournaltoZetadocs."Journal Template Name";

        // if VendorName <> '' then begin 
        //     VendorName := ConvertStr(VendorName, InvalidCharacters, ReplaceWithCharacters);
        //     TrimLeadingAndTrailingSpaces(VendorName);
        //     TopLevelArchiveLocation := 'Vendors/' + VendorName + '/' + DocumentType + '/' + DocumentNo + '/';
        // end;

        // if CustomerName <> '' then begin 
        //     CustomerName := ConvertStr(CustomerName, InvalidCharacters, ReplaceWithCharacters);
        //     TrimLeadingAndTrailingSpaces(CustomerName);
        //     TopLevelArchiveLocation := 'Customers/' + CustomerName + '/' + DocumentType + '/' + DocumentNo + '/';
        // end;

        // if ( VendorName = '' ) and ( CustomerName = '' ) then begin 
        //     TopLevelArchiveLocation := 'Journals/' + DocumentType + '/' + JournaltoZetadocs."Journal Template Name" + '/'+JournaltoZetadocs."Journal Batch Name" + '/' 
        //         + Format(WORKDATE, 0, '<Year4>') + '/' + JournaltoZetadocs."Document No.";
        // end;


    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1539 - Enable Zetadocs Send Remittance Advice from Vendor Ledger Entries
    procedure SetVendorLedgerEntriesArchiveLocation(RecRef: RecordRef) TopLevelArchiveLocation: Text;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        RecID: RecordID;
        fRef: FieldRef;
        VendorNo: Code[20];
        VendorName: Text[100];
        DocumentNo: Code[20];
        DocumentType: Enum "Gen. Journal Document Type";
        DocumentTypeDesc: Text[100];
    begin
        RecID := RecRef.RecordId;
        fRef := RecRef.Field(VendorLedgerEntry.FieldNo("Vendor No."));
        VendorNo := fRef.Value;
        if Vendor.Get(VendorNo) then begin
            VendorName := Vendor.Name;
            VendorName := ConvertStr(VendorName, InvalidCharacters, ReplaceWithCharacters);
            TrimLeadingAndTrailingSpaces(VendorName);

            fRef := RecRef.Field(VendorLedgerEntry.FieldNo("Document No."));
            DocumentNo := fRef.Value;

            fRef := RecRef.Field(VendorLedgerEntry.FieldNo("Document Type"));
            DocumentType := fRef.Value;
            DocumentTypeDesc := format(DocumentType);

            TopLevelArchiveLocation := 'Vendors/' + VendorName + '/' + DocumentTypeDesc + '/' + DocumentNo + '/';
        end;

    end;

    procedure SetGLEntriesArchiveLocation(RecRef: RecordRef) TopLevelArchiveLocation: Text;
    var
        GLEntry: Record "G/L Entry";
        Vendor: Record Vendor;
        Customer: Record Customer;
        RecID: RecordID;
        fRef: FieldRef;
        VendorName: Text[100];
        CustomerName: Text[100];
        DocumentType: Code[20];
        DocumentNo: Code[20];
    begin
        CustomerName := '';
        VendorName := '';
        DocumentType := '';
        GLEntry.Get(RecRef.RecordId);
        DocumentNo := GLEntry."Document No.";

        DocumentType := Format(GLEntry."Document Type");
        if (GLEntry."Source Type" = GLEntry."Source Type"::Vendor) and Vendor.get(GLEntry."Source No.") then
            VendorName := Vendor.Name
        else if (GLEntry."Source Type" = GLEntry."Source Type"::Customer) and Customer.get(GLEntry."Source No.") then
            CustomerName := Customer.Name;



        // if DocumentType = '' then
        //     if GLEntry."Journal Templ. Name" <> '' then
        //         DocumentType := GLEntry."Journal Template Name"
        //     else
        //         DocumentType := 'GLEntry';

        if VendorName <> '' then begin
            VendorName := ConvertStr(VendorName, InvalidCharacters, ReplaceWithCharacters);
            TrimLeadingAndTrailingSpaces(VendorName);
            TopLevelArchiveLocation := 'Vendors/' + VendorName + '/' + DocumentType + '/' + DocumentNo + '/';
        end;

        if CustomerName <> '' then begin
            CustomerName := ConvertStr(CustomerName, InvalidCharacters, ReplaceWithCharacters);
            TrimLeadingAndTrailingSpaces(CustomerName);
            TopLevelArchiveLocation := 'Customers/' + CustomerName + '/' + DocumentType + '/' + DocumentNo + '/';
        end;

        // if ( VendorName = '' ) and ( CustomerName = '' ) then begin 
        //     TopLevelArchiveLocation := 'Journals/' + DocumentType + '/' + GLEntry."Journal Template Name" + '/'+GLEntry."Journal Batch Name" + '/' 
        //         + Format(WORKDATE, 0, '<Year4>') + '/' + GLEntry."Document No.";
        // end;


    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1526 - Fix Zetadocs Folders for various documents 
    procedure SetTopLevelPurchaseOrderArchiveLocation(RecRef: RecordRef) TopLevelArchiveLocation: Text;
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        RecID: RecordID;
        fRef: FieldRef;
        VendorName: Text[100];
        PONum: Code[20];
    begin
        RecID := RecRef.RecordId;
        fRef := RecRef.Field(PurchaseHeader.FieldNo("Buy-from Vendor Name")); //name
        VendorName := fRef.Value;
        VendorName := ConvertStr(VendorName, InvalidCharacters, ReplaceWithCharacters);
        TrimLeadingAndTrailingSpaces(VendorName);

        //PO Num
        case RecID.TableNo of
            38:
                fRef := RecRef.Field(PurchaseHeader.FieldNo("No.")); // Purchase Header
            120, 122:
                fRef := RecRef.Field(PurchInvHeader.FieldNo("Order No.")); // Purch. Rcpt. Header; Purch. Inv. Header
            124:
                fRef := RecRef.Field(PurchCrMemoHeader.FieldNo("No.")); // Purch. Cr. Memo Hdr.
        end;

        PONum := fRef.Value;

        if PONum = '' then begin
            fRef := RecRef.Field(PurchInvHeader.FieldNo("No."));
            PONum := Format(fRef.Value);
        end;

        TopLevelArchiveLocation := 'Vendors/' + VendorName + '/PO Folders/' + PONum + '/';
    end;

    local procedure TrimLeadingAndTrailingSpaces(var StringToTrim: Text);
    begin
        StringToTrim := DELCHR(StringToTrim, '<>', '  ');
    end;

    // local procedure GetLotNoFromList(ItemNo: Code[20]; var LotNo: Code[20]);
    // var
    //     LotNoLookup: Page "OBF-Lot No. Lookup";
    //     ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
    // begin

    //     // https://odydev.visualstudio.com/ThePlan/_workitems/edit/910 - Zetadocs Lot No. Lookup doesn't show lots on purchase orders that haven't been received
    //     LotNoLookup.SetPageData(ItemNo);

    //     LotNoLookup.LookupMode(true);
    //     if LotNoLookup.RunModal = ACTION::LookupOK then begin
    //         LotNoLookup.GetRecord(ItemVariantLotInfo);
    //         LotNo := ItemVariantLotInfo."Lot No.";
    //     end else
    //         LotNo := '';
    // end;


    procedure SetOutputFileBasedOnSalesOrderReport(TableID: Integer; "Record": RecordID; ReportID: Integer): Text;
    var
        fieldRefDocType: FieldRef;
        fieldRefDocNo: FieldRef;
        fieldRefExtDocNo: FieldRef;
        RecRef: RecordRef;
        DocumentNo: Code[20];
        strSales: Label 'Sales';
        strConfirmation: Label 'CONF';
        strShippingRelease: Label 'REL';
        ExtDocumentNo: Code[35];
        InvalidFilenameCharacters: Label '" <>:/\|?*&''"';
    begin
        RecRef.Get(Record);
        fieldRefDocNo := RecRef.Field(3);
        fieldRefExtDocNo := RecRef.Field(100);

        if TableID = 36 then
            fieldRefDocType := RecRef.Field(1);

        DocumentNo := fieldRefDocNo.Value;
        ExtDocumentNo := fieldRefExtDocNo.Value;
        ExtDocumentNo := DelChr(ExtDocumentNo, '=', InvalidFilenameCharacters);  // https://docs.microsoft.com/en-us/dynamics-nav/delchr-function--code--text-

        case ReportID of
            50070:
                exit(StrSubstNo('%1-%2', strShippingRelease, CopyStr(DocumentNo, 3, 6)));
            50053:
                begin
                    if ExtDocumentNo <> '' then
                        exit(StrSubstNo('%1-%2-PO_%3', strConfirmation, CopyStr(DocumentNo, 3, 6), ExtDocumentNo))
                    else
                        exit(StrSubstNo('%1-%2', strConfirmation, CopyStr(DocumentNo, 3, 6)));
                end;
            50055, 23019013:
                exit(DocumentNo); // Posted Sales Invoice, Posted Credit Memo
            else
                exit(StrSubstNo('%1-%2 %3', strSales, Format(fieldRefDocType), DocumentNo));
        end;
    end;
}