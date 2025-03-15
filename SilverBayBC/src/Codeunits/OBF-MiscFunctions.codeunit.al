// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
codeunit 50065 "OBF-Misc Functions"
{
    Permissions = TableData "Sales Invoice Header" = m;

    trigger OnRun();
    begin
    end;

    procedure MyOrdersCount(): Integer;
    var
        SalesHeader: Record "Sales Header";
    begin
        SetStepAssignedToUserFilter(SalesHeader);
        exit(SalesHeader.Count);
    end;

    procedure SalespersonOrdersCount(): Integer;
    var
        SalesHeader: Record "Sales Header";
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then begin
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange("OBF-Workflow Salesperson Code", UserSetup."Salespers./Purch. Code");
                exit(SalesHeader.Count);
            end;
        exit(0);
    end;

    procedure MyUnacknowledgedOrdersCount(): Integer;
    var
        SalesHeader: Record "Sales Header";
    begin
        SetFilterForUnacknowledgedOrders(SalesHeader);
        exit(SalesHeader.Count);
    end;

    procedure OrdersAssignedToWorkflowGroupCount(WorkflowUserGroup: Code[20]): Integer;
    var
        SalesHeader: Record "Sales Header";
    begin
        SetSalesHeaderFilterForWorkflowGroup(SalesHeader, WorkflowUserGroup);
        exit(SalesHeader.Count);
    end;

    procedure InvoicesAssignedToWorkflowGroupCount(WorkflowUserGroup: Code[20]): Integer;
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SetSalesInvoiceHeaderFilterForWorkflowGroup(SalesInvoiceHeader, WorkflowUserGroup);
        exit(SalesInvoiceHeader.Count);
    end;

    Procedure SalespersonCustomersCount(): Integer;
    var
        Customer: Record Customer;
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then begin
                Customer.SetRange("OBF-Workflow Salesperson Code", UserSetup."Salespers./Purch. Code");
                exit(Customer.Count);
            end;
        exit(0);
    end;

    procedure SalespersonCustomersDrilldown();
    var
        Customer: Record Customer;
        UserSetup: Record "User Setup";
        CustomerList: page "Customer List";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then begin
                Customer.SetRange("OBF-Workflow Salesperson Code", UserSetup."Salespers./Purch. Code");
                if not Customer.IsEmpty then begin
                    CustomerList.SetTableView(Customer);
                    CustomerList.Run;
                end;
            end;
    end;

    procedure SalespersonOrdersDrilldown();
    var
        SalesHeader: Record "Sales Header";
        UserSetup: Record "User Setup";
        SalesOrderList: page "Sales Order List";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then begin
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Order);
                SalesHeader.SetRange("OBF-Workflow Salesperson Code", UserSetup."Salespers./Purch. Code");
                if SalesHeader.IsEmpty then
                    exit;
                SalesOrderList.SetTableView(SalesHeader);
                SalesOrderList.Run;
            end;
    end;

    procedure MyOrdersDrilldown();
    var
        SalesHeader: Record "Sales Header";
        SalesOrdersInProcess: Page "OBF-Sales Orders in Process";
    begin
        SetStepAssignedToUserFilter(SalesHeader);
        if SalesHeader.IsEmpty then
            exit;
        SalesOrdersInProcess.SetDrillDown;
        SalesOrdersInProcess.SetTableView(SalesHeader);
        SalesOrdersInProcess.Run;
    end;

    procedure MyUnacknowledgedOrdersDrilldown();
    var
        SalesHeader: Record "Sales Header";
        SalesOrdersInProcess: Page "OBF-Sales Orders in Process";
    begin
        SetFilterForUnacknowledgedOrders(SalesHeader);
        if SalesHeader.IsEmpty then
            exit;
        SalesOrdersInProcess.SetDrillDown;
        SalesOrdersInProcess.SetTableView(SalesHeader);
        SalesOrdersInProcess.Run;
    end;

    procedure SalesOrdersInProcessDrilldown(WorkflowUserGroupCode: Code[20]);
    var
        SalesHeader: Record "Sales Header";
        SalesOrdersInProcess: Page "OBF-Sales Orders in Process";
    begin
        SetSalesHeaderFilterForWorkflowGroup(SalesHeader, WorkflowUserGroupCode);
        if SalesHeader.IsEmpty then
            exit;
        SalesOrdersInProcess.SetDrillDown;
        SalesOrdersInProcess.SetTableView(SalesHeader);
        SalesOrdersInProcess.Run;
    end;

    procedure PostedSalesInvoicesInProcessDrilldown(WorkflowUserGroupCode: Code[20]);
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PostedSalesInvoicesInProcess: Page "OBF-Posted Inv. in Proc.";
    begin
        SetSalesInvoiceHeaderFilterForWorkflowGroup(SalesInvoiceHeader, WorkflowUserGroupCode);
        if SalesInvoiceHeader.IsEmpty then
            exit;
        PostedSalesInvoicesInProcess.SetDrillDown;
        PostedSalesInvoicesInProcess.SetTableView(SalesInvoiceHeader);
        PostedSalesInvoicesInProcess.Run;
    end;

    procedure SetStepAssignedToUserFilter(var SalesHeader: Record "Sales Header")
    var
        WorkflowUserGroup: Code[20];
    begin
        WorkflowUserGroup := WhichTeamIsUserPartOf();
        case WorkflowUserGroup of
            'WORKORDER', 'INVOICING':
                SalesHeader.SetRange("OBF-W. Step Assigned to User", WorkflowUserGroup);
            else
                SalesHeader.SetRange("OBF-W. Step Assigned to User", UserId);
        end;
    end;

    procedure SetFilterForUnacknowledgedOrders(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetRange("OBF-W. Step Assigned to User", UserId);
        SalesHeader.SetRange("OBF-Workflow Step Acknowledged", false);
    end;

    local procedure SetSalesInvoiceHeaderFilterForWorkflowGroup(var SalesInvoiceHeader: Record "Sales Invoice Header"; WorkflowUserGroupCode: Code[20])
    begin
        SalesInvoiceHeader.SetRange("OBF-Wk. Step Assg. to Group", WorkflowUserGroupCode);
    end;

    local procedure SetSalesHeaderFilterForWorkflowGroup(var SalesHeader: Record "Sales Header"; WorkflowUserGroupCode: Code[20])
    begin
        SalesHeader.SetRange(SalesHeader."OBF-W. Step Assigned to User", WorkflowUserGroupCode);
    end;

    procedure WhichTeamIsUserPartOf(): Code[20]
    var
        WorkflowUserGroupMember: Record "Workflow User Group Member";
    begin
        WorkflowUserGroupMember.SetRange("User Name", UserId);
        if WorkflowUserGroupMember.FindFirst then
            exit(WorkflowUserGroupMember."Workflow User Group Code")
        else
            exit('');
    end;

    procedure EnterOrderComment(SalesHeader: Record "Sales Header"; IsRevision: Boolean;
        var NoOfRevisions: Integer; var EnterOrderCommentsCancelled: Boolean)
    var
        EnterOrderCommentPage: Page "OBF-Enter Order Comment";
        RevisionComment: Text[1010];
    begin
        SalesHeader.SetRecFilter;
        EnterOrderCommentPage.SetRecord(SalesHeader);
        EnterOrderCommentPage.SetTableView(SalesHeader);
        EnterOrderCommentPage.LookupMode := true;

        if (EnterOrderCommentPage.RunModal = Action::LookupCancel) then begin
            EnterOrderCommentsCancelled := true;
            exit;
        end;

        EnterOrderCommentPage.GetCommentText(RevisionComment);

        if IsRevision then begin
            if StrLen(RevisionComment) = 0 then
                Error('You must enter a revision comment');
            NoOfRevisions := SalesHeader."OBF-No. of Revisions" + 1;
            RevisionComment := 'REV ' + FORMAT(NoOfRevisions) + ': ' + RevisionComment;
        end else begin
            NoOfRevisions := 0;
            if RevisionComment <> '' then
                RevisionComment := 'REL: ' + RevisionComment;
        end;

        if RevisionComment <> '' then
            SplitComment(SalesHeader, RevisionComment, NoOfRevisions);
    end;

    local procedure SplitComment(pSalesHeader: Record "Sales Header"; CommentText: Text; RevisionNo: Integer);
    var
        SpaceLeft: Integer;
        Word: Text;
        CommentLine: Record "Sales Comment Line";
        LineNo: Integer;
        TempWord: Text[50];
        Pos: Integer;
    begin
        CommentLine.Reset;
        CommentLine.SetRange("Document Type", pSalesHeader."Document Type");
        CommentLine.SetRange("No.", pSalesHeader."No.");
        CommentLine.SetRange("Document Line No.", 0);
        if CommentLine.FindLast then
            LineNo := CommentLine."Line No.";
        CommentLine.Init;
        CommentLine."Document Type" := pSalesHeader."Document Type";
        CommentLine."No." := pSalesHeader."No.";
        CommentLine.Date := Today;
        CommentLine."Document Line No." := 0;
        CommentLine.Code := CopyStr(UserId, 1, 10);
        CommentLine."Print On Pick Ticket" := true;
        CommentLine."OBF-Revision No." := RevisionNo;
        SpaceLeft := MaxStrLen(CommentLine.Comment);
        while StrLen(CommentText) > 0 do begin
            Pos := StrPos(CommentText, ' ');
            if Pos > 50 then
                Pos := 50 - 1;
            if Pos > 0 then begin
                Word := CopyStr(CommentText, 1, Pos);
                CommentText := CopyStr(CommentText, Pos + 1);
            end else begin
                if StrLen(CommentText) >= 50 then begin
                    Word := CopyStr(CommentText, 1, 50 - 1);
                    CommentText := CopyStr(CommentText, 50);
                end else begin
                    Word := CommentText;
                    Clear(CommentText);
                end;
            end;
            if (StrLen(Word) > SpaceLeft) then begin
                LineNo += 10000;
                CommentLine."Line No." := LineNo;
                CommentLine.Insert(true);
                CommentLine.Comment := '';
            end;
            TempWord := CopyStr(Word, 1);
            CommentLine.Validate(Comment, CommentLine.Comment + TempWord);
            SpaceLeft := 50 - StrLen(CommentLine.Comment);
            if StrLen(CommentText) = 0 then begin
                LineNo += 10000;
                CommentLine."Line No." := LineNo;
                CommentLine.Insert(true);
            end;
        end;
    end;

    procedure SendPostedSalesInvoiceToWorkflowUserGroup(var SalesInvoiceHeader: Record "Sales Invoice Header"; SendToWorkflowUserGroup: code[20]);
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SOWorkflowStep.SetRange("Sales Order No.", SalesInvoiceHeader."Order No.");
        if not SOWorkflowStep.FindFirst then
            SOWorkflowStep.CopyWorkflowstepsToSalesOrder(SalesInvoiceHeader."Order No.", '', '', SalesInvoiceHeader."Sell-to Customer Name");

        SOWorkflowStep.Reset;
        SOWorkflowStep.SetRange("Sales Order No.", SalesInvoiceHeader."Order No.");
        SOWorkflowStep.SetRange("Assigned to W. User Group", SendToWorkflowUserGroup);
        SOWorkflowStep.SetRange("Post Invoicing Step", true);
        if not SOWorkflowStep.FindFirst then
            Error('There are no Post Invoicing Steps assigned to Workflow User Group %1', SendToWorkflowUserGroup)
        else
            if SOWorkflowStep.Completed then
                Error('The Workflow Associated with Workflow Group %1 has already been completed.', SendToWorkflowUserGroup);
        if SalesInvoiceHeader."OBF-Workflow Step No." = 0 then begin
            SalesInvoiceHeader."OBF-Workflow Step No." := SOWorkflowStep."Step No.";
            SalesInvoiceHeader."OBF-Workflow Step Description" := SOWorkflowStep.Description;
            SOWorkflowStep.CalcFields("Assigned to W. User Group");
            SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := SOWorkflowStep."Assigned to W. User Group";
            SalesInvoiceHeader.Modify;
        end else begin
            Error('This Posted Sales Invoice is already assigned to Workflow User Group %1.', SalesInvoiceHeader."OBF-Wk. Step Assg. to Group");
        end;
    end;

    procedure CancelPostedSalesInvoiceWorkflowStep(var SalesInvoiceHeader: Record "Sales Invoice Header");
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        SalesInvoiceHeader.TestField("OBF-Workflow Step No.");
        SOWorkflowStep.SetRange("Sales Order No.", SalesInvoiceHeader."Order No.");
        SOWorkflowStep.SetRange("Post Invoicing Step", true);
        SOWorkflowStep.SetRange("Assigned to W. User Group", SalesInvoiceHeader."OBF-Wk. Step Assg. to Group");
        SOWorkflowStep.SetRange(Completed, true);
        if SOWorkflowStep.FindSet then
            repeat
                SOWorkflowStep.Completed := false;
                SOWorkflowStep."Completed by User" := '';
                SOWorkflowStep."Date Completed" := 0D;
                SOWorkflowStep.Modify;
            until (SOWorkflowStep.Next = 0);

        SalesInvoiceHeader."OBF-Workflow Step No." := 0;
        SalesInvoiceHeader."OBF-Workflow Step Description" := '';
        SalesInvoiceHeader."OBF-Wk. Step Assg. to Group" := '';
        SalesInvoiceHeader.Modify;
    end;

    procedure FormatLocationAddress(var AddrArray: array[8] of Text[50]; var Location: Record Location);
    var
        FormatAddress : Codeunit "Format Address";
        LocationContact : Text;
    begin

        if Location.Contact <> '' then
            LocationContact := Location.Contact
        else
            LocationContact := 'Location Contact';
        FormatAddress.FormatAddr(
              AddrArray, Location.Name, Location."Name 2", 'Location Contact', Location.Address, Location."Address 2",
              Location.City, Location."Post Code", Location.County, Location."Country/Region Code");
    end;
}