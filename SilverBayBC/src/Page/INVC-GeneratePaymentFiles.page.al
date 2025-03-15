// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
page 50120 "INVC Generate Payment Files"
//modeled after Page 10810 "Generate EFT Files"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Generate WF Payment Export';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    RefreshOnActivate = true;
    SourceTable = "EFT Export Workset";
    DataCaptionExpression = CurrPage.GenerateCheckFileLines.PAGE.GetFirstColumn();
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field("Bank Account"; BankAccountNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Account';
                TableRelation = "Bank Account";
                ToolTip = 'Specifies the number of the bank account.';

                trigger OnValidate()
                begin
                    BankAccount.SetRange("No.", BankAccountNo);
                    if BankAccount.FindFirst() then begin
                        BankAccountDescription := BankAccount.Name;
                        LastCheckNo := BankAccount."Last Check No.";
                        if (BankAccount."Export Format" = 0) or (BankAccount."Export Format" = BankAccount."Export Format"::Other) then
                            Message(NotSetupMsg);
                    end;
                    UpdateSubForm();
                end;
            }
            field(BankAccountDescription; BankAccountDescription)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Description';
                Editable = false;
                ToolTip = 'Specifies the name of the bank.';
            }
            field(LastCheckNo; LastCheckNo)
            {
                ApplicationArea = All;
                Caption = 'Last Check No.';
                Editable = false;
            }
            part(GenerateCheckFileLines; "INVC Generate Paymt File Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Lines';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GenerateCheckFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Generate Payment File';
                Ellipsis = true;
                Image = ExportFile;
                ShortCutKey = 'Ctrl+G';
                ToolTip = 'Export Wells Fargo payments on journal lines to a file prior to transmitting the file to your bank.';

                trigger OnAction()
                var
                    EFTExportWorkset: Record "EFT Export Workset";
                    GenerateCheck: Codeunit "INVC WF PM Export Mgt.";
                begin
                    CurrPage.GenerateCheckFileLines.PAGE.GetColumns(EFTExportWorkset);
                    if EFTExportWorkset.FindFirst() then
                        GenerateCheck.ProcessAndGenerateCheckFile(BankAccountNo, EFTExportWorkset);
                    UpdateSubForm();
                end;
            }
            action("Mark All")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark All';
                Image = Apply;
                ShortCutKey = 'Ctrl+M';
                ToolTip = 'Select all lines to be generated.';

                trigger OnAction()
                begin
                    CurrPage.GenerateCheckFileLines.PAGE.MarkUnmarkInclude(true, BankAccountNo);
                    CurrPage.Update(false);
                end;
            }
            action("Unmark All")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unmark All';
                Image = UnApply;
                ShortCutKey = 'Ctrl+U';

                trigger OnAction()
                begin
                    CurrPage.GenerateCheckFileLines.PAGE.MarkUnmarkInclude(false, BankAccountNo);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(GenerateEFTFile_Promoted; GenerateCheckFile)
                {
                }
                actionref("Mark All_Promoted"; "Mark All")
                {
                }
                actionref("Unmark All_Promoted"; "Unmark All")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Manage', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        SettlementDate := Today;

        if (BankAccountNoFilter <> '') and (BankAccountNoFilter <> BankAccountNo) then begin
            BankAccountNo := BankAccountNoFilter;
            BankAccount.SetRange("No.", BankAccountNo);
            if BankAccount.FindFirst() then begin
                BankAccountDescription := BankAccount.Name;
                LastCheckNo := BankAccount."Last Check No.";
            end;
        end;
        UpdateSubForm();
    end;

    var
        BankAccount: Record "Bank Account";
        EFTValues: Codeunit "EFT Values";
        BankAccountNo: Code[20];
        BankAccountDescription: Text[100];
        SettlementDate: Date;
        BankAccountNoFilter: Code[20];
        NotSetupMsg: Label 'This bank account is not setup for check exports.';
        INVCGenJournalBatch: Record "Gen. Journal Batch";
        LastCheckNo: Text;

    local procedure UpdateSubForm()
    begin
        CurrPage.GenerateCheckFileLines.PAGE.Set(BankAccountNo, INVCGenJournalBatch);
        CurrPage.Update(false);
    end;

    procedure SetBalanceAccount(BankAccountNumber: Code[20]; GenJnlBatch: Record "Gen. Journal Batch")
    begin
        BankAccountNoFilter := BankAccountNumber;
        INVCGenJournalBatch.Get(GenJnlBatch."Journal Template Name", GenJnlBatch.Name);
    end;
}

