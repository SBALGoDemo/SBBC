// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1650 - Fixed Assets
pageextension 50032 "OBF-Fixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        addafter("Bssi Global Dimension 1 Code")
        {
            field("OBF-Site Code"; Rec."OBF-Site Code")
            {
                ApplicationArea = All;
            }
            field("OBF-Original Cost"; Rec."OBF-Original Cost")
            {
                ApplicationArea = All;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2162 - Add Purchase Date to Fixed Assets List
            field("OBF-Purchase Date"; Rec."OBF-Purchase Date")
            {
                ApplicationArea = All;
            }

            field("OBF-Depreciation Start Date"; Rec."OBF-Depreciation Start Date")
            {
                ApplicationArea = All;
            }
            field("OBF-Accumulated Depreciation"; Rec."OBF-Accumulated Depreciation")
            {
                ApplicationArea = All;
            }
            field("OBF-Current Cost"; Rec."OBF-Current Cost")
            {
                ApplicationArea = All;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1912 - Fixed Asset List Enhancements
            field(Inactive; Rec.Inactive)
            {
                ApplicationArea = All;
            }
            field(DepreciationYears; FADepreciationBook."No. of Depreciation Years")
            {
                Caption = 'No. of Depreciation Years';
                ApplicationArea = All;
            }
            field(DepreciationEndingDate; FADepreciationBook."Depreciation Ending Date")
            {
                Caption = 'Depreciation Ending Date';
                ApplicationArea = All;
            }
            field(LastDepreciationAmount; FALedgerEntry.Amount)
            {
                Caption = 'Last Depreciation Amount';
                ApplicationArea = All;
            }

        }
    }


    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1912 - Fixed Asset List Enhancements    
    trigger OnAfterGetRecord()
    begin
        if not FADepreciationBook.Get(Rec."No.", 'COMPANY') then
            FADepreciationBook.Init();
        FALedgerEntry.SetRange("FA No.", Rec."No.");
        FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
        if not FALedgerEntry.FindLast() then
            FALedgerEntry.Init();
    end;

    var
        FADepreciationBook: Record "FA Depreciation Book";
        FALedgerEntry: Record "FA Ledger Entry";
}