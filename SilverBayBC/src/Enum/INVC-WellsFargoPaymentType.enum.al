// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
enum 50120 "INVC Wells Fargo Payment Type"
{
    Extensible = true;

    value(0; None)
    {
        Caption = '(None)';
    }
    value(1; Check)
    {
        Caption = 'Check Payment';
    }
    value(2; ACH)
    {
        Caption = 'ACH Payment';
    }
}
