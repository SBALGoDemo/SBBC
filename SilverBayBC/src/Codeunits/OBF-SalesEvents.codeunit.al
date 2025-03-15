codeunit 50050 "OBF-Sales Events"
{
    Permissions = TableData "Cust. Ledger Entry" = m, TableData "Sales Invoice Header" = m, tabledata "Item Ledger Entry" = m;

    trigger OnRun();
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20];
                        RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean)
    var
        SalesInvHdr: Record "Sales Invoice Header";
        RebateManagement: Codeunit "OBF-Rebate Management";
    begin
        if SalesInvHdrNo <> '' then begin
            SelectLatestVersion;
            SalesInvHdr.Get(SalesInvHdrNo);
            SetWorkflowStep(SalesInvHdr);
        end;
        RebateManagement.PostCustomerRebates(SalesHeader, SalesInvHdrNo, SalesCrMemoHdrNo);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)]
    local procedure SalesPost_OnAfterCheckSalesDoc(SalesHeader: Record "Sales Header");
    var
        ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)";
        PurchaseLine: Record "Purchase Line";
        ErrorFlag: Boolean;
    begin
        ItemChargeAssignmentPurch.SetRange("OBF-Orig. Doc. Type", ItemChargeAssignmentPurch."OBF-Orig. Doc. Type"::"Sales Order");
        ItemChargeAssignmentPurch.SetRange("OBF-Orig. Doc. No.", SalesHeader."No.");
        ErrorFlag := false;
        if ItemChargeAssignmentPurch.FindSet then begin
            repeat
                PurchaseLine.Get(ItemChargeAssignmentPurch."Document Type", ItemChargeAssignmentPurch."Document No.", ItemChargeAssignmentPurch."Document Line No.");
                if PurchaseLine."Quantity Received" <> PurchaseLine.Quantity then
                    ErrorFlag := true;
            until (ItemChargeAssignmentPurch.Next = 0);
            if ErrorFlag then
                error('There are associated Add-on Purchase Orders that must be posted before posting Sales Order %1', SalesHeader."No.");
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure SalesPost_OnAfterSalesShipmentLineInsert(var SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line");
    begin
        UpdateItemChargeLinks(SalesLine, SalesShipmentLine."Document No.");
    end;

    procedure UpdateItemChargeLinks(var SalesLine: Record "Sales Line"; SalesShptHeaderNo: Code[20]);
    var
        ItemChargePurch: Record "Item Charge Assignment (Purch)";
        ItemChargePurchCopy: Record "Item Charge Assignment (Purch)";
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Order then
            exit;

        if SalesLine."Qty. to Ship" = 0 then
            exit;

        ItemChargePurch.Reset();
        ItemChargePurch.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        ItemChargePurch.SetRange("Applies-to Doc. Type", ItemChargePurch."Applies-to Doc. Type"::"Sales Order");
        ItemChargePurch.SetRange("Applies-to Doc. No.", SalesLine."Document No.");
        ItemChargePurch.SetRange("Applies-to Doc. Line No.", SalesLine."Line No.");
        ItemChargePurch.SetFilter("Document No.", '<>%1', SalesLine."Document No.");
        if ItemChargePurch.IsEmpty() then
            exit;

        if (-SalesLine."Qty. to Ship") <> SalesLine.Quantity then
            Error('The Quantity Shipped must be equal to the Quantity on Line %1 because there are item charges linked to that line', SalesLine."Line No.");

        ItemChargePurch.FindSet();
        repeat
            ItemChargePurchCopy.Copy(ItemChargePurch);
            ItemChargePurchCopy.Validate("Applies-to Doc. Type",
                                        ItemChargePurch."Applies-to Doc. Type"::"Sales Shipment");
            ItemChargePurchCopy.Validate("Applies-to Doc. No.", SalesShptHeaderNo);
            ItemChargePurchCopy.Validate("Qty. to Handle", ItemChargePurchCopy."Qty. to Assign");
            ItemChargePurchCopy.Modify(true);
        until ItemChargePurch.Next() = 0;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCreateSalesLine', '', false, false)]
    local procedure OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary);
    begin
        SalesLine."OBF-Allocated Quantity" := TempSalesLine."OBF-Allocated Quantity";
        SalesLine."OBF-Line Net Weight" := TempSalesLine."OBF-Line Net Weight";
        SalesLine.Modify;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnDeleteSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean);
    begin
        if not RunTrigger then
            exit;
        CheckAllowEditAfterOrderShipped(Rec."OBF-Workflow Step No.");
        Rec.TestField("OBF-Cancellation Pending (940)", false);
        Rec.TestField("OBF-Revision Pending (940)", false);
        Rec.TestField("OBF-Whse. Sh. Rel. (940)", false);
        Rec.TestField("OBF-Release Pending (940)", false);
    end;

    local procedure CheckAllowEditAfterOrderShipped(WorkflowStepNo: Integer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SalesSetup.Get;
        if WorkflowStepNo > SalesSetup."OBF-Submit to Shipping Step" then
            SOWorkflowStep.CheckUserAllowedToEdit;
    end;

    procedure UpdateCustomEDIFieldsForCustomer(CustomerNo: code[20]);
    var
        SalesHeader: Record "Sales Header";
        Location: Record Location;
        IsModified: Boolean;
        NumModified: Integer;
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        if SalesHeader.FindSet then
            repeat
                InitializeCustomEDIFieldsForCustomer(SalesHeader, IsModified);
                if IsModified then begin
                    NumModified += 1;
                    SalesHeader.modify;
                end;
            until (SalesHeader.Next = 0);
        if NumModified > 0 then
            Message('The Custom EDI fields were initialized on %1 Sales Orders.', NumModified);
    end;

    procedure UpdateCustomEDIFieldsForLocation(LocationCode: code[10]);
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        IsModified: Boolean;
        NumModified: Integer;
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Location Code", LocationCode);
        if SalesHeader.FindSet then
            repeat
                InitializeCustomEDIFieldsForLocation(SalesHeader, IsModified);
                if IsModified then begin
                    NumModified += 1;
                    SalesHeader.modify;
                end;
            until (SalesHeader.Next = 0);
        if NumModified > 0 then
            Message('The Custom EDI fields were initialized on %1 Sales Orders.', NumModified);
    end;

    procedure InitializeCustomEDIFieldsForCustomer(var SalesHeader: record "Sales Header"; var IsModified: Boolean);
    begin
        IsModified := false;
        if SalesHeader."OBF-PO Acknowledgement Note" = SalesHeader."OBF-PO Acknowledgement Note"::" " then begin
            SalesHeader."OBF-PO Acknowledgement Note" := SalesHeader."OBF-PO Acknowledgement Note"::"*** This Order has not been confirmed ***";
            IsModified := true;
        end;
    end;

    procedure InitializeCustomEDIFieldsForLocation(var SalesHeader: record "Sales Header"; var IsModified: Boolean);
    begin
        IsModified := false;
        if SalesHeader."OBF-Whse. Sh. Rel. Note" = SalesHeader."OBF-Whse. Sh. Rel. Note"::" " then begin
            SalesHeader."OBF-Whse. Sh. Rel. Note" := SalesHeader."OBF-Whse. Sh. Rel. Note"::"*** Shipping Release has not been sent ***";
            IsModified := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesOrder(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean);
    var
        RebateManagement: Codeunit "OBF-Rebate Management";
    begin
        RebateManagement.GetRebates(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateSalesLineQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
    begin
        SetLineNetWeight(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit of Measure Code', false, false)]
    local procedure OnAfterValidateSalesLineUOM(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
    begin
        SetLineNetWeight(Rec);
    end;

    procedure SetLineNetWeight(var SalesLine: Record "Sales Line")
    begin
        SalesLine."OBF-Line Net Weight" := SalesLine.Quantity * SalesLine."Net Weight";
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    procedure SetWorkflowStep(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SalesSetup.Get;
        if SalesSetup."OBF-Post Invoicing W. Step" <> 0 then
            if SOWorkflowStep.Get(SalesInvoiceHeader."Order No.", SalesSetup."OBF-Post Invoicing W. Step") then begin
                SalesInvoiceHeader."OBF-Workflow Step No." := SOWorkflowStep."Step No.";
                SalesInvoiceHeader."OBF-Workflow Step Description" := SOWorkflowStep.Description;
                SOWorkflowStep.CalcFields("Assigned to W. User Group");
                SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := SOWorkflowStep."Assigned to W. User Group";
                SalesInvoiceHeader.Modify;
            end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure AutoCreateCustRuleForDocSet(CustomerNo: Code[20]; DocumentSetNo: Code[20]; UseCustContactIfAvailable: Boolean);
    var
        ZetadocsCustomerRule: Record "Zetadocs Customer Rule";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
    begin
        if ZetadocsCustomerRule.Get(CustomerNo, DocumentSetNo) then
            exit;

        SalesSetup.Get;
        Customer.Get(CustomerNo);
        ZetadocsCustomerRule."Customer No." := CustomerNo;
        ZetadocsCustomerRule."Zd Rule ID No." := DocumentSetNo;
        ZetadocsCustomerRule."Contact Option" := ZetadocsCustomerRule."Contact Option"::Other;
        if UseCustContactIfAvailable then
            if Customer."E-Mail" <> '' then begin
                ZetadocsCustomerRule."Contact Name" := Customer.Contact;
                ZetadocsCustomerRule."Contact E-Mail" := Customer."E-Mail";
            end;

        if ZetadocsCustomerRule."Contact E-Mail" = '' then begin
            ZetadocsCustomerRule."Contact Name" := SalesSetup."OBF-Zetadocs Send Name";
            ZetadocsCustomerRule."Contact E-Mail" := SalesSetup."OBF-Zetadocs Send Email";
        end;

        ZetadocsCustomerRule."Delivery Method" := ZetadocsCustomerRule."Delivery Method"::"E-Mail";
        ZetadocsCustomerRule.Insert;
        Commit;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1331 - Periodic Zetadocs Lockup Issue
    procedure DeleteItemSalesLineWithQuantityZero(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Type", SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity, '0');
        if SalesLine.FindSet then
            SalesLine.DeleteAll;
    end;

}