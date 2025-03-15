// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
page 50078 "OBF-SO Workflow Steps"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "OBF-SO Workflow Step";
    Caption = 'SO Workflow Steps';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            repeater(Group)
            {
                field("Step No."; Rec."Step No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    Lookup = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Width = 30;
                }
                field("Assigned to Type"; Rec."Assigned to Type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Assigned to W. User Group"; Rec."Assigned to W. User Group")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Assigned to User"; Rec."Assigned to User")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Width = 20;
                }
                field("Current Step"; Rec."Current Step")
                {
                    ApplicationArea = All;
                }
                field("Current Post Invoicing Step"; Rec."Current Post Invoicing Step")
                {
                    ApplicationArea = All;
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Date Completed"; Rec."Date Completed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Completed by User"; Rec."Completed by User")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Width = 20;
                }
                field("Next Workflow Step No."; Rec."Next Workflow Step No.")
                {
                    ApplicationArea = All;
                }
                field("Post Invoicing Step"; Rec."Post Invoicing Step")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CompleteStep)
            {
                Caption = 'Complete';
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.Validate(Completed, true);
                end;
            }
            action(UnCompleteStep)
            {
                Caption = 'Uncomplete Step';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.Validate(Completed, false);
                end;
            }
            action(SetCurrentStep)
            {
                Caption = 'Set Current Step';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.SetCurrentStep;
                end;
            }
            action(DeleteAllSteps)
            {
                Caption = 'Delete All Steps';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.DeleteAllSteps(Rec."Sales Order No.");
                end;
            }
        }
    }

    var
        SalesOrderNo: Code[20];

    trigger OnOpenPage();
    begin
        Rec.SetRange("Sales Order No.", SalesOrderNo);
        if SalesOrderNo = '' then
            Error('The Sales Order No. cannot be blank in the SO Workflow Steps page')
        else
            if Rec.Count = 0 then
                Error('There are no Workflow Steps associated with Order %1', SalesOrderNo);
    end;

    procedure SetSalesOrder(pSalesOrderNo: code[20]);
    begin
        SalesOrderNo := pSalesOrderNo;
    end;
}