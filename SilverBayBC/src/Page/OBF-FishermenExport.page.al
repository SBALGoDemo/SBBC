// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692-Create a Purchase Invoice Line Export for Fishermen for Northscope
page 50016 "OBF-Fishermen Export"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Fishermen Export';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Purch. Inv. Line";
    UsageCategory = Lists;
    Permissions = TableData "Purch. Inv. Header" = RIMD, TableData "Purch. Inv. Line" = RIMD;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number.';
                    Caption = 'Internal ID';
                }
                field(VendorInvoiceNo;PurchInvHeader."Vendor Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transaction Number';
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company';
                }
                field(PostingDate;PurchInvHeader."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1905 - Add Document Date to Fishermen Export page
                field(DocumentDate;PurchInvHeader."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Date';
                }
                
                field(LineID;LineID)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Line ID';
                }
                field("OBF-Fisherman Reference Code";Rec."OBF-Fisherman Reference Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fisherman Reference Code';
                }
                field("OBF-Expense Item";Rec."OBF-Expense Item")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expense Item';
                }
                field("OBF-Expense Quantity";Rec."OBF-Expense Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expense Quantity';
                }
                field("OBF-Expense Rate";Rec."OBF-Expense Rate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expense Item Rate';
                }
                field(Amount;Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                }
                field(BuyFromVendorName2;PurchInvHeader."Buy-from Vendor Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor ID';
                }
                field(BuyFromVendorNo;PurchInvHeader."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Name';
                }
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action(FishermenExportCreditMemo)
            {
                Caption = 'Fisherment Export - Credit Memo';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                RunObject = Page "OBF-Fishermen Exp.-Credit Memo";
            }
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1908 - Taxes not populating on Fisherman Export        
        area(Processing)
        {
            action(FixTaxIssue)
            {
                Caption = 'Fix Tax Issue';
                Image = Redo;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin 
                    procFixTaxIssue();
                end;    
            }       
        }
        
    }

    trigger OnAfterGetRecord()
    begin 
        PurchInvHeader.Get(Rec."Document No.");
    end;
    
    trigger OnOpenPage()
    begin 
        LineID := 1;
        Rec.SetFilter("OBF-Fisherman Reference Code",'<>%1','');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1908 - Taxes not populating on Fisherman Export
    procedure procFixTaxIssue()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        FirstPurchInvLine: Record "Purch. Inv. Line";
        SecondPurchInvLine: Record "Purch. Inv. Line";
        PurchInvLineToFix: Record "Purch. Inv. Line";
        NumFixed: Integer;
        NumSkipped: Integer;
    begin 
        PurchInvHeader.SetRange("OBF-Fisherman Reference Exists",true);
        PurchInvHeader.SetRange("OBF-Fisherman Ref. Tax Flag",true);
        if PurchInvHeader.FindSet() then
            repeat
                FirstPurchInvLine.SetRange("Document No.",PurchInvHeader."No.");
                FirstPurchInvLine.SetFilter("OBF-Fisherman Reference Code",'<>%1','');
                FirstPurchInvLine.FindFirst();

                SecondPurchInvLine.SetRange("Document No.",PurchInvHeader."No.");
                SecondPurchInvLine.SetFilter("OBF-Fisherman Reference Code",'<>%1&<>%2','',FirstPurchInvLine."OBF-Fisherman Reference Code");
                if SecondPurchInvLine.FindFirst() then
                    NumSkipped += 1
                else begin 
                    PurchInvLineToFix.SetRange("Document No.",PurchInvHeader."No.");
                    PurchInvLineToFix.SetFilter("OBF-Fisherman Reference Code",'%1','');
                    PurchInvLineToFix.SetFilter(Amount,'<>0');
                    PurchInvLineToFix.FindFirst();
                    PurchInvLineToFix."OBF-Fisherman Reference Code" := FirstPurchInvLine."OBF-Fisherman Reference Code";
                    if PurchInvLineToFix."No." = '2141' then
                        PurchInvLineToFix."OBF-Expense Item" := 'Tax';
                    PurchInvLineToFix.Modify();
                    NumFixed += 1; 
                end;                              
            until(PurchInvHeader.Next()=0);

        Message('%1 Purch. Inv. Lines with blank Fisherman Reference Codes were fixed %2 were skipped',NumFixed,NumSkipped);
    end;
    
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        LineID: Integer;
}