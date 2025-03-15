// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
tableextension 50007 "OBF-Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        modify("Your Reference")
        {
            Caption = 'Invoice No. to Print';
            trigger OnAfterValidate()
            begin
                Rec.TestField("Your Reference");
            end;
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices    
        field(50000; "OBF-FOB Location"; Code[20])
        {
            Caption = 'Point of Title Transfer';
            TableRelation = "OBF-FOB Location";
            DataClassification = CustomerContent;
        }

        field(50002; "OBF-MSC Certification"; Boolean)
        {
            Caption = 'MSC Certification';
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Invoice Line" where("Document No." = field("No."), "OBF-MSC Certification" = const(true)));
            Editable = false;
        }
        field(50003; "OBF-RFM Certification"; Boolean)
        {
            Caption = 'RFM Certification';
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Invoice Line" where("Document No." = field("No."), "OBF-RFM Certification" = const(true)));
            Editable = false;
        }
        field(50004; "OBF-Certification Text"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Certification Text';
            Editable = false;
        }
        field(50005; "OBF-Header Summary Line 1"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Header Summary Line';
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(52000; "OBF-Workflow Step No."; Integer)
        {
            Caption = 'Workflow Step No.';
            TableRelation = "OBF-SO Workflow Step"."Step No." where("Sales Order No." = field("Order No."));
        }
        field(52001; "OBF-Workflow Step Description"; Text[30])
        {
            Caption = 'Workflow Step Description';
        }
        field(52002; "OBF-Wk. Step Assg. to Group"; Code[50])
        {
            Caption = 'Workflow Step Assigned to Workflow User Group';
            TableRelation = "Workflow User Group";
        }
        field(52003; "OBF-Assigned Traffic Person"; Code[50])
        {
            Caption = 'Assigned Traffic Person';
            TableRelation = "Workflow User Group Member"."User Name" WHERE("Workflow User Group Code" = CONST('TRAFFIC'));
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    procedure CompleteCurrentStep();
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SOWorkflowStep.Get(Rec."Order No.", Rec."OBF-Workflow Step No.");
        SOWorkflowStep.CompleteStep_PostInvoicing;
        SOWorkflowStep.Modify;
    end;

    procedure CompleteCurrentStepAndSendToEDITeam();
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        MiscFunctions: Codeunit "OBF-Misc Functions";
    begin
        SOWorkflowStep.Get(Rec."Order No.", Rec."OBF-Workflow Step No.");
        SOWorkflowStep.TestField("Post Invoicing Step", true);
        SOWorkflowStep.CalcFields("Current Post Invoicing Step");
        SOWorkflowStep.TestField("Current Post Invoicing Step", true);
        SOWorkflowStep.SetSOWorkFlowStepCompleted(SOWorkflowStep);
        SOWorkflowStep.Modify;
        Rec."OBF-Workflow Step No." := 0;
        MiscFunctions.SendPostedSalesInvoiceToWorkflowUserGroup(Rec, 'EDI');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
    procedure ShowPurchaseOrdersAllocatedAgainstSalesOrder(SalesInvoiceHeader: Record "Sales Invoice Header");
    var
        AddOnPurchaseOrders: Page "OBF-Add-on POs for Posted Inv.";
    begin
        AddOnPurchaseOrders.SetSalesInfo(SalesInvoiceHeader);
        AddOnPurchaseOrders.RunModal();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure OBF_SendInvoice();
    // This functions uses the Zetadocs Send functionality to add the Invoice
    // to the Zetadocs Documents Factbox.  It can also be used to email the posted invoice
    // to one or more Customer email addresses based on the Zetadocs Customer Rules
    var
        ZdServerSend: Codeunit "Zetadocs Server Send";
        ZdCommon: Codeunit "Zetadocs Common";
        SalesEvents: Codeunit "OBF-Sales Events";
        ZdReportSelections: Record "Report Selections";
        SalesSetup: Record "Sales & Receivables Setup";
        ZdRecRef: RecordRef;
        ZdReportId: Integer;
    begin
        SalesSetup.Get;
        SalesEvents.AutoCreateCustRuleForDocSet(Rec."Sell-to Customer No.", SalesSetup."OBF-Doc. Set for Invoice", true);
        ZdRecRef.GetTable(Rec);
        ZdCommon.FindSelectionReportId(ZdReportSelections.Usage::"S.Invoice", ZdReportId);
        ZdServerSend.SendViaZetadocs(ZdRecRef, ZdReportId, '', true);
    end;

}
