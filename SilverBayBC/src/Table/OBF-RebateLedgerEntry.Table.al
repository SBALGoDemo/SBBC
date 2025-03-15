// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
table 50005 "OBF-Rebate Ledger Entry"
{
    LookupPageId = "OBF-Rebate Ledger Entries";
    DrillDownPageId = "OBF-Rebate Ledger Entries";
    DataCaptionFields = "Entry No.", "Source No.";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Source Type"; enum "OBF-Rebate Ledger Source Type")
        {
            Caption = 'Source Type';
        }
        field(30; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            trigger OnLookup()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                PostedSalesInvoice: Page "Posted Sales Invoice";
                PostedSalesCrMemo: Page "Posted Sales Credit Memo";
            begin
                case "Source Type" of
                    "Source Type"::"Posted Invoice":
                        begin
                            SalesInvoiceHeader.Get("Source No.");
                            PostedSalesInvoice.SetRecord(SalesInvoiceHeader);
                            PostedSalesInvoice.Run();
                        end;
                    "Source Type"::"Posted Cr. Memo":
                        begin
                            SalesCrMemoHeader.Get("Source No.");
                            PostedSalesCrMemo.SetRecord(SalesCrMemoHeader);
                            PostedSalesCrMemo.Run();
                        end;
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
            TableRelation = Customer;
            Caption = 'Sell-to Customer No.';
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
        field(201; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            CalcFormula = Lookup("Ship-to Address".City WHERE("Customer No." = FIELD("Sell-to Customer No."),
                                                               Code = FIELD("Ship-to Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; "Ship-to State"; Text[30])
        {
            Caption = 'Ship-to State';
            CalcFormula = Lookup("Ship-to Address".County WHERE("Customer No." = FIELD("Sell-to Customer No."),
                                                               Code = FIELD("Ship-to Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Rebate Line No."; Integer)
        {
            Caption = 'Rebate Line No.';
        }
        field(220; "Posted to Customer"; Boolean)
        {
            Caption = 'Posted to Customer';
        }
        field(230; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(240; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1433 - Add "Accrued Amount" to Rebate Ledger Entry table
        field(310; "Accrual Account No."; Code[20])
        {
            Caption = 'Accrual Account No.';
            TableRelation = "G/L Account";
        }
        field(320; "Accrued Amount"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Document No." = FIELD("Source No."),
                                                "G/L Account No." = FIELD("Accrual Account No."),
                                                "OBF-Rebate Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Accrued Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;            
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1910 - Create Custom Queries for Silver Bay Commission report
        field(1000; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            CalcFormula = Lookup("Sales Invoice Header"."External Document No." WHERE("No." = FIELD("Source No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1010; "No. of Cases"; Decimal)
        {
            Caption = 'No. of Cases';
            CalcFormula = Lookup("Sales Invoice Line".Quantity WHERE("Document No." = FIELD("Source No."), "Line No." = field("Source Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1030; "Customer Broker"; Code[20])
        {
            Caption = 'Customer Broker';
            TableRelation = "Dimension Value".Code where ("Dimension Code"=const('BROKER'));
            CalcFormula = Lookup(Customer."OBF-Broker" WHERE("No." = FIELD("Bill-to Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1040; "Ship-to Broker"; Code[20])
        {
            Caption = 'Ship-to Broker';
            TableRelation = "Dimension Value".Code where ("Dimension Code"=const('BROKER'));
            CalcFormula = Lookup("Ship-to Address"."OBF-Ship-to Broker" WHERE("Customer No." = FIELD("Sell-to Customer No."),
                                                               Code = FIELD("Ship-to Code")));
            Editable = false;
            FieldClass = FlowField;
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
    }

    fieldgroups
    {
    }


    procedure ShowSourceDoc()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin

        case "Source Type" of
            "Source Type"::"Posted Invoice":
                begin
                    SalesInvHeader.SetRange("No.", "Source No.");
                    PAGE.Run(Page::"Posted Sales Invoice", SalesInvHeader);
                end;
            "Source Type"::"Posted Cr. Memo":
                begin
                    SalesCrMemoHeader.SetRange("No.", "Source No.");
                    Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                end;
        end;
    end;

    local procedure AfterValidateSourceNo()
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
