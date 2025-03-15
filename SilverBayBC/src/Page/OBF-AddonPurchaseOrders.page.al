// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
page 50099 "OBF-Add-on Purchase Orders"
{
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;
    CaptionML = ENU = 'Add-on Purchase Orders';
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SalesOrderNo; SalesOrderNo)
                {
                    Caption = 'Sales Order No.';
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction();
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PageManagement: Codeunit "Page Management";
                    begin
                        PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                        PageManagement.PageRun(PurchaseHeader);
                    end;
                }
                action(CreateAddOnPurchOrderAction)
                {
                    Caption = 'Create Add-on Purch. Order';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;                    
                    trigger OnAction();
                    begin
                        CreateAddOnPurchOrder(SalesHeader);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        SetData;
    end;

    trigger OnAfterGetRecord();
    begin
        Rec.CalcFields(Amount);
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesOrderNo: Code[20];

    local procedure SetData();
    var
        DistinctAddOnPOQuery: Query "OBF-Distinct Add-on PO Query";
        PurchaseHeader: Record "Purchase Header";
    begin
        if SalesOrderNo = '' then
            exit;

        DistinctAddOnPOQuery.SetRange(Orig_Doc_No, SalesOrderNo);
        DistinctAddOnPOQuery.OPEN;
        while DistinctAddOnPOQuery.READ do begin
            PurchaseHeader.Get(Rec."Document Type"::Order, DistinctAddOnPOQuery.Document_No);
            Rec := PurchaseHeader;
            Rec.Insert;
        end;

        if not Rec.IsEmpty then
            Rec.FindFirst;

    end;

    procedure SetSalesOrder(pSalesHeader: Record "Sales Header");
    begin
        SalesHeader := pSalesHeader;
        SalesOrderNo := pSalesHeader."No.";
    end;

    local procedure CreateAddOnPurchOrder(SalesHeader: Record "Sales Header");
    var
        CreateAddonPurchaseOrder: Report "OBF-Create Add-on Purch. Order";
    begin
        CreateAddonPurchaseOrder.SetSalesOrder(SalesHeader);
        CreateAddonPurchaseOrder.RunModal();
    end;
}