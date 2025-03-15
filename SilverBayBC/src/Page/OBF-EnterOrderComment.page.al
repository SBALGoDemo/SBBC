// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50089 "OBF-Enter Order Comment"
{
    PageType = Card;
    SourceTable = "Sales Header";
    Caption = 'Enter Order Comment';
    UsageCategory = None;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CommentText; CommentText)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    Width = 500;
                }
            }
        }
    }

    actions
    {
    }

    var
        CommentText: Text[1000];

    procedure GetCommentText(var pCommentText: Text);
    begin
        pCommentText := CommentText;
    end;
}

