// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50005 "OBF-Rebate Ledger Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = "OBF-Rebate Ledger Entry";
    UsageCategory = Lists;
    Caption = 'Rebate Ledger Entries';
    DataCaptionFields = "Entry No.", "Source No.";
    ApplicationArea = all;
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

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1910 - Create Custom Queries for Silver Bay Commission report
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Broker";Rec."Customer Broker")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Broker";Rec."Ship-to Broker")  
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

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1910 - Create Custom Queries for Silver Bay Commission report
                field("No. of Cases";Rec."No. of Cases")
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

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1433 - Add "Accrued Amount" to Rebate Ledger Entry table
                field("Accrued Amount"; Rec."Accrued Amount")
                {
                    ApplicationArea = all;
                }
                
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
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

    actions
    {
        area(processing)
        {
            group(Entry)
            {
                Caption = 'Entry';
                action("<Action1101769002>")
                {
                    Caption = 'Rebate Card';
                    Image = Document;
                    RunObject = Page "OBF-Rebate Card";
                    RunPageLink = Code = field("Rebate Code");
                    RunPageView = sorting(Code);
                    ShortCutKey = 'Shift+F7';
                }
                separator(Action100000021)
                {
                }
                action(ShowSourceDocument)
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

                action(CustomerLedgerEntries)
                {
                    Caption = 'Customer Ledger Entries';
                    Image = Account;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Document No." = field("Source No.");
                }
                action(GeneralLedgerEntries)
                {
                    Caption = 'General Ledger Entries';
                    Image = Account;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "Document No." = field("Source No.");
                }
            }
        }
    }
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