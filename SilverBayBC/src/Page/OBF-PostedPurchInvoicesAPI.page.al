// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
page 50022 "OBF-Posted Purch. Invoices API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFPostedPurchInvoicesAPI';
    EntitySetCaption = 'OBFPostedPurchInvoicesAPI';
    EntityName = 'OBFPostedPurchInvoicesAPI';
    EntitySetName = 'OBFPostedPurchInvoicesAPI';

    SourceTable = "Purch. Inv. Header";
    DelayedInsert = true;
    Permissions = TableData "Purch. Inv. Header" = RIMD;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(InvoiceNo; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Editable = false;
                }
                field(OrderNo; Rec."Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the associated order.';
                    Editable = false;
                }
                field(VendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                    Editable = false;
                }
                field(BuyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, all;
                    Caption = 'Vendor No.';
                    ToolTip = 'Specifies the identifier of the vendor that you bought the items from.';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines.';
                    Editable = false;
                }
                field(PayToVendorNo; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
                    Editable = false;
                }
                field(PayToName; Rec."Pay-to Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the vendor who you received the invoice from.';
                    Editable = false;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                    Editable = false;
               }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    Editable = false;
                }
                field(SubsidiaryCode; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Editable = false;
                }
                field(DepartmentCode; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Editable = false;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                    Editable = false;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields on the purchase header.';
                    Editable = false;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                    Editable = false;
                }
                field(RemainingAmount; Rec."Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted purchase invoice.';
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the posted purchase invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                    Editable = false;
                }
                field(CoupaUpdatedFlag;Rec."OBF-Coupa Updated Flag")
                {
                    ApplicationArea = all;
                }
                field(CoupaInternalInvoiceID;Rec."OBF-Coupa Internal Invoice ID") 
                {
                    ApplicationArea = all;
                }               
            }
        }
    }

}