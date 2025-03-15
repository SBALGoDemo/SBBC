// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
table 50010 "OBF-Netsuite Purch Inv. Line"
{
    Caption = 'Netsuite Purchase Invoice Line';
    DrillDownPageID = "Posted Purchase Invoice Lines";
    LookupPageID = "Posted Purchase Invoice Lines";
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(1; "Document Type"; enum "OBF-Netsuite Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "OBF-Netsuite Purch Inv. Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Purchase Line Type")
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
        field(50; Status; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(60; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }

        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(999; "Sell-to Vendor No."; Code[20])
        {
            Caption = 'Sell-to Vendor No.';
            Editable = false;
            TableRelation = Vendor;
            ObsoleteState = Pending;
            ObsoleteReason = 'Bad Name';
        }
    }
    keys
    {
        key(Key1; "Document No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.")
        {
        }
    }
    
    procedure SetAdditionalFields()
    var
        NetsuitePurchaseHeader: Record "OBF-Netsuite Purch Inv. Header";
        NetsuitePurchaseLine: Record "OBF-Netsuite Purch Inv. Line";
    begin
        NetsuitePurchaseHeader.find('-');
        repeat
            NetsuitePurchaseLine.SetRange("Document No.",NetsuitePurchaseHeader."No.");
            NetsuitePurchaseLine.FindSet();
            repeat
                NetsuitePurchaseLine."Document Type" := NetsuitePurchaseHeader."Document Type";
                NetsuitePurchaseLine."Vendor No." := NetsuitePurchaseHeader."Vendor No.";
                NetsuitePurchaseLine."Vendor Name" := NetsuitePurchaseHeader."Vendor Name";
                NetsuitePurchaseLine."Posting Date" := NetsuitePurchaseHeader."Posting Date";
                NetsuitePurchaseLine."External Document No." := NetsuitePurchaseHeader."External Document No.";
                NetsuitePurchaseLine.Status := NetsuitePurchaseHeader.Status;
                NetsuitePurchaseLine.Modify();
            until(NetsuitePurchaseLine.Next()=0);
        until(NetsuitePurchaseHeader.Next()=0);
        Message('Done'); 
    end;
}