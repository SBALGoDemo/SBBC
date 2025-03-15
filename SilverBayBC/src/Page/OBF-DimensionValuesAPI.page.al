// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
page 50021 "OBF-Dimension Values API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFDimensionValuesAPI';
    EntitySetCaption = 'OBFDimensionValuesAPI';
    EntityName = 'OBFDimensionValuesAPI';
    EntitySetName = 'OBFDimensionValuesAPI';

    SourceTable = "Dimension Value";
    DelayedInsert = true;

   
   layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(DimensionCode; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the code for the dimension value.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies a descriptive name for the dimension value.';
                }
                field(DimensionValueType; Rec."Dimension Value Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose of the dimension value.';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.';

               }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field(CoupaLookupID;Rec."OBF-Coupa Lookup ID")
                {
                    ApplicationArea = All;
                }
   
            }
        }
    }

}