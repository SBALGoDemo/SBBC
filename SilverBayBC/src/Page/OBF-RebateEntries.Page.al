// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50006 "OBF-Rebate Entries"
{
    Editable = false;
    DeleteAllowed = true;
    PageType = List;
    SourceTable = "OBF-Rebate Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Rebate Entries';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Rebate Code"; Rec."Rebate Code")
                {
                    ApplicationArea = all;
                }
                field("Rebate Description"; Rec."Rebate Description")
                {
                    ApplicationArea = all;
                }
                field("Rebate Line No."; Rec."Rebate Line No.")
                {
                    ApplicationArea = all;
                }
                field("Rebate Type"; Rec."Rebate Type")
                {
                    ApplicationArea = all;
                }
                field("Calculation Basis"; Rec."Calculation Basis")
                {
                    ApplicationArea = all;
                }
                field("Rebate Quantity"; Rec."Rebate Quantity")
                {
                    ApplicationArea = all;
                }
                field("Rebate Unit of Measure"; Rec."Rebate Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Sales Line Amount"; Rec."Sales Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Rebate Value"; Rec."Rebate Value")
                {
                    ApplicationArea = all;
                }

                field("Rebate Amount"; Rec."Rebate Amount")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Entry)
            {
                Caption = 'Entry';
                action(UpdateRebateEntries)
                {
                    Caption = 'Update Rebate Entries';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        RebateManagement: Codeunit "OBF-Rebate Management";
                    begin
                        RebateManagement.GetRebates(SalesHeader);
                        CurrPage.Update();
                    end;
                }
                action(RebateCard)
                {
                    Caption = 'Rebate Card';
                    Image = Document;
                    RunObject = Page "OBF-Rebate Card";
                    RunPageLink = Code = FIELD("Rebate Code");
                    RunPageView = SORTING(Code);
                    ShortCutKey = 'Shift+F7';

                }
                separator(Action100000019)
                {
                }
                action("Show Source Document")
                {
                    Caption = 'Show Source Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;


                    trigger OnAction()
                    begin
                        Rec.ShowSourceDoc();
                    end;
                }
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";

    procedure SetSalesHeader(pSalesHeader: Record "Sales Header")
    begin
        SalesHeader := pSalesHeader;
    end;
}


