// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1703 - Create "Post Purchase Invoice" Web Service Action
codeunit 50003 "OBF-Post Purchase Invoice"
{
    internal procedure PostPurchaseInvoice(PurchaseInvoiceNo: Code[20]; var ErrorText: Text[1000]): Boolean;
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice,PurchaseInvoiceNo) then begin 
            ErrorText:= StrSubstNo('Purchase Invoice %1 does not exist',PurchaseInvoiceNo);
            exit(false);
        end;

        if PurchPost.Run(PurchaseHeader) then
            exit(true)
        else begin 
            ErrorText := GetLastErrorText();
            exit(false);
        end;

    end;

}