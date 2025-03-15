// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
page 50061 "OBF-Add-on POs for Posted Inv."
{
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;
    CaptionML = ENU = 'Add-on Purchase Orders for Posted Invoice';
    Editable = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(SalesOrderNo;SalesOrderNo)
                {
                    Caption = 'Sales Order No.';
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                    ApplicationArea = All;                    
                }
                field(SalesInvoiceNo; SalesInvoiceNo)
                {
                    Caption = 'Sales Invoice No.';
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
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
                        PurchInvHeader: Record "Purch. Inv. Header";
                        PageManagement: Codeunit "Page Management";
                    begin
                        if Rec."Document Type" = Rec."Document Type"::Order then begin
                            PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                            PageManagement.PageRun(PurchaseHeader);
                        end else begin
                            PurchInvHeader.Get(Rec."No.");
                            PageManagement.PageRun(PurchInvHeader);
                        end;
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
                        CreateAddOnPurchOrder(SalesInvoiceHeader);
                        CurrPage.Update();
                    end;
                }

            }
        }
    }

    trigger OnOpenPage();
    begin
        SetData(SalesOrderNo);
    end;

    trigger OnAfterGetRecord();
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Order:
                Rec.CalcFields(Amount);
            Rec."Document Type"::Invoice:
                begin
                    PurchInvHeader.Get(Rec."No.");
                    PurchInvHeader.CalcFields(Amount);
                    Rec.Amount := PurchInvHeader.Amount;
                end;
        end;
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceNo: Code[20];
        SalesOrderNo: Code[20];

    local procedure SetData(SalesOrderNo: Code[20]);
    var
        PurchaseHeaderTemp: Record "Purchase Header" temporary;
        PurchInvHeader: Record "Purch. Inv. Header";
        AddonPOsForSalesInvoiceQuery: Query "OBF-Addon POs for Sales Inv";
    begin

        if SalesOrderNo <> '' then
            AddonPOsForSalesInvoiceQuery.SetRange(Order_No, SalesOrderNo);
        AddonPOsForSalesInvoiceQuery.OPEN;
        while AddonPOsForSalesInvoiceQuery.READ do begin
            PurchInvHeader.Get(AddonPOsForSalesInvoiceQuery.Document_No);
            PurchaseHeaderTemp.TransferFields(PurchInvHeader);
            PurchaseHeaderTemp."Document Type" := PurchaseHeaderTemp."Document Type"::Invoice;
            Rec := PurchaseHeaderTemp;
            Rec.Insert;
        end;
        AddOpenAddOnPOs(SalesOrderNo);
        if not Rec.IsEmpty then
            Rec.FindFirst;
    end;

    local procedure AddOpenAddOnPOs(SalesOrderNo: Code[20]);
    var
        DistinctAddOnPOQuery: Query "OBF-Distinct Add-on PO Query";
        PurchaseHeader: Record "Purchase Header";
    begin
        if SalesOrderNo <> '' then
            DistinctAddOnPOQuery.SetRange(Orig_Doc_No, SalesOrderNo);
        DistinctAddOnPOQuery.OPEN;
        while DistinctAddOnPOQuery.READ do begin
            PurchaseHeader.Get(Rec."Document Type"::Order, DistinctAddOnPOQuery.Document_No);
            Rec := PurchaseHeader;
            Rec.Insert;
        end;
    end;

    procedure SetSalesInfo(pSalesInvoiceHeader: Record "Sales Invoice Header");
    begin
        SalesInvoiceNo := pSalesInvoiceHeader."No.";
        SalesOrderNo := pSalesInvoiceHeader."Order No.";
        SalesInvoiceHeader := pSalesInvoiceHeader;
    end;

    local procedure CreateAddOnPurchOrder(SalesInvoiceHeader: Record "Sales Invoice Header");
    var
        CreateAddonPurchaseOrder: Report "OBF-Create Add-on Purch. Order";
    begin
        CreateAddonPurchaseOrder.SetSalesInvoice(SalesInvoiceHeader);
        CreateAddonPurchaseOrder.RunModal();
    end;

}