// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1615-Setup Users and Permission Sets
permissionset 50007 "OBF-All Users"
{
    Assignable = true;
    IncludedPermissionSets = Login, "D365 Basic", "D365 Read", "Local Read", "Edit in Excel - View", "Export Report Excel", "Excel Export Action";
    Permissions =

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
        tabledata "OBF-Subsidiary Site" = R,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1666 - Create CIP Dimension Lookup based on Subsidiary
        tabledata "OBF-Subsidiary CIP" = R,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        tabledata "OBF-Certification" = R, 
        tabledata "OBF-Item Certification" = R,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
        tabledata "OBF-FOB Location" = RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
        tabledata "OBF-Netsuite Purch Inv. Header" = R, 
        tabledata "OBF-Netsuite Purch Inv. Line" = R,
        tabledata "OBF-Netsuite Sales Inv. Header" = R, 
        tabledata "OBF-Netsuite Sales Inv. Line" = R, 

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
        tabledata "OBF-SalesHeader Van" = R,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        tabledata "OBF-Rebate Entry"=R,
        tabledata "OBF-Rebate Header"=R,
        tabledata "OBF-Rebate Ledger Entry"=R,
        tabledata "OBF-Rebate Line"=R,
 
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2015 - Misc Permission Errors
        tabledata "Bank Deposit Header" = Rimd,
        tabledata "Posted Bank Deposit Header" = Rimd,
        tabledata "Posted Bank Deposit Line" = Rimd,

        tabledata "Item Entry Relation" = Rimd,
        tabledata "Value Entry Relation" = Rimd,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        tabledata "OBF-SO Workflow Step"=RIMD,
        tabledata "OBF-Workflow Step"=R,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1727 - Payment Imports
        tabledata "OBF-Payment Import Buffer"=RIMD,

        tabledata "OBF-Sales Header Van"=RIMD,

        system "Tools, Zoom" = X;
}
