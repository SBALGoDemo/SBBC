pageextension 50890 "INVC Data Exch. Line Def." extends "Data Exch Def Card"
{
    layout
    {
        addlast(General)
        {
            field("INVC Has Addenda Line"; Rec."INVC Has Addenda Line")
            {
                ApplicationArea = All;
                Caption = 'Has Addenda Line';
                ToolTip = 'Indicates if the Data Exchange has an addenda line and will correctly calculate the 2nd Detail line (addenda) with the appropriate custom INVC Line No. field value (used for ACH comment lines).';
            }
        }
    }
}