// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
codeunit 50000 "OBF-Rebate Management"
{
    Permissions = tabledata "OBF-Rebate Entry" = rimd, tabledata "OBF-Rebate Ledger Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        TempRebateHeader: Record "OBF-Rebate Header" temporary;
        SalesSetup: Record "Sales & Receivables Setup";

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure HandleDeleteOnSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        DeleteRebateEntriesOnSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure HandleDeleteOnSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        DeleteRebateEntriesOnSalesLine(Rec);
    end;

    procedure PostCustomerRebates(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        PostCustomerEntry(SalesInvHdrNo, SalesCrMemoHdrNo);
        DeleteRebateEntriesOnSalesHeader(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure HandleAfterSalesInvLineInsertOnSalesPost(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary)
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        CreateRebateLedgerEntriesFromInvoice(SalesLine, SalesInvLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesCrMemoLineInsert', '', false, false)]
    local procedure HandleAfterSalesCrMemoLineInsertOnSalesPost(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary; CommitIsSuppressed: Boolean)
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        CreateRebateLedgerEntriesFromCrMemo(SalesLine, SalesCrMemoLine);
    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', false, false)]
    local procedure HandleAfterInitGLEntryOnGenJnlPostLine(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        SetRebateOnGLEntry(GLEntry, GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure HandleAfterInitCustLedgEntryOnGenJnlPostLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        SalesSetup.Get();
        if SalesSetup."OBF-Disable Rebates" then
            exit;

        SetRebateOnCustLedgEntry(CustLedgerEntry, GenJournalLine);
    end;

    local procedure SetRebateOnGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."OBF-Rebate Ledger Entry No." := GenJournalLine."OBF-Rebate Ledger Entry No.";
        GLEntry."OBF-Rebate Code" := GenJournalLine."OBF-Rebate Code";
    end;

    local procedure SetRebateOnCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."OBF-Rebate Ledger Entry No." := GenJournalLine."OBF-Rebate Ledger Entry No.";
        CustLedgerEntry."OBF-Rebate Code" := GenJournalLine."OBF-Rebate Code";
    end;

    // GetRebates creates rebate entries for all of the Rebate Lines that apply to a given Sales Line based on the Customer and Item
    procedure GetRebates(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        RebateLine: Record "OBF-Rebate Line";
        Customer: Record Customer;
        Item: Record Item;
        RebateEntry: Record "OBF-Rebate Entry";
        NextEntryNo: Integer;
        OffInvoiceUnitRate: Text[50];
    begin
        if SalesHeader."Sell-to Customer No." = '' then
            exit;

        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) and
           (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) and
           (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo") then
            exit;

        DeleteRebateEntriesOnSalesHeader(SalesHeader);
        if SalesHeader."OBF-Bypass Rebate Calculation" then
            exit;

        GetRebatesForCustomer(SalesHeader);

        // Rule 1 - If there is a Rebate Value on a Rebate Line with Source = Customer and the “Ship-to Address Code” is blank on the 
        //          Rebate Line, then a Rebate Ledger Entry will be created for every Sales Line associated with that customer.  This 
        //          Rebate Entry will use the Rebate Value from the Rebate Line with Source = Item and Source Value = the Sales Line 
        //          Item No. if it exists.  Otherwise, the Rebate Entry will use the Rebate Value from the Rebate Line with 
        //          Source = Customer.
        // Rule 2 - If there is a Rebate Value on a Rebate Line with Source = Customer and a non-blank Ship-to Address Code value, then 
        //          a Rebate Ledger Entry will be created for every Sales Line associated with that customer and Ship-to Address. 
        // Rule 3 - The Unit of Measure Code on the Rebate Header only applies to Rebates with Calculation Basis = Dollar per Unit.  
        //          For example, if the Unit of Measure Code on the Rebate is LB and the sales line is for Cases, the Rebate Amount 
        //          will be equal to the Quantity on the Sales Line in Cases * the # of LBS per Case.  
        // Rule 4 –Rebates with Calculation Basis = Dollar per Unit will only apply to Sales Lines with Type = Item.  In addition, 
        //          the rebate will only apply to items that have an Item Unit of Measure defined for the Unit of Measure Code 
        //          associated with the Rebate.  
        // Rule 5 - If there is a Rebate Value on a Rebate Line with Source = Item, then a Rebate Ledger Entry will be created for 
        //          every Sales Line for the specified Item No as long as there is also a Rebate Line with Source = Customer for the 
        //          Customer (and Ship-to Address, if specified) for the given Rebate Code.
        // Rule 6 - If there is a Rebate Value on both Customer and Item Lines in the Rebate Subform, the rebate on the Customer Line 
        //          will apply to all items except for items that are listed in the Rebate Subform.  

        if TempRebateHeader.IsEmpty then
            exit;

        RebateEntry.Reset();
        if RebateEntry.FindLast() then
            NextEntryNo := RebateEntry."Entry No." + 1
        else
            NextEntryNo := 1;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Quantity, '<>0');
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.IsEmpty then
            exit;

        SalesLine.FindSet();
        repeat
            TempRebateHeader.FindSet();
            repeat
                Clear(RebateLine);
                if (SalesLine.Type = SalesLine.Type::Item) then begin
                    RebateLine.Reset();
                    RebateLine.SetRange("Rebate Code", TempRebateHeader.Code);
                    RebateLine.SetRange(Source, RebateLine.Source::Item);
                    RebateLine.SetRange(Value, SalesLine."No.");
                    if not RebateLine.FindFirst() then
                        Clear(RebateLine);
                end;
                AddOrUpdateRebateEntry(TempRebateHeader, RebateLine, SalesLine, NextEntryNo);
            until (TempRebateHeader.Next() = 0);
            SalesLine.CalcFields("OBF-Off Invoice Rebate Amount");
            OffInvoiceUnitRate := CalculateOffInvoicePerLb(SalesLine."OBF-Off Invoice Rebate Amount", SalesLine."OBF-Line Net Weight");
            if SalesLine."OBF-Off-Inv. Rebate Unit Rate" <> OffInvoiceUnitRate then begin
                SalesLine."OBF-Off-Inv. Rebate Unit Rate" := OffInvoiceUnitRate;
                SalesLine.Modify();
            end
        until (SalesLine.Next() = 0);

    end;

    // GetRebatesForCustomer finds all of the rebates that apply to the  customer, ship-to address and order date for the current order
    // Note 1: The rebates that a customer is eligible for are added to the TempRebateHeader table.
    // Note 2: There should only be one TempRebateHeader record for each Rebate Code.  
    // Note 3: If there are separate Rebate Lines for the Customer with blank Ship-to Address and the Customer and Ship-to Address, the
    //              Rebate Line with the non-blank Ship-to Address takes precedence.
    local procedure GetRebatesForCustomer(SalesHeader: Record "Sales Header")
    var
        RebateHeader: Record "OBF-Rebate Header";
        RebateLine: Record "OBF-Rebate Line";
    begin
        TempRebateHeader.DeleteAll();

        // All Customers
        RebateHeader.SetRange("Customer Rebate Line Exists", false);
        RebateHeader.SetFilter("Start Date", '%1|<=%2', 0D, SalesHeader."Order Date");
        RebateHeader.SetFilter("End Date", '%1|>=%2', 0D, SalesHeader."Order Date");
        if RebateHeader.FindSet() then
            repeat
                TempRebateHeader := RebateHeader;
                TempRebateHeader."Temp Ship-to Code" := '';
                TempRebateHeader."Temp Customer Rebate Value" := 0;
                TempRebateHeader."Temp Rebate Line No." := 0;
                TempRebateHeader.Insert();
            until (RebateHeader.Next() = 0);

        //Customer
        RebateLine.SetRange(Source, RebateLine.Source::Customer);
        RebateLine.SetRange(Value, SalesHeader."Sell-to Customer No.");
        if SalesHeader."Ship-to Code" <> '' then
            RebateLine.SetFilter("Ship-to Address Code", '%1|%2', SalesHeader."Ship-to Code", '')
        else
            RebateLine.SetFilter("Ship-to Address Code", '%1', '');
        if RebateLine.Findset() then
            repeat
                RebateHeader.Get(RebateLine."Rebate Code");
                if (RebateHeader."Start Date" <= SalesHeader."Order Date") or
                   (RebateHeader."Start Date" = 0D) then
                    if (RebateHeader."End Date" >= SalesHeader."Order Date") or
                       (RebateHeader."End Date" = 0D) then begin
                        TempRebateHeader.SetRange(Code, RebateHeader.Code);
                        if TempRebateHeader.FindFirst() then begin
                            if RebateLine."Ship-to Address Code" <> '' then begin  // See Note 3 above
                                TempRebateHeader."Temp Ship-to Code" := RebateLine."Ship-to Address Code";
                                TempRebateHeader."Temp Customer Rebate Value" := RebateLine."Rebate Value";
                                TempRebateHeader."Temp Rebate Line No." := RebateLine."Line No.";
                                TempRebateHeader.Modify();
                            end;
                        end else begin
                            TempRebateHeader := RebateHeader;
                            TempRebateHeader."Temp Ship-to Code" := RebateLine."Ship-to Address Code";
                            TempRebateHeader."Temp Customer Rebate Value" := RebateLine."Rebate Value";
                            TempRebateHeader."Temp Rebate Line No." := RebateLine."Line No.";
                            TempRebateHeader.Insert();
                        end;
                        TempRebateHeader.Reset();
                    end;
            until RebateLine.Next() = 0;
    end;

    procedure AddOrUpdateRebateEntry(pRebateHeader: record "OBF-Rebate Header"; pRebateLine: Record "OBF-Rebate Line"; pSalesLine: Record "Sales Line"; var NextEntryNo: Integer)
    var
        RebateEntry: Record "OBF-Rebate Entry";
        OldRebateEntry: Record "OBF-Rebate Entry";
        RebateValue: Decimal;
        RebateLineNo: Integer;
    begin

        if pSalesLine."Line No." = 0 then
            exit;

        if pRebateLine."Line No." = 0 then begin
            RebateValue := pRebateHeader."Temp Customer Rebate Value";
            RebateLineNo := pRebateHeader."Temp Rebate Line No.";
        end else begin
            RebateValue := pRebateLine."Rebate Value";
            RebateLineNo := pRebateLine."Line No.";
        end;

        if RebateValue = 0 then
            exit;

        if (pRebateHeader."Temp Ship-to Code" <> '') then begin
            pSalesLine.CalcFields("OBF-Ship-to Code");
            if pSalesLine."OBF-Ship-to Code" <> pRebateHeader."Temp Ship-to Code" then
                exit;
        end;

        OldRebateEntry.SetRange("Source Type", pSalesLine."Document Type".AsInteger());
        OldRebateEntry.SetRange("Source No.", pSalesLine."Document No.");
        OldRebateEntry.SetRange("Source Line No.", pSalesLine."Line No.");
        if pRebateLine."Rebate Code" = '' then begin
            OldRebateEntry.SetRange("Rebate Code", pRebateHeader.Code);
            OldRebateEntry.SetRange("Rebate Line No.", 0);
        end else begin
            OldRebateEntry.SetRange("Rebate Code", pRebateLine."Rebate Code");
            OldRebateEntry.SetRange("Rebate Line No.", pRebateLine."Line No.");
        end;

        if OldRebateEntry.FindFirst() then
            RebateEntry := OldRebateEntry
        else begin
            NextEntryNo += 1;
            RebateEntry.Init();
            RebateEntry."Entry No." := NextEntryNo;
            RebateEntry.Insert();
        end;

        RebateEntry."Rebate Code" := pRebateHeader.Code;
        RebateEntry."Rebate Unit of Measure" := pRebateHeader."Unit of Measure Code";
        RebateEntry."Ship-to Code" := pRebateHeader."Temp Ship-to Code";
        RebateEntry."Rebate Line No." := RebateLineNo;
        RebateEntry."Rebate Value" := RebateValue;
        RebateEntry."Source Type" := pSalesLine."Document Type";
        RebateEntry.Validate("Source No.", pSalesLine."Document No.");
        RebateEntry."Source Line No." := pSalesLine."Line No.";
        RebateEntry."Sales Line Amount" := pSalesLine."Line Amount";
        if pRebateHeader.Description <> '' then
            RebateEntry."Rebate Description" := pRebateHeader.Description
        else
            RebateEntry."Rebate Description" := 'Rebate ' + pRebateHeader.Code;
        RebateEntry."Rebate Type" := pRebateHeader."Rebate Type";
        RebateEntry."Calculation Basis" := pRebateHeader."Calculation Basis";
        RebateEntry."Item No." := pSalesLine."No.";
        RebateEntry."Rebate Code" := pRebateHeader.Code;
        RebateEntry."Rebate Type" := pRebateHeader."Rebate Type";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1433 - Add "Accrued Amount" to Rebate Ledger Entry table
        RebateEntry."Accrual Account No." := pRebateHeader."Accrual Account No.";
        RebateEntry."Dimension Set ID" := pSalesLine."Dimension Set ID";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
        RebateEntry."OBF-Entity ID" := pSalesLine."OBF-Header Subsidiary Code";      
        
        RebateEntry.UpdateRebateQuantity();

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1362 - Rebates Not Calculating Correctly for Credit Memos                
        if pSalesLine."Document Type" in [pSalesLine."Document Type"::"Credit Memo",pSalesLine."Document Type"::"Return Order"] then begin
            RebateEntry."Rebate Quantity" := -RebateEntry."Rebate Quantity";
            RebateEntry."Sales Line Amount" := - RebateEntry."Sales Line Amount";
        end;

        RebateEntry.UpdateRebateAmount();
        RebateEntry.Modify();
    end;


    local procedure CreateRebateLedgerEntriesFromInvoice(pSalesLine: Record "Sales Line"; PSalesInvLine: Record "Sales Invoice Line")
    var
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        OldRebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        EntryNo: Integer;
        RebateEntry: Record "OBF-Rebate Entry";
    begin

        if pSalesLine.Type <> pSalesLine.Type::Item then
            exit;

        if (pSalesLine."Document Type" <> pSalesLine."Document Type"::Order) and
           (pSalesLine."Document Type" <> pSalesLine."Document Type"::Invoice) then
            exit;

        if OldRebateLedgerEntry.FindLast() then
            EntryNo := OldRebateLedgerEntry."Entry No."
        else
            EntryNo := 0;

        RebateEntry.SetRange("Source No.", pSalesLine."Document No.");
        RebateEntry.SetRange("Source Line No.", pSalesLine."Line No.");
        if RebateEntry.FindSet() then
            repeat
                RebateLedgerEntry.Init();
                RebateLedgerEntry.TransferFields(RebateEntry);
                EntryNo += 1;
                RebateLedgerEntry."Entry No." := EntryNo;
                RebateLedgerEntry."Source Type" := RebateLedgerEntry."Source Type"::"Posted Invoice";
                RebateLedgerEntry."Source No." := PSalesInvLine."Document No.";
                RebateLedgerEntry."Posting Date" := PSalesInvLine."Posting Date";
                RebateLedgerEntry."Dimension Set ID" := PSalesInvLine."Dimension Set ID";

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
                RebateLedgerEntry."OBF-Entity ID" := PSalesInvLine."OBF-Header Subsidiary Code";

                RebateLedgerEntry."Date Created" := Today;
                if RebateLedgerEntry."Rebate Type" = RebateLedgerEntry."Rebate Type"::"Off-Invoice" then
                    RebateLedgerEntry."Posted to Customer" := true;
                RebateLedgerEntry.Insert(true);
            until (RebateEntry.Next() = 0);

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1362 - Rebates Not Calculating Correctly for Credit Memos                
    //      Code refactored to match CreateRebateLedgerEntriesFromInvoice
    local procedure CreateRebateLedgerEntriesFromCrMemo(pSalesLine: Record "Sales Line"; PSalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        OldRebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        EntryNo: Integer;
        RebateEntry: Record "OBF-Rebate Entry";
    begin

        if pSalesLine.Type <> pSalesLine.Type::Item then
            exit;

        if (pSalesLine."Document Type" <> pSalesLine."Document Type"::"Credit Memo") then
            exit;

        if OldRebateLedgerEntry.FindLast() then
            EntryNo := OldRebateLedgerEntry."Entry No."
        else
            EntryNo := 0;

        RebateEntry.SetRange("Source No.", pSalesLine."Document No.");
        RebateEntry.SetRange("Source Line No.", pSalesLine."Line No.");
        if RebateEntry.FindSet() then
            repeat
                RebateLedgerEntry.Init();
                RebateLedgerEntry.TransferFields(RebateEntry);
                EntryNo += 1;
                RebateLedgerEntry."Entry No." := EntryNo;
                RebateLedgerEntry."Source Type" := RebateLedgerEntry."Source Type"::"Posted Cr. Memo";
                RebateLedgerEntry."Source No." := PSalesCrMemoLine."Document No.";
                RebateLedgerEntry."Posting Date" := PSalesCrMemoLine."Posting Date";
                RebateLedgerEntry."Dimension Set ID" := PSalesCrMemoLine."Dimension Set ID";

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
                RebateLedgerEntry."OBF-Entity ID" := PSalesCrMemoLine."OBF-Header Subsidiary Code";

                RebateLedgerEntry."Date Created" := Today;
                if RebateLedgerEntry."Rebate Type" = RebateLedgerEntry."Rebate Type"::"Off-Invoice" then
                    RebateLedgerEntry."Posted to Customer" := true;
                RebateLedgerEntry.Insert(true);
            until(RebateEntry.Next()=0);

    end;

    local procedure PostCustomerEntry(SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        RebateHeader: Record "OBF-Rebate Header";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesSetup: Record "Sales & Receivables Setup";
        PostingDate: Date;
        DocNo: Code[20];
        LineNo: Integer;
    begin

        if (SalesInvHdrNo = '') and (SalesCrMemoHdrNo = '') then
            exit;

        SalesSetup.Get();
        if SalesInvHeader.Get(SalesInvHdrNo) then begin
            RebateLedgerEntry.SetRange("Source Type", RebateLedgerEntry."Source Type"::"Posted Invoice");
            RebateLedgerEntry.SetRange("Source No.", SalesInvHeader."No.");
            PostingDate := SalesInvHeader."Posting Date";
            DocNo := SalesInvHeader."No.";
        end;

        if SalesCrMemoHeader.Get(SalesCrMemoHdrNo) then begin
            RebateLedgerEntry.SetRange("Source Type", RebateLedgerEntry."Source Type"::"Posted Cr. Memo");
            RebateLedgerEntry.SetRange("Source No.", SalesCrMemoHeader."No.");
            PostingDate := SalesCrMemoHeader."Posting Date";
            DocNo := SalesCrMemoHeader."No.";
        end;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
        if RebateLedgerEntry.FindSet() then begin
            GenJnlLine.SetRange("Journal Template Name",SalesSetup."OBF-Rebate Jnl. Template");
            GenJnlLine.SetRange("Journal Batch Name",SalesSetup."OBF-Rebate Jnl. Batch");
            if GenJnlLine.FindLast() then
                LineNo := GenJnlLine."Line No.";
                
            repeat
                RebateHeader.Get(RebateLedgerEntry."Rebate Code");
                RebateHeader.TestField("Expense G/L Account");
                SourceCodeSetup.Get();
                SourceCodeSetup.TestField(Sales);
                GenJnlLine.Init();
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Journal Template Name" := SalesSetup."OBF-Rebate Jnl. Template";
                GenJnlLine."Journal Batch Name" := SalesSetup."OBF-Rebate Jnl. Batch";
                LineNo += 10000;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.Insert();

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
                GenJnlLine.validate("Shortcut Dimension 1 Code",RebateLedgerEntry."OBF-Entity ID");
                GenJnlLine.validate(BssiEntityID, RebateLedgerEntry."OBF-Entity ID");

                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No." := RebateHeader."Expense G/L Account";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                GenJnlLine."Bal. Account No." := RebateLedgerEntry."Bill-to Customer No.";
                if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::"Off-Invoice" then begin
                    GenJnlLine.Validate("Account No.", RebateHeader."Expense G/L Account");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);
                    GenJnlLine.Validate("Bal. Account No.", RebateLedgerEntry."Bill-to Customer No.");
                end else begin
                    RebateHeader.TestField("Accrual Account No.");
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", RebateHeader."Expense G/L Account");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.Validate("Bal. Account No.", RebateHeader."Accrual Account No.");
                end;
                GenJnlLine.Description := RebateLedgerEntry."Rebate Description";
                GenJnlLine."OBF-Rebate Code" := RebateLedgerEntry."Rebate Code";
                GenJnlLine."OBF-Rebate Ledger Entry No." := RebateLedgerEntry."Entry No.";
                GenJnlLine."Source Code" := SourceCodeSetup.Sales;
                GenJnlLine.Validate(Amount, RebateLedgerEntry."Rebate Amount");
                GenJnlLine."OBF-Rebate Code" := RebateLedgerEntry."Rebate Code";
                GenJnlLine."OBF-Rebate Ledger Entry No." := RebateLedgerEntry."Entry No.";
                if RebateLedgerEntry."Rebate Type" = RebateLedgerEntry."Rebate Type"::"Off-Invoice" then begin 
                    if RebateLedgerEntry."Source Type" = RebateLedgerEntry."Source Type"::"Posted Invoice" then
                        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice
                    else
                        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                    GenJnlLine."Applies-to Doc. No." := RebateLedgerEntry."Source No.";
                end;
                GenJnlLine."Dimension Set ID" := RebateLedgerEntry."Dimension Set ID";

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
                GenJnlLine."Bssi CenDec Entry" := true;
                GenJnlLine.SetRange(BssiEntityID, RebateLedgerEntry."OBF-Entity ID");
                
                GenJnlLine.Modify();

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
                if SalesSetup."OBF-Enable Autopost OI Rebates" then
                    GenJnlPostLine.RunWithCheck(GenJnlLine);

            until RebateLedgerEntry.Next() = 0;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
            if not SalesSetup."OBF-Enable Autopost OI Rebates" then
                Message('You must manually post the off-invoice rebates in batch %1',SalesSetup."OBF-Rebate Jnl. Batch");

        end;
    end;


    local procedure DeleteRebateEntriesOnSalesLine(var pSalesLine: Record "Sales Line")
    var
        RebateEntry: Record "OBF-Rebate Entry";
    begin
        if pSalesLine.IsTemporary then
            exit;

        RebateEntry.SetRange("Source Type", pSalesLine."Document Type");
        RebateEntry.SetRange("Source No.", pSalesLine."Document No.");
        RebateEntry.SetRange("Source Line No.", pSalesLine."Line No.");
        RebateEntry.DeleteAll(true);

    end;


    local procedure DeleteRebateEntriesOnSalesHeader(var pSalesHeader: Record "Sales Header")
    var
        RebateEntry: Record "OBF-Rebate Entry";
    begin
        if pSalesHeader.IsTemporary then
            exit;

        RebateEntry.SetRange("Source Type", pSalesHeader."Document Type");
        RebateEntry.SetRange("Source No.", pSalesHeader."No.");
        RebateEntry.DeleteAll();
    end;

    local procedure RoundAmount(Amount: Decimal): Decimal
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get;
        exit(Round(Amount, GeneralLedgerSetup."Amount Rounding Precision"));
    end;


    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1272 - Need Post Rebates Request Page
    procedure AccrueRebateToCustomer(var RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
                CustNo: Code[20]; DocNo: Code[20]; PostingDate: Date)
    var
        GenJnlLine: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        SourceCodeSetup: Record "Source Code Setup";
        RebateHeader: Record "OBF-Rebate Header";
        RebateLedgerEntryCopy: Record "OBF-Rebate Ledger Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        SalesSetup.Get();
        if DocNo = '' then
            Error('You must enter a Document no');

        if PostingDate = 0D then
            Error('You must enter a Posting Date');

        Currency.InitRoundingPrecision;
        if not RebateLedgerEntry.FindSet() then
            exit;

        SourceCodeSetup.Get();
        SourceCodeSetup.TestField(Sales);

        repeat
            RebateHeader.Get(RebateLedgerEntry."Rebate Code");
            GenJnlLine.Init();
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Journal Template Name" := SalesSetup."OBF-Rebate Jnl. Template";
            GenJnlLine."Journal Batch Name" := SalesSetup."OBF-Rebate Jnl. Batch";
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := RebateHeader."Accrual Account No.";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := RebateLedgerEntry."Bill-to Customer No.";
            GenJnlLine.Description := RebateLedgerEntry."Rebate Description";
            GenJnlLine."OBF-Rebate Code" := RebateLedgerEntry."Rebate Code";
            GenJnlLine."OBF-Rebate Ledger Entry No." := RebateLedgerEntry."Entry No.";
            GenJnlLine."Source Code" := SourceCodeSetup.Sales;
            GenJnlLine."Bill-to/Pay-to No." := RebateLedgerEntry."Bill-to Customer No.";
            GenJnlLine."Ship-to/Order Address Code" := RebateLedgerEntry."Ship-to Code";
            GenJnlLine."Sell-to/Buy-from No." := RebateLedgerEntry."Sell-to Customer No.";
            GenJnlLine.Validate("Currency Code", '');
            GenJnlLine.Validate(Amount, RebateLedgerEntry."Rebate Amount");
            GenJnlLine."Dimension Set ID" := RebateLedgerEntry."Dimension Set ID";

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
            GenJnlLine.BssiEntityID := RebateLedgerEntry."OBF-Entity ID";

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2228 - Rebate Posting Issue
            GenJnlLine."Shortcut Dimension 1 Code" := RebateLedgerEntry."OBF-Entity ID";
            

            GenJnlPostLine.RunWithCheck(GenJnlLine);

            RebateLedgerEntryCopy := RebateLedgerEntry;
            RebateLedgerEntryCopy."Posted To Customer" := true;
            RebateLedgerEntryCopy.Modify();
        until (RebateLedgerEntry.Next() = 0)
    end;

    procedure CloseRebatesWithoutPosting(var RebateLedgerEntry: Record "OBF-Rebate Ledger Entry"; CustNo: Code[20])
    var
        RebateLedgerEntryCopy: Record "OBF-Rebate Ledger Entry";

    begin
        if not RebateLedgerEntry.FindSet() then
            exit;

        repeat
            RebateLedgerEntryCopy := RebateLedgerEntry;
            RebateLedgerEntryCopy."Posted To Customer" := true;
            RebateLedgerEntryCopy.Modify();
        until (RebateLedgerEntry.Next() = 0)
    end;

    procedure CalculateOffInvoicePerLb(OffInvoiceRebateAmount: Decimal; LineNetWeight: Decimal): Text[50];
    var
        OffInvoicePerLb: Decimal;
        OffInvoicePerLbFormatted: Text[50];
    begin
        if LineNetWeight <> 0 then
            OffInvoicePerLb := round(OffInvoiceRebateAmount / LineNetWeight, 0.00001)
        else
            OffInvoicePerLb := OffInvoiceRebateAmount;

        if OffInvoicePerLb = 0 then
            OffInvoicePerLbFormatted := ''
        else
            OffInvoicePerLbFormatted := FORMAT(OffInvoicePerLb, 0, '<Precision,2:5><Standard Format,0>');

        if (OffInvoicePerLb <> 0) and (LineNetWeight <> 0) then
            OffInvoicePerLbFormatted += ' / LB';

        exit(OffInvoicePerLbFormatted);
    end;
}