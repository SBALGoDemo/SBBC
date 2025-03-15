    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1892 - Create new SBS Non Corp Company in Business Central
pageextension 50118 "OBF-Location List" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2";Rec."Name 2")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Promoted;
            }
        }
    }
}