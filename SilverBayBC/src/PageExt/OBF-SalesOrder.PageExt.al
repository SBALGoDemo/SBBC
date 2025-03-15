// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50041 "OBF-Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Sell-to Contact") { Visible = false; }
        // modify(BssiMEMInterEntity) { Visible = false; }
        // modify(BssiAllocationTemplateId) { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        movebefore("External Document No."; "Your Reference")
        modify("Your Reference")
        {
            Importance = Promoted;
            ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
        }
        moveafter("External Document No."; "Shortcut Dimension 1 Code", "Location Code")

        modify("External Document No.")
        {
            Importance = Promoted;
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        addafter("External Document No.")
        {
            field("OBF-FOB Location"; Rec."OBF-FOB Location")
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2296 - Change Caption on Shipment Method on Sales Order
        movebefore("Shortcut Dimension 1 Code"; "Shipment Method Code", "Shipping Agent Code")
        modify("Shipment Method Code")
        {
            CaptionClass = 'Shipment Method Code';
            Importance = Promoted;
        }
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")

        addafter("Shortcut Dimension 1 Code")
        {
            field("OBF-MSC Certification"; Rec."OBF-MSC Certification")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("OBF-RFM Certification"; Rec."OBF-RFM Certification")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("OBF-Certification Text"; Rec."OBF-Certification Text")
            {
                ApplicationArea = all;
                Visible = false;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
            field("OBF-Header Summary Line 1"; Rec."OBF-Header Summary Line 1")
            {
                ApplicationArea = all;
                Visible = false;
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
        addlast(General)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
            field(AddOnText; AddOnText)
            {
                ApplicationArea = All;
                Importance = Standard;
                Style = Unfavorable;
                Editable = false;
                Caption = ' ';
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/832 - Streamline Sales Order Processing with Zetadocs
            field("OBF-Workflow Salesperson Code"; Rec."OBF-Workflow Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("OBF-Assigned Traffic Person"; Rec."OBF-Assigned Traffic Person")
            {
                ApplicationArea = all;
            }
            field("OBF-Workflow Step No."; Rec."OBF-Workflow Step No.")
            {
                ApplicationArea = all;
            }
            field("OBF-Workflow Step Description"; Rec."OBF-Workflow Step Description")
            {
                ApplicationArea = all;
            }
            field("OBF-W. Step Assigned to User"; Rec."OBF-W. Step Assigned to User")
            {
                ApplicationArea = all;
            }
            field("OBF-Submittal Timestamp"; Rec."OBF-Submittal Timestamp")
            {
                ApplicationArea = all;
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        addafter("Shipping and Billing")
        {
            group(OBF_EDI)
            {
                Caption = 'EDI';
                Visible = CustomerEDIEnabled or LocationEDIEnabled;
                group(OBF_Customer)
                {
                    Caption = 'Customer';
                    Visible = CustomerEDIEnabled;
                    field("OBF-PO Acknowledgement (855)"; Rec."OBF-PO Acknowledgement (855)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-PO Ack. (855) Transmitted"; Rec."OBF-PO Ack. (855) Transmitted")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-PO Acknowledgement Note"; Rec."OBF-PO Acknowledgement Note")
                    {
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-Revision No. (855)"; Rec."OBF-Revision No. (855)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }

                }
                group(OBF_Location)
                {
                    Caption = 'Location';
                    Visible = LocationEDIEnabled;
                    field("OBF-Whse. Sh. Rel. (940)"; Rec."OBF-Whse. Sh. Rel. (940)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-Release Pending (940)"; Rec."OBF-Release Pending (940)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-Cancellation Pending (940)"; Rec."OBF-Cancellation Pending (940)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-Revision Pending (940)"; Rec."OBF-Revision Pending (940)")
                    {
                        Editable = false;
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                    field("OBF-No. of Revisions"; Rec."OBF-No. of Revisions")
                    {
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }

                    field("OBF-Whse. Sh. Rel. Note"; Rec."OBF-Whse. Sh. Rel. Note")
                    {
                        ApplicationArea = all;
                        Visible = true;
                        Importance = Promoted;
                    }
                }
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
        modify("Create &Warehouse Shipment") { Visible = false; }
        modify("Create Inventor&y Put-away/Pick") { Visible = false; }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
        modify(SendEmailConfirmation) { Visible = false; }

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

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
            group(Workflow)
            {
                Caption = 'SO Workflow';
                action(SubmitOrderToShipping)
                {
                    Caption = 'Submit Order to Shipping';
                    Image = SendTo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    Visible = ShowSubmitAction;
                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        SOWorkflowStep.SubmitOrderToShipping(Rec);
                    end;
                }
                action(ResubmitOrderToShipping)
                {
                    Caption = 'Resubmit Order to Shipping';
                    ToolTip = 'Use this action when resubmitting an order to shipping.  It will prompt for a revision comment and increment the "No. of Revisions" field.';
                    Image = Change;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowResubmitAction;
                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        SOWorkflowStep.ResubmitOrderToShipping(Rec);
                    end;
                }
                action(CompleteCurrentStepAction)
                {
                    Caption = 'Complete Current Step';
                    Image = Completed;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        Rec.CompleteCurrentStep();
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
                action(SendOrderConfirmation)
                {
                    Caption = 'Send Confirmation (ZD)';
                    Image = Order;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'This action sends the order confirmation using the Zetadocs customer rules and puts a copy in the Documents Factbox';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.OBF_SendOrderConfirmation();
                    end;
                }
                action(SendShippingReleaseToFactbox)
                {
                    Caption = 'Send Shipping Release to Factbox';
                    Image = PickWorksheet;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'This action puts a copy of the Shipping Release in the Documents Factbox';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.OBF_SendShippingReleaseToFactbox();
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1956 - Migrate Shipping Release report to Silver Bay                
                action(PrintShippingRelease)
                {
                    ApplicationArea = All;
                    Caption = 'Print Shipping Release';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction();
                    begin
                        Rec.RunReport_ShippingRelease();
                    end;
                }

                action(ReopenForSales)
                {
                    Caption = 'ReOpen (Sales)';
                    Image = ReOpen;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction();
                    begin
                        ReopenSalesOrder;
                    end;
                }
                action(WorkflowSteps)
                {
                    Caption = 'Workflow Steps';
                    Image = BulletList;
                    ApplicationArea = all;
                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        SOWorkflowStep.ShowSOWorkflowSteps(Rec."No.");
                    end;
                }
                action(ChangeLog)
                {
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    ApplicationArea = all;
                    RunObject = Page "OBF-Change Log Entries";
                    RunPageLink = "Primary Key Field 2 Value" = FIELD("No.");
                    RunPageView = sorting("Table No.", "Primary Key Field 1 Value")
                                Where("Table No." = Filter(36 | 37));
                }
            }
        }

        addlast(processing)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - EDI - Silver Bay
            group(SPS_EDI)
            {
                Caption = 'SPS EDI';
                action(SendPOAck)
                {
                    CaptionML = ENU = 'Send PO Ack. (855)';
                    Image = PrintAcknowledgement;
                    Visible = CustomerEDIEnabled;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.SendPOAck(Rec);
                        CurrPage.Update();
                    end;
                }
                action(SendShippingReleaseViaEDI)
                {
                    CaptionML = ENU = 'Send Shipping Rel. (940)';
                    Image = ReleaseShipment;
                    Visible = LocationEDIEnabled;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.SendShippingReleaseViaEDI(Rec);
                        CurrPage.Update(true);

                    end;
                }
                action(CancelShippingRelease)
                {
                    Caption = 'Cancel Shipping Rel. (940)';
                    Image = Cancel;
                    Visible = LocationEDIEnabled;
                    ApplicationArea = all;
                    trigger OnAction();
                    begin
                        Rec.CancelShippingRelease(Rec);
                        CurrPage.Update(true);
                    end;
                }
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
            Action(AddOnPOs)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Add-On POs';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = NewPurchaseInvoice;
                trigger OnAction();
                begin
                    Rec.ShowPurchaseOrdersAllocatedAgainstSalesOrder(Rec);
                end;
            }

            group(SPS_SQL)
            {
                Caption = 'SPS SQL Processing';
                Visible = false;
                action(SimulateDMProcessShippingReleasePending)
                {
                    Caption = 'Process Release Pending';
                    Image = CalculateSimulation;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SimulateSPSProcessShippingReleasePending();
                    end;
                }
                action(SimulateDMCancelShippingReleasePending)
                {
                    Caption = 'Process Cancellation Pending';
                    Image = CalculateSimulation;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SimulateSPSCancelShippingReleasePending();
                    end;
                }
                action(SimulateDMRevisionPending)
                {
                    Caption = 'Process Revision Pending';
                    Image = CalculateSimulation;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SimulateSPSRevisionPending();
                    end;
                }
            }
        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingAgent: Code[10];
        AddOnText: Text;
        AddOnsExistText: TextConst ENU = '*** ADD-ONS EXIST ***';
        ShowSubmitAction: Boolean;
        ShowResubmitAction: Boolean;
        CustomerEDIEnabled: Boolean;
        LocationEDIEnabled: Boolean;

    trigger OnAfterGetRecord();
    begin

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
        Rec.CalcFields("OBF-Add-on POs Exist");
        if Rec."OBF-Add-on POs Exist" then
            AddOnText := AddOnsExistText
        else
            AddOnText := '';

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        Rec.CalcFields("OBF-Customer EDI Enabled", "OBF-Location EDI Enabled");
        CustomerEDIEnabled := Rec."OBF-Customer EDI Enabled";
        LocationEDIEnabled := Rec."OBF-Location EDI Enabled";
        Rec.SetPOAckNote;
        Rec.SetWhseShippingReleaseNote;

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