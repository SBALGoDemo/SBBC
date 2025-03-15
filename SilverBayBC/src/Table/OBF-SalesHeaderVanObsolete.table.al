// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
table 50099 "OBF-Sales Header Van"
{
    DataClassification = CustomerContent;
    ObsoleteState = Pending;
    ObsoleteReason = 'Replaced by table "OBF-SalesHeader Van';
    
    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Van No."; Code[20])
        {
            Caption = 'Van No.';
        }        
    }
    
    keys
    {
        key(Key1; "Document Type", "Document No.", "Van No.")
        {
            Clustered = true;
        }
    }
    
}