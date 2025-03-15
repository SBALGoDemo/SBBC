// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
tableextension 50082 "OBF-Item Ch Assignment (Purch)"  extends "Item Charge Assignment (Purch)"
{
    fields
    {
        field(50010;"OBF-Lot No.";Code[20])
        {
            Caption = 'Lot No.';
            Editable = false;
        }

        field(51000;"OBF-Orig. Doc. Type";Enum "Purchase Applies-to Document Type")
        {
            Caption = 'Orig. Doc. Type';
        }
        field(51001;"OBF-Orig. Doc. No.";Code[20])
        {
            Caption = 'Orig. Doc. No.';
            TableRelation = if ("Applies-to Doc. Type"=const(Order)) "Purchase Header"."No." WHERE ("Document Type"=const(Order))
                            else if ("Applies-to Doc. Type"=const(Invoice)) "Purchase Header"."No." WHERE ("Document Type"=const(Invoice))
                            else if ("Applies-to Doc. Type"=const("Return Order")) "Purchase Header"."No." WHERE ("Document Type"=const("Return Order"))
                            else if ("Applies-to Doc. Type"=const("Credit Memo")) "Purchase Header"."No." WHERE ("Document Type"=const("Credit Memo"))
                            else if ("Applies-to Doc. Type"=const(Receipt)) "Purch. Rcpt. Header"."No."
                            else if ("Applies-to Doc. Type"=const("Return Shipment")) "Return Shipment Header"."No.";
        }
        field(51002;"OBF-Orig. Doc. Line No.";Integer)
        {
            Caption = 'Orig. Doc. Line No.';
            TableRelation = if ("Applies-to Doc. Type"=const(Order)) "Purchase Line"."Line No." WHERE ("Document Type"=const(Order),
                                        "Document No."=FIELD("Applies-to Doc. No."))
                            else if ("Applies-to Doc. Type"=const(Invoice)) "Purchase Line"."Line No." WHERE ("Document Type"=const(Invoice),
                                        "Document No."=FIELD("Applies-to Doc. No."))
                            else if ("Applies-to Doc. Type"=const("Return Order")) "Purchase Line"."Line No." WHERE ("Document Type"=const("Return Order"),
                                        "Document No."=FIELD("Applies-to Doc. No."))
                            else if ("Applies-to Doc. Type"=const("Credit Memo")) "Purchase Line"."Line No." WHERE ("Document Type"=const("Credit Memo"),
                                        "Document No."=FIELD("Applies-to Doc. No."))
                            else if ("Applies-to Doc. Type"=const(Receipt)) "Purch. Rcpt. Line"."Line No." WHERE ("Document No."=FIELD("Applies-to Doc. No."))
                            else if ("Applies-to Doc. Type"=const("Return Shipment")) "Return Shipment Line"."Line No." WHERE ("Document No."=FIELD("Applies-to Doc. No."));
        }
    }
}