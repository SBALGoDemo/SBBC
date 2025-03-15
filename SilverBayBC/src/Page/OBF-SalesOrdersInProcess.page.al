// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
//      * Added 5 fields related to 940
//      * Slight reorganization of other fields
//      * Added a new Workflow grouping for the existing Workflow actions
//      * Added new actions Generate Shipping Release, Print Shipping Release and
//          Restart Workflow Process to the Workflow action group
//      *  Added a new EDI Action group including
//          - Send PO ACK (855)
//          - Send Shipping Release (940)
//          - Cancel Shipping Release (940)
//      * Add a Zetadocs Action Group including standard Outbox and Customer Rules actions
//      * Add a SPS SQL Processing Action Group that includes actiongs to simulate
//          Datamasons processing a Release Pending, Cancel Pending and Revision Pending flags.
//      * Add code to the CompleteCurrentStep procedure to require using the Resubmit
//          action if the Current Step is 1 "Submit Order to Shipping".

page 50081 "OBF-Sales Orders in Process"
{
    PageType = List;
    SourceTable = "Sales Header";
    Caption = 'Sales Orders in Process';
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            field(CurrentFilters; CurrentFilters)
            {
                Caption = 'Current Filters';
                Editable = false;
            }
            field(CurrentKey; CurKey)
            {
                Caption = 'Current Key';
                Width = 50;
            }
            repeater(Group)
            {
                field("Workflow Step No."; Rec."OBF-Workflow Step No.")
                {
                    ApplicationArea = All;
                }
                field("Workflow Step Description"; Rec."OBF-Workflow Step Description")
                {
                    ApplicationArea = All;
                    Caption = 'Workflow Step';
                    Editable = false;
                    Style = AttentionAccent;
                    StyleExpr = AckRequired;
                    Width = 30;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        ShowSalesOrder();
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer';
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Wkf. Step Assgn. to UserName"; Rec."OBF-W. Step Ass. to User Name")
                {
                    ApplicationArea = All;
                    Caption = 'Workflow Step Assigned to';
                    Editable = false;
                    ToolTip = 'You can change the Assigned To user for the current step on the Workflow Steps page.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Workflow Salesperson Code"; Rec."OBF-Workflow Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Workflow Salesperson';
                    Style = Strong;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'By default, this is the user that originally created the sales order. If desired, it can be changed to another user on the Sales Order page.';
                }

                field("OBF-Assigned Traffic Person"; Rec."OBF-Assigned Traffic Person")
                {
                    ApplicationArea = All;
                    Caption = 'Traffic';
                    Style = strong;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = Strong;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }

                field("OBF-Submittal Timestamp"; Rec."OBF-Submittal Timestamp")
                {
                    ApplicationArea = All;
                }
                field("No. of Revisions"; Rec."OBF-No. of Revisions")
                {
                    ApplicationArea = All;
                    Caption = 'Revisions';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
                field("OBF-Location EDI Enabled"; Rec."OBF-Location EDI Enabled")
                {
                    ApplicationArea = All;
                }
                field("OBF-Multiple Locations"; Rec."OBF-Multiple Locations")
                {
                    ApplicationArea = All;
                }
                field("OBF-Bypass 940 Release Check"; Rec."OBF-Bypass 940 Release Check")
                {
                    ApplicationArea = All;
                }
                field("OBF-Whse. Sh. Rel. (940)"; Rec."OBF-Whse. Sh. Rel. (940)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("OBF-Release Pending (940)"; Rec."OBF-Release Pending (940)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("OBF-Cancellation Pending (940)"; Rec."OBF-Cancellation Pending (940)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("OBF-Revision Pending (940)"; Rec."OBF-Revision Pending (940)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
        area(factboxes)
        {
            part(ZddWebClient; "Zetadocs Web Rel. Docs. Page")
            {
                ApplicationArea = All;
                Visible = ZddIsFactboxVisible;
            }
            part(SalesComments; "OBF-Sales Comments FactBox")
            {
                ApplicationArea = All;
                Caption = 'Sales Comments';
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
            }
            part("OBF-SO Workflow Steps Listpart"; "OBF-SO Workflow Steps Listpart")
            {
                ApplicationArea = All;
                SubPageLink = "Sales Order No." = Field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CompleteCurrentStepAction)
                {
                    ApplicationArea = All;
                    Caption = 'Complete Current Step';
                    Image = Completed;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        Rec.CompleteCurrentStep;

                        // The following block of code keeps the new current record on this page the same as the reocrd that we were completing the current step for.
                        Rec.SetRange("No.", Rec."No.");
                        if not Rec.findfirst then begin
                            Rec.SetRange("No.");
                            if not Rec.FindFirst then;
                        end else
                            Rec.SetRange("No.");

                    end;
                }
                action(ChangeWorkflowStepAction)
                {
                    ApplicationArea = All;
                    Caption = 'Change Workflow Step';
                    Image = Change;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        Rec.ChangeWorkflowStep;
                    end;
                }

                action(AcknowledgeCurrentStep)
                {
                    ApplicationArea = All;
                    Caption = 'Acknowledge Current Step';
                    Image = Check;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        Rec.AcknowledgeCurrentStep;
                    end;
                }
                action(RestartWorkflowProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Restart Workflow Process';
                    ToolTip = 'This action is used by Traffic to send the order back to the Salesperson when a revision is needed. ';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        SOWorkflowStep.RestartWorkflowProcess(Rec);
                    end;
                }
                action(ShowDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Show Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction();
                    begin
                        ShowSalesOrder();
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
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
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction();
                    begin
                        Rec.RunReport_ShippingRelease();
                    end;
                }

                action(WorkflowSteps)
                {
                    ApplicationArea = All;
                    Caption = 'Workflow Steps';
                    Image = BulletList;
                    trigger OnAction();
                    var
                        SOWorkflowStep: Record "OBF-SO Workflow Step";
                    begin
                        SOWorkflowStep.ShowSOWorkflowSteps(Rec."No.");
                    end;
                }
                action(ChangeLog)
                {
                    ApplicationArea = All;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page "OBF-Change Log Entries";
                    RunPageLink = "Primary Key Field 2 Value" = FIELD("No.");
                    RunPageView = sorting("Table No.", "Primary Key Field 1 Value")
                                Where("Table No." = Filter(36 | 37));
                }
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
            group(EDI)
            {
                Caption = 'EDI';
                action(SendPOAck)
                {
                    CaptionML = ENU = 'Send PO Acknowledgement (855)';
                    Image = PrintAcknowledgement;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SendPOAck(Rec);
                        CurrPage.Update(true);
                    end;
                }
                action(SendShippingReleaseViaEDI)
                {
                    CaptionML = ENU = 'Send Shipping Release (940)';
                    Image = ReleaseShipment;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SendShippingReleaseViaEDI(Rec);
                        CurrPage.update(true);
                    end;
                }
                action(CancelShippingRelease)
                {
                    Caption = 'Cancel Shipping Release (940)';
                    Image = Cancel;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.CancelShippingRelease(Rec);
                        CurrPage.update(true);
                    end;
                }
            }


            group(Zetadocs)
            {
                caption = 'Zetadocs';
                action(ZdOutbox)
                {
                    Caption = 'Outbox';
                    Image = OverdueMail;
                    ApplicationArea = All;
                    Promoted = false;
                    RunObject = Page "Zetadocs Delivery Outbox";
                }
                action(ZdRules)
                {
                    Caption = 'Rules';
                    Image = CheckRulesSyntax;
                    ApplicationArea = All;
                    Promoted = false;
                    RunObject = Page "Zetadocs Customer Rule List";
                    RunPageLink = "Customer No." = FIELD("Sell-to Customer No.");
                }
            }
            group(SPS_SQL)
            {
                Caption = 'SPS SQL Processing';
                Visible = false;
                action(SimulateSPSProcessShippingReleasePending)
                {
                    Caption = 'Process Release Pending';
                    Image = CalculateSimulation;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SimulateSPSProcessShippingReleasePending();
                    end;
                }
                action(SimulateSPSCancelShippingReleasePending)
                {
                    Caption = 'Process Cancellation Pending';
                    Image = CalculateSimulation;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        Rec.SimulateSPSCancelShippingReleasePending();
                    end;
                }
                action(SimulateSPSRevisionPending)
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

    trigger OnOpenPage();
    begin
        Rec.SetFilter("OBF-Workflow Step No.", '>0');
        if IsDrillDown then
            Rec.SetCurrentKey("OBF-Workflow Step Acknowledged", "OBF-Workflow Salesperson Code", "OBF-Workflow Step No.")
        else
            Rec.SetCurrentKey("OBF-Workflow Salesperson Code", "OBF-Workflow Step No.");
    end;

    trigger OnAfterGetCurrRecord();
    var
        ZdCommon: Codeunit "Zetadocs Common";
        ZdRecRef: RecordRef;
    begin
        CurrentFilters := Rec.GetFilters;
        CurKey := 'Sorting: ' + Rec.CURRENTKEY;

        if not ZddIsOnAfterGetCurrRecordInitialised then begin
            ZddIsOnAfterGetCurrRecordInitialised := true;
            ZddIsFactboxVisible := ZdCommon.IsFactboxVisibleForPage(CurrPage.OBJECTID(FALSE));
        end;

        if GuiAllowed then begin
            ZdRecRef.GetTable(Rec);
            if ZdRecRef.Get(ZdRecRef.RecordId) and (ZdRecRef.RecordId <> ZddPrevRecID) then begin
                ZddPrevRecID := ZdRecRef.RecordId;
                CurrPage.ZddWebClient.Page.SetRecordID(ZdRecRef.RecordId);
                CurrPage.ZddWebClient.Page.Update(false);
            end;
        end;

    end;

    trigger OnAfterGetRecord();
    begin
        if IsDrillDown then
            AckRequired := not Rec."OBF-Workflow Step Acknowledged"
        else
            AckRequired := false;
    end;

    var
        ZddPrevRecID: RecordID;
        ZddIsFactboxVisible: Boolean;
        ZddIsActionsVisible: Boolean;
        ZddIsOnAfterGetCurrRecordInitialised: Boolean;

        IsDrillDown: Boolean;
        AckRequired: Boolean;
        AddOnText: Text;
        CurrentFilters: Text;
        CurKey: Text;

    procedure SetDrillDown()
    begin
        IsDrillDown := true;
    end;

    procedure ShowSalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        SalesHeader := Rec;
        SalesHeader.SetRecFilter;
        SalesOrder.SetTableView(SalesHeader);
        SalesOrder.Editable(true);
        SalesOrder.Run;
    end;
}