// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1692-Create a Purchase Invoice Line Export for Fishermen for Northscope
page 50017 "OBF-Fishermen Exp.-Credit Memo"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Fishermen Export-Credit Memo';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Purch. Cr. Memo Line";
    UsageCategory = Lists;
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
                field(VendorInvoiceNo;PurchCrMemoHeader."Vendor Cr. Memo No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transaction Number';
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company';
                }
                field(PostingDate;PurchCrMemoHeader."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1905 - Add Document Date to Fishermen Export page
                field(DocumentDate;PurchCrMemoHeader."Document Date")
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
                field(BuyFromVendorName2;PurchCrMemoHeader."Buy-from Vendor Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor ID';
                }
                field(BuyFromVendorNo;PurchCrMemoHeader."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Name';
                }
            }
        }

    }

    trigger OnAfterGetRecord()
    begin 
        PurchCrMemoHeader.Get(Rec."Document No.");
    end;
    
    trigger OnOpenPage()
    begin 
        LineID := 1;
        Rec.SetFilter("OBF-Fisherman Reference Code",'<>%1','');
    end;

    
    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        LineID: Integer;
}