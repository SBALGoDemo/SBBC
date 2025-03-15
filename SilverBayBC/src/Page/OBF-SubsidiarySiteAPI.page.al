// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1784 - Create Misc. APIs
page 50046 "OBF-Subsidiary Site API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFSubsidiarySiteAPI';
    EntitySetCaption = 'OBFSubsidiarySiteAPI';
    EntityName = 'OBFSubsidiarySiteAPI';
    EntitySetName = 'OBFSubsidiarySiteAPI';

    SourceTable = "OBF-Subsidiary Site";
    DelayedInsert = true;

   
   layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(SubsidiaryCode; Rec."Subsidiary Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field(SiteCode; Rec."Site Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the code for the dimension value.';
                }
            }
        }
    }

}