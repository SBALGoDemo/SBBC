// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates

page 50003 "OBF-Rebate Card"
{
    PageType = Document;
    SourceTable = "OBF-Rebate Header";
    Caption = 'Rebate Card';
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Rebate Type"; Rec."Rebate Type")
                {
                    ApplicationArea = all;
                }
                field("Calculation Basis"; Rec."Calculation Basis")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    TableRelation = "Unit of Measure";
                    ApplicationArea = all;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                }
                field(AppliesToAllCustomers; not Rec."Customer Rebate Line Exists")
                {
                    Caption = 'Applies to All Customers';
                    ApplicationArea = all;
                }
                group(Posting)
                {
                    Caption = 'Posting';
                    field("Expense G/L Account"; Rec."Expense G/L Account")
                    {
                        ApplicationArea = all;
                    }
                    field("Accrual Account No."; Rec."Accrual Account No.")
                    {
                        ApplicationArea = all;
                    }

                }
            }
            part(Subform; "OBF-Rebate Subform")
            {
                SubPageLink = "Rebate Code" = FIELD(Code);
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entries)
            {
                Caption = 'Entries';
                action("Rebate Entries")
                {
                    Caption = 'Rebate Entries';
                    Image = Allocate;
                    RunObject = Page "OBF-Rebate Entries";
                    RunPageLink = "Rebate Code" = FIELD(Code);

                }
                action("Page OBF-Rebate Ledger Entries")
                {
                    Caption = 'Rebate Ledger Entries';
                    Image = AddToHome;
                    RunObject = Page "OBF-Rebate Ledger Entries";
                    RunPageLink = "Rebate Code" = FIELD(Code);

                }
                action("Page Customer Ledger Entries")
                {
                    Caption = 'Customer Ledger Entries';
                    Image = Account;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "OBF-Rebate Code" = FIELD(Code);


                    ApplicationArea = all;
                }
                // action("Page General Ledger Entries")
                // {
                //     Caption = 'General Ledger Entries';
                //     Image = Account;
                //     RunObject = Page "General Ledger Entries";
                //     RunPageLink = "OBF-Rebate Code" = FIELD(Code);
                //     ApplicationArea = all;

                // }


            }
        }
    }
}
