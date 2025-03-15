// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2330 - BC Report with 2024 1099 Info
report 50004 "OBF-Vendor Ledger Payments"
{
    Caption = 'Vendor Payments 1099';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src/ReportLayouts/OBF-VendorLedgerPayments.xlsx';

    dataset
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.", "Document No.", "Posting Date");
            column(SubsidiaryCode; "Global Dimension 1 Code")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
            dataitem(Vendor; "Vendor")
            {
                DataItemLink = "No." = field("Vendor No.");

                column(Name; "Name")
                {
                }
                column(Name2; "Name 2")
                {
                }
                column(Address; Address)
                {
                }
                column(Address2; "Address 2")
                {
                }
                column(City; City)
                {
                }
                column(PhoneNo; "Phone No.")
                {
                }
                column(OurAccountNo; "Our Account No.")
                {
                }
                column(VendorPostingGroup; "Vendor Posting Group")
                {
                }
                column(CountryRegionCode; "Country/Region Code")
                {
                }
                column(PostCode; "Post Code")
                {
                }
                column(County; County)
                {
                }
                column(FederalIDNo; "Federal ID No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                if postedDateYear <> 0 then begin
                    SetFilter("Document Type", 'Payment');
                    SetRange("Posting Date", DMY2Date(1, 1, postedDateYear), DMY2Date(31, 12, postedDateYear));
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(PostedDateYear; postedDateYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Year';
                    }
                }
            }
        }
    }

    var
        postedDateYear: Integer;

    trigger OnInitReport()
    begin
        postedDateYear := Date2DMY(Today(), 3);
    end;
}