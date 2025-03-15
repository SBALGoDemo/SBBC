// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50010 "OBF-Post Rebates Subform"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "OBF-Rebate Ledger Entry";
    SourceTableView = where("Posted to Customer" = const(false),"Rebate Type"=const(Accrual));
    DataCaptionFields = "Entry No.", "Source No.";
    Caption = 'Lines';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
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
                field("Posting Date"; Rec."Posting Date")
                {
                    Importance = Standard;
                    ApplicationArea = all;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Posted to Customer"; Rec."Posted to Customer")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1272 - Need Post Rebates Request Page
    procedure AccrueRebates(DocumentNo: Code[20]; PostingDate: Date)
    var
        RebateLedgerEntriesToPost: Record "OBF-Rebate Ledger Entry";
        RebateManagement: Codeunit "OBF-Rebate Management";
    begin
        CurrPage.SetSelectionFilter(RebateLedgerEntriesToPost);
        RebateManagement.AccrueRebateToCustomer(RebateLedgerEntriesToPost, Rec."Bill-to Customer No.",DocumentNo,PostingDate);
        CurrPage.Update();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/680 - Mark rebates line as "closed" without posting to customer ledger
    procedure CloseRebatesWithoutPosting();
    var
        RebateLedgerEntriesToPost: Record "OBF-Rebate Ledger Entry";
        RebateManagement: Codeunit "OBF-Rebate Management";
    begin
        CurrPage.SetSelectionFilter(RebateLedgerEntriesToPost);
        RebateManagement.CloseRebatesWithoutPosting(RebateLedgerEntriesToPost, Rec."Bill-to Customer No.");
        CurrPage.Update();
    end;

    procedure GetSelectionFilter(): Text
    var
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(RebateLedgerEntry);
        exit(GetSelectionFilterForRebateLedgerEntry(RebateLedgerEntry));
    end;

    procedure GetSelectionFilterForRebateLedgerEntry(var RebateLedgerEntry: Record "OBF-Rebate Ledger Entry"): Text
    var
        RecRef: RecordRef;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        RecRef.GetTable(RebateLedgerEntry);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, RebateLedgerEntry.FieldNo("Entry No.")));
    end;
}