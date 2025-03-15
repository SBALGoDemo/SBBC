tableextension 50018 "OBF-Sales Setup" extends "Sales & Receivables Setup"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        field(50021; "OBF-Req. Ext. Doc. for 940"; Boolean)
        {
            Caption = 'Require Ext. Doc. No. for 940';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1316 - Autonumber New Ship-to Addresses
        field(50100; "OBF-Customer Ship-to Nos."; Code[20])
        {
            Caption = 'Customer Ship-to Nos.';
            TableRelation = "No. Series";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(52000; "OBF-Submit to Shipping Step"; Integer)
        {
            Caption = 'Submit Order to Shipping Step';
            TableRelation = "OBF-Workflow Step";
        }
        field(52001; "OBF-Shipping Release Step"; Integer)
        {
            Caption = 'Shipping Release Step';
            TableRelation = "OBF-Workflow Step";
        }
        field(52002; "OBF-Cold Storage Step"; Integer)
        {
            Caption = 'Cold Storage Step';
            TableRelation = "OBF-Workflow Step";
        }
        field(52003; "OBF-Posting Step"; Integer)
        {
            Caption = 'Posting Step';
            TableRelation = "OBF-Workflow Step";
        }
        field(52004; "OBF-Post Invoicing W. Step"; Integer)
        {
            Caption = 'Post Invoicing Workflow Step No.';
            TableRelation = "OBF-Workflow Step";
        }
        field(52005; "OBF-Default Workflow Slsperson"; Code[20])
        {
            Caption = 'Default Workflow Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(54000; "OBF-Rebate Nos."; Code[20])
        {
            Caption = 'Rebate Nos.';
            TableRelation = "No. Series";
        }
        field(54001; "OBF-Rebate Document Nos."; Code[20])
        {
            Caption = 'Rebate Document Nos.';
            TableRelation = "No. Series";
        }
        field(54002; "OBF-Rebate Jnl. Template"; Code[20])
        {
            Caption = 'Rebate Journal Template';
        }
        field(54003; "OBF-Rebate Jnl. Batch"; Code[20])
        {
            Caption = 'Rebate Journal Batch';
        }
        field(54004; "OBF-Rebate Expense Account"; Code[20])
        {
            Caption = 'Rebate Expense Account';
            TableRelation = "G/L Account";
        }
        field(54005; "OBF-Rebate Acc. Offset Account"; Code[20])
        {
            Caption = 'Rebate Accrual Offset Account';
            TableRelation = "G/L Account";
        }
        field(54006; "OBF-Rebate Default UOM"; Code[10])
        {
            Caption = 'Rebate Default Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(54007; "OBF-Enable Dup. Rebate Check"; Boolean)
        {
            Caption = 'Enable Duplicate Rebate Line Check';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
        field(54008; "OBF-Enable Autopost OI Rebates"; Boolean)
        {
            Caption = 'Enable Automatic Posting of Off-Invoice Rebates';
            // trigger OnValidate()
            // begin 
            //     if Rec."OBF-Enable Autopost OI Rebates" then
            //         Error('"Enable Automatic Posting of Off-Invoice Rebates" may not be enabled until MEM issue is resolved.');
            // end;
        }

        field(54100; "OBF-Disable Rebates"; Boolean)
        {
            Caption = 'Disable Rebates';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
        field(50023; "OBF-Zetadocs Send Email"; Text[100])
        {
            Caption = 'Zetadocs Send Email';
        }
        field(50024; "OBF-Zetadocs Send Name"; Text[50])
        {
            Caption = 'Zetadocs Send Name';
        }
        field(50026; "OBF-Doc. Set for Order Conf."; Code[20])
        {
            Caption = 'Zetadocs Document Set for Order Confirmation';
            TableRelation = "Zetadocs Document Set";
        }
        field(50027; "OBF-Doc. Set for Shipping Rel."; Code[20])
        {
            Caption = 'Zetadocs Document Set for Shipping Release';
            TableRelation = "Zetadocs Document Set";
        }
        field(50028; "OBF-Doc. Set for Invoice"; Code[20])
        {
            Caption = 'Zetadocs Document Set for Invoice';
            TableRelation = "Zetadocs Document Set";
        }

    }
}