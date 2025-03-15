// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
// The structure of this page is based on Page 5806 "Purch. Receipt Lines"

page 50097 "OBF-Item Ledger (IC Appl.)"
{
    Caption = 'Item Ledger (IC Application)';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry';
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Lot No.", Rec."Lot No.");
                    end;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                    Visible = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
                    Visible = false;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                    Visible = true;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected sales amount, in LCY.';
                    Visible = false;
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sales amount, in LCY.';
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected cost, in LCY, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted cost, in LCY, of the quantity posting.';
                }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted non-inventoriable cost, that is an item charge assigned to an outbound entry.';
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected cost, in ACY, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted cost of the entry, in the additional reporting currency.';
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted non-inventoriable cost, that is, an item charge assigned to an outbound entry in the additional reporting currency.';
                    Visible = false;
                }
                field("Completely Invoiced"; Rec."Completely Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.';
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
                    Visible = false;
                }
                field("Applied Entry to Adjust"; Rec."Applied Entry to Adjust")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                    Visible = false;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line number of the order that created the entry.';
                    Visible = false;
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the line number of the production order component.';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("&Value Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Item Ledger Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Item Ledger Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.';
                }
            }
            group("&Application")
            {
                Caption = '&Application';
                Image = Apply;
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    ToolTip = 'View the ledger entries that have been applied to this record.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Show Applied Entries", Rec);
                    end;
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item = R;
                    ApplicationArea = Reservation;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';

                    trigger OnAction()
                    begin
                        Rec.ShowReservationEntries(true);
                    end;
                }
                action("Application Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Application Worksheet';
                    Image = ApplicationWorksheet;
                    ToolTip = 'View item applications that are automatically created between item ledger entries during item transactions.';

                    trigger OnAction()
                    var
                        ApplicationWorksheet: Page "Application Worksheet";
                    begin
                        Clear(ApplicationWorksheet);
                        ApplicationWorksheet.SetRecordToShow(Rec);
                        ApplicationWorksheet.Run();
                    end;
                }
            }
        }

    }

 
    trigger OnAfterGetRecord()
    begin
        DocumentNoHideValue := false;
        DocumentNoOnFormat;
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter(Quantity, '<>0');
        Rec.SetRange(Correction, false);
        Rec.FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        FromItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        UnitCost: Decimal;
        DocumentNoHideValue: Boolean;

    procedure Initialize(NewItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; NewUnitCost: Decimal)
    begin
        ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
        UnitCost := NewUnitCost;
    end;

    local procedure IsFirstDocLine(): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TempItemLedgerEntry.Reset();
        TempItemLedgerEntry.CopyFilters(Rec);
        TempItemLedgerEntry.SetRange("Document No.", Rec."Document No.");
        if not TempItemLedgerEntry.FindFirst() then begin
            Rec.FilterGroup(2);
            ItemLedgerEntry.CopyFilters(Rec);
            Rec.FilterGroup(0);
            ItemLedgerEntry.SetRange("Document No.", Rec."Document No.");
            if not ItemLedgerEntry.FindFirst() then
                exit(false);
            TempItemLedgerEntry := ItemLedgerEntry;
            TempItemLedgerEntry.Insert();
        end;
        if Rec."Entry No." = TempItemLedgerEntry."Entry No." then
            exit(true);
    end;

    local procedure LookupOKOnPush()
    begin
        FromItemLedgerEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(FromItemLedgerEntry);
        if FromItemLedgerEntry.FindFirst() then begin
            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
            CreateItemLedgerEntryChargeAssgnt(FromItemLedgerEntry, ItemChargeAssgntPurch);
        end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
            DocumentNoHideValue := true;
    end;

    // The following procedure is modelled after procedure CreateRcptChargeAssgnt in Codeunit "Item Charge Assgnt. (Purch.)"
    procedure CreateItemLedgerEntryChargeAssgnt(var FromItemLedgerEntry: Record "Item Ledger Entry"; ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        CU_ItemChargeAssgntPurch : Codeunit "Item Charge Assgnt. (Purch.)";
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
    begin
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Item Ledger Entry");
        repeat
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.", FromItemLedgerEntry."Document No.");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.", FromItemLedgerEntry."Entry No.");
            if not ItemChargeAssgntPurch2.FindFirst() then
                CU_ItemChargeAssgntPurch.InsertItemChargeAssignment(
                    ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Item Ledger Entry",
                    FromItemLedgerEntry."Document No.", FromItemLedgerEntry."Entry No.",
                    FromItemLedgerEntry."Item No.", FromItemLedgerEntry.Description, NextLine);
        until FromItemLedgerEntry.Next() = 0;
    end;

}