// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2331 - Create Item Categories API Page
page 50049 "OBF-Item Categories API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFItemCategoriesAPI';
    EntitySetCaption = 'OBFItemCategoriesAPI';
    EntityName = 'OBFItemCategoriesAPI';
    EntitySetName = 'OBFItemCategoriesAPI';

    SourceTable = "Item Category";
    DelayedInsert = true;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(ParentCategory; Rec."Parent Category")
                {
                    ApplicationArea = All;
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}