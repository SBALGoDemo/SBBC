// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
page 50007 "OBF-Purchase Invoices"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFPurchaseInvoicesAPI';
    EntitySetCaption = 'OBFPurchaseInvoicesAPI';
    EntityName = 'OBFPurchaseInvoicesAPI';
    EntitySetName = 'OBFPurchaseInvoicesAPI';

    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Invoice));
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(DocumentType;Rec."Document Type")
                {
                    ApplicationArea = All;                    
                }
                field(InvoiceNo; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(SystemId;Rec.SystemId)
                {
                    ApplicationArea = All;                    
                }
                field(BuyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(BuyFromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(VendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                }
                field(BuyFromAddress;Rec."Buy-from Address")
                {
                    ApplicationArea = all;
                }
                field(BuyFromAddress2;Rec."Buy-from Address 2")
                {
                    ApplicationArea = all;
                }
                field(BuyFromCity;Rec."Buy-from City")
                {
                    ApplicationArea = all;
                }
                field(BuyFromState;Rec."Buy-from County")
                {
                    ApplicationArea = all;
                }
                field(BuyFromPostCode; Rec."Buy-from Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the post code of the vendor who delivered the items.';
                }
                field(BuyFromCountry; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.';
                }

                field(ShipToName; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(ShipToAddress;Rec."Ship-to Address")
                {
                    ApplicationArea = all;
                }
                field(ShipToAddress2;Rec."Ship-to Address 2")
                {
                    ApplicationArea = all;
                }
                field(ShipToCity;Rec."Ship-To City")
                {
                    ApplicationArea = all;
                }
                field(ShipToState;Rec."Ship-To County")
                {
                    ApplicationArea = all;
                }
                field(ShipToPostCode; Rec."Ship-To Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the post code of the vendor who delivered the items.';
                }
                field(ShipToCountry; Rec."Ship-To Country/Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.';
                } 
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = all;
                }
                field(SubsidiaryCode; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
    
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                 }
 
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor''s reference.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field(CoupaInternalInvoiceID;Rec."OBF-Coupa Internal Invoice ID") 
                {
                    ApplicationArea = all;
                }
           
            }
        }
    }

}