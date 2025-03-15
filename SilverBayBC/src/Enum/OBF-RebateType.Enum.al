// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates

enum 50011 "OBF-Rebate Type"
{
    Caption = 'Rebate Type';
    Extensible = true;

    value(0; "Off-Invoice") { }
    value(2; Accrual) { }
}