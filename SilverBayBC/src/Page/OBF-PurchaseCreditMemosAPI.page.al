// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
page 50011 "OBF-Purchase Credit Memos API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFPurchaseCreditMemosAPI';
    EntitySetCaption = 'OBFPurchaseCreditMemosAPI';
    EntityName = 'OBFPurchaseCreditMemosAPI';
    EntitySetName = 'OBFPurchaseCreditMemosAPI';

    ODataKeyFields = SystemId;

    DelayedInsert = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = filter("Credit Memo"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {

                field(DocumentNo; Rec."No.")
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
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor who delivers the products.';
                }
                field(BuyFromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the vendor who delivers the products.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                }

                field(BuyFromAddress; Rec."Buy-from Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address of the vendor who ships the items.';
                }
                field(BuyFromAddress2; Rec."Buy-from Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies additional address information.';
                }
                field(BuyFromCity; Rec."Buy-from City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city of the vendor on the purchase document.';
                }

                field(BuyFromState; Rec."Buy-from County")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                }

                field(BuyFromPostCode; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                }
                field(BuyFromCountry; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country or region of the vendor on the purchase document.';
                }
                field(BuyFromContactNo; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of your contact at the vendor.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
                field(VATReportingDate; Rec."VAT Reporting Date")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies the date used to include entries on VAT reports in a VAT period. This is either the date that the document was created or posted, depending on your setting on the General Ledger Setup page.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields.';
                }
                field(ExpectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date you expect to receive the items on the purchase document.';
                }
                field(VendorAuthorizationNo; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the identification number of a compensation agreement.';
                }
                field(IncominfDocumentEntryNo; Rec."Incoming Document Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the incoming document that this purchase document is created for.';
                }
                field(VendorCrMemoNo; Rec."Vendor Cr. Memo No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the campaign number the document is linked to.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field(JobQueueStatus; Rec."Job Queue Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of a job queue entry that handles the posting of purchase credit memos.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                     ToolTip = 'Specifies whether the record is open, is waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the language to be used on printouts for this document.';
                }
                field(FormatRegion; Rec."Format Region")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the format to be used on printouts for this document.';
                }
                field(SubsidiaryCode; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(CoupaInternalInvoiceID;Rec."OBF-Coupa Internal Invoice ID") 
                {
                    ApplicationArea = all;
                }  
            }
        }
    }

    
    // I copied the following code from https://github.com/microsoft/ALAppExtensions/blob/main/Apps/W1/APIV2/app/src/pages/APIV2PurchaseCreditMemos.Page.al
    //      I commented out four lines and added two replacement lines to get it to compile.

    var
        GraphMgtPurchCrMemo: Codeunit "Graph Mgt - Purch. Cr. Memo";
        NoLineErr: Label 'Please add at least one line item to the credit memo.';
        CannotFindCreditMemoErr: Label 'The credit memo cannot be found.';

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        GetDraftCreditMemo(PurchaseHeader);
        PostCreditMemo(PurchaseHeader, PurchCrMemoHdr);
        SetActionResponse(ActionContext, GraphMgtPurchCrMemo.GetPurchaseCrMemoHeaderId(PurchCrMemoHdr));
    end;

    procedure Post2(SystemIDGUID: Guid; var ActionContext: WebServiceActionContext)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        GetDraftCreditMemo2(SystemIDGUID, PurchaseHeader);
        PostCreditMemo(PurchaseHeader, PurchCrMemoHdr);
        SetActionResponse(ActionContext, GraphMgtPurchCrMemo.GetPurchaseCrMemoHeaderId(PurchCrMemoHdr));
    end;
 

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; ParamInvoiceId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"OBF-Purchase Credit Memos API");
        //ActionContext.AddEntityKey(Rec.FieldNo(Id), ParamInvoiceId);
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), ParamInvoiceId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;

    
    local procedure PostCreditMemo(var PurchaseHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        PreAssignedNo: Code[20];
    begin
        if not PurchaseHeader.PurchLinesExist() then
            Error(NoLineErr);
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader);
        PreAssignedNo := PurchaseHeader."No.";
        PurchaseHeader.SendToPosting(Codeunit::"Purch.-Post");
        PurchCrMemoHdr.SetCurrentKey("Pre-Assigned No.");
        PurchCrMemoHdr.SetRange("Pre-Assigned No.", PreAssignedNo);
        PurchCrMemoHdr.FindFirst();
    end;


    local procedure GetDraftCreditMemo(var PurchaseHeader: Record "Purchase Header")
    begin
        // if Rec.Posted then
        //     Error(DraftCreditMemoActionErr);

        //if not PurchaseHeader.GetBySystemId(Rec.Id) then
        if not PurchaseHeader.GetBySystemId(Rec.SystemId) then
            Error(CannotFindCreditMemoErr);
    end;
    
    local procedure GetDraftCreditMemo2(SystemIDGUID: Guid;var PurchaseHeader: Record "Purchase Header")
    begin
        // if Rec.Posted then
        //     Error(DraftCreditMemoActionErr);

        //if not PurchaseHeader.GetBySystemId(Rec.Id) then
        if not PurchaseHeader.GetBySystemId(SystemIDGUID) then
            Error(CannotFindCreditMemoErr);
    end;

}