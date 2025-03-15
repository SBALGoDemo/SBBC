// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
table 50003 "OBF-Rebate Line"
{

    fields
    {
        field(10; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            TableRelation = "OBF-Rebate Header";
            NotBlank = true;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; Source; enum "OBF-Rebate Source")
        {
            Caption = 'Source';
            trigger OnValidate()
            begin
                ValidateSourceNo();
            end;
        }
        field(70; Value; Code[20])
        {
            Caption = 'Value';
            trigger OnLookup()
            begin
                OnLookupValue();
            end;

            trigger OnValidate()
            begin
                ValidateValue();
            end;
        }
        field(80; "Ship-to Address Code"; Code[10])
        {
            Caption = 'Ship-to Address Code';
            TableRelation = IF (Source = FILTER(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD(Value));

            trigger OnLookup()
            begin
                LookupShipToAddress();
            end;

            trigger OnValidate()
            begin
                ValidateShipToAddress();
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1523 - Overflow issue when adding items with long descriptions to Rebate card
        field(90; Description; Text[100])
        {
            Caption = 'Description';
        }
        
        field(100; "Rebate Value"; Decimal)
        {
            Caption = 'Rebate Value';
            MinValue = 0;

            trigger OnValidate()
            begin
                ValidateRebateValue();
            end;
        }
    }

    keys
    {
        key(Key1; "Rebate Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        DuplicateCheck();
    end;

    var
        RebateHeader: Record "OBF-Rebate Header";
        Text002: Label 'Rebate value for %1 cannot be greater than 100.';
        Text003: Label 'Rebate Values cannot be entered at that line level when Source equals %1. Enter a Rebate Value in the header.';

    local procedure ValidateSourceNo()
    begin
        if Rec.Source <> xRec.Source then begin
            Clear(Value);
            Clear("Ship-to Address Code");
            Clear(Description);
            Clear("Rebate Value");
        end;
    end;

    local procedure ValidateValue()
    var
        Item: Record Item;
        Customer: Record Customer;

    begin

        if Value <> '' then begin
            Item.Reset();
            Customer.Reset();


            Clear("Ship-to Address Code");
            Clear(Description);

            DuplicateCheck();

            case Source of
                Source::Customer:
                    begin
                        GetRebateHeader();
                        Customer.Get(Value);
                        Description := Customer.Name;
                    end;

                Source::Item:
                    begin
                        Item.Get(Value);
                        Description := Item.Description;
                    end;
            end;
        end else begin
            Description := '';
            "Ship-to Address Code" := '';
        end;

    end;

    local procedure OnLookupValue()
    var
        Item: Record Item;
        Customer: Record Customer;
    begin
        Item.Reset();
        Customer.Reset();

        case Source of
            Source::Customer:
                begin
                    if Value <> '' then
                        Customer."No." := Value;

                    if not Customer.Find('=') then
                        Customer.Find('-');

                    if (Page.RunModal(Page::"Customer List", Customer) = ACTION::LookupOK) then
                        Validate(Value, Customer."No.");
                end;

            Source::Item:
                begin
                    if Value <> '' then
                        Item."No." := Value;

                    if not Item.Find('=') then
                        Item.Find('-');

                    if (Page.RunModal(Page::"Item List", Item) = ACTION::LookupOK) then
                        Validate(Value, Item."No.");

                end;
        end;
    end;

    local procedure ValidateShipToAddress()
    begin
        TestField(Source, Source::Customer);
        DuplicateCheck();
    end;

    local procedure LookupShipToAddress()
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        ShiptoAddress.Reset();
        if Value <> '' then begin
            if (Source = Source::Customer) then begin
                ShiptoAddress.SetRange("Customer No.", Value);

                if (Page.RunModal(Page::"Ship-to Address List", ShiptoAddress) = ACTION::LookupOK) then
                    Validate("Ship-to Address Code", ShiptoAddress.Code);
            end;
        end;
    end;

    local procedure ValidateRebateValue()
    begin

        if "Rebate Value" <> xRec."Rebate Value" then begin
            GetRebateHeader();

            if RebateHeader."Calculation Basis" = RebateHeader."Calculation Basis"::"Percent of Sales" then
                if "Rebate Value" > 100 then
                    Error(Text002, RebateHeader.Code);

        end;
    end;

    procedure GetRebateHeader()
    begin
        RebateHeader.Get("Rebate Code");
    end;

    // Orca Bay Rebate Rules

    // Rule 7, for a given Rebate Code, there will only be one Rebate Line for a given Customer with “Ship-to Address” blank.
    // Rule 8, for a given Rebate Code, there will only be one Rebate Line for a combination of a Customer No. and a Ship-to Address Code.
    // Rule 9, for a given Rebate Code, there will only be one Rebate Line for a given Item No.

    procedure DuplicateCheck()
    var
        RebateLine: Record "OBF-Rebate Line";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if (Rec."Line No." = 0) or (Rec."Rebate Code" = '') then
            exit;

        SalesSetup.Get();
        if not SalesSetup."OBF-Enable Dup. Rebate Check" then 
            exit;
        RebateLine.SetRange("Rebate Code", Rec."Rebate Code");
        RebateLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
        RebateLine.SetRange(Source, Rec.Source);
        RebateLine.SetRange(Value, Rec.Value);
        RebateLine.SetRange("Ship-to Address Code", Rec."Ship-to Address Code");
        if not RebateLine.IsEmpty then
            if Rec.Source = Rec.Source::Customer then
                Error('There is already a rebate line for Rebate %1 Customer %2 Ship-to %3', Rec."Rebate Code", Rec.Value, Rec."Ship-to Address Code")
            else
                Error('There is already a rebate line for Rebate %1 Item %2', Rec."Rebate Code", Rec.Value);

    end;
}
