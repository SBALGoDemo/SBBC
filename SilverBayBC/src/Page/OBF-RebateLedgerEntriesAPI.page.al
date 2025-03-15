// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1910 - Create Custom Queries for Silver Bay Commission report
page 50047 "OBF-Rebate Ledger Entries API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFRebateLedgerEntriesAPI';
    EntitySetCaption = 'OBFRebateLedgerEntriesAPI';
    EntityName = 'OBFRebateLedgerEntriesAPI';
    EntitySetName = 'OBFRebateLedgerEntriesAPI';

    SourceTable = "OBF-Rebate Ledger Entry";
    DelayedInsert = true;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(CustomerBroker; Rec."Customer Broker")
                {
                    ApplicationArea = All;
                }
                field(ShipToBroker; Rec."Ship-to Broker")
                {
                    ApplicationArea = All;
                }
                field(SellToCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field(SellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(ShipToCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2203 - Rebate API Page Updates
                field(ShipToCity; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field(ShipToState; Rec."Ship-to State")
                {
                    ApplicationArea = All;
                }

                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field(NoOfCases; Rec."No. of Cases")
                {
                    ApplicationArea = All;
                }
                field(SalesLineAmount; Rec."Sales Line Amount")
                {
                    ApplicationArea = All;
                }
                field(RebateValue; Rec."Rebate Value")
                {
                    ApplicationArea = All;
                }
                field(CalculationBasis; Rec."Calculation Basis")
                {
                    ApplicationArea = All;
                }
                field(RebateAmount; Rec."Rebate Amount")
                {
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2203 - Rebate API Page Updates
                field(RebateCode; Rec."Rebate Code")
                {
                    ApplicationArea = All;
                }
                field(RebateDescription; Rec."Rebate Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}