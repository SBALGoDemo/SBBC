// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50007 "OBF-Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        modify("Sell-to Contact") { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        movebefore("External Document No.";"Your Reference")
        modify("Your Reference") 
        { 
            Importance = Promoted;
            ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1826 - Sales Invoice Enhancements
        moveafter("External Document No."; "Location Code","Shortcut Dimension 1 Code")
        modify("Location Code") {Importance = Promoted;}

        modify("External Document No.") 
        { 
            Importance = Promoted;
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        addafter("External Document No.")
        {
            field("OBF-FOB Location";Rec."OBF-FOB Location")
            {
                ApplicationArea = all;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
            field("OBF-Bypass Rebate Calculation"; Rec."OBF-Bypass Rebate Calculation")
            {
                Importance = Additional;
                ApplicationArea = all;
            }
        }
        movebefore("Shortcut Dimension 1 Code";"Shipment Method Code")
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method';
            Importance = Promoted;
        }
        moveafter("Shortcut Dimension 1 Code";"Shortcut Dimension 2 Code")
        
        addafter("Shortcut Dimension 1 Code")
        {           
            field("OBF-MSC Certification";Rec."OBF-MSC Certification")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("OBF-RFM Certification";Rec."OBF-RFM Certification")
            {
                ApplicationArea = all;
                Importance = Additional;
            }

        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        addafter("Shipping Agent Code")
        {
            field(ShippingAgent; ShippingAgent)
            {
                Caption = 'Shipping Agent';
                TableRelation = "Shipping Agent";
                ApplicationArea = all;
                trigger OnValidate();
                var
                    ReleaseSalesDocument: Codeunit "Release Sales Document";
                begin
                    IF Rec."Shipping Agent Code" = ShippingAgent THEN
                        EXIT;

                    Case Rec.Status of
                        Rec.Status::Open:
                            Rec.Validate("Shipping Agent Code", ShippingAgent);
                        Rec.Status::Released:
                            begin
                                ReleaseSalesDocument.Reopen(Rec);
                                Rec.Validate("Shipping Agent Code", ShippingAgent);
                                ReleaseSalesDocument.Run(Rec);
                            end;
                        else
                            Rec.FieldError(Status);
                    end;
                end;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        addbefore(ApprovalFactBox)
        {
            part(SalesComments; "OBF-Sales Comments FactBox")
            {
                Caption = 'Sales Comments';
                Visible = true;
                ApplicationArea = all;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addafter(ApprovalFactBox)
        {
            part(SalesDocRebateFactbox; "OBF-Sales Doc. Rebate FactBox")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
                Visible = true;
                ApplicationArea = all;
                Caption = 'Rebate';
            }
        }

    }
    actions
    {
        addlast(Navigation)
        {
            action(Vans)
            {
                Caption = 'Vans';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                begin
                    Rec.ShowVanList();
                end;                
            } 

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
            action("Page OBF-Rebate Entries")
            {
                Image = DepositLines;
                Caption = 'Rebate Entries';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    RebateEntries: Page "OBF-Rebate Entries";
                    RebateEntry: Record "OBF-Rebate Entry";
                begin
                    RebateEntry.SetRange("Source Type", Rec."Document Type");
                    RebateEntry.SetRange("Source No.", Rec."No.");
                    RebateEntries.SetTableView(RebateEntry);
                    RebateEntries.SetSalesHeader(Rec);
                    RebateEntries.RunModal();
                end;
            }

            action(ChangeLog)
            {
                Caption = 'Change Log';
                Image = ChangeLog;
                ApplicationArea = All;
                RunObject = Page "OBF-Change Log Entries";
                RunPageLink = "Primary Key Field 2 Value" = FIELD("No.");
                RunPageView = sorting("Table No.", "Primary Key Field 1 Value")
                            Where("Table No." = Filter(36 | 37));
            }
                      
        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingAgent: Code[10];
        ShowSubmitAction: Boolean;
        ShowResubmitAction: Boolean;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    trigger OnAfterGetRecord();
    begin
        ShippingAgent := Rec."Shipping Agent Code";
        ShowSubmitAction := (Rec."OBF-Workflow Step No." = 0);
        SalesSetup.Get;
        ShowResubmitAction := (Rec."OBF-Workflow Step No." = SalesSetup."OBF-Submit to Shipping Step");
    end;
    local procedure ReopenSalesOrder();
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        UserSetup: Record "User Setup";
        EditAllowed: Boolean;
    begin
        if Rec.Status <> Rec.Status::Released then
            exit;

        Rec.Status := Rec.Status::Open;
        Rec.Modify(false);
    end;
}