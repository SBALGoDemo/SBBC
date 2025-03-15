// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2018 - Make memo field available on customer and vender ledgers
tableextension 50024 "OBF-Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "OBF-Memo"; Text[250])
        {
            Caption = 'Memo';
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure OBF_SendRemittanceAdviceEntries();
    // This functions uses the Zetadocs Send functionality to add the Invoice
    // to the Zetadocs Documents Factbox.  It can also be used to email the posted invoice
    // to one or more Customer email addresses based on the Zetadocs Customer Rules
    var
        ZdServerSend: Codeunit "Zetadocs Server Send";
        ZdCommon: Codeunit "Zetadocs Common";
        PurchasingEvents: Codeunit "OBF-Purchasing Events";
        ZdReportSelections: Record "Report Selections";
        PurchSetup: Record "Purchases & Payables Setup";
        ZdRecRef: RecordRef;
        ZdReportId: Integer;
    begin
        PurchSetup.Get;
        PurchasingEvents.AutoCreateVendorRuleForDocSet(Rec."Buy-from Vendor No.", PurchSetup."OBF-Doc. Set for Remit Adv", true);

        ZdRecRef.GetTable(Rec);
        ZdCommon.FindSelectionReportId(ZdReportSelections.Usage::"P.V.Remit.", ZdReportId);
        ZdServerSend.SendViaZetadocs(ZdRecRef, ZdReportId, '', true);
    end;
}