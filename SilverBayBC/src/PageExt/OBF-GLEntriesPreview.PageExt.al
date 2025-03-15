// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1651 - Intercompany Transactions - Multi Entity Accounting addon
pageextension 50022 "OBF-GL Entries Preview" extends "G/L Entries Preview"
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1715 - Show Due-to and Due-From on Ledger Entries
        addlast(Control1)
        {
            // field(BssiEntityID;Rec.BssiEntityID)
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiDuetoDuefrom;Rec.BssiDuetoDuefrom)
            // {
            //     ApplicationArea = all;
            // }
            // field("Bssi IC Settlement";Rec."Bssi IC Settlement")
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiICDestEntity;Rec.BssiICDestEntity)
            // {
            //     ApplicationArea = all;
            // }
            // field(BssiReportAmount;Rec.BssiReportAmount)
            // {
            //     ApplicationArea = all;
            // }
        }

    }
}