// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
table 50004 "OBF-Rebate Entry"
{
    DrillDownPageID = "OBF-Rebate Entries";
    LookupPageID = "OBF-Rebate Entries";
    Caption = 'Rebate Entry';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Source Type"; enum "Sales Document Type")
        {
            Caption = 'Source Type';
        }
        field(30; "Source No."; Code[20])
        {
            Caption = 'Source No.';
           trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                if SalesHeader.Get("Source Type", "Source No.") then begin
                    Validate("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
                    Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                    Validate("Ship-to Code", SalesHeader."Ship-to Code");
                end else begin
                    Clear("Bill-to Customer No.");
                    Clear("Sell-to Customer No.");
                end;
            end;
        }
        field(40; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(50; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            TableRelation = "OBF-Rebate Header";
        }
        field(60; "Rebate Description"; Text[50])
        {
            Caption = 'Rebate Description';
        }
        field(70; "Rebate Type"; enum "OBF-Rebate Type")
        {
            Caption = 'Rebate Type';
        }
        field(80; "Calculation Basis"; enum "OBF-Rebate Calculation Basis")
        {
            Caption = 'Calculation Basis';
        }
        field(90; "Rebate Quantity"; Decimal)
        {
            Caption = 'Rebate Quantity';
        }
        field(100; "Rebate Unit of Measure"; Code[10])
        {
            Caption = 'Rebate Unit of Measure';
        }
        field(110; "Sales Line Amount"; Decimal)
        {
            Caption = 'Sales Line Amount';
        }
        field(120; "Rebate Value"; Decimal)
        {
            Caption = 'Rebate Value';
        }
        field(130; "Rebate Amount"; Decimal)
        {
            Caption = 'Rebate Amount';
        }
        field(140; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(145; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(150; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(160; "Bill-to Customer Name"; Text[100])
        {
            Caption = 'Bill-to Customer Name';
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Bill-to Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(170; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(180; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(190; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(200; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Sell-to Customer No."),
                                                               Code = FIELD("Ship-to Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Rebate Line No."; Integer)
        {
            Caption = 'Rebate Line No.';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1433 - Add "Accrued Amount" to Rebate Ledger Entry table
        field(310; "Accrual Account No."; Code[20])
        {
            Caption = 'Accrual Account No.';
            TableRelation = "G/L Account";
        }

        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
        field(50000; "OBF-Entity ID"; Code[20])
        {
            Caption = 'Entity ID';
            //ToolTip = 'Needed for Multi Entity Management';
        }
        
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Rebate Amount")
        {
            SumIndexFields = "Rebate Amount";
        }
    }

    fieldgroups
    {
    }

    procedure ShowSourceDoc()
    var
        SalesHeader: Record "Sales Header";
    begin

        SalesHeader.SetRange("Document Type", "Source Type");
        SalesHeader.SetRange("No.", "Source No.");
        case "Source Type" of
            "Source Type"::Order:
                begin
                    PAGE.Run(PAGE::"Sales Order", SalesHeader);
                end;
            "Source Type"::Invoice:
                begin
                    PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                end;
            "Source Type"::"Credit Memo":
                begin
                    PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                end;
            "Source Type"::"Return Order":
                begin
                    PAGE.Run(PAGE::"Sales Return Order", SalesHeader);
                end;
        end;
    end;

    procedure UpdateRebateAmount()
    var
        Currency: Record Currency;
    begin
        Currency.InitRoundingPrecision;
        case "Calculation Basis" of
            "Calculation Basis"::"Dollar per Unit":
                "Rebate Amount" := Round("Rebate Quantity" * "Rebate Value", Currency."Amount Rounding Precision");
            "Calculation Basis"::"Percent of Sales":
                "Rebate Amount" := Round("Sales Line Amount" * 0.01 * "Rebate Value", Currency."Amount Rounding Precision");
        end;
    end;

    procedure UpdateRebateQuantity()
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        SalesLine: Record "Sales Line";
    begin
        if ("Item No." = '') or ("Rebate Unit of Measure" = '') then begin
            "Rebate Quantity" := 0;
            exit;
        end;

        if not ItemUnitOfMeasure.Get("Item No.", "Rebate Unit of Measure") then begin
            "Rebate Quantity" := 0;
            exit;
        end;

        if not SalesLine.Get("Source Type", "Source No.", "Source Line No.") then begin
            "Rebate Quantity" := 0;
            exit;
        end;

        "Rebate Quantity" := SalesLine."Quantity (Base)" * ItemUnitOfMeasure."OBF-Qty. per Base UOM";
    end;
}