// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
report 50056 "OBF-Create Add-on Purch. Order"
{
    CaptionML = ENU = 'Create Add-on Purchase Order';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(SalesOrderNo;SalesOrderNo)
                    {
                        Caption = 'Sales Order No.';
                        Editable = false;
                        TableRelation = "Sales Header"."No." WHERE ("Document Type"=const(Order));
                        ApplicationArea = All;                    
                    }
                    field(SubsidiaryCode;SubsidiaryCode)
                    {
                        Caption = 'Subsidiary Code';
                        TableRelation = "Dimension Value".Code where ("Dimension Code"=const('SUBSIDIARY'));
                        ApplicationArea = All;                    
                    }
                    field(SiteCode;SiteCode)
                    {
                        Caption = 'Site Code';
                        TableRelation = "Dimension Value".Code where ("Dimension Code"=const('SITE'));
                        ApplicationArea = All;                    
                    }
                    field(VendorNo;VendorNo)
                    {
                        Caption = 'Vendor No.';
                        TableRelation = Vendor;
                        QuickEntry = false;
                        ApplicationArea = All;                    
                        trigger OnValidate();
                        var 
                            Vendor : Record Vendor;
                        begin
                            if VendorNo = '' then
                                VendorName := ''
                            else begin
                                Vendor.Get(VendorNo);
                                VendorName := Vendor.Name;
                            end;                
                        end;
                    }
                    field(VendorName;VendorName)
                    {
                        Caption = 'Vendor Name';
                        Editable = false;
                        ApplicationArea = All;                    
                    }
                    field(PostingDate;PostingDate)
                    {
                        Caption = 'Posting Date';
                        QuickEntry = false;
                        ApplicationArea = All;                    
                    }
                    field(ItemChargeCode;ItemChargeCode)
                    {
                        Caption = 'Item Charge Code';
                        TableRelation = "Item Charge";
                        QuickEntry = false;
                        ApplicationArea = All;                    
                    }
                    field(DistributionMethod;DistributionMethod)
                    {
                        Caption = 'Distribution Method';
                        QuickEntry = false;
                        ApplicationArea = All;                    
                    }
                    field(ChargeAmount;ChargeAmount)
                    {
                        Caption = 'Charge Amount';
                        ApplicationArea = All;                    
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
      OrigDocType : Enum "Purchase Applies-to Document Type";
      OrigDocNo : Code[20];
      OrigDocLineNo : Integer;
      SubsidiaryCode : Code[20];
      SiteCode : Code[20];

    trigger OnInitReport();
    var
      PurchSetup : Record "Purchases & Payables Setup";
    begin
      PurchSetup.Get;
      DistributionMethod := PurchSetup."OBF-Add-on Def. Dist. Method";
      ItemChargeCode := PurchSetup."OBF-Addon Def. Item Ch. Code";
    end;

    trigger OnPreReport();
    begin
        CreateAddOnPurchaseOrder;
    end;

    var
        SalesOrderNo : Code[20];
        VendorNo : Code[20];
        VendorName : Text[100];
        ItemChargeCode : Code[20];
        ChargeAmount : Decimal;
        PostingDate : Date;
        DistributionMethod : Enum "OBF-Addon Distribution Method";

    procedure SetSalesOrder(SalesHeader : Record "Sales Header");
    begin
        SalesOrderNo := SalesHeader."No.";
        SetVendorBasedOnShippingAgent(SalesHeader."Shipping Agent Code");
        PostingDate := SalesHeader."Shipment Date";
        SubsidiaryCode := SalesHeader."Shortcut Dimension 1 Code";
    end;

    procedure SetSalesInvoice(SalesInvoiceHeader : Record "Sales Invoice Header")
    begin 
        SalesOrderNo := SalesInvoiceHeader."Order No.";
        SetVendorBasedOnShippingAgent(SalesInvoiceHeader."Shipping Agent Code");
        PostingDate := SalesInvoiceHeader."Shipment Date";
    end;

    procedure SetVendorBasedOnShippingAgent(ShippingAgentCode : Code[10]);
    var
      ShippingAgent : Record "Shipping Agent";
      Vendor : Record Vendor;
    begin
        VendorNo := '';
        VendorName := '';
        if ShippingAgentCode <> '' then begin
            ShippingAgent.Get(ShippingAgentCode);
            if ShippingAgent."OBF-Vendor No." <> '' then begin
                VendorNo := ShippingAgent."OBF-Vendor No.";
                Vendor.Get(VendorNo);
                VendorName := Vendor.Name;
            end;
        end;
    end;

    local procedure CreateAddOnPurchaseOrder();
    var
        NoSeries: Codeunit "No. Series";
        PurchaseHeader : Record "Purchase Header";
        PurchaseLine : Record "Purchase Line";
        PurchSetup : Record "Purchases & Payables Setup";
        SubsidiarySite : Record "OBF-Subsidiary Site";
        PurchaseOrder : Page "Purchase Order";
        AddOnPurchaseOrderNo : Code[20];
        QuantityToAssign : Decimal;
    begin
        QuantityToAssign := 1.0;

        if ItemChargeCode = '' then
            Error('You must enter an Item Charge Code');
        if VendorNo = '' then
            Error('You must enter a Vendor No.');
        if ChargeAmount = 0 then
            Error('You must enter a Charge Amount');
        if SubsidiaryCode = '' then
            Error('You must enter a Subsidiary Code');        
        if SiteCode = '' then
            Error('You must enter a Site Code');
        if not SubsidiarySite.Get(SubsidiaryCode,SiteCode) then
            Error('Invalid Subsidiary Site Combination: %1; %2',SubsidiaryCode,SiteCode);
        PurchSetup.Get;
        PurchSetup.TestField("OBF-Add-on Purchase Order Nos.");
        AddOnPurchaseOrderNo := NoSeries.GetNextNo(PurchSetup."OBF-Add-on Purchase Order Nos.");

        PurchaseHeader.Init;
        PurchaseHeader.Validate("Document Type",PurchaseHeader."Document Type"::Order);
        PurchaseHeader.Validate("No.",AddOnPurchaseOrderNo);
        PurchaseHeader."Shortcut Dimension 1 Code" := SubsidiaryCode;
        PurchaseHeader.Insert(true);
        PurchaseHeader.Validate("Shortcut Dimension 1 Code");
        PurchaseHeader.Modify();
        PurchaseHeader.Validate("Buy-from Vendor No.",VendorNo);
        PurchaseHeader.Validate("Posting Date",PostingDate);
        PurchaseHeader.Validate("Posting Description",SalesOrderNo);
        PurchaseHeader.Modify;

        PurchaseLine.Init;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        PurchaseLine."Shortcut Dimension 1 Code" := SubsidiaryCode;
        PurchaseLine.Insert(true);
        PurchaseLine.Validate("Shortcut Dimension 1 Code");
        PurchaseLine.Modify();
        PurchaseLine.Validate(Type,PurchaseLine.Type::"Charge (Item)");
        PurchaseLine.Validate("No.",ItemChargeCode);
        PurchaseLine.Validate(Quantity,QuantityToAssign);
        PurchaseLine.Validate("Direct Unit Cost",ChargeAmount);
        PurchaseLine.Validate("OBF-Site Code",SiteCode);
        PurchaseLine.Modify;

        AssignItemChargeToSalesOrder(SalesOrderNo,PurchaseLine);
        Commit();

        PurchaseOrder.SetRecord(PurchaseHeader);
        PurchaseOrder.RunModal;
    end;

    local procedure AssignItemChargeToSalesOrder(SalesOrderNo : Code[20];PurchaseLine : Record "Purchase Line");
    var
        SalesLine : Record "Sales Line";
        SalesShipmentLine : Record "Sales Shipment Line";
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)" temporary;
        AssignItemChargePurch : Codeunit "Item Charge Assgnt. (Purch.)";
        NextLineNo : Integer;
    begin
        TempItemChargeAssgntPurch.DeleteAll;

        ItemChargeAssgntPurch.Init;
        ItemChargeAssgntPurch."Document Type" := PurchaseLine."Document Type";
        ItemChargeAssgntPurch."Document No." := PurchaseLine."Document No.";
        ItemChargeAssgntPurch."Document Line No." := PurchaseLine."Line No.";
        ItemChargeAssgntPurch."Item Charge No." := PurchaseLine."No.";
        ItemChargeAssgntPurch."Unit Cost" := PurchaseLine."Unit Cost";

        SalesLine.SetRange("Document Type",SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.",SalesOrderNo);
        SalesLine.SetRange(Type,SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity,'<>%1',0);
        if SalesLine.FindSet then
            CreateSalesOrderChargeAssgnt(SalesLine,ItemChargeAssgntPurch);

        SalesShipmentLine.SetRange("Order No.",SalesOrderNo);
        SalesShipmentLine.SetRange(Type,SalesShipmentLine.Type::Item);
        SalesShipmentLine.SetFilter(Quantity,'<>%1',0);
        if SalesShipmentLine.FindSet then
            CreateSalesShipmentChargeAssgnt(SalesShipmentLine,ItemChargeAssgntPurch);

        case DistributionMethod of
            DistributionMethod::Equally :
                AssignEqually(PurchaseLine);
            DistributionMethod::Amount :
                AssignByAmount(PurchaseLine);
            DistributionMethod::Weight :
                AssignByWeight(PurchaseLine);
            DistributionMethod::Quantity :
                AssignByQuantity(PurchaseLine);
        end;
    end;

    local procedure AssignEqually(PurchaseLine : Record "Purchase Line");
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        ItemChargeAssgntPurchCopy : Record "Item Charge Assignment (Purch)";
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
        RemainingNumOfLines : Integer;
        ForUpdate : Boolean;
    begin
        TotalQtyToAssign := PurchaseLine.Quantity;
        TotalAmtToAssign := PurchaseLine.Amount;

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type",PurchaseLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchaseLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.",PurchaseLine."Line No.");
        RemainingNumOfLines := ItemChargeAssgntPurch.Count;
        ForUpdate := true;
        if ItemChargeAssgntPurch.FindSet(ForUpdate) then
          repeat
            ItemChargeAssgntPurch."Qty. to Assign" := Round(TotalQtyToAssign / RemainingNumOfLines,0.00001);

            if (TotalQtyToAssign * TotalAmtToAssign) <> 0 then
              ItemChargeAssgntPurch."Amount to Assign" := Round(ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,0.01)
            else
              ItemChargeAssgntPurch."Amount to Assign" := 0;

            TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
            TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
            RemainingNumOfLines := RemainingNumOfLines - 1;
            ItemChargeAssgntPurch.Modify;
          until ItemChargeAssgntPurch.Next = 0;
    end;

    local procedure AssignByAmount(PurchaseLine : Record "Purchase Line");
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)" temporary;
        SalesLine : Record "Sales Line";
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
        TotalAppliesToDocLineAmount : Decimal;
        ForUpdate : Boolean;
    begin
        TotalQtyToAssign := PurchaseLine.Quantity;
        TotalAmtToAssign := PurchaseLine.Amount;

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type",PurchaseLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchaseLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.",PurchaseLine."Line No.");
        ForUpdate := true;
        if ItemChargeAssgntPurch.FindSet(true) then
          repeat
            if not ItemChargeAssgntPurch.PurchLineInvoiced then begin
              TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
              ItemChargeAssgntPurch.TestField("Applies-to Doc. Type",ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Order");
              SalesLine.Get(SalesLine."Document Type"::Order,ItemChargeAssgntPurch."Applies-to Doc. No.",ItemChargeAssgntPurch."Applies-to Doc. Line No.");
              TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" := Abs(SalesLine."Line Amount");

              if TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" <> 0 then
                TempItemChargeAssgntPurch.Insert
              else begin
                ItemChargeAssgntPurch."Amount to Assign" := 0;
                ItemChargeAssgntPurch."Qty. to Assign" := 0;
                ItemChargeAssgntPurch.Modify;
              end;
              TotalAppliesToDocLineAmount += TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
            end;
          until ItemChargeAssgntPurch.Next = 0;

        if TempItemChargeAssgntPurch.FindSet then
          repeat
            ItemChargeAssgntPurch.Get(
              TempItemChargeAssgntPurch."Document Type",
              TempItemChargeAssgntPurch."Document No.",
              TempItemChargeAssgntPurch."Document Line No.",
              TempItemChargeAssgntPurch."Line No.");
            if TotalQtyToAssign <> 0 then begin
              ItemChargeAssgntPurch."Qty. to Assign" :=
                Round(TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,0.00001);

              if (TotalQtyToAssign * TotalAmtToAssign) <> 0 then
                ItemChargeAssgntPurch."Amount to Assign" := Round(ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,0.01)
              else
                ItemChargeAssgntPurch."Amount to Assign" := 0;

              TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
              TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
              TotalAppliesToDocLineAmount -= TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
              ItemChargeAssgntPurch.Modify;
            end;
          until TempItemChargeAssgntPurch.Next = 0;
    end;

    local procedure AssignByWeight(PurchaseLine : Record "Purchase Line");
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)" temporary;
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
        LineWeight : Decimal;
        TotalWeight : Decimal;
        QtyRemainder : Decimal;
        AmountRemainder : Decimal;
        LineUnitOfMeasureCode : Code[10];
        LastUnitOfMeasureCode : Code[10];
        MustHaveSameUOMText : Label 'All Applies to Doc. Lines must have the same\Unit of Measure to distribute by Quantity.';
        ForUpdate : Boolean;
    begin
        TotalQtyToAssign := PurchaseLine.Quantity;
        TotalAmtToAssign := PurchaseLine.Amount;

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type",PurchaseLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchaseLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.",PurchaseLine."Line No.");
        ForUpdate := true;
        if ItemChargeAssgntPurch.FindSet(ForUpdate) then
          repeat
            if not ItemChargeAssgntPurch.PurchLineInvoiced then begin
              TempItemChargeAssgntPurch.Init;
              TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
              TempItemChargeAssgntPurch.Insert;
              GetSalesLineItemWeight(TempItemChargeAssgntPurch,LineWeight,LineUnitOfMeasureCode);
              TotalWeight += LineWeight;
              if (LastUnitOfMeasureCode <> '') then begin
                if LastUnitOfMeasureCode <> LineUnitOfMeasureCode then
                  Error(MustHaveSameUOMText);
                LastUnitOfMeasureCode := LineUnitOfMeasureCode;
              end;
            end;
          until ItemChargeAssgntPurch.Next = 0;

        if TempItemChargeAssgntPurch.FindSet(true) then
          repeat
            GetSalesLineItemWeight(TempItemChargeAssgntPurch,LineWeight,LineUnitOfMeasureCode);
            if TotalWeight <> 0 then
              TempItemChargeAssgntPurch."Qty. to Assign" :=
                (TotalQtyToAssign * LineWeight) / TotalWeight + QtyRemainder
            else
              TempItemChargeAssgntPurch."Qty. to Assign" := 0;
            AssignPurchItemCharge(ItemChargeAssgntPurch,TempItemChargeAssgntPurch,QtyRemainder,AmountRemainder);
          until TempItemChargeAssgntPurch.Next = 0;
    end;

    local procedure AssignByQuantity(PurchaseLine : Record "Purchase Line");
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)" temporary;
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
        LineQuantity : Decimal;
        TotalQuantity : Decimal;
        QtyRemainder : Decimal;
        AmountRemainder : Decimal;
        LineUnitOfMeasureCode : Code[10];
        LastUnitOfMeasureCode : Code[10];
        MustHaveSameUOMText : Label 'All Applies to Doc. Lines must have the same\Unit of Measure to distribute by Quantity.';
        ForUpdate : Boolean;
    begin
        TotalQtyToAssign := PurchaseLine.Quantity;
        TotalAmtToAssign := PurchaseLine.Amount;

        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type",PurchaseLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.",PurchaseLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.",PurchaseLine."Line No.");
        ForUpdate := true;
        if ItemChargeAssgntPurch.FindSet(ForUpdate) then
          repeat
            if not ItemChargeAssgntPurch.PurchLineInvoiced then begin
              TempItemChargeAssgntPurch.Init;
              TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
              TempItemChargeAssgntPurch.Insert;
              GetSalesLineItemQuantity(TempItemChargeAssgntPurch,LineQuantity,LineUnitOfMeasureCode);
              TotalQuantity += LineQuantity;
              if (LastUnitOfMeasureCode <> '') then begin
                if LastUnitOfMeasureCode <> LineUnitOfMeasureCode then
                  Error(MustHaveSameUOMText);
                LastUnitOfMeasureCode := LineUnitOfMeasureCode;
              end;
            end;
          until ItemChargeAssgntPurch.Next = 0;

        if TempItemChargeAssgntPurch.FindSet(true) then
          repeat
            GetSalesLineItemQuantity(TempItemChargeAssgntPurch,LineQuantity,LineUnitOfMeasureCode);
            if TotalQuantity <> 0 then
              TempItemChargeAssgntPurch."Qty. to Assign" :=
                (TotalQtyToAssign * LineQuantity) / TotalQuantity + QtyRemainder
            else
              TempItemChargeAssgntPurch."Qty. to Assign" := 0;
            AssignPurchItemCharge(ItemChargeAssgntPurch,TempItemChargeAssgntPurch,QtyRemainder,AmountRemainder);
          until TempItemChargeAssgntPurch.Next = 0;
        TempItemChargeAssgntPurch.DeleteAll;
    end;

    local procedure GetSalesLineItemQuantity(ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";var Quantity : Decimal;var UnitOfMeasureCode : Code[10]);
    var
        SalesLine : Record "Sales Line";
    begin
        ItemChargeAssgntPurch.TestField(ItemChargeAssgntPurch."Applies-to Doc. Type", ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Order");
        SalesLine.Get(SalesLine."Document Type"::Order, ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.");
        Quantity := Abs(SalesLine.Quantity);
        UnitOfMeasureCode := SalesLine."Unit of Measure Code";

    end;

    local procedure GetSalesLineItemWeight(ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";var Weight : Decimal;var UnitOfMeasureCode : Code[10]);
    var
        SalesLine : Record "Sales Line";
        SalesShipmentLine : Record "Sales Shipment Line";
    begin
        case ItemChargeAssgntPurch."Applies-to Doc. Type" of
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Order" : begin 
                SalesLine.Get(SalesLine."Document Type"::Order, ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                if SalesLine."Gross Weight" <> 0 then
                    Weight := Abs(SalesLine.Quantity * SalesLine."Gross Weight")
                else
                    Weight := Abs(SalesLine.Quantity * SalesLine."Net Weight");
                UnitOfMeasureCode := SalesLine."Unit of Measure Code";
            end;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1450 - Make Add-On Button available on the Posted Sales Invoice page
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment" : begin 
                SalesShipmentLine.Get( ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                if SalesShipmentLine."Gross Weight" <> 0 then
                    Weight := Abs(SalesShipmentLine.Quantity * SalesShipmentLine."Gross Weight")
                else
                    Weight := Abs(SalesShipmentLine.Quantity * SalesShipmentLine."Net Weight");
                UnitOfMeasureCode := SalesShipmentLine."Unit of Measure Code";              
            end;
            else
                Error('Applies-to Doc. Type must be either Sales Order or Sales Shipment');
        end;

    end;

    local procedure AssignPurchItemCharge(var ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";ItemChargeAssgntPurch2 : Record "Item Charge Assignment (Purch)";var QtyRemainder : Decimal;var AmountRemainder : Decimal);
    begin
        ItemChargeAssgntPurch.Get(
          ItemChargeAssgntPurch2."Document Type",
          ItemChargeAssgntPurch2."Document No.",
          ItemChargeAssgntPurch2."Document Line No.",
          ItemChargeAssgntPurch2."Line No.");
        ItemChargeAssgntPurch."Qty. to Assign" := Round(ItemChargeAssgntPurch2."Qty. to Assign", 0.00001);
        ItemChargeAssgntPurch."Amount to Assign" := ItemChargeAssgntPurch."Qty. to Assign" * ItemChargeAssgntPurch."Unit Cost" + AmountRemainder;
        AmountRemainder := ItemChargeAssgntPurch."Amount to Assign" - Round(ItemChargeAssgntPurch."Amount to Assign",0.01);
        QtyRemainder := ItemChargeAssgntPurch2."Qty. to Assign" - ItemChargeAssgntPurch."Qty. to Assign";
        ItemChargeAssgntPurch."Amount to Assign" := Round(ItemChargeAssgntPurch."Amount to Assign",0.01);
        ItemChargeAssgntPurch.Modify;
    end;

    
    procedure CreateSalesOrderChargeAssgnt(var FromSalesOrderLine : Record "Sales Line";ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)");
    var
        ItemChargeAssgntPurch2 : Record "Item Charge Assignment (Purch)";
        ShptLine : Record "Sales Shipment Line";
        NextLine : Integer;

    begin
        NextLine := ItemChargeAssgntPurch."Line No.";

        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");

        repeat
  
            FromSalesOrderLine.TestField("Quantity Shipped", 0);
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Order");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromSalesOrderLine."Document No.");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromSalesOrderLine."Line No.");

            if not ItemChargeAssgntPurch2.FindFirst() then begin
                SetOrigDocInfo(ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Order",
                                FromSalesOrderLine."Document No.",
                                FromSalesOrderLine."Line No.");

                InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Order",
                    FromSalesOrderLine."Document No.",FromSalesOrderLine."Line No.",
                    FromSalesOrderLine."No.",FromSalesOrderLine.Description,NextLine);
            end;

        until FromSalesOrderLine.Next = 0;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1450 - Make Add-On Button available on the Posted Sales Invoice page
    procedure CreateSalesShipmentChargeAssgnt(var FromSalesShipmentLine : Record "Sales Shipment Line";ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)");
    var
        ItemChargeAssgntPurch2 : Record "Item Charge Assignment (Purch)";
        ShptLine : Record "Sales Shipment Line";
        NextLine : Integer;

    begin
        NextLine := ItemChargeAssgntPurch."Line No.";

        ItemChargeAssgntPurch2.SetRange("Document Type",ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.",ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.",ItemChargeAssgntPurch."Document Line No.");

        repeat
  
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Type",ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Order");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.",FromSalesShipmentLine."Document No.");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.",FromSalesShipmentLine."Line No.");

            if not ItemChargeAssgntPurch2.FindFirst() then begin
                SetOrigDocInfo(ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Order",
                                FromSalesShipmentLine."Order No.",
                                FromSalesShipmentLine."Order Line No.");

                InsertItemChargeAssgnt(ItemChargeAssgntPurch,ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment",
                    FromSalesShipmentLine."Document No.",FromSalesShipmentLine."Line No.",
                    FromSalesShipmentLine."No.",FromSalesShipmentLine.Description,NextLine);
            end;

        until FromSalesShipmentLine.Next = 0;
    end;

    procedure InsertItemChargeAssgnt(ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";ApplToDocType :  Enum "Purchase Applies-to Document Type";ApplToDocNo2 : Code[20];ApplToDocLineNo2 : Integer;ItemNo2 : Code[20];Description2 : Text[100];var NextLineNo : Integer);
    begin
        InsertItemChargeAssgntWithAssignValues(
          ItemChargeAssgntPurch,ApplToDocType,ApplToDocNo2,ApplToDocLineNo2,ItemNo2,Description2,0,0,NextLineNo);
    end;

    procedure InsertItemChargeAssgntWithAssignValues(FromItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
      ApplToDocType :  Enum "Purchase Applies-to Document Type";
      FromApplToDocNo : Code[20];FromApplToDocLineNo : Integer;FromItemNo : Code[20];FromDescription : Text[100];QtyToAssign : Decimal;AmountToAssign : Decimal;var NextLineNo : Integer);
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
    begin
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntPurch."Document No." := FromItemChargeAssgntPurch."Document No.";
        ItemChargeAssgntPurch."Document Type" := FromItemChargeAssgntPurch."Document Type";
        ItemChargeAssgntPurch."Document Line No." := FromItemChargeAssgntPurch."Document Line No.";
        ItemChargeAssgntPurch."Item Charge No." := FromItemChargeAssgntPurch."Item Charge No.";
        ItemChargeAssgntPurch."Line No." := NextLineNo;
        ItemChargeAssgntPurch."Applies-to Doc. No." := FromApplToDocNo;
        ItemChargeAssgntPurch."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntPurch."Applies-to Doc. Line No." := FromApplToDocLineNo;
        ItemChargeAssgntPurch."Item No." := FromItemNo;
        ItemChargeAssgntPurch.Description := FromDescription;
        ItemChargeAssgntPurch."Unit Cost" := FromItemChargeAssgntPurch."Unit Cost";

        if OrigDocNo <> '' then begin
          ItemChargeAssgntPurch."OBF-Orig. Doc. Type" := OrigDocType;
          ItemChargeAssgntPurch."OBF-Orig. Doc. No." := OrigDocNo;
          ItemChargeAssgntPurch."OBF-Orig. Doc. Line No." := OrigDocLineNo;
        end else begin
          ItemChargeAssgntPurch."OBF-Orig. Doc. Type" := ApplToDocType;
          ItemChargeAssgntPurch."OBF-Orig. Doc. No." := FromApplToDocNo;
          ItemChargeAssgntPurch."OBF-Orig. Doc. Line No." := FromApplToDocLineNo;
        end;

        if QtyToAssign <> 0 then begin
          ItemChargeAssgntPurch."Amount to Assign" := AmountToAssign;
          ItemChargeAssgntPurch.Validate("Qty. to Assign",QtyToAssign);
        end;
        ItemChargeAssgntPurch.Insert;
    end;

    
    procedure SetOrigDocInfo(poptOrigDocType :  Enum "Purchase Applies-to Document Type";pOrigDocNo : Code[20];pOrigDocLineNo : Integer);
    begin
        OrigDocType := poptOrigDocType;
        OrigDocNo := pOrigDocNo;
        OrigDocLineNo := pOrigDocLineNo;
    end;
}