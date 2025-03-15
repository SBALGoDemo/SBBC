// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50008 "OBF-Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"),"CIP Code Blocked" = const(false));
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        field(50002; "OBF-MSC Certification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MSC Certification';    
        }
        field(50003; "OBF-RFM Certification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'RFM Certification';    
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50021; "OBF-Line Net Weight"; Decimal)
        {
            Caption = 'Line Net Weight';
            Editable = false;
        }  
        field(54001; "OBF-Off Invoice Rebate Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("OBF-Rebate Ledger Entry"."Rebate Amount" WHERE("Source Type" = FILTER("Posted Invoice"),
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