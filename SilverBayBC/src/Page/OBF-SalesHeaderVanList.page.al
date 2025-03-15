// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
page 50001 "OBF-Sales Header Van List"
{
    AutoSplitKey = true;
    ApplicationArea = all;
    PageType = List;
    SourceTable = "OBF-SalesHeader Van";
    UsageCategory = Documents;
    Caption = 'Sales Header Van List';

    layout
    {
        area(content)
        {
            repeater(VanList)
            {
                field("Van No.";Rec."Van No.")
                {
                }
            }
        }
    }
}