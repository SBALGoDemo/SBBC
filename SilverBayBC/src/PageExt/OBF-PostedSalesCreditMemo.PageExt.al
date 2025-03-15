// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50029 "OBF-Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    actions
    {
        addafter(DocAttach)
        {
            action(RebateLedgerEntries)
            {
                Caption = 'Rebate Ledger Entries';
                Image = DepositLines;
                RunObject = Page "OBF-Rebate Ledger Entries";
                RunPageLink = "Source Type" = filter("Posted Cr. Memo"),
                              "Source No." = field("No.");
                ApplicationArea = all;
            }
        }
    }
}