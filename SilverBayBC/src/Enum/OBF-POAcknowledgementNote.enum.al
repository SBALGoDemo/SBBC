// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
enum 50002 "OBF-PO Acknowledgement Note"
{
    Extensible = true;
    
    value(0; " ")
    {
    }
    value(1; "*** This Order has not been confirmed ***")
    {
    }
    value(2; "*** Acknowledgement Sent ***")
    {
    }
    value(3;"*** A PO Revision has been received and not acknowledged ***")
    {
    }
    value(4;"*** PO Acknowledgement (855) and PO Inbound Change (860) must not both be true ***")
    {
    }
    value(5; "*** Acknowledgement Transmitted ***")
    {
    }
}