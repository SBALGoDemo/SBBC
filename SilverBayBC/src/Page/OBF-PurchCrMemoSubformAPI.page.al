// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
page 50026 "OBF-Purch. Cr.Memo Subform API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIPublisher = 'SilverBay';
    APIGroup = 'customapi';

    EntityCaption = 'OBFPurchCrMemoSubformAPI';
    EntitySetCaption = 'OBFPurchCrMemoSubformAPI';
    EntityName = 'OBFPurchCrMemoSubformAPI';
    EntitySetName = 'OBFPurchCrMemoSubformAPI';

    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const("Credit Memo"));
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentType; Rec."Document Type")
                {
                }
                field(documentNo; Rec."Document No.")
                {
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(ReturnReasonCode; Rec."Return Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                }
                field(type; Rec.Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the line type.';
                }
                

                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what you are buying, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';
                }
                field(item_reference_no; Rec."Item Reference No.")
                {
                    ApplicationArea = Suite, ItemReferences;
                    ToolTip = 'Specifies the referenced item number.';
                }
                field(variant_code; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Describes what is being purchased. The suggested text comes from the item itself. You can change it to suit your needs for this document. If you change it here, the source of the text will not change. If the line''s Type field is set to Comment, you can use this field to write the comment, and leave the other fields empty.';
                }
                field(description_2; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field(location_code; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of what you''re buying. The number is based on the unit chosen in the Unit of Measure Code field.';
                }
                field(unit_of_Measure_code; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(direct_unit_cost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the price of one unit of what you are buying.';
                }
                field(dimension_1_code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(dimension_2_code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(dimension_3_code; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(dimension_4_code; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(dimension_5_code; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(dimension_6_code; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(dimension_7_code; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(dimension_8_code; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(SiteCode;Rec."OBF-Site Code")
                {
                    ApplicationArea = All;
                }
                field(CIPCode;Rec."OBF-CIP Code")
                {
                    ApplicationArea = All;
                }
                field(FishermanReferenceCode;Rec."OBF-Fisherman Reference Code")
                {
                    ApplicationArea = All;
                }
                field(ExpenseItem;Rec."OBF-Expense Item")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
}