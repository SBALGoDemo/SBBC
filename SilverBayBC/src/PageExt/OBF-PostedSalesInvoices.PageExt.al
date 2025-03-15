// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
pageextension 50017 "OBF-Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                Visible = true;
                ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
            }
            field("OBF-FOB Location"; Rec."OBF-FOB Location")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1826 - Sales Invoice Enhancements
        addafter("Location Code")
        {
            field(LocationName; Location.Name)
            {
                Caption = 'Location Name';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(LocationAddress; Location.Address)
            {
                Caption = 'Location Address';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(LocationCity; Location.City)
            {
                Caption = 'Location City';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(LocationState; Location.County)
            {
                Caption = 'Location State';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(LocationPostCode; Location."Post Code")
            {
                Caption = 'Location Zip Code';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(LocationCountry; Location."Country/Region Code")
            {
                Caption = 'Location Country';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
        }

        moveafter("Sell-to Customer Name"; "External Document No.")
        modify("External Document No.")
        {
            Visible = true;
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify("Currency Code") { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1826 - Sales Invoice Enhancements
        modify("Bill-to Customer No.") { Visible = true; ApplicationArea = all; Caption = 'Bill-to Customer No.'; }
        modify("Bill-to Name") { Visible = true; ApplicationArea = all; Caption = 'Bill-to Name'; }
        addafter("Bill-to Name")
        {
            field("Bill-to Address"; Rec."Bill-to Address") { Visible = true; ApplicationArea = all; Caption = 'Bill-to Address'; }
            field("Bill-to City"; Rec."Bill-to City") { Visible = true; ApplicationArea = all; Caption = 'Bill-to City'; }
            field("Bill-to County"; Rec."Bill-to County") { Visible = true; ApplicationArea = all; }
        }
        modify("Bill-to Post Code") { Visible = true; Caption = 'Bill-to Zip Code'; }
        modify("Bill-to Country/Region Code") { Visible = true; Caption = 'Bill-to Country Code'; }
        modify("Ship-to Code") { Visible = true; }
        modify("Ship-to Name") { Visible = true; }
        addafter("Ship-to Name")
        {
            field("Ship-to Address"; Rec."Ship-to Address") { Visible = true; ApplicationArea = all; }
            field("Ship-to City"; Rec."Ship-to City") { Visible = true; ApplicationArea = all; }
            field("Ship-to County"; Rec."Ship-to County") { Visible = true; ApplicationArea = all; }
        }
        modify("Ship-to Post Code") { Visible = true; }
        modify("Ship-to Country/Region Code") { Visible = true; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2105 - Add order date field to SB posted sales invoices list
        addafter("External Document No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2373 - Add Memo to Posted Sales Invoices List
        addlast(factboxes)
        {
            part(CustomerLedgerEntriesFactbox; "Customer Ledger Entry FactBox")
            {
                ApplicationArea = all;
                Visible = true;
                ShowFilter = false;
                SubPageLink = "Posting Date" = field("Posting Date"), "Document No." = field("No.");
            }
        }
    }

    var
        Location: Record Location;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1826 - Sales Invoice Enhancements
    trigger OnAfterGetRecord()
    begin
        if Rec."Location Code" <> '' then
            Location.Get(Rec."Location Code")
        else
            Clear(Location);
    end;

}