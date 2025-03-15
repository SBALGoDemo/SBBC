// https://odydev.visualstudio.com/ThePlan/_workitems/edit/929 - Create Shipping Release report in NAV
report 50070 "OBF-Shipping Release"
{
    Caption = 'Shipping Release';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\ReportLayouts\OBF-ShippingRelease.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const(Order));

                trigger OnAfterGetRecord();
                begin
                    TempSalesLine := "Sales Line";
                    TempSalesLine_LineNo += 10000;
                    TempSalesLine."Line No." := TempSalesLine_LineNo;
                    TempSalesLine."Sell-to Customer No." := 'ORDER_LINE';

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1956 - Migrate Shipping Release report to Silver Bay
                    if TempSalesLine.Type = TempSalesLine.Type::Item then
                        TempSalesLine.Description := TempSalesLine."No." + '-' + TempSalesLine.Description;

                    TempSalesLine.Insert;

                    if Type = Type::Item then begin
                        TotalQty += Quantity;
                        LineWeight := TempSalesLine."Quantity (Base)" * TempSalesLine."Net Weight";
                        TotalWeight += LineWeight;
                        GetLotsForSalesLine("Sales Line");
                    end;
                end;

                trigger OnPostDataItem();
                begin
                    InsertTempLineForTotals(TotalQty, TotalWeight);
                end;
            }
            dataitem(SalesOrderComments; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = sorting("OBF-Revision No.") where("Document Type" = const(Order), "Print On Pick Ticket" = const(true), "Document Line No." = const(0));
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord();
                begin
                    if SalesOrderComments."OBF-Revision No." <> LastRevisionNo then
                        InsertTempLineForComments('');
                    LastRevisionNo := SalesOrderComments."OBF-Revision No.";
                    InsertTempLineForComments(Comment);
                end;
            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(No_SalesHeader; "Sales Header"."No.")
                {
                }
                column(CompanyInfoPicture; CompanyInformation.Picture)
                {
                }
                column(CompanyAddress1; CompanyAddress[1])
                {
                }
                column(CompanyAddress2; CompanyAddress[2])
                {
                }
                column(CompanyAddress3; CompanyAddress[3])
                {
                }
                column(CompanyAddress4; CompanyAddress[4])
                {
                }
                column(CompanyAddress5; CompanyAddress[5])
                {
                }
                column(CompanyAddress6; CompanyAddress[6])
                {
                }
                column(CompanyAddress7; CompanyAddress[7])
                {
                }
                column(CompanyAddress8; CompanyAddress[8])
                {
                }
                column(ShipToAddress1; ShipToAddress[1])
                {
                }
                column(ShipToAddress2; ShipToAddress[2])
                {
                }
                column(ShipToAddress3; ShipToAddress[3])
                {
                }
                column(ShipToAddress4; ShipToAddress[4])
                {
                }
                column(ShipToAddress5; ShipToAddress[5])
                {
                }
                column(ShipToAddress6; ShipToAddress[6])
                {
                }
                column(ShipToAddress7; ShipToAddress[7])
                {
                }
                column(ShipToAddress8; ShipToAddress[8])
                {
                }
                column(LocationName; LocationName)
                {
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1047 - Add Traffic Person to Shipping Release printout  
                column(TrafficPerson; TrafficPerson)
                {
                }

                column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                {
                }
                column(SellToCustNo; "Sales Header"."Sell-to Customer No.")
                {
                }
                column(ExtDocNo_SalesHeader; "Sales Header"."External Document No.")
                {
                }
                column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                {
                }
                column(ShptDate_SalesHeader; "Sales Header"."Shipment Date")
                {
                }
                column(RequestedDeliveryDate_SalesHeader; "Sales Header"."Requested Delivery Date")
                {
                }
                column(ShipmentMethodCode_SalesHeader; "Sales Header"."Shipment Method Code")
                {
                }
                column(ShippingAgentCode_SalesHeader; "Sales Header"."Shipping Agent Code")
                {
                }
                column(ShippingAgentName; ShippingAgent.Name)
                {
                }
                column(SalesPurchPersonName; SalesPurchPerson.Name)
                {
                }
                column(ShipmentMethodDesc; ShipmentMethod.Description)
                {
                }
                column(PaymentTermsDesc; PaymentTerms.Description)
                {
                }
                column(SpotCount; SpotCount)
                {
                    DecimalPlaces = 0 : 2;
                }
                column(PalletCount; PalletCount)
                {
                }
                column(FreightRate; FreightRate)
                {
                }
                column(FooterComment; FooterComment)
                {
                }
                dataitem(SalesLine; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(TempSalesLine_LineType; TempSalesLine."Sell-to Customer No.")
                    {
                    }
                    column(TempSalesLineNo; TempSalesLine."No.")
                    {
                    }
                    column(TempSalesLineUOM; TempSalesLine."Unit of Measure Code")
                    {
                    }
                    column(TempSalesLineQuantity; TempSalesLine.Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(TempSalesLineDesc; TempSalesLine.Description + ' ' + TempSalesLine."Description 2")
                    {
                    }
                    column(TempSalesLineLot; TempSalesLine.Description)
                    {
                    }
                    column(TempSalesLineLotQty; TempSalesLine."Description 2")
                    {
                    }
                    column(TempSalesLineDocumentNo; TempSalesLine."Document No.")
                    {
                    }
                    column(TempSalesLineLineNo; TempSalesLine."Line No.")
                    {
                    }
                    column(TempSalesLineNetWeight; LineWeight)
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(TempSalesLinePackSize; PackSizePlaceHolder)
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        SalesLine: Record "Sales Line";
                        lctxtFreight: Label 'Freight:';
                        lctxtAllowance: Label 'Allowance:';
                    begin
                        OnLineNumber := OnLineNumber + 1;
                        LineWeight := 0;
                        if OnLineNumber = 1 then
                            TempSalesLine.Find('-')
                        else
                            TempSalesLine.Next;
                        if TempSalesLine.Type = TempSalesLine.Type::Item then
                            LineWeight := TempSalesLine."Quantity (Base)" * TempSalesLine."Net Weight"
                        else
                            if TempSalesLine."Sell-to Customer No." = 'ORDER_TOTAL' then
                                LineWeight := TempSalesLine."Net Weight";
                        // TempSalesLine.CalcFields(TempSalesLine."OBF-Pack Size");

                    end;

                    trigger OnPreDataItem();
                    begin
                        NumberOfLines := TempSalesLine.Count;
                        SetRange(Number, 1, NumberOfLines);
                        OnLineNumber := 0;
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                LocationName := '';
                if not Location.Get("Sales Header"."Location Code") then
                    Clear(Location)
                else
                    LocationName := 'Pickup at: ' + Location.Name;

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1047 - Add Traffic Person to Shipping Release printout
                TrafficPerson := 'Traffic Department';
                if "Sales Header"."OBF-Assigned Traffic Person" <> '' then begin
                    User.SetRange("User Name", "Sales Header"."OBF-Assigned Traffic Person");
                    if User.FindFirst() then
                        TrafficPerson := User."Full Name";
                end;

                if not Cust.Get("Sell-to Customer No.") then
                    Clear(Cust);

                if not ShippingAgent.Get("Sales Header"."Shipping Agent Code") then
                    Clear(ShippingAgent);

                FormatDocumentFields("Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");
                CompressArray(ShipToAddress);

                TotalQty := 0;
                TotalWeight := 0;

                TempSalesLine.Reset;
                TempSalesLine.DeleteAll;
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
                    Caption = 'Options';
                    field(SpotCount; SpotCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Spot Count';
                        DecimalPlaces = 0 : 2;
                    }
                    field(PalletCount; PalletCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Pallet Count';
                    }
                    field(FreightRate; FreightRate)
                    {
                        ApplicationArea = All;
                        Caption = 'Freight Rate';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.Get;
        CompanyInformation.CALCFIELDS(Picture);
        SalesSetup.Get;
        FormatAddress.Company(CompanyAddress, CompanyInformation);
        CompanyAddress[7] := CompanyInformation."Phone No.";
        CompressArray(CompanyAddress);
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesLine: Record "Sales Line" temporary;
        Cust: Record Customer;
        ShippingAgent: Record "Shipping Agent";
        Location: Record Location;
        User: Record User;
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        LocationName: Text[70];
        FreightRate: Text[50];
        CompanyAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        SalespersonText: Text[50];
        TrafficPerson: Text[80];
        LastRevisionNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        OnLotLineNumber: Integer;
        SpotCount: Decimal;
        PalletCount: Integer;
        TempSalesLine_LineNo: Integer;
        TotalQty: Decimal;
        LineWeight: Decimal;
        TotalWeight: Decimal;
        FooterComment: Label 'Please advise immediately if unable to ship as requested.  Please note Spot Count on BOL.';
        PackSizePlaceHolder: Code[10];

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header");
    begin
        FormatDocument.SetSalesPerson(SalesPurchPerson, SalesHeader."Salesperson Code", SalespersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesHeader."Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");

    end;

    local procedure InsertTempLineForTotals(pTotalQuantity: Decimal; pTotalWeight: Decimal);
    begin
        InitTempSalesLine('ORDER_TOTAL');
        TempSalesLine.Quantity := pTotalQuantity;
        TempSalesLine."Net Weight" := pTotalWeight;
        TempSalesLine.Insert;
    end;

    local procedure InsertTempLineForComments(Comment: Text[80]);
    begin
        InitTempSalesLine('ORDER_COMMENT');
        FormatDocument.ParseComment(Comment, TempSalesLine.Description, TempSalesLine."Description 2");
        TempSalesLine.Insert;
    end;

    local procedure InitTempSalesLine(TypeOfLine: Code[20]);
    begin
        TempSalesLine.Init;
        TempSalesLine."Document Type" := "Sales Header"."Document Type";
        TempSalesLine."Document No." := "Sales Header"."No.";
        TempSalesLine_LineNo += 10000;
        TempSalesLine."Line No." := TempSalesLine_LineNo;
        TempSalesLine."Sell-to Customer No." := TypeOfLine;
    end;

    local procedure GetLotsForSalesLine(pSalesLine: Record "Sales Line");
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntryTemp: Record "Reservation Entry" temporary;
        Item: Record Item;
        LineNo: Integer;
    begin
        ReservationEntry.Reset;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", pSalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", pSalesLine."Line No.");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", pSalesLine."Document Type");
        ReservationEntryTemp.Reset;
        ReservationEntryTemp.DeleteAll;
        if ReservationEntry.FindSet then
            repeat
                ReservationEntryTemp.SetRange("Lot No.", ReservationEntry."Lot No.");
                if not ReservationEntryTemp.FindFirst then begin
                    LineNo += 1;
                    ReservationEntryTemp.Init;
                    ReservationEntryTemp."Entry No." := LineNo;
                    ReservationEntryTemp."Item No." := ReservationEntry."Item No.";
                    ReservationEntryTemp."Lot No." := ReservationEntry."Lot No.";
                    //ReservationEntryTemp."OBF-Net Weight" := ReservationEntry."OBF-Net Weight";
                    ReservationEntryTemp.Insert;
                end;
                ReservationEntryTemp."Quantity (Base)" -= ReservationEntry."Quantity (Base)";
                ReservationEntryTemp.Modify;
            until (ReservationEntry.Next = 0);

        ReservationEntryTemp.Reset;
        if ReservationEntryTemp.FindSet then
            repeat
                InitTempSalesLine('ORDER_LINE_LOT');
                TempSalesLine.Description := GetLotText(ReservationEntryTemp."Item No.", ReservationEntryTemp."Variant Code", ReservationEntryTemp."Lot No.");
                Item.Get(ReservationEntryTemp."Item No.");
                TempSalesLine."Description 2" := Format(ReservationEntryTemp."Quantity (Base)") + ' ' + Item."Base Unit of Measure";
                TempSalesLine.Insert;
            until (ReservationEntryTemp.Next = 0);
    end;

    local procedure GetLotText(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]): Text[50];
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        // if LotNoInformation.Get(ItemNo, VariantCode, LotNo) then
        //     if LotNoInformation."OBF-Alternate Lot No." <> '' then
        //         exit(LotNoInformation."OBF-Alternate Lot No." + ' (' + LotNo + ')');
        exit(LotNo);
    end;
}

