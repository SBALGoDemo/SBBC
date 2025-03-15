// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50002 "OBF-Rebate List"
{
    CardPageID = "OBF-Rebate Card";
    PageType = List;
    SourceTable = "OBF-Rebate Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Rebate List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Calculation Basis"; Rec."Calculation Basis")
                {
                    ApplicationArea = all;
                }
                field("Rebate Type"; Rec."Rebate Type")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
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
                    RunPageLink = "Rebate Code" = field(Code);
                    ApplicationArea = all;
                }
                action(RebateLedgerEntries)
                {
                    Caption = 'Rebate Ledger Entries';
                    Image = AddToHome;
                    RunObject = Page "OBF-Rebate Ledger Entries";
                    RunPageLink = "Rebate Code" = field(Code);
                    ApplicationArea = all;
                }
                action(CustomerLedgerEntries)
                {
                    Caption = 'Customer Ledger Entries';
                    Image = Account;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "OBF-Rebate Code" = field(Code);
                    ApplicationArea = all;
                }
            }
        }
    }
}