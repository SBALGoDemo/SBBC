// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
page 50023 "OBF-ZD Add Sales Doc. Type"

{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Integer;
    Caption = 'Add Zetadocs Sales Document Type';
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(TitleText; TitleText)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Title Text';
                }
                field(AddText; OptionMembers)
                {
                    ApplicationArea = All;
                    Caption = 'ZD Sales Document Type';
                }
            }
        }
    }

    var
        TitleText: Text;
        OptionMembers: Enum "OBF-ZD Sales Document Type";

    procedure GetAddText() RetAddText: Text
    begin
        if OptionMembers.AsInteger() = 0 then 
            RetAddText := 'Order Confirmation'
        else
            RetAddText := Format(OptionMembers);
    end;

    procedure AddTitleInfo(TitleInfo: Text)
    begin
        TitleText := TitleInfo;
    end;

}