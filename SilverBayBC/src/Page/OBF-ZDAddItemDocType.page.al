// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
page 50025 "OBF-ZD Add Item Doc. Type"

{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Integer;
    Caption = 'Add Zetadocs Item Document Type';
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
                    Caption = 'ZD Item Document Type';
                }
            }
        }
    }

    var
        TitleText: Text;
        OptionMembers: Enum "OBF-ZD Item Document Type";

    procedure GetAddText() RetAddText : Text
    begin
        RetAddText := Format(OptionMembers);
    end;

    procedure GetOrdinalValue() OrdinalValue : Integer;
    begin
        OrdinalValue := OptionMembers.AsInteger();
    end;

    procedure AddTitleInfo(TitleInfo : Text)
    begin
        TitleText := TitleInfo;
    end;

}