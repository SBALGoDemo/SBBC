// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1910 - Create Custom Query for Silver Bay Commission report
query 50000 "OBF-Sales Invoice"
{
    QueryType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';
    EntityName = 'OBFSalesInvoice';
    EntitySetName = 'OBFSalesInvoice';
    EntityCaption = 'OBFSalesInvoice';
    EntitySetCaption = 'OBFSalesInvoice';
    
    elements
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(Posting_Date;"Posting Date")
            {                
            }  
            column(Document;"No.")
            {                
            }
            column(Sell_to_Customer_No_;"Sell-to Customer No.")
            {                
            }
            column(Sell_to_Customer_Name;"Sell-to Customer Name")
            {                
            }
            column(PO;"External Document No.")
            {                
            }
            column(Ship_to_Code;"Ship-to Code")
            {                
            }
            column(Ship_to_City;"Ship-to City")
            {                
            }           
            column(Ship_to_State;"Ship-to County")
            {                
            }
            column(Ship_to_Country_Region_Code;"Ship-to Country/Region Code")
            {                
            }
            column(Shipment_Method_Code;"Shipment Method Code")
            {                
            }
            column(Location_Code;"Location Code")
            {                
            }
    
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = SalesInvoiceHeader."No.";
                SqlJoinType = InnerJoin;
                column(Line_No_;"Line No.")
                {
                }
                column(Type;Type)
                {
                }
                column(No_;"No.")
                {
                }
                column(Description;Description)
                {
                }

                column(Item_Category_Code;"Item Category Code")
                {
                }
                column(OBF_Item_Category_Description;"OBF-Item Category Description")
                {
                }
                column(Pounds;"OBF-Line Net Weight")
                {
                }
                column(Quantity;Quantity)
                {
                }
                column(Unit_of_Measure_Code;"Unit of Measure Code")
                {
                }
                column(Unit_Price;"Unit Price")
                {
                }
                column(Line_Total;Amount)
                {
                }
            }
        }
    }
}