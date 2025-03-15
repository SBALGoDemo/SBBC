// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2313 - Add Item Attribute Value Mapping API Page
page 50048 "OBF-Item Attribute Mapping API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFItemAttributeValueMappingAPI';
    EntitySetCaption = 'OBFItemAttributeValueMappingAPI';
    EntityName = 'OBFItemAttributeValueMappingAPI';
    EntitySetName = 'OBFItemAttributeValueMappingAPI';

    SourceTable = "Item Attribute Value Mapping";
    DelayedInsert = true;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableID; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field(ItemNo; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(ItemAttributeID; Rec."Item Attribute ID")
                {
                    ApplicationArea = All;
                }
                field(ItemAttributeValueID; Rec."Item Attribute Value ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}