// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50038 "OBF-Sales Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group(OBF_Extensions)
            {
                CaptionML = ENU = 'Extensions';

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1316 - Autonumber New Ship-to Addresses
                field("OBF-Customer Ship-to Nos."; Rec."OBF-Customer Ship-to Nos.")
                {
                    ApplicationArea = all;
                }

                group(OBF_Rebates)
                {
                    Caption = 'Rebates';
                    field("OBF-Disable Rebates"; Rec."OBF-Disable Rebates")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Enable Dup. Rebate Check"; Rec."OBF-Enable Dup. Rebate Check")
                    {
                        ApplicationArea = all;
                    }

                    field("OBF-Rebate Jnl. Template"; Rec."OBF-Rebate Jnl. Template")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Jnl. Batch"; Rec."OBF-Rebate Jnl. Batch")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Nos."; Rec."OBF-Rebate Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Document Nos."; Rec."OBF-Rebate Document Nos.")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Expense Account"; Rec."OBF-Rebate Expense Account")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Acc. Offset Account"; Rec."OBF-Rebate Acc. Offset Account")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Rebate Default UOM"; Rec."OBF-Rebate Default UOM")
                    {
                        ApplicationArea = all;
                    }

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1899 - Rebates - Mult Entiry Management Issue
                    field("OBF-Enable Autopost OI Rebates"; Rec."OBF-Enable Autopost OI Rebates")
                    {
                        ApplicationArea = all;
                    }

                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
                group(OBF_SOWorkflow)
                {
                    Caption = 'Sales Order Workflow';
                    field("OBF-Submit to Shipping Step"; Rec."OBF-Submit to Shipping Step")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Shipping Release Step"; Rec."OBF-Shipping Release Step")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Cold Storage Step"; Rec."OBF-Cold Storage Step")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Posting Step"; Rec."OBF-Posting Step")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Post Invoicing W. Step"; Rec."OBF-Post Invoicing W. Step")
                    {
                        ApplicationArea = all;
                    }
                    field("OBF-Default Workflow Slsperson"; Rec."OBF-Default Workflow Slsperson")
                    {
                        ApplicationArea = all;
                    }
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
                group(EDI)
                {
                    Caption = 'EDI';
                    field("OBF-Req. Ext. Doc. for 940"; Rec."OBF-Req. Ext. Doc. for 940")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Require an External Document No. when sending a 940 shipping release';
                    }
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
                group("OBF-Zetadocs")
                {
                    Caption = 'Zetadocs';
                    field("OBF-Zetadocs Send Name"; Rec."OBF-Zetadocs Send Name")
                    {
                        ApplicationArea = All;
                    }
                    field("OBF-Zetadocs Send Email"; Rec."OBF-Zetadocs Send Email")
                    {
                        ApplicationArea = All;
                    }
                    field("OBF-Doc. Set for Order Conf."; Rec."OBF-Doc. Set for Order Conf.")
                    {
                        ApplicationArea = All;
                    }
                    field("OBF-Doc. Set for Shipping Rel."; Rec."OBF-Doc. Set for Shipping Rel.")
                    {
                        ApplicationArea = All;
                    }
                    field("OBF-Doc. Set for Invoice"; Rec."OBF-Doc. Set for Invoice")
                    {
                        ApplicationArea = All;
                    }
                }

            }
        }

    }
}