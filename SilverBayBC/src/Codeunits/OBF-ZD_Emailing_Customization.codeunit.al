// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1766 - Zetadocs Capture Plus for Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1210 - Upgrade Zetadocs to Business Central
codeunit 50068 "OBF-ZD Emailing Customizations"
{
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Zetadocs Customize", 'OnAfterZetadocsDelivery', '', true, true)]
local procedure OnAfterZetadocsDelivery(var OnAfterZetadocsDeliveryHandler: Codeunit "Zdd OnAfterZetadocsDelivery")
var
    user: Record User;
    TheRecordId: RecordId;
    DeliveryResultToken: JsonToken;
    DeliveryResultObject: JsonObject;
    DeliveryJsonArray: JsonArray;
    IsDeliverySuccess: Boolean;
    IsArchiveSuccess: Boolean;
    InError: Boolean;
    ErrorDescription: Text;
    RecordIdText: Text;
    EmailTo: Text;
    SendingUser: Text;
    FailureEmailBody: Label 'Failed to send %2. To %1. Error: %3. Delivery Successful: %4. Archiving Successful: %5.', Comment = '%2 is the document, %1 is to whom it has been sent, %3 is the error returned, %4 is the delivery status, %5 is the archiving status';
    EmailBody: Text;
    SalesHeader: Record "Sales Header";
    SalesShipment: Record "Sales Shipment Header";
    PostedSalesInv: Record "Sales Invoice Header";
    crlf: Text[2];
    ReportName: Text;
    TransferHeader: Record "Transfer Header";
    PurchHeader: Record "Purchase Header";
    PostedSalesInvoice: Record "Sales Invoice Header";

begin

    crlf[1] := 13;
    crlf[2] := 10;
    if (not OnAfterZetadocsDeliveryHandler.IsZetadocsDeliverySuccessful()) then begin
        // Format the email body how you wish.           
        EmailBody := StrSubstNo('Delivery Report for %1, delivery was attempted on %2' + crlf,
        OnAfterZetadocsDeliveryHandler.GetReportName(),
        OnAfterZetadocsDeliveryHandler.GetReportDateTime());
        EmailBody := strSubstNo('%1' + crlf + crlf + '%2. Details below: ' + crlf + crlf, EmailBody, OnAfterZetadocsDeliveryHandler.GetDeliveryErrorMessage());
        //Get Delivery Json Array
        OnAfterZetadocsDeliveryHandler.GetDeliveryResults(DeliveryJsonArray);
        foreach DeliveryResultToken in DeliveryJsonArray do begin
            //Convert Token to Object, use this in the methods below
            DeliveryResultObject := DeliveryResultToken.AsObject();
            //Get Email To
            EmailTo := OnAfterZetadocsDeliveryHandler.GetEmailTo(DeliveryResultObject);
            //Get Record Id
            OnAfterZetadocsDeliveryHandler.GetRecordId(DeliveryResultObject, TheRecordID);
            //Get if Delivery was successful
            IsDeliverySuccess := OnAfterZetadocsDeliveryHandler.IsDeliverySuccessful(DeliveryResultObject);
            //Get Error Description
            ErrorDescription := OnAfterZetadocsDeliveryHandler.GetDeliveryErrorDescription(DeliveryResultObject);
            //Get if Delivery Process is in Error
            InError := OnAfterZetadocsDeliveryHandler.IsDeliveryInError(DeliveryResultObject);
            //Get if the Archiving was successful
            IsArchiveSuccess := OnAfterZetadocsDeliveryHandler.IsArchiveSuccessful(DeliveryResultObject);
            if (InError) then begin
                //Populate the email body with some extra information like the document type/number and email recipients.
                EmailBody := EmailBody + StrSubstNo(FailureEmailBody + crlf + crlf,
                EmailTo,
                TheRecordID,
                ErrorDescription,
                IsDeliverySuccess,
                IsArchiveSuccess);
            end;
        end;

        //Send the email to the user who ran the report.
        SendingUser := OnAfterZetadocsDeliveryHandler.GetSendingUser();
        if (user.Get(UserSecurityId())) then begin
            if (not (user."Contact Email" = '')) then
                SendErrorMail(user."Contact Email", EmailBody);
        end;

    end else begin
        //if sent document is sucessful
        //Get Delivery Json Array
        OnAfterZetadocsDeliveryHandler.GetDeliveryResults(DeliveryJsonArray);
        foreach DeliveryResultToken in DeliveryJsonArray do begin
            //Convert Token to Object, use this in the methods below
            DeliveryResultObject := DeliveryResultToken.AsObject();
            //Get Email To
            EmailTo := OnAfterZetadocsDeliveryHandler.GetEmailTo(DeliveryResultObject);
            //Get Record Id
            OnAfterZetadocsDeliveryHandler.GetRecordId(DeliveryResultObject, TheRecordID);
            //Get if Delivery was successful
            IsDeliverySuccess := OnAfterZetadocsDeliveryHandler.IsDeliverySuccessful(DeliveryResultObject);
            //Get Error Description
            ErrorDescription := OnAfterZetadocsDeliveryHandler.GetDeliveryErrorDescription(DeliveryResultObject);
            //Get if Delivery Process is in Error
            InError := OnAfterZetadocsDeliveryHandler.IsDeliveryInError(DeliveryResultObject);
            //Get if the Archiving was successful
            IsArchiveSuccess := OnAfterZetadocsDeliveryHandler.IsArchiveSuccessful(DeliveryResultObject);

            ReportName := OnAfterZetadocsDeliveryHandler.GetReportName;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1331 - Periodic Zetadocs Lockup Issue
            Message('In ZD Emailing Customization, Report Name=%1, IsDeliverySucess=%2, ErrorDescription=%3, InError=%4, IsArchiveSuccess=%5',
                        ReportName, IsDeliverySuccess, ErrorDescription, InError, IsArchiveSuccess);

            case ReportName OF
                // 'Sales - Confirmation': //Sales Order Confirmation
                //     begin
                //         SalesHeader.get(TheRecordId);
                //         SalesHeader."Order Confirmation Sent" := TRUE;
                //         SalesHeader."Sales Confirm Ready" := FALSE;
                //         SalesHeader.Modify();
                //         Commit();
                //     end;
                // 'Sales Conf. Prepayment Invoice': //Pre-Payment Invoice
                //     begin
                //         SalesHeader.get(TheRecordId);
                //         SalesHeader."Prepayment Sent" := TRUE;
                //         SalesHeader."Prepayment Ready" := FALSE;
                //         SalesHeader.Modify();
                //         Commit();
                //     end;
                // 'Purchase Blanket Order': //Blanket Purchase Order
                //     begin
                //         PurchHeader.get(TheRecordId);
                //         PurchHeader."Blanket Order Sent" := TRUE;
                //         PurchHeader."Blanket Order Ready" := FALSE;
                //         PurchHeader.Modify();
                //         Commit();
                //     end;
                // 'Blanket Sales Order': //Blanket Sales Order
                //     begin
                //         SalesHeader.get(TheRecordId);
                //         SalesHeader."Blanket Order Sent" := TRUE;
                //         SalesHeader."Blanket Order Ready" := FALSE;
                //         SalesHeader.Modify();
                //         Commit();
                //     end;
                // 'Pick Instruction': //Pick Ticket
                //     begin
                //         SalesHeader.get(TheRecordId);
                //         SalesHeader."Picklist Sent" := TRUE;
                //         SalesHeader."Pick List Ready" := FALSE;
                //         SalesHeader.Modify();
                //         Commit();
                //     end;
                // 'Purchase Order': //Purchase Order
                //     BEGIN
                //         PurchHeader.get(TheRecordId);
                //         PurchHeader."PO Sent" := TRUE;
                //         PurchHeader."PO Ready" := FALSE;
                //         PurchHeader.Modify();
                //         Commit();
                //     end;
                // 'Whse. Receiving Notice': //Purchase Whse. Receipt Notice
                //     begin
                //         PurchHeader.get(TheRecordId);
                //         PurchHeader."Whse. Receiving Notice Sent" := TRUE;
                //         PurchHeader.Modify();
                //         Commit();
                //     end;
                // 'Transfer Order': //Transfer Order
                //     begin
                //         TransferHeader.get(TheRecordId);
                //         TransferHeader."Transfer Order Sent" := TRUE;
                //         TransferHeader."Transfer Order Ready" := FALSE;
                //         TransferHeader.Modify();
                //         Commit();
                //     end;
            end;
        end;
    end;
end;

local procedure SendErrorMail(emailAddress: Text; emailBody: Text)
var
    EmailMessage: codeunit "Email Message";
    Email: Codeunit Email;
    Recipients: List of [Text];
begin
    Recipients.Add(emailAddress);
    EmailMessage.Create(Recipients, 'Zetadocs Delivery Error Report', emailBody, true);
    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
end;
}
