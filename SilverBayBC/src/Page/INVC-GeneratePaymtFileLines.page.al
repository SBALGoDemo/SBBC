// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
page 50121 "INVC Generate Paymt File Lines"
//modeled after Page 10811 "Generate EFT File Lines"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "INVC Check Export Workset";
    SourceTableTemporary = true;
    SourceTableView = sorting("Wells Fargo Payment Type", "Account Type", "Account No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Include; Rec.Include)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies to either include or exclude this line.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
                }
                field("Wells Fargo Payment Type"; Rec."Wells Fargo Payment Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the account number that the journal line entry will be posted to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the total amount that the journal line consists of.';
                }
            }
        }
    }

    actions
    {
    }

    procedure Set(BankAccountNumber: Code[20]; JournalBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        Vend: Record Vendor;
    begin
        Rec.DeleteAll();
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", JournalBatch.Name);
        GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Manual Check");
        GenJnlLine.SetRange("Check Printed", false);
        GenJnlLine.SetFilter("Currency Code", '%1', '');
        GenJnlLine.SetFilter("INVC WF Payment Type", '<>%1', GenJnlLine."INVC WF Payment Type"::None);
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.SetRange("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
        GenJnlLine.SetRange("Bal. Account No.", BankAccountNumber);
        If GenJnlLine.FindSet() then
            repeat
                GenJnlLine.CalcFields("INVC WF Payment Type");
                Rec.Init();
                Rec."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                Rec."Journal Template Name" := GenJnlLine."Journal Template Name";
                Rec."Line No." := GenJnlLine."Line No.";
                Rec."Document Date" := GenJnlLine."Document Date";
                Rec."Document No." := GenJnlLine."Document No.";
                Rec."Account Type" := GenJnlLine."Account Type";
                Rec."Account No." := GenJnlLine."Account No.";
                Rec."Amount (LCY)" := GenJnlLine."Amount (LCY)";
                if Vend.Get(GenJnlLine."Account No.") then
                    Rec.Description := Vend.Name;
                Rec.Include := true;
                Rec."Wells Fargo Payment Type" := GenJnlLine."INVC WF Payment Type";
                Rec."Subsidiary Code" := GenJnlLine."Shortcut Dimension 1 Code";
                Rec.Insert();
            until GenJnlLine.Next() = 0;
        CurrPage.Update(false);
    end;


    procedure GetFirstColumn(): Text[50]
    begin
        if Rec.FindFirst() then
            exit(Rec."Journal Template Name" + ' · ' + Rec."Journal Batch Name" + ' · ' + Format(Rec."Line No.") + ' · ' + Format(Rec."Sequence No."))
        else
            exit('');
    end;

    procedure GetColumns(var TempExportWorkset: Record "EFT Export Workset" temporary)
    begin
        TempExportWorkset.DeleteAll();
        Rec.SetRange(Include, true);
        if Rec.FindFirst() then
            repeat
                TempExportWorkset.TransferFields(Rec);
                TempExportWorkset.BssiEntityId := Rec."Subsidiary Code";
                TempExportWorkset.Insert();
            until Rec.Next() = 0;
        Rec.Reset();
    end;

    procedure MarkUnmarkInclude(SetInclude: Boolean; BankAccountNumber: Code[20])
    begin
        if Rec.FindSet() then
            repeat
                Rec.Include := SetInclude;
                Rec.Modify();
            until Rec.Next() = 0;
    end;
}

