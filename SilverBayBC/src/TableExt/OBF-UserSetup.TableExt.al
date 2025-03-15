tableextension 50073 "OBF-User Setup" extends "User Setup"
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50000; "OBF-Allow Send Sh. Release"; Boolean)
        {
            Caption = 'Allow Send Shipping Release Via EDI (940)';
        }
        field(50001; "OBF-Allow Edit After Shipped"; Boolean)
        {
            Caption = 'Allow Edit After Order Submitted to Shipping';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1530 - Restrict access to Remit-to Method Field on Vendor Card 
        field(50002; "OBF-Allow Change Pmt. Method"; Boolean)
        {
            Caption = 'Allow Change Vendor Payment Method';
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed by Silver Bay';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2085 - Create Utility to Delete an ACH Payment Batch after Check Transmitted
        field(50003; "OBF-Allow Pmt. Jnl. Fn."; Boolean)
        {
            Caption = 'Allow User to Clear the Check Transmitted Flag on the Payment Journal';
        }
                
    }
}