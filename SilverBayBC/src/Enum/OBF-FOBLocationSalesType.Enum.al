// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
enum 50021 "OBF-FOB Location Sales Type"
{
    Extensible = true;

    value(0; " ") { }
    value(1; "Washington State") { }
    value(2; Interstate) { }
    value(3; International) { }
    value(4; "OB JV Settlement") { }
}