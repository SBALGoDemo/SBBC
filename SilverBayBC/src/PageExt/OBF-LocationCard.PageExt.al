// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
pageextension 50117 "OBF-Location Card" extends "Location Card"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1892 - Create new SBS Non Corp Company in Business Central
        addafter(Name)
        {
            field("Name 2";Rec."Name 2")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }
        }
        
        addafter("Bin Policies")
        {
            group(OBF_Extension)
            {
                Caption = 'Extension';
                field("OBF-EDI Enabled"; Rec."OBF-EDI Enabled")
                {
                    ApplicationArea = all;
                    Visible = true;
                    Importance = Promoted;
                }
            }
        }
    }
}