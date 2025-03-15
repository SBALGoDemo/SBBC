// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50090 "OBF-Sales Comments FactBox"
{
    AutoSplitKey = true;
    Caption = 'Sales Comments';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = "Sales Comment Line";
    SourceTableView = sorting("OBF-Revision No.");
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("OBF-Revision No."; Rec."OBF-Revision No.")
                {
                    ApplicationArea = All;
                }
                field("Print On Pick Ticket"; Rec."Print On Pick Ticket")
                {
                    ApplicationArea = All;
                    Caption = 'Print on Shipping Release';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenCommentsPage)
            {
                Caption = 'Open';
                ShortCutKey = 'Return';
                ApplicationArea = All;
                trigger OnAction();
                begin
                    ShowDetails;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.SetUpNewLine;
    end;

    procedure ShowDetails();
    begin
        Page.Run(Page::"Sales Comment Sheet", Rec);
    end;
}