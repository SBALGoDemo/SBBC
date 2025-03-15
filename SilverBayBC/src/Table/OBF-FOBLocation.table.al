// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
table 50011 "OBF-FOB Location"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "OBF-FOB Locations";
    LookupPageID = "OBF-FOB Locations";

    fields
    {
        field(1;Code;Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(70; "Sales Type"; enum "OBF-FOB Location Sales Type")
        {
            Caption = 'Sales Type';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Code,Description,"Sales Type")
        {
        }
    }
}

