// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
query 50055 "OBF-Distinct Add-on PO Query"
{
    elements
    {
        dataitem(Item_Charge_Assignment_Purch;"Item Charge Assignment (Purch)")
        {
            DataItemTableFilter = "OBF-Orig. Doc. Type"=CONST("Sales Order");
            column(Document_No;"Document No.")
            {
            }
            column(Orig_Doc_No;"OBF-Orig. Doc. No.")
            {
            }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}

query 50056 "OBF-Addon POs for Sales Inv"
{

    elements
    {
        dataitem(Sales_Invoice_Header;"Sales Invoice Header")
        {
            column(Order_No;"Order No.")
            {
            }
            dataitem(Sales_Shipment_Header;"Sales Shipment Header")
            {
                DataItemLink = "Order No."=Sales_Invoice_Header."Order No.";
                dataitem(Item_Ledger_Entry;"Item Ledger Entry")
                {
                    DataItemLink = "Document No."=Sales_Shipment_Header."No.","Posting Date"=Sales_Shipment_Header."Posting Date";
                    SqlJoinType = InnerJoin;
                    dataitem(Value_Entry;"Value Entry")
                    {
                        DataItemLink = "Item Ledger Entry No."=Item_Ledger_Entry."Entry No.";
                        SqlJoinType = InnerJoin;
                        DataItemTableFilter = "Item Charge No."=FILTER(<>''),"Document Type"=CONST("Purchase Invoice");
                        column(Document_No;"Document No.")
                        {
                        }
                        column(Count_)
                        {
                            Method = Count;
                        }
                    }
                }
            }
        }
    }
}