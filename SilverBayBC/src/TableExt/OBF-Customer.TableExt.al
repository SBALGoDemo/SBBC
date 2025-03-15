// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50012 "OBF-Customer" extends "Customer"
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List
        field(50030; "OBF-Broker"; Code[20])
        {
            Caption = 'Broker';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BROKER'));
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        field(51000; "OBF-EDI Enabled"; Boolean)
        {
            Caption = 'EDI Enabled';
            trigger OnValidate();
            var
                SalesEvents: Codeunit "OBF-Sales Events";
            begin
                if "OBF-EDI Enabled" then
                    SalesEvents.UpdateCustomEDIFieldsForCustomer(Rec."No.");
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(52000; "OBF-Workflow Salesperson Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Workflow Salesperson Code';
            trigger OnValidate();
            begin
                if Rec."OBF-Workflow Salesperson Code" <> xRec."OBF-Workflow Salesperson Code" then
                    UpdateSalesHeaderWorkflowSalesperson(Rec."No.", Rec."OBF-Workflow Salesperson Code");
            end;
        }
        field(52001; "OBF-Workflow Traffic Person"; Code[20])
        {
            TableRelation = "Workflow User Group Member"."User Name" WHERE("Workflow User Group Code" = CONST('TRAFFIC'));
            Caption = 'Workflow Traffic Person';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1923 - Disallow special characters in customer names
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit "Regex";
            begin
                If Regex.IsMatch(Rec.Name, '[^a-zA-Z0-9_ ]') then
                    Error('Customer Name can only contain letters, numbers, spaces, and underscores.')
            end;
        }

        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then begin
                    Rec."OBF-Site Code" := '';
                end;
            end;
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    local procedure UpdateSalesHeaderWorkflowSalesperson(CustomerNo: Code[20]; NewWorkflowSalespersonCode: Code[20]);
    var
        SalesHeader: Record "Sales Header";
        NumSalesOrdersForCustomer: Integer;
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        NumSalesOrdersForCustomer := SalesHeader.Count;
        if NumSalesOrdersForCustomer > 0 then begin
            SalesHeader.ModifyAll("OBF-Workflow Salesperson Code", NewWorkflowSalespersonCode);
            Message('The Workflow Salesperson Code was updated on %1 sales orders for customer %2',
                NumSalesOrdersForCustomer, CustomerNo);
        end;
    end;

}