codeunit 50002 "OBF-Event Subscriptions"
{
    Permissions = TableData "G/L Entry" = m;

    trigger OnRun()
    begin

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean);
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        Rec."OBF-Workflow Salesperson Code" := SalesSetup."OBF-Default Workflow Slsperson";
        if copystr(Rec."No.", 1, 5) = 'S-INV' then
            Rec."Your Reference" := copystr(Rec."No.", 6, 20)
        else
            Rec."Your Reference" := Rec."No.";
        Rec.Modify();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean);
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            exit;

        Rec."OBF-Header Subsidiary Code" := SalesHeader."Shortcut Dimension 1 Code";
        Rec.Modify();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2035 - Set Default Value for "Bank Payment Type" in the Payment Journal   
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterGenJournalLineInsert(var Rec: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if Rec."Journal Template Name" <> 'PAYMENT' then
            exit;

        GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
        Rec."Bank Payment Type" := GenJournalBatch."OBF-Def. Bank Payment Type";
        Rec.Modify();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1316 - Autonumber New Ship-to Addresses
    [EventSubscriber(ObjectType::Page, page::"Ship-to Address", 'OnBeforeOnNewRecord', '', false, false)]
    local procedure ShipToAddress_OnBeforeOnNewRecord(var Customer: Record Customer; var IsHandled: Boolean; var ShipToAddress: Record "Ship-to Address")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        IF ShipToAddress.Code = '' then begin

            SalesSetup.Get();
            SalesSetup.TestField("OBF-Customer Ship-to Nos.");

            ShipToAddress."OBF-No. Series" := SalesSetup."OBF-Customer Ship-to Nos.";
            ShipToAddress."Customer No." := Customer."No.";
            ShipToAddress.Code := NoSeries.GetNextNo(ShipToAddress."OBF-No. Series");
            ShipToAddress.Validate(Name, Customer.Name);
            ShipToAddress."Country/Region Code" := Customer."Country/Region Code";
            ShipToAddress."OBF-Ship-to Broker" := Customer."OBF-Broker";
            IsHandled := true;
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesOrder(var SalesHeader: Record "Sales Header");
    begin

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1741 - Sales Credit Memo Issues
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then
            SalesHeader.PrepareToPrint();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1776 - Add Memo field to Deposit Page 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure GenJnlPostLine_OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    begin
        CustLedgerEntry."OBF-Memo" := GenJournalLine.Comment;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2018 - Make memo field available on customer and vender ledgers
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure CustLedgerEntryEdit_OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry."OBF-Memo" := FromCustLedgEntry."OBF-Memo";
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2018 - Make memo field available on customer and vender ledgers
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure VendLedgerEntryEdit_OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry."OBF-Memo" := FromVendLedgEntry."OBF-Memo";
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - Block Invalid Subsidiary Site Combinations
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertGeneralLedgerEntry(var Rec: Record "G/L Entry")
    var
        GeneralLedgerSetup: record "General Ledger Setup";
        SubsidiarySite: record "OBF-Subsidiary Site";
    begin
        GeneralLedgerSetup.Get();

        if GeneralLedgerSetup."OBF-Block Invalid Sub and Site" = true then begin
            Rec.CalcFields("Shortcut Dimension 3 Code");
            if (Rec."Shortcut Dimension 3 Code" <> '') and (not SubsidiarySite.Get(Rec."Global Dimension 1 Code", Rec."Shortcut Dimension 3 Code")) then
                Error('The subsidiary and site combination is invalid for Subsidiary: %1 and Site: %2.',
                    Rec."Global Dimension 1 Code",
                    Rec."Shortcut Dimension 3 Code");
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code 
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterGLEntryInsert(var Rec: Record "G/L Entry")
    begin
        Rec.CalcFields("Shortcut Dimension 3 Code");
        Rec."OBF-Site Code" := Rec."Shortcut Dimension 3 Code";
        Rec.Modify();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code 
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterGLAccountInsert(var Rec: Record "G/L Account")
    var
        SubsidiarySite: Record "OBF-Subsidiary Site";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
    begin
        if Rec."Account Type" <> Rec."Account Type"::Posting then
            exit;

        SubsidiarySite.FindSet();
        repeat
            if not GLBalBySubsSite.Get(Rec."No.", SubsidiarySite."Subsidiary Code", '') then begin
                GLBalBySubsSite."G/L Account No." := Rec."No.";
                GLBalBySubsSite."Subsidiary Code" := SubsidiarySite."Subsidiary Code";
                GLBalBySubsSite."Site Code" := '';
                GLBalBySubsSite.Insert();
            end;
            if not GLBalBySubsSite.Get(Rec."No.", SubsidiarySite."Subsidiary Code", SubsidiarySite."Site Code") then begin
                GLBalBySubsSite."G/L Account No." := Rec."No.";
                GLBalBySubsSite."Subsidiary Code" := SubsidiarySite."Subsidiary Code";
                GLBalBySubsSite."Site Code" := SubsidiarySite."Site Code";
                GLBalBySubsSite.Insert();
            end;
        until (SubsidiarySite.Next() = 0);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1770 - Auto populated G/L Entry Site Code 
    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterDimensionValueInsert(var Rec: Record "Dimension Value")
    var
        GLAccount: Record "G/L Account";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
    begin
        if (Rec."Dimension Code" <> 'SUBSIDIARY') then
            exit;

        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.FindSet();
        repeat
            if not GLBalBySubsSite.Get(GLAccount."No.", Rec.Code, '') then begin
                GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                GLBalBySubsSite."Subsidiary Code" := Rec.Code;
                GLBalBySubsSite."Site Code" := '';
                GLBalBySubsSite.Insert();
            end;
        until (GLAccount.Next() = 0);
    end;

}