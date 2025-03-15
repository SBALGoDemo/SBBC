// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
page 50027 "OBF-FOB Locations"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "OBF-FOB Location";
    UsageCategory = Administration;
    Caption = 'FOB Locations';

    layout
    {
        area(content)
        {
            repeater(Control50000)
            {
                field("Code";Rec.Code)
                {
                }
                field(Description;Rec.Description)
                {
                }
                field("Sales Type";Rec."Sales Type")
                {
                }
            }
        }
    }
}

