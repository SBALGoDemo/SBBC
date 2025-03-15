// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50003 "OBF-Purchase Header" extends "Purchase Header"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Purchase Invoices
        field(50000; "OBF-FOB Location"; Code[20])
        {
            Caption = 'Point of Title Transfer';
            TableRelation = "OBF-FOB Location";
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1620 - Coupa Integration
        field(50002; "OBF-Coupa Internal Invoice ID"; Code[20])
        {
            Caption = 'Coupa Internal Invoice ID';
            DataClassification = CustomerContent;
        }
        
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                if Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code" then begin
                    SubDimension.RemoveSubDimensionsFromDimSetID(Rec."Dimension Set ID");
                    RemoveSubDimensionsFromLines();
                end;
            end;
        }
    }


    local procedure RemoveSubDimensionsFromLines()
    var
        SubDimension: Codeunit "OBF-Sub Dimension";
        PurchaseLine: Record "Purchase Line";
        SiteAndCIPCodeMessage: Label 'The Site Code Dimension and the CIP Code were cleared for all Purchase Lines.';
    begin
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
        if PurchaseLine.FindSet() then begin
            Message(SiteAndCIPCodeMessage);
            repeat
                SubDimension.RemoveSubDimensionsFromDimSetID(PurchaseLine."Dimension Set ID");
                PurchaseLine."OBF-Site Code" := '';
                PurchaseLine."OBF-CIP Code" := '';
                PurchaseLine.Modify();
            until (PurchaseLine.Next() = 0);
        end;
    end;

}
