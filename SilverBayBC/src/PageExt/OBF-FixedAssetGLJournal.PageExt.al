// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1716 - Fixed Asset Setup
pageextension 50025 "OBF-Fixed Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        // Add changes to page layout here
    }
    
    actions
    {
        addlast(Navigation)
        {
            action(DeleteBatchLines)
            {
                Caption = 'Delete Batch Lines';
                Image = DeleteRow;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                begin
                    DeleteFixedAssetGLJournalLines();                    
                end;                
            }            
        }
    }
    
    local procedure DeleteFixedAssetGLJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name",'ASSETS');  
        GenJournalLine.SetRange("Journal Batch Name",Rec."Journal Batch Name");
        Message('%1 Records will be deleted',GenJournalLine.Count());  
        GenJournalLine.DeleteAll();   
    end;
}