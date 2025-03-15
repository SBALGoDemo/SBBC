// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2361 - Add columns to Posted Sales Credit Memo Lines page
pageextension 50070 "OBF-Pstd. Sl. Cr. Mm. Lines" extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field(CustomerPO;CustomerPO)
            {
                ApplicationArea = All;
                Caption = 'Customer PO';
            }
            field("Posting Date";Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field(Name;CustomerName)
            {
                ApplicationArea = all;
                Caption = 'Customer Name';
            }
        }
    }
    var
        CustomerName: Text[100];
        CustomerPO: Text[50];
    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        CustomerName:= '';

        if Customer.get(Rec."Sell-to Customer No.") then
            CustomerName := Customer.Name;

        if SalesCrMemoHeader.Get(Rec."Document No.") then
            CustomerPO := SalesCrMemoHeader."External Document No.";
    end;
}