codeunit 50888 "INVC ACH Export Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Export EFT (ACH)", 'OnBeforeACHUSDetailModify', '', false, false)]
    local procedure INVCAddPmtInfo1ToACHBeforeACHDetailModify(var ACHUSDetail: Record "ACH US Detail"; var TempEFTExportWorkset: Record "EFT Export Workset" temporary; BankAccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if GenJnlLine.Get(TempEFTExportWorkset."Journal Template Name", TempEFTExportWorkset."Journal Batch Name", TempEFTExportWorkset."Line No.") then
            if GenJnlLine."Payment Related Information 1" = '' then
                ACHUSDetail."INVC Pmt. Information 1" := StrSubstNo('ACH payment to Vendor %1', GenJnlLine."Account No.")
            else
                ACHUSDetail."INVC Pmt. Information 1" := GenJnlLine."Payment Related Information 1";
    end;
    
    [EventSubscriber(ObjectType::Table, Database::"ACH US Detail", 'OnBeforeModifyEvent', '', false, false)]
    local procedure INVCAssignLineNoOnBeforeACHUSDetailModify(var Rec: Record "ACH US Detail"; var xRec: Record "ACH US Detail"; RunTrigger: Boolean)
    begin
        Evaluate(Rec."INVC Line No.", Rec."Entry Detail Sequence No");
        if Rec."INVC Line No." <> 1 then
            if DataExchDefHasAddendaLines(Rec."Data Exch. Entry No.") then
                Rec."INVC Line No." := ROUND(Rec."INVC Line No." / 2, 1, '=');
    end;

    local procedure DataExchDefHasAddendaLines(DataExchEntryNo: Integer): Boolean
    var
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
    begin
        if DataExch.Get(DataExchEntryNo) then
            if DataExchDef.Get(DataExch."Data Exch. Def Code") then
                if DataExchDef."INVC Has Addenda Line" then
                    exit(true);
        exit(false);
    end;

}