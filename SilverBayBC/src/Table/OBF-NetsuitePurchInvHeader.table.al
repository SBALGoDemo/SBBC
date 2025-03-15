// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
table 50009 "OBF-Netsuite Purch Inv. Header"
{
    Caption = 'Netsuite Purch. Invoice Header';
    DataCaptionFields = "Document Type", "No.", "Vendor Name";
    DrillDownPageID = "OBF-Netsuite Purch. Hist. List";
    LookupPageID = "OBF-Netsuite Purch. Hist. List"; 

    fields
    {
        field(1; "Document Type"; enum "OBF-Netsuite Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; Status; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(79; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {            
        }
    }
}