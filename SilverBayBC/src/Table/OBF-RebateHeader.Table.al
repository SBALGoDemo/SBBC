// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
table 50002 "OBF-Rebate Header"
{
    LookupPageID = "OBF-Rebate List";
    DrillDownPageID = "OBF-Rebate List";
    Caption = 'Rebate Header';

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(40; "Rebate Type"; enum "OBF-Rebate Type")
        {
            Caption = 'Rebate Type';
            trigger OnValidate()
            begin
                SetDefaultRebateExpenseAccount();
                SetDefaultAccrualAccountNo();
            end;
        }
        field(50; "Calculation Basis"; enum "OBF-Rebate Calculation Basis")
        {
            Caption = 'Calculation Basis';
            trigger OnValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                if "Calculation Basis" = "Calculation Basis"::"Percent of Sales" then
                    "Unit of Measure Code" := ''
                else begin
                    SalesSetup.Get();
                    "Unit of Measure Code" := SalesSetup."OBF-Rebate Default UOM";
                end;
            end;
        }
        field(60; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if ("Calculation Basis" = filter("Dollar per Unit")) "Unit of Measure".Code;
        }
        field(80; "Start Date"; Date)
        {
            Caption = 'Start Date';
            trigger OnValidate()
            begin
                if ("Start Date" > "End Date") and ("End Date" <> 0D) then
                    Error(Text005);
            end;
        }
        field(90; "End Date"; Date)
        {
            Caption = 'End Date';
            trigger OnValidate()
            begin
                if "End Date" <> 0D then
                    if ("End Date" < "Start Date") and ("Start Date" <> 0D) then
                        Error(Text005);
            end;
        }
        field(120; "Expense G/L Account"; Code[20])
        {
            Caption = 'Expense G/L Account';
            TableRelation = "G/L Account";
        }
        field(130; "Accrual Account No."; Code[20])
        {
            Caption = 'Accrual Account No.';
            TableRelation = "G/L Account";
        }
        field(140; "Customer Rebate Line Exists"; Boolean)
        {
            Caption = 'Customer Rebate Line Exists';
            FieldClass = FlowField;
            CalcFormula = exist("OBF-Rebate Line" where("Rebate Code" = field(Code), Source = const(Customer)));
            Editable = false;
        }

        field(220; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(310; "Temp Ship-to Code"; Code[10])
        {
            Caption = 'Temp Ship-to Code';
        }
        field(320; "Temp Customer Rebate Value"; Decimal)
        {
            Caption = 'Temp Customer Rebate Value';
        }
        field(330; "Temp Rebate Line No."; Integer)
        {
            Caption = 'Temp Rebate Line No.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RebateEntry: Record "OBF-Rebate Entry";
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
        RebateLine: Record "OBF-Rebate Line";
    begin
        RebateLedgerEntry.SetRange("Rebate Code", Rec.Code);
        if not RebateLedgerEntry.IsEmpty then
            Error('You may not delete Rebate %1 because Rebate Ledger Entries exist for this Rebate.', Rec.Code);

        RebateEntry.SetRange("Rebate Code", Rec.Code);
        if not RebateEntry.IsEmpty then
            Error('You may not delete Rebate %1 because Rebate Entries exist for this Rebate.', Rec.Code);

        RebateLine.Reset();
        RebateLine.SetRange("Rebate Code", Code);
        RebateLine.DeleteAll();
    end;

    trigger OnInsert()
    var
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1804 - Upgrade to BC24
        NoSeries: Codeunit "No. Series";

    begin

        if Code = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("OBF-Rebate Nos.");

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1804 - Upgrade to BC24
            "No. Series" := SalesSetup."OBF-Rebate Nos.";
            if NoSeries.AreRelated(SalesSetup."OBF-Rebate Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            Code := NoSeries.GetNextNo("No. Series");

        end;

        SetDefaultRebateExpenseAccount();
        SetDefaultAccrualAccountNo();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Text005: Label 'Start Date must not be greater than End Date.';

    procedure AssistEdit(OldRebate: Record "OBF-Rebate Header"): Boolean
    var
        Rebate: Record "OBF-Rebate Header";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1804 - Upgrade to BC24
        NoSeries: Codeunit "No. Series";

    begin
        Rebate := Rec;
        SalesSetup.Get();
        SalesSetup.TestField(SalesSetup."OBF-Rebate Nos.");

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1804 - Upgrade to BC24
        if NoSeries.LookupRelatedNoSeries(SalesSetup."OBF-Rebate Nos.", OldRebate."No. Series", Rebate."No. Series") then begin
            NoSeries.GetNextNo(Rebate.Code);

            Rec := Rebate;
            exit(true);
        end;
    end;

    procedure SetDefaultRebateExpenseAccount()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        "Expense G/L Account" := SalesSetup."OBF-Rebate Expense Account";
    end;

    procedure SetDefaultAccrualAccountNo()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        case "Rebate Type" of
            "Rebate Type"::Accrual:
                "Accrual Account No." := SalesSetup."OBF-Rebate Acc. Offset Account";
            "Rebate Type"::"Off-Invoice":
                "Accrual Account No." := '';
        end;
    end;

    procedure ExistingRebateEntriesCheck(RebateCode: Code[10])
    var
        RebateEntry: record "OBF-Rebate Entry";
        RebateLedgerEntry: Record "OBF-Rebate Ledger Entry";
    begin
        RebateEntry.SetRange("Rebate Code", RebateCode);
        if not RebateEntry.IsEmpty then
            Error('There are existing Rebate Entries for Rebate Code %1', RebateCode);

        RebateLedgerEntry.SetRange("Rebate Code", RebateCode);
        if not RebateLedgerEntry.IsEmpty then
            Error('There are existing Rebate Ledger Entries for Rebate Code %1', RebateCode);
    end;
}