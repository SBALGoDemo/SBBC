// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1889 - Import Item Charge Assignment by Item Ledger Entry
// Note: This is a copy of the BC20.4 Page 5805 "Item Charge Ass. (Purch)"

page 50076 "OBF-Item Charge Ass. (ILE)"
{
    AutoSplitKey = true;
    Caption = 'Item Charge Assignment (Item Ledger)';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Worksheet;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Item Charge';
    RefreshOnActivate = true;
    SourceTable = "Item Charge Assignment (Purch)";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = ItemCharges;
                    Editable = false;
                    ToolTip = 'Specifies the type of the document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = ItemCharges;
                    Editable = false;
                    ToolTip = 'Specifies the number of the document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to Doc. Line No."; Rec."Applies-to Doc. Line No.")
                {
                    ApplicationArea = ItemCharges;
                    Editable = false;
                    ToolTip = 'Specifies the number of the line on the document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = ItemCharges;
                    Editable = false;
                    ToolTip = 'Specifies the item number on the document line that this item charge is assigned to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ItemCharges;
                    ToolTip = 'Specifies a description of the item on the document line that this item charge is assigned to.';
                }
                field("OBF-Lot No.";Rec."OBF-Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = ItemCharges;
                    ToolTip = 'Specifies how many units of the item charge will be assigned to the document line. If the document has more than one line of type Item, then this quantity reflects the distribution that you selected when you chose the Suggest Item Charge Assignment action.';

                    trigger OnValidate()
                    begin
                        if PurchLine2.Quantity * Rec."Qty. to Assign" < 0 then
                            Error(Text000,
                              Rec.FieldCaption(Rec."Qty. to Assign"), PurchLine2.FieldCaption(Quantity));
                    end;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = ItemCharges;
                    ToolTip = 'Specifies the number of units of the item charge will be the assigned to the document line.';
                }
                field("Amount to Assign"; Rec."Amount to Assign")
                {
                    ApplicationArea = ItemCharges;
                    Editable = false;
                    ToolTip = 'Specifies the value of the item charge that will be the assigned to the document line.';
                }
                field("<Gross Weight>"; GrossWeight)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Gross Weight';
                    DecimalPlaces = 0 : 4;
                    Editable = false;
                    ToolTip = 'Specifies the initial weight of one unit of the item. The value may be used to complete customs documents and waybills.';
                }
                field("<Unit Volume>"; UnitVolume)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Unit Volume';
                    DecimalPlaces = 0 : 4;
                    Editable = false;
                    ToolTip = 'Specifies the volume of one unit of the item. The value may be used to complete customs documents and waybills.';
                }
                field(QtyToReceiveBase; QtyToReceiveBase)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Qty. to Receive (Base)';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the documents line for this item charge assignment have not yet been posted as received.';
                }
                field(QtyReceivedBase; QtyReceivedBase)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Qty. Received (Base)';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the documents line for this item charge assignment have been posted as received.';
                }
                field(QtyToShipBase; QtyToShipBase)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Qty. to Ship (Base)';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the documents line for this item charge assignment have not yet been posted as shipped.';
                }
                field(QtyShippedBase; QtyShippedBase)
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    Caption = 'Qty. Shipped (Base)';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies how many units of the item on the documents line for this item charge assignment have been posted as shipped.';
                }
            }
            group(Control22)
            {
                ShowCaption = false;
                fixed(Control1900669001)
                {
                    ShowCaption = false;
                    group(Assignable)
                    {
                        Caption = 'Assignable';
                        field(AssignableQty; AssignableQty)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Total (Qty.)';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the total quantity of the item charge that you can assign to the related document line.';
                        }
                        field(AssgntAmount; AssgntAmount)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Total (Amount)';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the total value of the item charge that you can assign to the related document line.';
                        }
                    }
                    group("To Assign")
                    {
                        Caption = 'To Assign';
                        field(TotalQtyToAssign; TotalQtyToAssign)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Qty. to Assign';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the total quantity of the item charge that you can assign to the related document line.';
                        }
                        field(TotalAmountToAssign; TotalAmountToAssign)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Amount to Assign';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            ToolTip = 'Specifies the total value of the item charge that you can assign to the related document line.';
                        }
                    }
                    group("Rem. to Assign")
                    {
                        Caption = 'Rem. to Assign';
                        field(RemQtyToAssign; RemQtyToAssign)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Rem. Qty. to Assign';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            Style = Unfavorable;
                            StyleExpr = RemQtyToAssign <> 0;
                            ToolTip = 'Specifies the quantity of the item charge that has not yet been assigned.';
                        }
                        field(RemAmountToAssign; RemAmountToAssign)
                        {
                            ApplicationArea = ItemCharges;
                            Caption = 'Rem. Amount to Assign';
                            DecimalPlaces = 0 : 5;
                            Editable = false;
                            Style = Unfavorable;
                            StyleExpr = RemAmountToAssign <> 0;
                            ToolTip = 'Specifies the value of the quantity of the item charge that has not yet been assigned.';
                        }
                    }
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
        area(processing)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1321 - Add Item Ledger option to charge assignment screen
            action(GetItemLedgerEntries)
            {
                ApplicationArea = ItemCharges;
                Caption = 'Get &Item Ledger Entries';
                Image = Ledger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Select an Item Ledger Entry that you want to assign the item charge to, for example, for Item Reclass Journal transfers.';

                trigger OnAction()
                var
                    ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                    ItemLedgerICAppl: Page "OBF-Item Ledger (IC Appl.)";
                    ItemChargeAssignment: Page "Item Charge Assignment (Purch)";
                begin
                    PurchLine2.TestField("Qty. to Invoice");

                    ItemChargeAssgntPurch.SetRange("Document Type", Rec."Document Type");
                    ItemChargeAssgntPurch.SetRange("Document No.", Rec."Document No.");
                    ItemChargeAssgntPurch.SetRange("Document Line No.", Rec."Document Line No.");

                    //ItemLedgerICAppl.SetTableView(ItemLedgerEntry);
                    if ItemChargeAssgntPurch.FindLast() then
                        ItemLedgerICAppl.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                    else
                        ItemLedgerICAppl.Initialize(Rec, PurchLine2."Unit Cost");

                    ItemLedgerEntry.SetFilter(Quantity,'>0');
                    ItemLedgerEntry.FindLast();
                    ItemLedgerICAppl.SetTableView(ItemLedgerEntry);
                    ItemLedgerICAppl.SetRecord(ItemLedgerEntry);

                    ItemLedgerICAppl.LookupMode(true);
                    ItemLedgerICAppl.RunModal();
                end;
            }

            action(SuggestItemChargeAssignment)
            {
                AccessByPermission = TableData "Item Charge" = R;
                ApplicationArea = ItemCharges;
                Caption = 'Suggest &Item Charge Assignment';
                Ellipsis = true;
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Use a function that assigns and distributes the item charge when the document has more than one line of type Item. You can select between four distribution methods. ';

                trigger OnAction()
                var
                    AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                begin
                    AssignItemChargePurch.SuggestAssgnt(PurchLine2, AssignableQty, AssgntAmount);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateQtyAssgnt;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateQty;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Document Type" = Rec."Applies-to Doc. Type" then begin
            PurchLine2.TestField("Receipt No.", '');
            PurchLine2.TestField("Return Shipment No.", '');
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Document Type", PurchLine2."Document Type");
        Rec.SetRange("Document No.", PurchLine2."Document No.");
        Rec.SetRange("Document Line No.", PurchLine2."Line No.");
        Rec.SetRange("Item Charge No.", PurchLine2."No.");
        Rec.FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if RemAmountToAssign <> 0 then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(Text001, RemAmountToAssign, Rec."Document Type", Rec."Document No."), true)
            then
                exit(false);
    end;

    var
        Text000: Label 'The sign of %1 must be the same as the sign of %2 of the item charge.';
        PurchLine: Record "Purchase Line";
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssgntAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        DataCaption: Text[250];
        Text001: Label 'The remaining amount to assign is %1. It must be zero before you can post %2 %3.\ \Are you sure that you want to close the window?', Comment = '%2 = Document Type, %3 = Document No.';
        GrossWeight: Decimal;
        UnitVolume: Decimal;

    protected var
        PurchLine2: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        TransferRcptLine: Record "Transfer Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        QtyToReceiveBase: Decimal;
        QtyReceivedBase: Decimal;
        QtyToShipBase: Decimal;
        QtyShippedBase: Decimal;

    local procedure UpdateQtyAssgnt()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        PurchLine2.CalcFields("Qty. to Assign", "Qty. Assigned");
        AssignableQty :=
          PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced" - PurchLine2."Qty. Assigned";

        ItemChargeAssgntPurch.Reset();
        ItemChargeAssgntPurch.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
        ItemChargeAssgntPurch.SetRange("Document Type", Rec."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.", Rec."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.", Rec."Document Line No.");
        ItemChargeAssgntPurch.CalcSums("Qty. to Assign", "Amount to Assign");
        TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssgntPurch."Amount to Assign";

        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    end;

    local procedure UpdateQty()
    begin
        case Rec."Applies-to Doc. Type" of
            Rec."Applies-to Doc. Type"::"Item Ledger Entry":
                begin
                    ItemLedgerEntry.Get(Rec."Applies-to Doc. Line No.");
                    QtyToReceiveBase := 0;
                    QtyReceivedBase := ItemLedgerEntry."Quantity";
                    QtyToShipBase := 0;
                    QtyShippedBase := 0;
                    GrossWeight := ItemLedgerEntry."OBF-Net Weight"/ItemLedgerEntry."Quantity";
                    UnitVolume := 0;
                end;
                
        end;
    end;

    procedure Initialize(NewPurchLine: Record "Purchase Line"; NewLineAmt: Decimal)
    begin
        PurchLine2 := NewPurchLine;
        DataCaption := PurchLine2."No." + ' ' + PurchLine2.Description;
        AssgntAmount := NewLineAmt;
    end;
 
}