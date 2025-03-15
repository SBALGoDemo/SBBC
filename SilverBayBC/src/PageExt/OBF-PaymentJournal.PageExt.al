pageextension 50003 "OBF-Payment Journal" extends "Payment Journal"
{
    layout
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1714 - Show Credit and Debit Amount on Journals and Ledger Entries
        modify(Amount)
        {
            Visible = false;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
        modify(ShortcutDimCode3)
        {
            Visible = false;
            Editable = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1868 - Add comments to CoBank ACH
        modify("Payment Related Information 1")
        {
            Visible = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
        addafter(Description)
        {
            field("OBF-Site Code";Rec."OBF-Site Code")
            {
                ApplicationArea = all;
            }
            field("OBF-CIP Code";Rec."OBF-CIP Code")
            {
                ApplicationArea = all;
            }
            
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1868 - Add comments to CoBank ACH
            field("INVC Payment Related Information 1"; Rec."Payment Related Information 1")
            {
                Caption = 'ACH Payment Comment';
                ApplicationArea = All;
                ToolTip = 'Information related to the payment. This field can be mapped in the ACH file when exporting.';
            }

        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
        addafter("Check Printed")
        {
            field("Check Exported";Rec."Check Exported")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Check Transmitted";Rec."Check Transmitted")
            {
                ApplicationArea = all;
                Editable = false;
            }    
        }

    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
    //      Merged from INVC page extension
    actions
    {
        addlast(Processing)
        {
            action(GenerateWFPmts)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Generate Wells Fargo Payment File';
                Image = ExportFile;
                ToolTip = 'Generate a check export file based on the payment journal check and ACH lines. A window showing the file content opens from where you complete the export.';

                trigger OnAction()
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                    GenerateCheckFiles: Page "INVC Generate Payment Files";
                begin
                    GenJournalBatch.Get(Rec."Journal Template Name", CurrentJnlBatchName);
                    GenerateCheckFiles.SetBalanceAccount(GenJournalBatch."Bal. Account No.", GenJournalBatch);
                    GenerateCheckFiles.Run();
                end;
            }

            action(VoidAllWFPmts)
            {
                ApplicationArea = All;
                Caption = 'Void Wells Fargo Payment File';
                Image = VoidAllChecks;

                trigger OnAction()
                var
                    INVCCheckExportMgt: Codeunit "INVC WF PM Export Mgt.";
                begin
                    INVCCheckExportMgt.VoidWFCheckExport(Rec);
                end;
            }
        }
        addafter(GenerateEFT)
        {
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2085 - Create Utility to Delete an ACH Payment Batch after Check Transmitted
            action(OBFClearCheckTransmittedFlag)
            {
                ApplicationArea = All;
                Caption = 'Clear Check Transmitted Flag';
                ToolTip = 'This Action Clears the Check Transmitted Flag in this Payment Journal Batch.';
                Image = VoidAllChecks;
                trigger OnAction()
                begin
                    ClearCheckTransmittedFlag(Rec."Journal Batch Name");                   
                end;
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2085 - Create Utility to Delete an ACH Payment Batch after Check Transmitted
    local procedure ClearCheckTransmittedFlag(JournalBatchName:Code[10])
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."OBF-Allow Pmt. Jnl. Fn." then
            Error('The "Allow User to Clear the Check Transmitted Flags on Payment Journal" permission must be set on your User Setup record to use this function.');
        GenJournalBatch.Get('PAYMENT',JournalBatchName);
        GenJournalBatch.TestField("OBF-Def. Bank Payment Type",GenJournalBatch."OBF-Def. Bank Payment Type"::"Electronic Payment");
        GenJournalLine.SetRange("Journal Template Name",'PAYMENT'); 
        GenJournalLine.SetRange("Journal Batch Name",JournalBatchName);
        GenJournalLine.SetRange("Check Transmitted",true);
        if GenJournalLine.Count > 0 then
            if Confirm('Are you sure that you want to clear the Check Transmitted flag for all records in this batch?') then begin 
                GenJournalLine.ModifyAll("Check Transmitted",false); 
                Message('The Check Transmitted field was cleared in Batch %1',JournalBatchName);   
            end;
    end;

}