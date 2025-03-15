// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
table 50007 "OBF-Netsuite Sales Inv. Header"
{
    Caption = 'Netsuite Sales Invoice Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "OBF-Netsuite Sales Hist. List";
    LookupPageID = "OBF-Netsuite Sales Hist. List";

    fields
    {
        field(1; "Document Type"; enum "OBF-Netsuite Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
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
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {            
        }
    }
}