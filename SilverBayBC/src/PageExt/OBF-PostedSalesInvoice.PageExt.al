// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
pageextension 50016 "OBF-Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        modify("Your Reference")
        {
            Importance = Promoted;
            Caption = 'Invoice No. to Print';
            ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
        }
        modify("External Document No.")
        {
            Importance = Promoted;
            Caption = 'Customer PO';
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }

        addlast(General)
        {
            field("OBF-Certification Text"; Rec."OBF-Certification Text")
            {
                ApplicationArea = all;
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1756 - Item Sales report
    actions
    {
        addlast(Navigation)
        {
            action(SetFOBLocation)
            {
                Caption = 'Set FOB Location';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                var
                    CUOnUpgrade: Codeunit "OBF-OnUpgrade";
                begin
                    CUOnUpgrade.SetSalesShipmentHeaderFOBLocation();
                end;
            }
            action(SetItemLedgerDescription)
            {
                Caption = 'Set Item Ledger Description';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                var
                    CUOnUpgrade: Codeunit "OBF-OnUpgrade";
                begin
                    CUOnUpgrade.SetItemLedgerEntryDescription();
                end;
            }
        }


        addlast(Processing)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
            action(CompleteCurrentStepAction)
            {
                Caption = 'Complete Current Step';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.CompleteCurrentStep;
                end;
            }
            action(SendToEDITeam)
            {
                Caption = 'Send to EDI Team';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                var
                    MiscFunctions: Codeunit "OBF-Misc Functions";
                begin
                    MiscFunctions.SendPostedSalesInvoiceToWorkflowUserGroup(Rec, 'EDI');
                end;
            }
            action(StartCreditMemoProcess)
            {
                Caption = 'Start Credit Memo Process';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                var
                    MiscFunctions: Codeunit "OBF-Misc Functions";
                begin
                    MiscFunctions.SendPostedSalesInvoiceToWorkflowUserGroup(Rec, 'CREDITMEMO');
                end;
            }

            action(CancelWorkflowStep)
            {
                Caption = 'Cancel Workflow Step';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                var
                    MiscFunctions: Codeunit "OBF-Misc Functions";
                begin
                    MiscFunctions.CancelPostedSalesInvoiceWorkflowStep(Rec);
                end;
            }

            action(WorkflowSteps)
            {
                Caption = 'Workflow Steps';
                Image = Workflow;
                Promoted = true;
                PromotedCategory = "Process";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                var
                    SOWorkflowStep: Record "OBF-SO Workflow Step";
                begin
                    SOWorkflowStep.ShowSOWorkflowSteps(Rec."Order No.");
                end;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
            Action(AddOnPOs)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Add-On POs';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = NewPurchaseInvoice;
                trigger OnAction();
                begin
                    Rec.ShowPurchaseOrdersAllocatedAgainstSalesOrder(Rec);
                end;
            }

        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addafter(DocAttach)
        {
            action(RebateLedgerEntries)
            {
                Caption = 'Rebate Ledger Entries';
                Image = DepositLines;
                ApplicationArea = all;
                RunObject = Page "OBF-Rebate Ledger Entries";
                RunPageLink = "Source Type" = filter("Posted Invoice"),
                              "Source No." = field("No.");
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
        addlast(Reporting)
        {
            action(SendPostedInvoiceToFactbox)
            {
                Caption = 'Send Posted Invoice to Factbox';
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'This action sends the posted sales invoice using the Zetadocs customer rules and puts a copy in the Documents Factbox';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.OBF_SendInvoice();
                end;
            }
        }
    }
}