// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
codeunit 50120 "INVC WF PM Export Mgt."
//modeled after Codeunit 10098 "Generate EFT"
{
    var
        GeneratingFileMsg: Label 'The check export file is now being generated.';
        CheckFileCreated: Boolean;
        Path: Text;
        NothingToExportErr: Label 'There is nothing to export.';


    procedure ProcessAndGenerateCheckFile(BalAccountNo: Code[20]; var TempEFTExportWorkset: Record "EFT Export Workset" temporary)
    var
        CustomLayoutReporting: Codeunit "Custom Layout Reporting";
        ExportEFTACH: Codeunit "Export EFT (ACH)";
        Window: Dialog;
    begin
        InitialChecks(BalAccountNo);
        Filename := SetFilename(BalAccountNo);
        TempBuffer.DeleteAll();
        GenJnlLineChecks(TempEFTExportWorkset);
        CheckFileCreated := false;
        Window.Open(GeneratingFileMsg);
        GenerateHeader();
        GenerateLines(TempBuffer);
        UpdateGrandTotals();
        GenerateFooter();
        ExportAndDownloadFile();
        InsertChecks();
        Window.Close();
        if CheckFileCreated = false then
            ResetAllJnlLineChecks(TempEFTExportWorkset);
        TempBuffer.DeleteAll();
    end;

    local procedure InitialChecks(BankAccountNo: Code[20])
    var
        IsHandled: Boolean;
    begin
        BankAccount.LockTable();
        BankAccount.Get(BankAccountNo);
        BankAccount.TestField(Blocked, false);
        if not BankAccount."INVC Export WF Payment File" then
            error('%1 must be checked to enable check exporting.', BankAccount.FieldCaption("INVC Export WF Payment File"));
        BankAccount.TestField("Last Check No.");
        BankAccount.TestField("Last Remittance Advice No.");
    end;


    procedure GenJnlLineChecks(var EFTExportWorkset: Record "EFT Export Workset" temporary)
    var
        GenJnlLine: Record "Gen. Journal Line";
        WFPaymentType: Enum "INVC Wells Fargo Payment Type";
    begin
        if EFTExportWorkset.FindSet() then
            repeat
                if GenJnlLine.Get(EFTExportWorkset."Journal Template Name", EFTExportWorkset."Journal Batch Name", EFTExportWorkset."Line No.") then begin
                    if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor then
                        error('Check export can only be performed for lines that have an Account Type of Vendor.');
                    if GenJnlLine."Currency Code" <> '' then
                        error('You can only export USD checks. Currency Code must be blank for all lines.');
                    if (GenJnlLine."Applies-to Doc. No." = '') and (GenJnlLine.IsApplied()) then
                        error('You cannot export journal lines with multiple Applied Entries.');
                    GenJnlLine.CalcFields("INVC WF Payment Type");
                    if GenJnlLine."INVC WF Payment Type" = WFPaymentType::ACH then
                        ValidateACHPaymentLine(GenJnlLine."Account No.", GenJnlLine."Recipient Bank Account");
                    GenJnlLine."Check Printed" := true;
                    GenJnlLine."Document No." := 'WF-' + Format(GenJnlLine."INVC WF Payment Type".AsInteger()) + GenJnlLine."Account No.";
                    GenJnlLine.Modify();
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Check Line", GenJnlLine);
                    case GenJnlLine."INVC WF Payment Type" of
                        WFPaymentType::Check:
                            AddToSummarizedChecks(GenJnlLine);
                        WFPaymentType::ACH:
                            AddToSummarizedACH(GenJnlLine);
                    end;
                end;
            until EFTExportWorkset.Next() = 0;
    end;

    procedure ResetAllJnlLineChecks(var EFTExportWorkset: Record "EFT Export Workset" temporary)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if EFTExportWorkset.FindSet() then
            repeat
                if GenJnlLine.Get(EFTExportWorkset."Journal Template Name", EFTExportWorkset."Journal Batch Name", EFTExportWorkset."Line No.") then begin
                    GenJnlLine."Check Printed" := false;
                    GenJnlLine.Modify();
                end;
            until EFTExportWorkset.Next() = 0;
    end;

    local procedure SetFilename(BalAccountNo: Code[20]): Text;
    begin
        BankAccount."INVC Last WF Export File" := 'sbsl.' + Format(CurrentDateTime(), 0, '<Hours24,2><Minutes,2><Seconds,2>99<Year4><Month,2><Day,2>') + '.txt';
        BankAccount.Modify();
        exit(BankAccount."INVC Last WF Export File");
    end;

    local procedure GenerateHeader()
    begin
        TxtBuilder.AppendLine('PAYMTHD,' + 'CRDDBTFL,' + 'TRANNO,' + 'VALDT,' + 'PAYAMT,' + 'PMTFMTCD,' + 'CUR,' + 'ORIGACCTTY,' + 'ORIGACCT,' + 'ORIGBNKIDTY,' + 'ORIGBNKID,' + 'RCVPRTYACCTTY,' + 'RCVPRTYACCT,' + 'RCVACCTCUR,' + 'RCVBNKIDTY,' + 'RCVBNKID,' + 'RCVBNKSECID,' + 'ORIGTORCVPRTYINF,' + 'ORIGPRTYNM,' + 'ORIGPRTYADDR1,' + 'ORIGPRTYADDR2,' + 'ORIGPRTYADDR3,' + 'ORIGPRTYCTY,' + 'ORIGPRTYSTPRO,' + 'ORIGPRTYPSTCD,' + 'ORIGPRTYCTRYCD,' + 'ORIGPRTYCTRYNM,' + 'ORIGPRTYEMLADDR,' + 'RCVPRTYNM,' + 'RCVPRTYID,' + 'RCVPRTYADDR1,' + 'RCVPRTYADDR2,' + 'RCVPRTYADDR3,' + 'RCVPRTYCTY,' + 'RCVPRTYSTPRO,' + 'RCVPRTYPSTCD,' + 'RCVPRTYCTRYCD,' + 'RCVBNKNM,' + 'RCVBNKADDR1,' + 'RCVBNKCTY,' + 'RCVBNKSTPRO,' + 'RCVBNKPSTCD,' + 'RCVBNKCTRYCD,' + 'CHKNO,' + 'DOCTMPLNO,' + 'CHKDELCD,' + 'ACHCMPID,' + 'FILEFRMT,' + 'DELTYPE_1,' + 'DELCONTNM_1,' + 'DELEMLADDR_1,' + 'SECTYP_1,' + 'INVNO,' + 'INVDT,' + 'INVDESC,' + 'INVNET,' + 'INVGROSS,' + 'INVDISCT,' + 'PONUM,' + 'INVTYPE,' + 'INVONLYREC');
    end;

    local procedure AddToSummarizedChecks(var GenJnlLine: Record "Gen. Journal Line")
    var
        CompInf: Record "Company Information";
        Vend: Record Vendor;
        GenJnlLine2: Record "Gen. Journal Line";
        i: Integer;
    begin
        TempBuffer.Reset();
        TempBuffer.SetRange(TRANNO, GenJnlLine."Document No.");
        TempBuffer.SetRange("Vendor No.", GenJnlLine."Account No.");
        TempBuffer.SetRange("Bank Payment Type", TempBuffer."Bank Payment Type"::Check);
        if not TempBuffer.FindLast() then begin
            TempBuffer.Init();
            TempBuffer.TRANNO := GenJnlLine."Document No.";
            if GenJnlLine."Applies-to Doc. No." <> '' then begin
                if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::"Invoice" then
                    error('You cannot export %1 documents to the payment file.', GenJnlLine."Applies-to Doc. Type");
                TempBuffer."Line No." := 1;
                TempBuffer.PAYMTHD := 'CHK';
                TempBuffer.CRDDBTFL := 'C';
                TempBuffer.VALDT := FormatDate(GenJnlLine."Posting Date");
                TempBuffer.CUR := 'USD';
                TempBuffer.ORIGACCTTY := 'D';
                TempBuffer."Vendor No." := GenJnlLine."Account No.";
                TempBuffer."Journal Line No." := GenJnlLine."Line No.";
                TempBuffer."Journal Template Name" := GenJnlLine."Journal Template Name";
                TempBuffer."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                if GenJnlLine."Applies-to Ext. Doc. No." <> '' then
                    TempBuffer.INVNO := GenJnlLine."Applies-to Ext. Doc. No."
                else
                    TempBuffer.INVNO := GenJnlLine."Applies-to Doc. No.";
                TempBuffer.INVTYPE := 'IV';
                TempBuffer.INVONLYREC := 'N';
                TempBuffer.PAYAMT := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVNET := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVDISCT := FormatAmount(Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVGROSS := FormatAmount(GenJnlLine."Amount (LCY)" + Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.CHKDELCD := '100';
                TempBuffer.ORIGBNKIDTY := 'ABA';
                CompInf.Get();
                TempBuffer.ORIGPRTYNM := RemoveCommas(CompInf.Name);
                Vend.Get(GenJnlLine."Account No.");
                TempBuffer.ORIGACCT := RemoveCommas(BankAccount."Bank Account No.");
                TempBuffer.ORIGBNKID := RemoveCommas(BankAccount."Bank Branch No.");
                TempBuffer.ORIGPRTYADDR1 := RemoveCommas(CompInf.Address);
                TempBuffer.ORIGPRTYADDR2 := RemoveCommas(CompInf."Address 2");
                TempBuffer.ORIGPRTYCTY := RemoveCommas(CompInf.City);
                TempBuffer.ORIGPRTYSTPRO := RemoveCommas(CompInf.County);
                TempBuffer.ORIGPRTYPSTCD := RemoveCommas(CompInf."Post Code");
                TempBuffer.ORIGPRTYCTRYCD := RemoveCommas(CompInf."Country/Region Code");
                TempBuffer.RCVPRTYNM := RemoveCommas(Vend.Name);
                TempBuffer.RCVPRTYADDR1 := RemoveCommas(Vend.Address);
                TempBuffer.RCVPRTYADDR2 := RemoveCommas(Vend."Address 2");
                TempBuffer.RCVPRTYPSTCD := RemoveCommas(Vend."Post Code");
                TempBuffer.RCVPRTYSTPRO := RemoveCommas(Vend.County);
                TempBuffer.RCVPRTYCTY := RemoveCommas(Vend.City);
                if Vend."Country/Region Code" <> '' then
                    TempBuffer.RCVPRTYCTRYCD := RemoveCommas(Vend."Country/Region Code")
                else
                    TempBuffer.RCVPRTYCTRYCD := CompInf."Country/Region Code";
                BankAccount."Last Check No." := IncStr(BankAccount."Last Check No.");
                TempBuffer.CHKNO := Format(BankAccount."Last Check No.");
                GetVendInvInfo(GenJnlLine);
                TempBuffer.INVDT := FormatDate(VendLedgEntry."Document Date");
                TempBuffer.INVDESC := VendLedgEntry.Description;
                TempBuffer.PONUM := VendLedgEntry."Message to Recipient";
                GenJnlLine."Document No." := BankAccount."Last Check No.";
                GenJnlLine."Export File Name" := BankAccount."INVC Last WF Export File";
                TempBuffer."Bank Payment Type" := TempBuffer."Bank Payment Type"::Check;
                GenJnlLine.Modify();
                BankAccount.Modify();
                TempBuffer.Insert();
            end else begin
                //multi-application line - not currently supported
            end;
        end else begin
            i := TempBuffer."Line No.";
            TempBuffer.Init();
            TempBuffer.TRANNO := GenJnlLine."Document No.";
            if GenJnlLine."Applies-to Doc. No." <> '' then begin
                if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::"Invoice" then
                    error('You cannot export %1 documents to the payment file.', GenJnlLine."Applies-to Doc. Type");
                TempBuffer."Line No." := i + 1;
                TempBuffer."Vendor No." := GenJnlLine."Account No.";
                TempBuffer."Journal Line No." := GenJnlLine."Line No.";
                TempBuffer."Journal Template Name" := GenJnlLine."Journal Template Name";
                TempBuffer."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                if GenJnlLine."Applies-to Ext. Doc. No." <> '' then
                    TempBuffer.INVNO := GenJnlLine."Applies-to Ext. Doc. No."
                else
                    TempBuffer.INVNO := GenJnlLine."Applies-to Doc. No.";
                TempBuffer.INVNET := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVDISCT := FormatAmount(Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVGROSS := FormatAmount(GenJnlLine."Amount (LCY)" + Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVTYPE := 'IV';
                TempBuffer.INVONLYREC := 'Y';
                TempBuffer2.Get(GenJnlLine."Document No.", 1);
                GetVendInvInfo(GenJnlLine);
                TempBuffer.INVDT := FormatDate(VendLedgEntry."Document Date");
                TempBuffer.INVDESC := VendLedgEntry.Description;
                TempBuffer.PONUM := VendLedgEntry."Message to Recipient";
                TempBuffer.CHKNO := TempBuffer2.CHKNO;
                GenJnlLine."Document No." := TempBuffer.CHKNO;
                GenJnlLine."Export File Name" := BankAccount."INVC Last WF Export File";
                UpdateTotal(GenJnlLine."Amount (LCY)", TempBuffer.TRANNO, GenJnlLine."Account No.");
                TempBuffer."Bank Payment Type" := TempBuffer."Bank Payment Type"::Check;
                TempBuffer.Insert();
                GenJnlLine.Modify();
            end;
        end;
    end;

    local procedure AddToSummarizedACH(var GenJnlLine: Record "Gen. Journal Line")
    var
        CompInf: Record "Company Information";
        Vend: Record Vendor;
        GenJnlLine2: Record "Gen. Journal Line";
        VendBankAcc: Record "Vendor Bank Account";
        i: Integer;
    begin
        TempBuffer.Reset();
        TempBuffer.SetRange(TRANNO, GenJnlLine."Document No.");
        TempBuffer.SetRange("Vendor No.", GenJnlLine."Account No.");
        TempBuffer.SetRange("Bank Payment Type", TempBuffer."Bank Payment Type"::ACH);
        if not TempBuffer.FindLast() then begin
            TempBuffer.Init();
            TempBuffer.TRANNO := GenJnlLine."Document No.";
            if GenJnlLine."Applies-to Doc. No." <> '' then begin
                if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::"Invoice" then
                    error('You cannot export %1 documents to the payment file.', GenJnlLine."Applies-to Doc. Type");
                TempBuffer."Line No." := 1;
                TempBuffer.PAYMTHD := 'DAC';
                TempBuffer.CRDDBTFL := 'C';
                TempBuffer.VALDT := FormatDate(GenJnlLine."Posting Date");
                TempBuffer.CUR := 'USD';
                TempBuffer.ORIGACCTTY := 'D';
                TempBuffer."Vendor No." := GenJnlLine."Account No.";
                TempBuffer."Journal Line No." := GenJnlLine."Line No.";
                TempBuffer."Journal Template Name" := GenJnlLine."Journal Template Name";
                TempBuffer."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                if GenJnlLine."Applies-to Ext. Doc. No." <> '' then
                    TempBuffer.INVNO := GenJnlLine."Applies-to Ext. Doc. No."
                else
                    TempBuffer.INVNO := GenJnlLine."Applies-to Doc. No.";
                TempBuffer.INVTYPE := 'IV';
                TempBuffer.INVONLYREC := 'N';
                TempBuffer.PAYAMT := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVNET := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVDISCT := FormatAmount(Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVGROSS := FormatAmount(GenJnlLine."Amount (LCY)" + Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.ORIGBNKIDTY := 'ABA';
                TempBuffer.RCVPRTYID := GenJnlLine."Account No.";
                CompInf.Get();
                TempBuffer.ORIGPRTYNM := RemoveCommas(CompInf.Name);
                Vend.Get(GenJnlLine."Account No.");
                if Vend."Partner Type" = Vend."Partner Type"::Company then
                    TempBuffer.PMTFMTCD := 'CCD'
                else
                    TempBuffer.PMTFMTCD := 'PPD';
                TempBuffer.ORIGACCT := RemoveCommas(BankAccount."Bank Account No.");
                TempBuffer.ORIGBNKID := RemoveCommas(BankAccount."Bank Branch No.");
                TempBuffer.ORIGPRTYADDR1 := RemoveCommas(CompInf.Address);
                TempBuffer.ORIGPRTYADDR2 := RemoveCommas(CompInf."Address 2");
                TempBuffer.ORIGPRTYCTY := RemoveCommas(CompInf.City);
                TempBuffer.ORIGPRTYSTPRO := RemoveCommas(CompInf.County);
                TempBuffer.ORIGPRTYPSTCD := RemoveCommas(CompInf."Post Code");
                TempBuffer.ORIGPRTYCTRYCD := RemoveCommas(CompInf."Country/Region Code");
                TempBuffer.RCVPRTYNM := RemoveCommas(Vend.Name);
                TempBuffer.RCVPRTYADDR1 := RemoveCommas(Vend.Address);
                TempBuffer.RCVPRTYADDR2 := RemoveCommas(Vend."Address 2");
                TempBuffer.RCVPRTYPSTCD := RemoveCommas(Vend."Post Code");
                TempBuffer.RCVPRTYSTPRO := RemoveCommas(Vend.County);
                TempBuffer.RCVPRTYCTY := RemoveCommas(Vend.City);
                if Vend."Country/Region Code" <> '' then
                    TempBuffer.RCVPRTYCTRYCD := RemoveCommas(Vend."Country/Region Code")
                else
                    TempBuffer.RCVPRTYCTRYCD := CompInf."Country/Region Code";
                VendBankAcc.Get(GenJnlLine."Account No.", GenJnlLine."Recipient Bank Account");
                TempBuffer.RCVBNKNM := RemoveCommas(VendBankAcc.Name);
                TempBuffer.RCVBNKADDR1 := RemoveCommas(VendBankAcc.Address);
                TempBuffer.RCVBNKCTY := RemoveCommas(VendBankAcc.City);
                if VendBankAcc."Country/Region Code" = '' then
                    TempBuffer.RCVBNKCTRYCD := CompInf."Country/Region Code"
                else
                    TempBuffer.RCVBNKCTRYCD := RemoveCommas(VendBankAcc."Country/Region Code");
                TempBuffer.RCVBNKPSTCD := RemoveCommas(VendBankAcc."Post Code");
                TempBuffer.RCVBNKSTPRO := RemoveCommas(VendBankAcc.County);
                TempBuffer.RCVPRTYACCT := RemoveCommas(VendBankAcc."Bank Account No.");
                TempBuffer.RCVBNKID := RemoveCommas(VendBankAcc."Transit No.");
                TempBuffer.RCVPRTYACCTTY := 'D';
                TempBuffer.RCVBNKIDTY := 'ABA';
                TempBuffer.ORIGPRTYCTRYNM := CompInf."Country/Region Code";
                TempBuffer.ORIGPRTYEMLADDR := CompInf."E-Mail";
                TempBuffer.ACHCMPID := RemoveCommas(BankAccount."Bank Branch No.");
                TempBuffer.FILEFRMT := 'PDF';
                TempBuffer.DELTYPE_1 := 'EMAIL';
                TempBuffer.DELCONTNM_1 := 'A/R - ' + Vend.Name;
                if VendBankAcc."E-Mail" <> '' then
                    TempBuffer.DELEMLADDR_1 := VendBankAcc."E-Mail"
                else
                    TempBuffer.DELEMLADDR_1 := Vend."E-Mail";
                TempBuffer.SECTYP_1 := 'ACCT';
                TempBuffer.ORIGTORCVPRTYINF := 'ACH Remittance - ' + TempBuffer.CHKNO;
                BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
                TempBuffer.CHKNO := BankAccount."Last Remittance Advice No.";
                GetVendInvInfo(GenJnlLine);
                TempBuffer.INVDT := FormatDate(VendLedgEntry."Document Date");
                TempBuffer.INVDESC := VendLedgEntry.Description;
                TempBuffer.PONUM := VendLedgEntry."Message to Recipient";
                GenJnlLine."Document No." := BankAccount."Last Remittance Advice No.";
                GenJnlLine."Export File Name" := BankAccount."INVC Last WF Export File";
                TempBuffer."Bank Payment Type" := TempBuffer."Bank Payment Type"::ACH;
                GenJnlLine.Modify();
                BankAccount.Modify();
                TempBuffer.Insert();
            end else begin
                //multi-application line not currently supported
            end;
        end else begin
            i := TempBuffer."Line No.";
            TempBuffer.Init();
            TempBuffer.TRANNO := GenJnlLine."Document No.";
            if GenJnlLine."Applies-to Doc. No." <> '' then begin
                if GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::"Invoice" then
                    error('You cannot export %1 documents to the payment file.', GenJnlLine."Applies-to Doc. Type");
                TempBuffer."Line No." := i + 1;
                TempBuffer."Vendor No." := GenJnlLine."Account No.";
                TempBuffer."Journal Line No." := GenJnlLine."Line No.";
                TempBuffer."Journal Template Name" := GenJnlLine."Journal Template Name";
                TempBuffer."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                if GenJnlLine."Applies-to Ext. Doc. No." <> '' then
                    TempBuffer.INVNO := GenJnlLine."Applies-to Ext. Doc. No."
                else
                    TempBuffer.INVNO := GenJnlLine."Applies-to Doc. No.";
                TempBuffer.INVNET := FormatAmount(GenJnlLine."Amount (LCY)");
                TempBuffer.INVDISCT := FormatAmount(Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVGROSS := FormatAmount(GenJnlLine."Amount (LCY)" + Abs(GenJnlLine."Inv. Discount (LCY)"));
                TempBuffer.INVTYPE := 'IV';
                TempBuffer.INVONLYREC := 'Y';
                TempBuffer2.Get(GenJnlLine."Document No.", 1);
                GetVendInvInfo(GenJnlLine);
                TempBuffer.INVDT := FormatDate(VendLedgEntry."Document Date");
                TempBuffer.INVDESC := VendLedgEntry.Description;
                TempBuffer.PONUM := VendLedgEntry."Message to Recipient";
                GenJnlLine."Document No." := TempBuffer.CHKNO;
                GenJnlLine."Export File Name" := BankAccount."INVC Last WF Export File";
                TempBuffer."Bank Payment Type" := TempBuffer."Bank Payment Type"::ACH;
                TempBuffer.CHKNO := TempBuffer2.CHKNO;
                GenJnlLine."Document No." := TempBuffer.CHKNO;
                GenJnlLine."Export File Name" := BankAccount."INVC Last WF Export File";
                UpdateTotal(GenJnlLine."Amount (LCY)", TempBuffer.TRANNO, GenJnlLine."Account No.");
                TempBuffer.Insert();
                GenJnlLine.Modify();
            end;
        end;
    end;

    local procedure GenerateLines(TempBuffer: Record "INVC WF Payment Export Buffer")
    var
        TxtToAppend: Text;
    begin
        if TempBuffer.FindSet() then
            repeat
                if TempBuffer."Bank Payment Type" = TempBuffer."Bank Payment Type"::Check then
                    TxtBuilder.AppendLine(TempBuffer.PAYMTHD + ',' + TempBuffer.CRDDBTFL + ',' + TempBuffer.TRANNO + ',' + TempBuffer.VALDT + ',' + TempBuffer.PAYAMT + ',' + TempBuffer.PMTFMTCD + ',' + TempBuffer.CUR + ',' + TempBuffer.ORIGACCTTY + ',' + TempBuffer.ORIGACCT + ',' + TempBuffer.ORIGBNKIDTY + ',' + TempBuffer.ORIGBNKID + ',' + TempBuffer.RCVPRTYACCTTY + ',' + TempBuffer.RCVPRTYACCT + ',' + TempBuffer.RCVACCTCUR + ',' + TempBuffer.RCVBNKIDTY + ',' + TempBuffer.RCVBNKID + ',' + TempBuffer.RCVBNKSECID + ',' + TempBuffer.ORIGTORCVPRTYINF + ',' + TempBuffer.ORIGPRTYNM + ',' + TempBuffer.ORIGPRTYADDR1 + ',' + TempBuffer.ORIGPRTYADDR2 + ',' + TempBuffer.ORIGPRTYADDR3 + ',' + TempBuffer.ORIGPRTYCTY + ',' + TempBuffer.ORIGPRTYSTPRO + ',' + TempBuffer.ORIGPRTYPSTCD + ',' + TempBuffer.ORIGPRTYCTRYCD + ',' + TempBuffer.ORIGPRTYCTRYNM + ',' + TempBuffer.ORIGPRTYEMLADDR + ',' + TempBuffer.RCVPRTYNM + ',' + TempBuffer.RCVPRTYID + ',' + TempBuffer.RCVPRTYADDR1 + ',' + TempBuffer.RCVPRTYADDR2 + ',' + TempBuffer.RCVPRTYADDR3 + ',' + TempBuffer.RCVPRTYCTY + ',' + TempBuffer.RCVPRTYSTPRO + ',' + TempBuffer.RCVPRTYPSTCD + ',' + TempBuffer.RCVPRTYCTRYCD + ',' + TempBuffer.RCVBNKNM + ',' + TempBuffer.RCVBNKADDR1 + ',' + TempBuffer.RCVBNKCTY + ',' + TempBuffer.RCVBNKSTPRO + ',' + TempBuffer.RCVBNKPSTCD + ',' + TempBuffer.RCVBNKCTRYCD + ',' + TempBuffer.CHKNO + ',' + TempBuffer.DOCTMPLNO + ',' + TempBuffer.CHKDELCD + ',' + TempBuffer.ACHCMPID + ',' + TempBuffer.FILEFRMT + ',' + TempBuffer.DELTYPE_1 + ',' + TempBuffer.DELCONTNM_1 + ',' + TempBuffer.DELEMLADDR_1 + ',' + TempBuffer.SECTYP_1 + ',' + TempBuffer.INVNO + ',' + TempBuffer.INVDT + ',' + TempBuffer.INVDESC + ',' + TempBuffer.INVNET + ',' + TempBuffer.INVGROSS + ',' + TempBuffer.INVDISCT + ',' + TempBuffer.PONUM + ',' + TempBuffer.INVTYPE + ',' + TempBuffer.INVONLYREC);
                if TempBuffer."Bank Payment Type" = TempBuffer."Bank Payment Type"::ACH then
                    TxtBuilder.AppendLine(TempBuffer.PAYMTHD + ',' + TempBuffer.CRDDBTFL + ',' + TempBuffer.TRANNO + ',' + TempBuffer.VALDT + ',' + TempBuffer.PAYAMT + ',' + TempBuffer.PMTFMTCD + ',' + TempBuffer.CUR + ',' + TempBuffer.ORIGACCTTY + ',' + TempBuffer.ORIGACCT + ',' + TempBuffer.ORIGBNKIDTY + ',' + TempBuffer.ORIGBNKID + ',' + TempBuffer.RCVPRTYACCTTY + ',' + TempBuffer.RCVPRTYACCT + ',' + TempBuffer.RCVACCTCUR + ',' + TempBuffer.RCVBNKIDTY + ',' + TempBuffer.RCVBNKID + ',' + TempBuffer.RCVBNKSECID + ',' + TempBuffer.ORIGTORCVPRTYINF + ',' + TempBuffer.ORIGPRTYNM + ',' + TempBuffer.ORIGPRTYADDR1 + ',' + TempBuffer.ORIGPRTYADDR2 + ',' + TempBuffer.ORIGPRTYADDR3 + ',' + TempBuffer.ORIGPRTYCTY + ',' + TempBuffer.ORIGPRTYSTPRO + ',' + TempBuffer.ORIGPRTYPSTCD + ',' + TempBuffer.ORIGPRTYCTRYCD + ',' + TempBuffer.ORIGPRTYCTRYNM + ',' + TempBuffer.ORIGPRTYEMLADDR + ',' + TempBuffer.RCVPRTYNM + ',' + TempBuffer.RCVPRTYID + ',' + TempBuffer.RCVPRTYADDR1 + ',' + TempBuffer.RCVPRTYADDR2 + ',' + TempBuffer.RCVPRTYADDR3 + ',' + TempBuffer.RCVPRTYCTY + ',' + TempBuffer.RCVPRTYSTPRO + ',' + TempBuffer.RCVPRTYPSTCD + ',' + TempBuffer.RCVPRTYCTRYCD + ',' + TempBuffer.RCVBNKNM + ',' + TempBuffer.RCVBNKADDR1 + ',' + TempBuffer.RCVBNKCTY + ',' + TempBuffer.RCVBNKSTPRO + ',' + TempBuffer.RCVBNKPSTCD + ',' + TempBuffer.RCVBNKCTRYCD + ',' + '' + ',' + TempBuffer.DOCTMPLNO + ',' + TempBuffer.CHKDELCD + ',' + TempBuffer.ACHCMPID + ',' + TempBuffer.FILEFRMT + ',' + TempBuffer.DELTYPE_1 + ',' + TempBuffer.DELCONTNM_1 + ',' + TempBuffer.DELEMLADDR_1 + ',' + TempBuffer.SECTYP_1 + ',' + TempBuffer.INVNO + ',' + TempBuffer.INVDT + ',' + TempBuffer.INVDESC + ',' + TempBuffer.INVNET + ',' + TempBuffer.INVGROSS + ',' + TempBuffer.INVDISCT + ',' + TempBuffer.PONUM + ',' + TempBuffer.INVTYPE + ',' + TempBuffer.INVONLYREC);
            until TempBuffer.Next() = 0;
    end;

    local procedure UpdateGrandTotals()
    var
        DecEval: Decimal;
    begin
        TempBuffer.Reset();
        TempBuffer.SetRange("Line No.", 1);
        if TempBuffer.FindSet() then
            repeat
                EVALUATE(DecEval, TempBuffer.PAYAMT);
                FileTotal += DecEval;
            until TempBuffer.Next() = 0;
    end;

    local procedure GenerateFooter()
    begin
        TempBuffer.Reset();
        TempBuffer.SetRange("Line No.", 1);
        if TempBuffer.FindSet() then;
        TxtBuilder.AppendLine('TRAILER' + ',' + FORMAT(TempBuffer.Count) + ',' + FormatAmount(FileTotal));
    end;

    local procedure ExportAndDownloadFile()
    begin
        TempBlob.CreateOutStream(OutS);
        OutS.WriteText(TxtBuilder.ToText());
        TempBlob.CreateInStream(InS);
        if DownloadFromStream(InS, '', '', '', FileName) then
            CheckFileCreated := true;
    end;

    local procedure UpdateTotal(AmtToAdd: Decimal; TranNo: Code[20]; VendorNo: Code[20])
    var
        DecEval: Decimal;
    begin
        TempBuffer2.Reset();
        if TempBuffer2.Get(TranNo, 1) then begin
            EVALUATE(DecEval, TempBuffer2.PAYAMT);
            DecEval += AmtToAdd;
            TempBuffer2.PAYAMT := FormatAmount(DecEval);
            TempBuffer2.Modify();
        end;
    end;

    local procedure InsertChecks()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        CheckAmt: Decimal;
        CheckNo: Text;
        VendNo: Text[20];
        LastLineNo: Integer;
    begin
        TempBuffer.Reset();
        TempBuffer.SetRange("Line No.", 1);
        if TempBuffer.FindSet() then
            repeat
                VendNo := format(TempBuffer."Vendor No.");
                LastLineNo := 0;
                CheckNo := TempBuffer.CHKNO;
                GenJnlLine2.Init();
                GenJnlLine2."Journal Template Name" := TempBuffer."Journal Template Name";
                GenJnlLine2."Journal Batch Name" := TempBuffer."Journal Batch Name";
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                GenJnlLine2.VALIDATE("Account No.", BankAccount."No.");
                GenJnlLine2."Document No." := TempBuffer.CHKNO;
                GenJnlLine2."Bank Payment Type" := GenJnlLine2."Bank Payment Type"::"Manual Check";
                GenJnlLine2."Check Printed" := true;
                GenJnlLine2."Check Exported" := true;
                GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                Evaluate(GenJnlLine2.Amount, TempBuffer.PAYAMT);
                GenJnlLine2.Validate(Amount, -GenJnlLine2.Amount);
                TempBuffer2.SetRange(TRANNO, TempBuffer.TRANNO);
                if TempBuffer2.FindSet() then
                    repeat
                        if GenJnlLine.Get(TempBuffer2."Journal Template Name", TempBuffer2."Journal Batch Name", TempBuffer2."Journal Line No.") then begin
                            GenJnlLine."Bal. Account No." := '';
                            GenJnlLine."Check Exported" := true;
                            GenJnlLine."Posting Date" := Today();
                            GenJnlLine.Modify(false);
                            LastLineNo := GenJnlLine."Line No.";
                        end;
                    until TempBuffer2.Next() = 0;
                GenJnlLine2."Posting Date" := Today();
                GenJnlLine2."Document Date" := Today();
                GenJnlLine2."Line No." := LastLineNo + 250;
                GenJnlLine2."Export File Name" := BankAccount."INVC Last WF Export File";
                GenJnlLine2."Payment Related Information 1" := VendNo;
                // GenJnlLine2.BssiEntityID := GenJnlLine2."Shortcut Dimension 1 Code";
                GenJnlLine2.Insert();
            until TempBuffer.Next() = 0;
    end;

    local procedure GetVendInvInfo(GenJnlLn: Record "Gen. Journal Line")
    var
        PurInvHdr: Record "Purch. Inv. Header";
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SetRange("Vendor No.", GenJnlLn."Account No.");
        VendLedgEntry.SetRange("Document Type", GenJnlLn."Applies-to Doc. Type");
        VendLedgEntry.SetRange("Document No.", GenJnlLn."Applies-to Doc. No.");
        if VendLedgEntry.FindFirst() then begin
            if PurInvHdr.Get(VendLedgEntry."Document No.") then
                VendLedgEntry."Message to Recipient" := PurInvHdr."Order No."
            else
                VendLedgEntry."Message to Recipient" := '';
        end;
    end;

    local procedure FormatAmount(DecToFormat: Decimal): Text
    begin
        if DecToFormat = 0 then
            exit('0')
        else
            exit(DELCHR(FORMAT(DecToFormat, 0), '<=>', ','));
    end;

    local procedure FormatDate(DateToFormat: Date): Text
    begin
        exit(Format(DateToFormat, 0, '<Month,2>/<Day,2>/<Year4>'));
    end;

    local procedure RemoveCommas(TxtToFormat: Text): Text
    begin
        exit(DELCHR(FORMAT(TxtToFormat), '<=>', ','));
    end;

    procedure VoidWFCheckExport(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        i: Integer;
    begin
        if confirm('Void all Wells Fargo check export lines?') then begin
            i := 0;
            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
            GenJnlLine2.Reset();
            GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine2.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Manual Check");
            GenJnlLine2.SetFilter("Export File Name", '<>%1', '');
            if GenJnlLine2.FindSet() then
                repeat
                    if GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"Bank Account"
                    then
                        GenJnlLine2.Delete()
                    else begin
                        i += 1;
                        GenJnlLine2."Document No." := format(i);
                        GenJnlLine2."Check Printed" := false;
                        GenJnlLine2."Check Exported" := false;
                        GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
                        GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
                        GenJnlLine2."Export File Name" := '';
                        GenJnlLine2.Modify();
                    end;
                until GenJnlLine2.Next() = 0
            else
                message('Nothing to void.');
        end;
    end;

    local procedure ValidateACHPaymentLine(VendNo: Code[20]; BankAccCode: Code[20]);
    var
        Vend: Record Vendor;
        VendBankAcct: Record "Vendor Bank Account";
        EFTRectBankAccMgt: Codeunit "EFT Recipient Bank Account Mgt";
    begin
        Vend.Get(VendNo);
        Vend.TestField("Preferred Bank Account Code");
        if not VendBankAcct.Get(VendNo, BankAccCode) then
            error('Bank Account %1 for Vendor %2 does not exist.', BankAccCode, VendNo)
        else if not VendBankAcct."Use for Electronic Payments" then
            error('Bank Account %1 for Vendor %2 is not marked as %3.', BankAccCode, VendNo, VendBankAcct.FieldCaption("Use for Electronic Payments"));
        if VendBankAcct."Bank Account No." = '' then
            error('Bank Account %1 for Vendor %2 has no %3.', BankAccCode, VendNo, VendBankAcct.FieldCaption("Bank Account No."));
        if (VendBankAcct."Transit No." = '') and (VendBankAcct."Bank Branch No." = '') then
            error('Bank Account %1 for Vendor %2 has no %3 and %4.', BankAccCode, VendNo, VendBankAcct.FieldCaption("Transit No."), VendBankAcct.FieldCaption("Bank Branch No."));
        if (Vend."E-Mail" = '') and (VendBankAcct."E-Mail" = '') then
            error('Vendor %1 must have an e-mail address set on either the Vendor record or the %2 Vendor Bank Account.', VendNo, BankAccCode);
        if VendBankAcct.Name = '' then
            error('Bank Account %1 for Vendor %2 must have the %3 filled.', BankAccCode, VendNo, VendBankAcct.FieldCaption(Name));
    end;

    //to support voiding and unapplying check in Check Ledger Entries
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeCheckLedgEntryInsert', '', false, false)]
    local procedure INVCOnPostBankAccOnBeforeCheckLedgEntryInsert(var CheckLedgerEntry: Record "Check Ledger Entry"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    var
        Vend: Record Vendor;
    begin
        if (GenJournalLine."Bank Payment Type" = GenJournalLine."Bank Payment Type"::"Manual Check") and (GenJournalLine."Export File Name" <> '') then begin
            CheckLedgerEntry."Bal. Account Type" := CheckLedgerEntry."Bal. Account Type"::Vendor;
            CheckLedgerEntry."Bal. Account No." := GenJournalLine."Payment Related Information 1";
            if Vend.Get(GenJournalLine."Account No.") then begin
                CheckLedgerEntry.Description := Vend.Name;
                if GenJournalLine."INVC WF Payment Type" <> GenJournalLine."INVC WF Payment Type"::None then
                    CheckLedgerEntry.Description += ' (' + Format(GenJournalLine."INVC WF Payment Type") + ')';
            end;
        end;
    end;


    var
        BankAccount: Record "Bank Account";
        ExportFile: File;
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        Filename: Text;
        TxtBuilder: TextBuilder;
        TempBuffer: Record "INVC WF Payment Export Buffer";
        TempBuffer2: Record "INVC WF Payment Export Buffer";
        VendLedgEntry: Record "Vendor Ledger Entry";
        FileTotal: Decimal;
}