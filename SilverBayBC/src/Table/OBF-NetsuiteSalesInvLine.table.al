// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
table 50008 "OBF-Netsuite Sales Inv. Line"
{
    Caption = 'Netsuite Sales Invoice Line';
    DrillDownPageID = "OBF-Netsuite Sales History";
    LookupPageID = "OBF-Netsuite Sales History";
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(1; "Document Type"; enum "OBF-Netsuite Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "OBF-Netsuite Sales Inv. Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge";
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Unit Price"; Decimal)
        {
            DecimalPlaces = 2:2;
            Caption = 'Unit Price';
        }
        field(29; Amount; Decimal)
        {
            DecimalPlaces = 2:2;
            Caption = 'Amount';
        }
        field(31; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(41; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Subsidiary Code"));
            Caption = 'Site Code';
        }
        field(70; Status; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
    }
    keys
    {
        key(Key1; "Document No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Sell-to Customer No.")
        {
        }
    }

    procedure SetCustomerAndPostingDate()
    var
        NetsuiteSalesHeader: Record "OBF-Netsuite Sales Inv. Header";
        NetsuiteSalesLine: Record "OBF-Netsuite Sales Inv. Line";
    begin
        NetsuiteSalesHeader.find('-');
        repeat
            NetsuiteSalesLine.SetRange("Document No.",NetsuiteSalesHeader."No.");
            NetsuiteSalesLine.FindSet();
            repeat
                NetsuiteSalesLine."Document Type" := NetsuiteSalesHeader."Document Type";
                NetsuiteSalesLine."Sell-to Customer No." := NetsuiteSalesHeader."Sell-to Customer No.";
                NetsuiteSalesLine."Sell-to Customer Name" := NetsuiteSalesHeader."Sell-to Customer Name";
                NetsuiteSalesLine."Posting Date" := NetsuiteSalesHeader."Posting Date";
                NetsuiteSalesLine.Status := NetsuiteSalesHeader.Status;
                NetsuiteSalesLine."External Document No." := NetsuiteSalesHeader."External Document No.";
                NetsuiteSalesLine.Modify();
            until(NetsuiteSalesLine.Next()=0);
        until(NetsuiteSalesHeader.Next()=0);
        Message('Done'); 

    end;
}