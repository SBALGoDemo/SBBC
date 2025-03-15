// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1615-Setup Users and Permission Sets
permissionset 50000 "OBF-Accounting"
{
    Caption = 'OBF-Accounting Base';
    Assignable = true;
    IncludedPermissionSets = "Local", "D365 ACC. PAYABLE", "D365 ACC. RECEIVABLE", "D365 BANKING", "D365 FINANCIAL REP.", "D365 INV DOC, CREATE", "D365 INV DOC, POST", "D365 JOURNALS, EDIT", "D365 JOURNALS, POST";
    Permissions = // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1522 - Allow Accounting to update Dimension Values
        tabledata "Dimension Value"=RIMD,
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
        tabledata "OBF-Subsidiary Site"=RIMD,
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1666 - Create CIP Dimension Lookup based on Subsidiary
        tabledata "OBF-Subsidiary CIP"=RIMD,
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        tabledata "OBF-Certification"=RIMD,
        tabledata "OBF-Item Certification"=RIMD,
        tabledata "OBF-Asset Temp"=RIMD,
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
        tabledata "OBF-FOB Location"=RIMD,
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
        tabledata "OBF-SalesHeader Van"=RIMD,

        //https://odydev.visualstudio.com/ThePlan/_workitems/edit/1769 - Create Subsidiary Site Trial Balance Report
        tabledata "OBF-G/L Bal. by Subs. Site"=RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
        tabledata "INVC Check Export Workset" = RIMD,
        tabledata "INVC WF Payment Export Buffer" = RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        tabledata "OBF-Rebate Entry"=RIMD,
        tabledata "OBF-Rebate Header"=RIMD,
        tabledata "OBF-Rebate Ledger Entry"=RIMD,
        tabledata "OBF-Rebate Line"=RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        tabledata "OBF-Workflow Step"=RIMD,
        
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2049 - Create Logistics Permission Set
        tabledata "Reservation Entry" = RIMD,

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
        tabledata "OBF-Netsuite History"=RIMD,
        tabledata "OBF-Netsuite Purch Inv. Header"=RIMD,
        tabledata "OBF-Netsuite Purch Inv. Line"=RIMD,
        tabledata "OBF-Netsuite Sales Inv. Header"=RIMD,
        tabledata "OBF-Netsuite Sales Inv. Line"=RIMD;
}