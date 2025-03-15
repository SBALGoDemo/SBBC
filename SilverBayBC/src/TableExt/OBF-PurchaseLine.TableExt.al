// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50004 "OBF-Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                SubDimension.UpdateDimSetIDForSubDimension('SITE', "OBF-SITE Code", Rec."Dimension Set ID");
            end;
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                SubDimension.UpdateDimSetIDForSubDimension('CIP', "OBF-CIP Code", Rec."Dimension Set ID");
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692 - Create a Purchase Invoice Line Export for Fishermen for Northscope
        field(50002; "OBF-Fisherman Reference Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fisherman Reference Code';
            trigger OnLookup()
            begin 
                LookupFishermanReference();
            end;
            trigger OnValidate()
            begin 
                ValidateFishermanReference();
            end;
        }
        field(50003; "OBF-Expense Item"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Item';
        }
        field(50004; "OBF-Expense Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Quantity';
        }
        field(50005; "OBF-Expense Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Rate';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
        field(50020; "OBF-Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Source Type" = CONST(39),
                                                                           "Source Subtype" = FIELD("Document Type"),
                                                                           "Source ID" = FIELD("Document No."),
                                                                           "Source Ref. No." = FIELD("Line No.")));
            Caption = 'Reserved Qty. for Lots';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
                 
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                if Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code" then begin
                    SubDimension.RemoveSubDimensionsFromDimSetID(Rec."Dimension Set ID");
                    Rec."OBF-CIP Code" := '';
                end;
            end;
        }
    }

    local procedure LookupFishermanReference()
    var
        Vendor: Record Vendor;
    begin

        Vendor.SetFilter("Our Account No.",'<>%1','');
        if "OBF-Fisherman Reference Code" <> '' then begin
            Vendor.SetRange("Our Account No.","OBF-Fisherman Reference Code");
            Vendor.FindFirst();
            Vendor.SetRange("Our Account No.");
        end;

        if (Page.RunModal(Page::"Vendor Lookup", Vendor) = ACTION::LookupOK) then
            "OBF-Fisherman Reference Code" := Vendor."Our Account No.";
    end;

    local procedure ValidateFishermanReference()
    var
        Vendor: Record Vendor;
    begin
        if "OBF-Fisherman Reference Code" = '' then 
            exit;

        Vendor.SetRange("Our Account No.","OBF-Fisherman Reference Code");
        Vendor.FindFirst();

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1889 - Import Item Charge Assignment by Item Ledger Entry
    // The following procedure is based on the procedure ShowItemChargeAssgnt in the Purchase Line table
    procedure OBF_ShowItemChargeAssgnt()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        ItemChargeAssgnts: Page "OBF-Item Charge Ass. (ILE)";
        ItemChargeAssgntLineAmt: Decimal;
        IsHandled: Boolean;
        OBF_ItemChargeAssignmentErr: Label 'You can only assign Item Charges for Line Types of Charge (Item).';
    begin
        Get("Document Type", "Document No.", "Line No.");
        CheckNoAndQuantityForItemChargeAssgnt();

        if Type <> Type::"Charge (Item)" then begin
            Message(OBF_ItemChargeAssignmentErr);
            exit;
        end;

        PurchaseHeader.Get(Rec."Document Type",Rec."Document No.");
        if PurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(PurchaseHeader."Currency Code");
        if ("Inv. Discount Amount" = 0) and
           ("Line Discount Amount" = 0) and
           (not PurchaseHeader."Prices Including VAT")
        then
            ItemChargeAssgntLineAmt := "Line Amount"
        else
            if PurchaseHeader."Prices Including VAT" then
                ItemChargeAssgntLineAmt :=
                  Round(CalcLineAmount / (1 + "VAT %" / 100), Currency."Amount Rounding Precision")
            else
                ItemChargeAssgntLineAmt := CalcLineAmount;

        ItemChargeAssgntPurch.Reset();
        ItemChargeAssgntPurch.SetRange("Document Type", "Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.", "Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.", "Line No.");
        ItemChargeAssgntPurch.SetRange("Item Charge No.", "No.");
        if not ItemChargeAssgntPurch.FindLast() then begin
            ItemChargeAssgntPurch."Document Type" := "Document Type";
            ItemChargeAssgntPurch."Document No." := "Document No.";
            ItemChargeAssgntPurch."Document Line No." := "Line No.";
            ItemChargeAssgntPurch."Item Charge No." := "No.";
            ItemChargeAssgntPurch."Unit Cost" :=
              Round(ItemChargeAssgntLineAmt / Quantity,
                Currency."Unit-Amount Rounding Precision");
        end;

        IsHandled := false;

        if not IsHandled then
            ItemChargeAssgntLineAmt :=
                Round(ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity), Currency."Amount Rounding Precision");

        if IsCreditDocType() then
            AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch, "Return Shipment No.")
        else
            AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch, "Receipt No.");
        Clear(AssignItemChargePurch);
        Commit();

        ItemChargeAssgnts.Initialize(Rec, ItemChargeAssgntLineAmt);
        ItemChargeAssgnts.RunModal();

        CalcFields("Qty. to Assign");
    end;

    local procedure CheckNoAndQuantityForItemChargeAssgnt()
    begin
        TestField("No.");
        TestField(Quantity);
    end;
    
}