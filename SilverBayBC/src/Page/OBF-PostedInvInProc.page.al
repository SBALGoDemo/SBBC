// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50087 "OBF-Posted Inv. in Proc."
{
    PageType = List;
    SourceTable = "Sales Invoice Header";
    Caption = 'Posted Invoices in Process';
    UsageCategory = Lists;
    Editable = false;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field(CurrentFilters; CurrentFilters)
            {
                Caption = 'Current Filters';
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
                    Style = AttentionAccent;
                    StyleExpr = AckRequired;
                    Width = 30;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("OBF-Wk. Step Assg. to Group"; Rec."OBF-Wk. Step Assg. to Group")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned to';
                    Width = 20;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
            part(ZddWebClient; "Zetadocs Web Rel. Docs. Page")
            {
                ApplicationArea = All;
                Visible = ZddIsFactboxVisible;
            }

            part(SalesComments; "OBF-Sales Comments FactBox")
            {
                Caption = 'Sales Comments';
                SubPageLink = "Document Type" = const("Posted Invoice"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
            part("OBF-SO Workflow Steps Listpart"; "OBF-SO Workflow Steps Listpart")
            {
                SubPageLink = "Sales Order No." = Field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CompleteCurrentStepAction)
            {
                Caption = 'Complete Current Step';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.CompleteCurrentStep;
                end;
            }
            action(SendToEDITeam)
            {
                Caption = 'Send to EDI Team';
                ToolTip = 'This action completes the current step then sends this posted Sales Invoice to the EDI workflow step.';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = "Process";
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction();
                begin
                    rEC.CompleteCurrentStepAndSendToEDITeam;
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

                trigger OnAction();
                var
                    MiscFunctions: Codeunit "OBF-Misc Functions";
                begin
                    MiscFunctions.CancelPostedSalesInvoiceWorkflowStep(Rec);
                end;
            }

            action(ShowDocument)
            {
                Caption = 'Show Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Posted Sales Invoice";
                RunPageOnRec = true;
            }
            action(WorkflowSteps)
            {
                Caption = 'Workflow Steps';
                Image = Workflow;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    SOWorkflowStep: Record "OBF-SO Workflow Step";
                begin
                    SOWorkflowStep.ShowSOWorkflowSteps(Rec."Order No.");
                end;
            }
            action(ChangeLog)
            {
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "OBF-Change Log Entries";
                RunPageLink = "Primary Key Field 2 Value" = FIELD("Order No.");
                RunPageView = sorting("Table No.", "Primary Key Field 1 Value")
                              Where("Table No." = Filter(36 | 37));
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetFilter("OBF-Workflow Step No.", '>0');
        WorkflowStepFix();

    end;

    trigger OnAfterGetCurrRecord();
    var
        ZdCommon: Codeunit "Zetadocs Common";
        ZdRecRef: RecordRef;
    begin
        CurrentFilters := Rec.GetFilters;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
        if not ZddIsOnAfterGetCurrRecordInitialised then begin
            // Inside OnAfterGetCurrRecord to work around BC sometimes not triggering it 
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

    var
        ZddPrevRecID: RecordID;
        ZddIsFactboxVisible: Boolean;
        ZddIsActionsVisible: Boolean;
        ZddIsOnAfterGetCurrRecordInitialised: Boolean;

        IsDrillDown: Boolean;
        AckRequired: Boolean;
        CurrentFilters: Text;

    procedure SetDrillDown()
    begin
        IsDrillDown := true;
    end;

    Procedure WorkflowStepFix()
    var
        SalesEvents: Codeunit "OBF-Sales Events";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SalesSetup.Get();
        SalesInvoiceHeader.SetRange("OBF-Workflow Step No.", 1, SalesSetup."OBF-Post Invoicing W. Step" - 1);
        if SalesInvoiceHeader.FindSet() then
            repeat
                SalesEvents.SetWorkflowStep(SalesInvoiceHeader);
            until SalesInvoiceHeader.Next() = 0;
    end;
}