// https://odydev.visualstudio.com/DefaultCollection/ThePlan/_workitems/edit/2335 - Changes to Aged Accounts Receivable report
reportextension 50000 "Aged Accounts Receivable" extends BssiMEMAgedAccountsReceivable
{
    dataset
    {
        add(Totals)
        {
            column(Your_Reference; CurrReport."Cust. Ledger Entry"."Your Reference")
            {
            }
            column(External_Document_No; CurrReport."Cust. Ledger Entry"."External Document No.")
            {
            }
            column(OBF_Memo; CurrReport."Cust. Ledger Entry"."OBF-Memo")
            {
            }
            column(Description_First_Line; FirstSalesInvoiceLineDescription)
            {
            }
        }

        modify(Totals)
        {
            trigger OnAfterAfterGetRecord()
            var
                SalesInvoiceLine: Record "Sales Invoice Line";
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                FirstSalesInvoiceLineDescription := '';
                if (CurrReport."Cust. Ledger Entry"."Document Type" <> CustLedgerEntry."Document Type"::Payment) and (CurrReport."Cust. Ledger Entry"."Document Type" <> CustLedgerEntry."Document Type"::"Credit Memo") then begin
                    SalesInvoiceLine.SetRange("Document No.", CurrReport."Cust. Ledger Entry"."Document No.");
                    if SalesInvoiceLine.FindFirst() then begin
                        if SalesInvoiceLine.Type = SalesInvoiceLine.Type::" " then
                            FirstSalesInvoiceLineDescription := SalesInvoiceLine.Description;
                    end;
                end;
            end;
        }

        modify(Customer)
        {
            trigger OnAfterPreDataItem()
            begin
                Customer.SetCurrentKey(Name);
            end;
        }

        add(Header)
        {
            column(YourReferenceCaption; YourReferenceCaption)
            {
            }
            column(ExternalDocumentNoCaption; ExternalDocumentNoCaption)
            {
            }
            column(FirstLineDescriptionCaption; FirstLineDescriptionCaption)
            {
            }
        }
    }

    rendering
    {
        layout(ExcelLayout)
        {
            Type = Excel;
            LayoutFile = 'src\ReportLayouts\OBF-AgedAccountsReceivable.xlsx';
        }
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'src\ReportLayouts\OBF-AgedAccountsReceivable.rdlc';
        }
    }


    var
        YourReferenceCaption: Label 'Invoice No. to Print';
        ExternalDocumentNoCaption: Label 'Customer PO';
        FirstLineDescriptionCaption: Label 'First Line Desc.';
        FirstSalesInvoiceLineDescription: Text[100];
}