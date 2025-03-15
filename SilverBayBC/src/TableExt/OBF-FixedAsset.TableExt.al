// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1650 - Fixed Assets
tableextension 50009 "OBF-Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Global Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                Rec.ValidateShortcutDimCode(3, "OBF-Site Code");
            end;
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Global Dimension 1 Code"));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(4, "OBF-CIP Code");
            end;
        }
        field(50002; "OBF-Original Cost"; Decimal)
        {
            Caption = 'Original Cost';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Ledger Entry".Amount where("FA No." = field("No."), "FA Posting Type" = const("Acquisition Cost")));
            Editable = false;
        }
        field(50003; "OBF-Depreciation Start Date"; Date)
        {
            Caption = 'Depreciation Start Date';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Depreciation Book"."Depreciation Starting Date" where("FA No." = field("No.")));
            Editable = false;
        }
        field(50004; "OBF-Accumulated Depreciation"; Decimal)
        {
            Caption = 'Accumulated Depreciation';
            FieldClass = FlowField;
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("No."), "FA Posting Type" = const(Depreciation), "Posting Date" = FIELD("OBF-Date Filter")));
            Editable = false;
        }
        field(50005; "OBF-Current Cost"; Decimal)
        {
            Caption = 'Current Cost';
            FieldClass = FlowField;
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("No."), "Posting Date" = FIELD("OBF-Date Filter")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2162 - Add Purchase Date to Fixed Assets List
        field(50006; "OBF-Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Ledger Entry"."Document Date" where("FA No." = field("No."), "FA Posting Type" = const("Acquisition Cost")));
            Editable = false;
        }

        field(50055; "OBF-Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then begin
                    Rec."OBF-Site Code" := '';
                    Rec."OBF-CIP Code" := '';
                end;
            end;
        }
    }
}