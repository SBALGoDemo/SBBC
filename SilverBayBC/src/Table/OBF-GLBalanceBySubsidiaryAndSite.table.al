//https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
table 50112 "OBF-G/L Bal. by Subs. Site"
{
    DataClassification = CustomerContent;
    Caption = 'G/L Balance by Subsidiary and Site';
    DataCaptionFields = "Subsidiary Code", "Site Code";

    fields
    {
        field(1; "G/L Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account No.';
        }
        field(2; "G/L Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No."=field("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
        }
        field(3; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(4; "Subsidiary Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SUBSIDIARY'), Code = field("Subsidiary Code")));
            Caption = 'Subsidiary Name';
            Editable = false;
        }
        field(7; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SITE'));
            Caption = 'Site Code';
        }
        field(8; "Site Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Name';
            Editable = false;
        }
        field(9; "Site Code Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Blocked where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Code Blocked';
            Editable = false;
        }
        field(10; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(31; "Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("G/L Account No."),
                                                        "Global Dimension 1 Code" = field("Subsidiary Code"),
                                                        "OBF-Site Code" = field("Site Code"),
                                                        "Posting Date" = field(UPPERLIMIT("Date Filter"))));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Balance at Date for Subsidiary"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("G/L Account No."),
                                                        "Global Dimension 1 Code" = field("Subsidiary Code"),
                                                        "Posting Date" = field(UPPERLIMIT("Date Filter"))));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "G/L Account No.","Subsidiary Code", "Site Code")
        {
            Clustered = true;
        }
    }

    procedure SetData()
    var
        GLAccount: Record "G/L Account";
        SubsidiarySite: Record "OBF-Subsidiary Site";
        GLBalBySubsSite: Record "OBF-G/L Bal. by Subs. Site";
        ChartOfAccounts: Page "Chart of Accounts";
    begin 
        GLAccount.SetRange("Account Type",GLAccount."Account Type"::Posting);
        GLAccount.FindSet();
        repeat
            SubsidiarySite.FindSet();
            repeat
                if not GLBalBySubsSite.Get(GLAccount."No.",SubsidiarySite."Subsidiary Code",'') then begin
                    GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                    GLBalBySubsSite."Subsidiary Code" := SubsidiarySite."Subsidiary Code";
                    GLBalBySubsSite."Site Code" := ''; 
                    GLBalBySubsSite.Insert();
                end;
                if not GLBalBySubsSite.Get(GLAccount."No.",SubsidiarySite."Subsidiary Code",SubsidiarySite."Site Code") then begin
                    GLBalBySubsSite."G/L Account No." := GLAccount."No.";
                    GLBalBySubsSite."Subsidiary Code" := SubsidiarySite."Subsidiary Code";
                    GLBalBySubsSite."Site Code" := SubsidiarySite."Site Code"; 
                    GLBalBySubsSite.Insert();
                end;

            until(SubsidiarySite.Next()=0);
        until(GLAccount.Next() = 0);
    end;
}