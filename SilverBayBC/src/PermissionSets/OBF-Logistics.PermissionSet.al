// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2049 - Create Logistics Permission Set
permissionset 50008 "OBF-Logistics"
{
    Caption = 'OBF-Logistics';
    Assignable = true;
    IncludedPermissionSets = "Local", 
                            "D365 ACC. PAYABLE", 
                            "D365 ACC. RECEIVABLE", 
                            "D365 BANKING", 
                            "D365 FINANCIAL REP.", 
                            "D365 INV DOC, CREATE", 
                            "D365 INV DOC, POST", 
                            "D365 JOURNALS, EDIT", 
                            "D365 JOURNALS, POST",
                            "D365 PURCH DOC, EDIT",
                            "D365 PURCH DOC, POST",
                            "D365 SALES",
                            "D365 SALES DOC, EDIT",
                            "D365 SALES DOC, POST",
                            "BSSI MEM TRANSACTION",
                            "OBF-ALL USERS";

    Permissions =  
        tabledata "Reservation Entry" = RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        tabledata "OBF-Rebate Entry"=RIMD,
        tabledata "OBF-Rebate Header"=RIMD,
        tabledata "OBF-Rebate Ledger Entry"=RIMD,
        tabledata "OBF-Rebate Line"=RIMD,

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        tabledata "OBF-Workflow Step"=RIMD;
        
}