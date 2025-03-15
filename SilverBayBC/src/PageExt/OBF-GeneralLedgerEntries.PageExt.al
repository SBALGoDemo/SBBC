// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1651 - Intercompany Transactions - Multi Entity Accounting addon
pageextension 50021 "OBF-General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1714 - Show Credit and Debit Amount on Journals and Ledger Entries
        modify(Amount)
        {
            Visible = false;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addafter("External Document No.")
        {
            field(SourceName; SourceName)
            {
                Caption = 'Source Name';
                Editable = false;
                ApplicationArea = all;
            }
            field("OBF-Rebate Code"; Rec."OBF-Rebate Code")
            {
                Caption = 'Rebate Code';
                Editable = false;
                ApplicationArea = all;
            }
            field("OBF-Rebate Ledger Entry No."; Rec."OBF-Rebate Ledger Entry No.")
            {
                Caption = 'Rebate Ledger Entry No.';
                Editable = false;
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
                    RebateLedgerEntries: page "OBF-Rebate Ledger Entries";
                begin
                    if Rec."OBF-Rebate Ledger Entry No." = 0 then
                        exit;
                    RebateLedgerEntry.SetRange("Entry No.", Rec."OBF-Rebate Ledger Entry No.");
                    RebateLedgerEntries.SetTableView(RebateLedgerEntry);
                    RebateLedgerEntries.RunModal();
                end;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1715 - Show Due-to and Due-From on Ledger Entries
        addlast(Control1)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }

            // field(BssiEntityID;Rec.BssiEntityID)
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiDuetoDuefrom;Rec.BssiDuetoDuefrom)
            // {
            //     ApplicationArea = all;
            // }
            // field("Bssi IC Settlement";Rec."Bssi IC Settlement")
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiICDestEntity;Rec.BssiICDestEntity)
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiReportAmount;Rec.BssiReportAmount)
            // {
            //     ApplicationArea = all;
            // }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2106 - G/L Entry Invalid Subsidiary and Site Combinations
            field("OBF-Site Code Issue"; Rec."OBF-Site Code Issue")
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = all;
            }

        }

    }

    var
        SourceName: Text[100];

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1320 - Add Source Name to General Ledger
    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        SourceName := '';
        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                Begin
                    if Customer.Get(Rec."Source No.") then
                        SourceName := Customer.Name;
                End;
            Rec."Source Type"::Vendor:
                Begin
                    if Vendor.Get(Rec."Source No.") then
                        SourceName := Vendor.Name;
                End;
        end;
    end;
}