// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
pageextension 50054 OBF_UserSetup extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("OBF-Allow Send Sh. Release"; Rec."OBF-Allow Send Sh. Release")
            {
                ApplicationArea = all;
            }
            field("OBF-Allow Edit After Shipped"; Rec."OBF-Allow Edit After Shipped")
            {
                ApplicationArea = all;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2085 - Create Utility to Delete an ACH Payment Batch after Check Transmitted
            field("OBF-Allow Pmt. Jnl. Fn.";Rec."OBF-Allow Pmt. Jnl. Fn.")
            {
                ApplicationArea = all;
                ToolTip = 'This permission allows the user to clear the Check Transmitted Flag on the Payment Journal.';
            }
            
        }
    }
}