// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
table 50001 "OBF-SalesHeader Van"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(5; "Van No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Van No.';
        }        
    }
    
    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    
}