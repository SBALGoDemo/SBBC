// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1784 - Create API for Posted Sales Invoices
page 50040 "OBF-Posted Sales Inv. Sub. API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFPostedSalesInvoiceSubformAPI';
    EntitySetCaption = 'OBFPostedSalesInvoiceSubformAPI';
    EntityName = 'OBFPostedSalesInvoiceSubformAPI';
    EntitySetName = 'OBFPostedSalesInvoiceSubformAPI';

    SourceTable = "Sales Invoice Line";
    DelayedInsert = true;
    Permissions = TableData "Sales Invoice Line" = R;
    
    layout
    {
        area(content)
        {
            repeater(Control1)
            {

                field(InvoiceNo; SalesInvoiceHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    AboutTitle = 'The final invoice number (No.)';
                    AboutText = 'This is the invoice number uniquely identifying each posted sale. Your customers see this number on the invoices they receive from you.';
                    ToolTip = 'Specifies the posted sales invoice number. Each posted sales invoice gets a unique number. Typically, the number is generated based on a number series.';
                }
                field(OrderNo; SalesInvoiceHeader."Order No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the related order.';
                }
                field(InvoiceNoToPrint; SalesInvoiceHeader."Your Reference")
                {
                    ApplicationArea = Suite;
                }
                field(ExternalDocumentNo; SalesInvoiceHeader."External Document No.")
                {
                    ApplicationArea = Suite;
                }
                field(PaymentTerms; SalesInvoiceHeader."Payment Terms Code")
                {
                    ApplicationArea = Suite;
                }
                field(ShipmentMethod; SalesInvoiceHeader."Shipment Method Code")
                {
                    ApplicationArea = Suite;
                }
                field(SellToCustomerNo; SalesInvoiceHeader."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field(SellToCustomerName; SalesInvoiceHeader."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                field(DueDate; SalesInvoiceHeader."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the invoice is due for payment.';
                }
                field(SellToPostCode; SalesInvoiceHeader."Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the customer''s main address.';
                }
                field(SellToCountryRegionCode; SalesInvoiceHeader."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the customer''s main address.';

                }
                field(SellToContact; SalesInvoiceHeader."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the customer''s main address.';

                }
                field(BillToCustomerNo; SalesInvoiceHeader."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';

                }
                field(BillToName; SalesInvoiceHeader."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';

                }
                field(BillToPostCode; SalesInvoiceHeader."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the customer''s billing address.';

                }
                field(BillToCountryRegionCode; SalesInvoiceHeader."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';

                }
                field(BillToContact; SalesInvoiceHeader."Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the customer''s billing address.';

                }
                field(ShipToCode; SalesInvoiceHeader."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';

                }
                field(ShipToName; SalesInvoiceHeader."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';

                }
                field(ShipToPostCode; SalesInvoiceHeader."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the address that the items are shipped to.';

                }
                field(ShipToCountryRegionCode; SalesInvoiceHeader."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the address that the items are shipped to.';

                }
                field(ShipToContact; SalesInvoiceHeader."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';

                }
                field(PostingDate; SalesInvoiceHeader."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the invoice was posted.';

                }
                field(SalespersonCode; SalesInvoiceHeader."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which salesperson is associated with the invoice.';

                }
                field(Header_Dim1Code; SalesInvoiceHeader."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field(HeaderDim2Code; SalesInvoiceHeader."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field(Header_LocationCode; SalesInvoiceHeader."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location from which the items were shipped.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the line type.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(ItemReferenceNo; Rec."Item Reference No.")
                {
                    AccessByPermission = tabledata "Item Reference" = R;
                    ApplicationArea = Suite, ItemReferences;
                    ToolTip = 'Specifies the referenced item number.';
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';

                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';

                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';

                }
                 field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the product that was sold.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';

                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field(UOM; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(UnitCost; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';

                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field(AmountIncludingTax; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including VAT fields on the associated sales lines.';
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                }

                field(ApplToItemEntry; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied to.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                }
                field(GrossWeight; Rec."Gross Weight")
                {
                    Caption = 'Unit Gross Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the gross weight of one unit of the item. In the sales statistics window, the gross weight on the line is included in the total gross weight of all the lines for the particular sales document.';

                }
                field(NetWeight; Rec."Net Weight")
                {
                    Caption = 'Unit Net Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the net weight of one unit of the item. In the sales statistics window, the net weight on the line is included in the total net weight of all the lines for the particular sales document.';

                }
                field(UnitVolume; Rec."Unit Volume")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the volume of one unit of the item. In the sales statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular sales document.';

                }
                field(UnitsPerParcel; Rec."Units per Parcel")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units per parcel of the item. In the sales statistics window, the number of units per parcel on the line helps to determine the total number of units for all the lines for the particular sales document.';

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        SalesInvoiceHeader.get(Rec."Document No.");
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ShortcutDimCode: array[8] of Code[20];
 
}