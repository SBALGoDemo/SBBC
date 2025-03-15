// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50002 "OBF-Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            begin
                SubDimension.UpdateDimSetIDForSubDimension('SITE', "OBF-Site Code", Rec."Dimension Set ID");
            end;
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            begin
                SubDimension.UpdateDimSetIDForSubDimension('CIP', "OBF-CIP Code", Rec."Dimension Set ID");
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50010; "OBF-Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = ToBeClassified;
        }
        field(50011; "OBF-Rebate Ledger Entry No."; Integer)
        {
            Caption = 'Rebate Ledger Entry No.';
            DataClassification = ToBeClassified;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
        field(50120; "INVC WF Payment Type"; Enum "INVC Wells Fargo Payment Type")
        {
            Caption = 'Wells Fargo Payment Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Method"."INVC WF Export Type" where(Code = field("Payment Method Code")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1786 - Add "Our Account No." to General Journal
        field(50200; "OBF-Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            Editable = False;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1786 - Add "Our Account No." to General Journal
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
            begin
                Rec."OBF-Our Account No." := '';

                if (Rec."Account Type" = Rec."Account Type"::Vendor) then
                    if Vendor.Get(Rec."Account No.") then
                        Rec."OBF-Our Account No." := Vendor."Our Account No.";
            end;
        }

        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code" then begin
                    SubDimension.RemoveSubDimensionsFromDimSetID(Rec."Dimension Set ID");
                    Rec."OBF-Site Code" := '';
                    Rec."OBF-CIP Code" := '';
                end;
            end;
        }
    }

    var
        SubDimension: Codeunit "OBF-Sub Dimension";
}
