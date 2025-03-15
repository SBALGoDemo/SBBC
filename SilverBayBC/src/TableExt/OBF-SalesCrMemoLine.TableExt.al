// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
tableextension 50022 "OBF-Sales Cr. Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50020; "OBF-Exclude from Weight Calc."; Boolean)
        {
            Caption = 'Exclude from Weight Calculation';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."OBF-Exclude from Weight Calc."
                                    where("No." = field("No.")));
            editable = false;
        }
        field(50021; "OBF-Line Net Weight"; Decimal)
        {
            Caption = 'Line Net Weight';
            Editable = false;
        }
        field(54001; "OBF-Off Invoice Rebate Amount"; Decimal)
        {
            Caption = 'Off Invoice Rebate Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("OBF-Rebate Ledger Entry"."Rebate Amount" WHERE("Source Type" = FILTER("Posted Cr. Memo"),
                                                                        "Source No." = FIELD("Document No."),
                                                                         "Source Line No." = FIELD("Line No."),
                                                                         "Rebate Type" = FILTER("Off-Invoice")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
        field(54002; "OBF-Header Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Header Subsidiary Code';
        }

        field(54003; "OBF-Item Description"; Text[100])
        {
            Caption = 'Item Description';
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54004; "OBF-Item Category Description"; Text[100])
        {
            Caption = 'Item Category Description';
            CalcFormula = Lookup("Item Category".Description WHERE(Code = FIELD("Item Category Code")));
            Editable = false;
            FieldClass = FlowField;
        }                
    }
}