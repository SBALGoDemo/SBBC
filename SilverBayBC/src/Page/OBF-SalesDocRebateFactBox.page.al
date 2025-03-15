// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50008 "OBF-Sales Doc. Rebate FactBox"
{
    Caption = 'Rebates';
    PageType = CardPart;
    SourceTable = "Sales Header";
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            field("OBF-Off Invoice Rebate Total";Rec."OBF-Off Invoice Rebate Total")
            {
                ApplicationArea = all;
            }

            field("OBF-Accrual Rebate Total"; Rec."OBF-Accrual Rebate Total")
            {
                ApplicationArea = all;
            }
        }
    }
}