// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
table 50026 "OBF-SO Workflow Step"
{
    DrillDownPageID = "OBF-SO Workflow Steps Listpart";
    LookupPageID = "OBF-SO Workflow Steps Listpart";
    Permissions = TableData "Sales Invoice Header" = m, tabledata "OBF-SO Workflow Step" = im;

    fields
    {
        field(1; "Sales Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(2; "Step No."; Integer)
        {
            Caption = 'Step No.';
            TableRelation = "OBF-Workflow Step";
            Editable = false;
        }
        field(3; "Description"; Text[30])
        {
            Caption = 'Step Description';
        }
        field(4; "Assigned to User"; Code[50])
        {
            Caption = 'Assigned to User';
            TableRelation = "User Setup";
            ValidateTableRelation = false;
            trigger OnValidate();
            var
                SalesHeader: Record "Sales Header";
            begin
                TestField("Assigned to Type", "Assigned to Type"::"Individual User");
                "Assigned to User Name" := GetUserName("Assigned to User");
                if not Rec."Post Invoicing Step" then begin
                    CalcFields("Current Step");
                    if "Current Step" then begin
                        SalesHeader.Get(SalesHeader."Document Type"::Order, "Sales Order No.");
                        SalesHeader."OBF-W. Step Assigned to User" := Rec."Assigned to User";
                        SalesHeader."OBF-W. Step Ass. to User Name" := Rec."Assigned to User Name";
                        SalesHeader.Modify(false);
                    end;
                end;
            end;
        }
        field(5; Completed; Boolean)
        {
            Caption = 'Completed';

            trigger OnValidate();
            begin
                if not Rec.Completed then
                    UnCompleteStep
                else
                    if Rec."Post Invoicing Step" then
                        CompleteStep_PostInvoicing
                    else
                        CompleteStep(false);
            end;
        }
        field(6; "Date Completed"; Date)
        {
            Caption = 'Date Completed';
            Editable = false;
        }
        field(7; "Completed by User"; Code[50])
        {
            Caption = 'Completed by User';
            Editable = false;
        }
        field(8; "Next Workflow Step No."; Integer)
        {
            Caption = 'Next Workflow Step No.';
            CalcFormula = Lookup("OBF-Workflow Step"."Next Step No." where("Step No." = field("Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Current Step"; Boolean)
        {
            Caption = 'Current Step';
            CalcFormula = Exist("Sales Header" where("No." = field("Sales Order No."),
                                                      "OBF-Workflow Step No." = field("Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Assigned to Type"; enum "OBF-Workflow Assigned to Type")
        {
            CalcFormula = Lookup("OBF-Workflow Step"."Assigned to Type" where("Step No." = field("Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Is Posted"; Boolean)
        {
            Caption = 'Is Posted';
            CalcFormula = Exist("Sales Invoice Header" where("Order No." = field("Sales Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Assigned to W. User Group"; Code[20])
        {
            Caption = 'Assigned to Workflow User Group';
            TableRelation = "Workflow User Group";
            CalcFormula = Lookup("OBF-Workflow Step"."Assigned to W. User Group" where("Step No." = field("Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Assigned to User Name"; Code[50])
        {
            Caption = 'Assigned to User Name';
            Editable = false;
        }
        field(17; "Post Invoicing Step"; Boolean)
        {
            Caption = 'Post Invoicing Step';
            Editable = false;
        }
        field(18; "Current Post Invoicing Step"; Boolean)
        {
            Caption = 'Current Post Invoicing Step';
            CalcFormula = Exist("Sales Invoice Header" where("Order No." = field("Sales Order No."),
                                                      "OBF-Workflow Step No." = field("Step No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Sales Order No.", "Step No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        if not "Post Invoicing Step" then begin
            CalcFields("Is Posted");
            TestField("Is Posted", false);
        end;
    end;

    procedure CompleteStep(IncrementNoOfRevisions: Boolean);
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        WorkflowStep: Record "OBF-Workflow Step";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        NextStep: Record "OBF-SO Workflow Step";
        PreviousStepAssignedTo: code[50];
        NextStepNo: Integer;
    begin
        Rec.CalcFields("Assigned to W. User Group");
        if Rec."Assigned to W. User Group" <> 'SALES' then
            CheckUserAllowedToEdit;
        SalesSetup.Get;
        Rec.CalcFields("Current Step");
        if Rec."Step No." > SalesSetup."OBF-Submit to Shipping Step" then
            Rec.TestField("Current Step", true);
        if Rec."Step No." = SalesSetup."OBF-Posting Step" then
            Error('Step %1 %2 is the Posting Step.  To complete it, you must post the sales order.', Rec."Step No.", Rec.Description);
        SetSOWorkFlowStepCompleted(Rec);

        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Sales Order No.");

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1344 - Resubmit to Shipping Bug
        // SalesHeader.SetWhseShippingReleaseNote();
        // SalesHeader.SetPOAckNote();
        
        Rec.CalcFields("Next Workflow Step No.");
        NextStepNo := 0;
        if Rec."Next Workflow Step No." <> 0 then
            if SOWorkflowStep.Get(Rec."Sales Order No.", Rec."Next Workflow Step No.") then
                if not SOWorkflowStep.Completed then
                    NextStepNo := Rec."Next Workflow Step No.";

        if NextStepNo = 0 then
            NextStepNo := LookupNextStep(Rec."Sales Order No.", Rec."Step No.");

        NextStep.Get(Rec."Sales Order No.", NextStepNo);

        PreviousStepAssignedTo := SalesHeader."OBF-W. Step Assigned to User";
        SalesHeader.Validate("OBF-Workflow Step No.", NextStepNo);
        if SalesHeader."OBF-W. Step Assigned to User" <> PreviousStepAssignedTo then
            SalesHeader."OBF-Workflow Step Acknowledged" := false;

        if SalesHeader."OBF-Submittal Timestamp" = 0DT then
            SalesHeader."OBF-Submittal Timestamp" := CurrentDateTime;
        if IncrementNoOfRevisions then
            SalesHeader."OBF-No. of Revisions" += 1;

        SalesHeader.Modify(false);

    end;

    procedure CompleteStep_PostInvoicing();
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        WorkflowStep: Record "OBF-Workflow Step";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        NextStep: Record "OBF-SO Workflow Step";
        NextStepNo: Integer;
    begin
        Rec.TestField("Post Invoicing Step", true);
        Rec.CalcFields("Current Post Invoicing Step");
        Rec.TestField("Current Post Invoicing Step", true);
        SetSOWorkFlowStepCompleted(Rec);
        SalesInvoiceHeader.SetRange("Order No.", Rec."Sales Order No.");
        SalesInvoiceHeader.FindFirst;

        Rec.CalcFields("Next Workflow Step No.");
        NextStepNo := 0;
        if Rec."Next Workflow Step No." <> 0 then
            if SOWorkflowStep.Get(Rec."Sales Order No.", Rec."Next Workflow Step No.") then
                if not SOWorkflowStep.Completed then
                    NextStepNo := Rec."Next Workflow Step No.";

        if NextStepNo = 0 then begin
            SalesInvoiceHeader."OBF-Workflow Step No." := 0;
            SalesInvoiceHeader."OBF-Workflow Step Description" := '';
            SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := '';
        end else begin
            NextStep.Get(Rec."Sales Order No.", NextStepNo);
            SalesInvoiceHeader."OBF-Workflow Step No." := NextStepNo;
            SalesInvoiceHeader."OBF-Workflow Step Description" := NextStep.Description;
            NextStep.CalcFields("Assigned to W. User Group");
            SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := NextStep."Assigned to W. User Group";
        end;
        SalesInvoiceHeader.Modify(false);
    end;

    procedure UnCompleteStep();
    var
        IsLastStep: Boolean;
        SalesHeader: Record "Sales Header";
    begin
        IsLastStep := IsLastCompletedStepForSalesOrder(Rec."Sales Order No.", Rec."Step No.");
        Rec."Date Completed" := 0D;
        Rec."Completed by User" := '';
        if IsLastStep then
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Sales Order No.") then begin
                SalesHeader."OBF-Workflow Step No." := Rec."Step No.";
                SalesHeader."OBF-Workflow Step Description" := Rec.Description;
                SalesHeader."OBF-W. Step Assigned to User" := Rec."Assigned to User";
                SalesHeader."OBF-W. Step Ass. to User Name" := Rec."Assigned to User Name";
                SalesHeader."OBF-Workflow Step Acknowledged" := false;
                SalesHeader.Modify(false);
                Message('Step %1-"%2" was uncompleted and set as the current step for this sales order', Rec."Step No.", Rec.Description);
                exit;
            end;

        Message('You might also need to use the "Set Current Step" action to change the currently assigned workflow step for the Sales Order.');
    end;

    procedure IsLastCompletedStepForSalesOrder(OrderNo: code[20]; StepNo: Integer): Boolean;
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        IsLastStep: Boolean;
    begin
        SOWorkflowStep.SetRange("Sales Order No.", OrderNo);
        SOWorkflowStep.SetRange(Completed, true);
        SOWorkflowStep.SetCurrentKey("Sales Order No.", "Step No.");
        if not SOWorkflowStep.FindLast then
            exit(false);

        IsLastStep := SOWorkflowStep."Step No." = StepNo;
        exit(IsLastStep);
    end;

    procedure SubmitOrderToShipping(var SalesHeader2: Record "Sales Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        SalesHeader: Record "Sales Header";
        MiscFunctions: Codeunit "OBF-Misc Functions";
        RebateManagement: Codeunit "OBF-Rebate Management";
        NoOfRevisions: Integer;
        EnterOrderCommentCancelled: Boolean;
    begin

        SalesHeader := SalesHeader2;
        SalesHeader.SetRecFilter;
        SalesHeader.FindFirst;

        SOWorkflowStep.SetRange("Sales Order No.", SalesHeader."No.");
        if not SOWorkflowStep.IsEmpty then
            Error('This Sales Order has already been sent to traffic.');

        if SalesHeader."OBF-Assigned Traffic Person" = '' then begin
            SalesHeader.Validate("OBF-Assigned Traffic Person", LookupTrafficPerson);
            SalesHeader.Modify;
            Commit;  // This is needed because the Sales Header record can also be modified by the SOWorkflowStep.CompleteStep below
        end;

        SalesHeader.TestField("OBF-Workflow Salesperson Code");

        if not SalesHeader.CheckIfOrderIsFullyAllocated then
            error('This order is not fully allocated.');

        SalesHeader.TestField("Shipment Method Code");

        if not CheckCreditLimit(SalesHeader."Sell-to Customer No.", SalesHeader."No.") then
            exit;

        Commit;
        MiscFunctions.EnterOrderComment(SalesHeader, false, NoOfRevisions, EnterOrderCommentCancelled);
        if not EnterOrderCommentCancelled then begin
            CopyWorkflowstepsToSalesOrder(SalesHeader."No.", SalesHeader."OBF-Workflow Salesperson Code", SalesHeader."OBF-Assigned Traffic Person", SalesHeader."Sell-to Customer Name");
            SalesSetup.Get;
            SOWorkflowStep.Get(SalesHeader."No.", SalesSetup."OBF-Submit to Shipping Step");
            SOWorkflowStep.CompleteStep(false);
            SOWorkflowStep.Modify;

            RebateManagement.GetRebates(SalesHeader);

        end;
        SalesHeader2 := SalesHeader;
    end;

    procedure LookupTrafficPerson(): Code[50]
    var
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        WorkflowUserGroupMembersPage: Page "OBF-Workflow Group Members";
    begin
        Clear(WorkflowUserGroupMembersPage);
        WorkflowUserGroupMember.SetRange("Workflow User Group Code", 'TRAFFIC');
        WorkflowUserGroupMembersPage.SetRecord(WorkflowUserGroupMember);
        WorkflowUserGroupMembersPage.SetTableView(WorkflowUserGroupMember);
        WorkflowUserGroupMembersPage.LookupMode(true);
        if WorkflowUserGroupMembersPage.RunModal = Action::LookupOK then begin
            WorkflowUserGroupMembersPage.GetRecord(WorkflowUserGroupMember);
            exit(WorkflowUserGroupMember."User Name");
        end else
            Error('You must select a Traffic Person.');
    end;

    procedure RestartWorkflowProcess(var SalesHeader: Record "Sales Header")
    // This function is used by Traffic to restart the workflow process.  
    // This can only be done before the BOL is received from Cold Storage.
    // This checks to see if there are any EDI 940 flags set;  If so, these must be cancelled before proceeding. 
    // This then uncompletes any completed steps and sets the Current Step to 1 “Submit/Resubmit Order to Shipping”.
    var
        UserSetup: Record "User Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SalesSetup.Get;
        UserSetup.Get(UserId);
        UserSetup.TestField("OBF-Allow Edit After Shipped");

        if SalesHeader."OBF-Workflow Step No." <> 0 then begin
            SOWorkflowStep.ResetWorkflowStep(SalesHeader."No.", SalesSetup."OBF-Submit to Shipping Step");
            SOWorkflowStep.ResetWorkflowStep(SalesHeader."No.", SalesSetup."OBF-Shipping Release Step");
            SOWorkflowStep.ResetWorkflowStep(SalesHeader."No.", SalesSetup."OBF-Cold Storage Step");
            SOWorkflowStep.Get(SalesHeader."No.", SalesSetup."OBF-Submit to Shipping Step");
            SOWorkflowStep.SetCurrentStep;
        end;
    end;

    procedure ResubmitOrderToShipping(var SalesHeader: Record "Sales Header")
    var
        MiscFunctions: Codeunit "OBF-Misc Functions";
        SalesSetup: Record "Sales & Receivables Setup";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        NoOfRevisions: Integer;
        EnterOrderCommentsCancelled: Boolean;
    begin
        // This function is used by the Salesperson to resubmit an order to shipping after a revision. 
        SalesSetup.Get;
        if SalesHeader."OBF-Workflow Step No." = 0 then
            Error('The Sales Order workflow has not been started for this order.');

        if SalesHeader."OBF-Workflow Step No." > SalesSetup."OBF-Submit to Shipping Step" then
            Error('This order has been submitted to traffic.  To make a revision, please contact Traffic to restart the Sales Order workflow process.');

        if not SalesHeader.CheckIfOrderIsFullyAllocated then
            error('This order is not fully allocated.');

        Commit;
        MiscFunctions.EnterOrderComment(SalesHeader, true, NoOfRevisions, EnterOrderCommentsCancelled);
        if EnterOrderCommentsCancelled then
            exit;

        SOWorkflowStep.Get(SalesHeader."No.", SalesSetup."OBF-Submit to Shipping Step");
        SOWorkflowStep.CompleteStep(true);
        SOWorkflowStep.Modify;
    end;

    procedure CopyWorkflowstepsToSalesOrder(OrderNo: Code[20]; WorkflowSalespersonCode: Code[20]; AssignedTrafficPerson: Code[50]; CustomerName: Text[100]);
    var
        WorkflowStep: Record "OBF-Workflow Step";
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        UserSetup: Record "User Setup";
        MissingSalespersonMessageSent: Boolean;

    begin
        WorkflowStep.FindSet;
        repeat
            SOWorkflowStep.Init;
            SOWorkflowStep.TransferFields(WorkflowStep);
            SOWorkflowStep."Sales Order No." := OrderNo;
            SOWorkflowStep.CalcFields("Assigned to W. User Group", "Assigned to Type");
            if SOWorkflowStep."Assigned to Type" = SOWorkflowStep."Assigned to Type"::Team then
                SOWorkflowStep."Assigned to User" := Format(SOWorkflowStep."Assigned to W. User Group")
            else
                case SOWorkflowStep."Assigned to W. User Group" of
                    'SALES':
                        SOWorkflowStep."Assigned to User" := GetUserForSalesperson(WorkflowSalespersonCode, MissingSalespersonMessageSent);

                    'TRAFFIC':
                        if AssignedTrafficPerson <> '' then
                            SOWorkflowStep."Assigned to User" := AssignedTrafficPerson;
                    else
                        SOWorkflowStep."Assigned to User" := '';
                end;
            SOWorkflowStep."Assigned to User Name" := SOWorkflowStep.GetUserName(SOWorkflowStep."Assigned to User");
            SOWorkflowStep."Customer Name" := CustomerName;
            SOWorkflowStep.Insert;
        until (WorkflowStep.Next = 0);
    end;

    procedure GetUserForSalesperson(SalespersonCode: code[20]; var MissingSalespersonMessageSent: Boolean): Code[50];
    var
        UserSetup: Record "User Setup";
    begin
        if SalespersonCode = '' then
            exit('');

        UserSetup.SetRange("Salespers./Purch. Code", SalespersonCode);
        if UserSetup.FindFirst then
            exit(UserSetup."User ID");

        if not MissingSalespersonMessageSent then begin
            message('You must create a User Setup record for Salesperson %1 for the Assigned to User to be set properly.', SalespersonCode);
            MissingSalespersonMessageSent := true;
        end;

        exit('');
    end;

    procedure SetSOWorkFlowStepCompleted(var SOWorkflowStep: Record "OBF-SO Workflow Step");
    begin
        SOWorkflowStep.Completed := true;
        SOWorkflowStep."Completed by User" := GetUserName(UserId);
        SOWorkflowStep."Date Completed" := TODAY;
    end;

    procedure SetCurrentStep();
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        Rec.TestField(Completed, false);
        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Sales Order No.") then begin
            if SalesHeader."OBF-Workflow Step No." = Rec."Step No." then
                exit;
            SalesHeader.Validate("OBF-Workflow Step No.", Rec."Step No.");
            SalesHeader."OBF-Workflow Step Acknowledged" := false;
            SalesHeader.Modify(false);
        end else begin
            SalesInvoiceHeader.SetRange("Order No.", Rec."Sales Order No.");
            if SalesInvoiceHeader.FindFirst then begin
                SalesInvoiceHeader."OBF-Workflow Step No." := Rec."Step No.";
                SalesInvoiceHeader."OBF-Workflow Step Description" := Rec.Description;
                Rec.CalcFields("Assigned to W. User Group");
                SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := Rec."Assigned to W. User Group";
                SalesInvoiceHeader.Modify;
            end;
        end;
    end;

    procedure DeleteAllSteps(SalesOrderNo: Code[20]);
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCommentLine: Record "Sales Comment Line";
        Question: Label 'Do you also want to clear the Submittal Timestamp, the No. of Revisions and the Release or Revision Notes?';
        Answer: Boolean;
        IsSalesOrder: Boolean;
    begin
        if SalesOrderNo = '' then
            exit;
        CheckUserAllowedToEdit;
        IsSalesOrder := SalesHeader.get(SalesHeader."Document Type"::Order, SalesOrderNo);
        // if IsSalesOrder then
        //     CheckThatAll940FlagsAreCleared(SalesHeader);

        SOWorkflowStep.SetRange("Sales Order No.", SalesOrderNo);
        SOWorkflowStep.DeleteAll;

        if IsSalesOrder then begin
            SalesHeader.Validate("OBF-Workflow Step No.", 0);
            SalesHeader."OBF-Workflow Step Acknowledged" := false;
            if Dialog.Confirm(Question, false) then begin
                SalesHeader."OBF-Submittal Timestamp" := 0DT;
                SalesHeader."OBF-No. of Revisions" := 0;
                SalesCommentLine.SetRange("No.", SalesOrderNo);
                SalesCommentLine.SetRange("Print On Pick Ticket", true);
                SalesCommentLine.DeleteAll;
            end;
            SalesHeader.Modify(false);
        end else begin
            SalesInvoiceHeader.SetRange("Order No.", Rec."Sales Order No.");
            if SalesInvoiceHeader.FindFirst then begin
                SalesInvoiceHeader."OBF-Workflow Step No." := 0;
                SalesInvoiceHeader."OBF-Workflow Step Description" := '';
                SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := '';
                SalesInvoiceHeader.Modify;
            end;
        end;

    end;

    procedure GetUserName(UserName: Code[50]): Code[50];
    var
        SlashPosition: Integer;
    begin
        SlashPosition := StrPos(UserName, '\');
        if SlashPosition = 0 then
            exit(UserName)
        else
            exit(CopyStr(UserName, SlashPosition + 1));
    end;

    procedure LookupNextStep(OrderNo: Code[20]; CurrentStepNo: Integer): Integer;
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
        SOWorkflowSteps: Page "OBF-SO Workflow Step Lookup";
    begin
        SOWorkflowStep.Reset;
        SOWorkflowStep.SetFilter("Sales Order No.", OrderNo);
        SOWorkflowStep.SetRange(Completed, false);
        SOWorkflowStep.SetRange("Post Invoicing Step", false);
        SOWorkflowStep.SetFilter("Step No.", '<>%1', CurrentStepNo);
        if SOWorkflowStep.Count = 1 then begin
            SOWorkflowStep.FindFirst;
            exit(SOWorkflowStep."Step No.");
        end;

        Clear(SOWorkflowSteps);
        SOWorkflowSteps.SetRecord(SOWorkflowStep);
        SOWorkflowSteps.SetTableView(SOWorkflowStep);
        SOWorkflowSteps.LookupMode(true);
        if SOWorkflowSteps.RunModal = Action::LookupOK then begin
            SOWorkflowSteps.GetRecord(SOWorkflowStep);
            exit(SOWorkflowStep."Step No.");
        end else
            Error('You must select the next workflow step.');
    end;

    procedure ShowSOWorkflowSteps(OrderNo: Code[20]);
    var
        SOWorkflowSteps: Page "OBF-SO Workflow Steps";
    begin
        CheckUserAllowedToEdit;
        SOWorkflowSteps.SetSalesOrder(OrderNo);
        SOWorkflowSteps.RunModal;
    end;

    procedure ResetWorkflowStep(OrderNo: Code[20]; StepNo: Integer);
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        CheckUserAllowedToEdit;
        if SOWorkflowStep.Get(OrderNo, StepNo) then
            if SOWorkflowStep.Completed then begin
                SOWorkflowStep.Completed := false;
                SOWorkflowStep."Date Completed" := 0D;
                SOWorkflowStep."Completed by User" := '';
                SOWorkflowStep.Modify;
            end;
    end;

    procedure UpdateUserOnSalesHeader();
    var
        SalesHeader: Record "Sales Header";
    begin
        if (Rec."Assigned to User" = xRec."Assigned to User") then
            exit;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Sales Order No.") then
            exit;

        SalesHeader."OBF-W. Step Assigned to User" := Rec."Assigned to User";
        SalesHeader."OBF-W. Step Ass. to User Name" := Rec."Assigned to User Name";
        SalesHeader.Modify(false);
    end;


    procedure CheckUserAllowedToEdit()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."OBF-Allow Edit After Shipped" then
            Error('Order modification not allowed after it is submitted to shipping.  Request Traffic to restart workflow so that you may proceed. Contact NAVHELP if you need more information.');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1003 - Credit Overline
    local procedure CheckCreditLimit(CustomerNo: Code[20]; SalesOrderNo: Code[20]): Boolean;
    var
        Customer: Record Customer;
        TotalAmount: Decimal;
        OverlineURL: Text;
        ConfirmationTxt: Label 'The Customer''s credit limit has been exceeded.  Have you uploaded the Credit Overline pdf to the Documents factbox?';
        OverlineURLTxt: Label 'http://odyit01/nav/default.php?go=155&sonum=';
    begin
        Customer.Get(CustomerNo);
        Customer.CALCFIELDS("Outstanding Orders (LCY)", "Balance (LCY)");
        TotalAmount := Customer."Outstanding Orders (LCY)" + Customer."Balance (LCY)";
        if TotalAmount <= Customer."Credit Limit (LCY)" then
            exit(true);

        if Dialog.Confirm(ConfirmationTxt) then
            exit(true);

        OverlineURL := OverlineURLTxt + SalesOrderNo;
        Hyperlink(OverlineURL);
        exit(false);

    end;

}