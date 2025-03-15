// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1667 -How to handle fixed assets 
table 50098 "OBF-Asset Temp"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Subsidiary; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(2; Site; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Asset ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Asset Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Asset Type"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Purchase Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Original Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Cumulative Appreciation"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Current Net Book Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Asset Lifetime"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; Quantity; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Last Depreciation Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(14; "Subsidiary Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SUBSIDIARY'), Code = field("Subsidiary Code")));
            Caption = 'Subsidiary Name';
            Editable = false;
        }
        field(17; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Subsidiary Code"));
            Caption = 'Site Code';
        }
        field(18; "Site Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Name';
            Editable = false;
        }
        field(20; "FA Subclass"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "FA Subclass";
        }
    }

    keys
    {
        key(Key1; "Asset ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure MainSubsidiaryLoop()
    var
        AssetTemp: Record "OBF-Asset Temp";
        Num: Integer;
        Num2: Integer;
    begin
        //AssetTemp.SetFilter("Subsidiary Code", '%1', '');
        AssetTemp.FindSet();
        repeat
            AssetTemp."Subsidiary Code" := FindSubsidiary(AssetTemp.Subsidiary);
            if AssetTemp."Subsidiary Code" <> '' then begin
                AssetTemp.Modify();
                Num += 1;
            end else
                Num2 += 1;
        until (AssetTemp.Next() = 0);
        Message('%1 records were updated; %2 were skipped', Num, Num2);
    end;

    
    procedure MainSiteLoop()
    var
        AssetTemp: Record "OBF-Asset Temp";
        Num: Integer;
        Num2: Integer;
    begin
        AssetTemp.SetFilter("Subsidiary Code", '<>%1', '');
        //AssetTemp.SetFilter("Site Code",'%1','');
        AssetTemp.FindSet();
        repeat
            AssetTemp."Site Code" := FindSite(AssetTemp."Subsidiary Code",AssetTemp.Site);
            if AssetTemp."Site Code" <> '' then begin
                AssetTemp.Modify();
                Num += 1;
            end else
                Num2 += 1;
        until (AssetTemp.Next() = 0);
        Message('%1 records were updated; %2 were skipped', Num, Num2);
    end;

    procedure FindSubsidiary(SubsidiaryText: Text[250]): Code[20]
    var
        DimensionValue: Record "Dimension Value";
        SubsidiaryName: Text[24];
    begin
        DimensionValue.SetRange("Dimension Code", 'SUBSIDIARY');
        SubsidiaryName := CopyStr(SubsidiaryText, 1, 24);
        DimensionValue.SetFilter(Name, STRSUBSTNO('%1*', SubsidiaryName));
        DimensionValue.SetRange(Blocked, false);
        if DimensionValue.Count > 1 then
            exit('*** MULTIPLE ***')
        else
            if DimensionValue.FindFirst() then
                exit(DimensionValue.Code)
            else
                exit('');
    end;

    procedure FindSite(SubsidiaryCode:Code[20];SiteText: Text[250]): Code[20]
    var
        SubsidiarySite: Record "OBF-Subsidiary Site";
        SiteName: Text[5];
    begin
        SubsidiarySite.SetRange("Subsidiary Code", SubsidiaryCode);
        SiteName := CopyStr(SiteText, 1, 5);
        case SiteText of
            '3050 Hilltop' : SiteName := 'Hillt';
            'California Seafoods : Seal Control' : SiteName := 'Seal ';
            'False Pass Plant : FSP Store(s) : King Cove Store' : SiteName := 'King ';
            'Naknek Plant : Westward Wind Tender' : SiteName := 'Westw';
            'Naknek Plant : SBS Opportunity Tender' : SiteName := 'SBS O';
            'Naknek Plant : Lady Kodiak Tender' : SiteName := 'Lady ';
            else SiteName := CopyStr(SiteText, 1, 5);
        end;
        SubsidiarySite.SetFilter("Site Name", STRSUBSTNO('%1*', SiteName));
        if SubsidiarySite.Count > 1 then
            exit('*** MULTIPLE ***')
        else
            if SubsidiarySite.FindFirst() then
                exit(SubsidiarySite."Site Code")
            else
                exit('');
    end;

    procedure MainAssetTypeLoop()
    var
        AssetTemp: Record "OBF-Asset Temp";
        Num: Integer;
        Num2: Integer;
    begin
        AssetTemp.FindSet();
        repeat
            AssetTemp."FA Subclass" := FindFASubClass(AssetTemp."Asset Type");
            if AssetTemp."FA Subclass" <> '' then begin
                AssetTemp.Modify();
                Num += 1;
            end else
                Num2 += 1;
        until (AssetTemp.Next() = 0);
        Message('%1 records were updated; %2 were skipped', Num, Num2);
    end;

    procedure FindFASubClass(AssetTypeText: Text[250]): Code[20]
    var
        FASubclass: Record "FA Subclass";
        AssetTypeName: Text[6];
    begin
        AssetTypeName := CopyStr(AssetTypeText, 1, 6);
        FASubclass.SetFilter(Name, STRSUBSTNO('%1*', AssetTypeName));
        if FASubclass.Count > 1 then
            exit('*** MULTIPLE ***')
        else
            if FASubclass.FindFirst() then
                exit(FASubclass.Code)
            else
                exit('');
    end;

    procedure FAJournalLoop()
    var
        SubDimension: Codeunit "OBF-Sub Dimension";
        FAJournalLine: Record "FA Journal Line";
        AssetTemp: Record "OBF-Asset Temp";
        DepreciationDate: Date;
        LineNo: Integer;
        Num: Integer;
        Num2: Integer;
    begin
        Evaluate(DepreciationDate,'12/31/2023');
        //AssetTemp.SetRange("Asset ID",'FAM000026');
        AssetTemp.FindSet();
        repeat
            FAJournalLine.Init();
            FAJournalLine.Validate("Journal Template Name",'ASSETS');
            FAJournalLine.Validate("Journal Batch Name",'JOSEPH');
            LineNo += 10000;
            FAJournalLine.Validate("Line No.",LineNo);
            FAJournalLine.Insert(true);
            FAJournalLine.Validate("Depreciation Book Code",'COMPANY');
            FAJournalLine.Validate("FA Posting Type",FAJournalLine."FA Posting Type"::"Acquisition Cost");
            FAJournalLine.Validate("FA No.",AssetTemp."Asset ID");
            FAJournalLine.Validate("FA Posting Date",AssetTemp."Purchase Date");
            FAJournalLine.Validate("Document No.",'FA_OPB');
            FAJournalLine.Validate(Amount,AssetTemp."Original Cost");
            FAJournalLine.Validate("Shortcut Dimension 1 Code",AssetTemp."Subsidiary Code");
            SubDimension.UpdateDimSetIDForSubDimension('SITE', AssetTemp."Site Code", FAJournalLine."Dimension Set ID");
            FAJournalLine.Modify();
            Num += 1;

            FAJournalLine.Init();
            FAJournalLine.Validate("Journal Template Name",'ASSETS');
            FAJournalLine.Validate("Journal Batch Name",'JOSEPH');
            LineNo += 10000;
            FAJournalLine.Validate("Line No.",LineNo);
            FAJournalLine.Insert(true);
            FAJournalLine.Validate("Depreciation Book Code",'COMPANY');
            FAJournalLine.Validate("FA No.",AssetTemp."Asset ID");
            FAJournalLine.Validate("FA Posting Type",FAJournalLine."FA Posting Type"::Depreciation);
            FAJournalLine.Validate("FA Posting Date",DepreciationDate);
            FAJournalLine.Validate("Document No.",'FA_OPB');
            FAJournalLine.Validate(Amount,AssetTemp."Current Net Book Value"-AssetTemp."Original Cost");
            FAJournalLine.Validate("Shortcut Dimension 1 Code",AssetTemp."Subsidiary Code");
            SubDimension.UpdateDimSetIDForSubDimension('SITE', AssetTemp."Site Code", FAJournalLine."Dimension Set ID");
            FAJournalLine.Modify();
            Num += 1;
        until(AssetTemp.Next()=0);
        Message('Num Journal Lines Added = %1',Num);      
    end;
}