// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50013 "OBF-Vendor" extends Vendor
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Global Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                Rec.ValidateShortcutDimCode(3,"OBF-Site Code");
            end;
        }
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then begin
                    Rec."OBF-Site Code" := '';
                end;
            end;
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1727 - Payment Imports
    procedure FindVendorNoFromOurAccountNo(OurAccountNo:Text[20]): Code[20]
    var
        Vendor: Record Vendor;
    begin
        if OurAccountNo = '' then
            exit('');

        Vendor.SetRange("Our Account No.",OurAccountNo);
        if Vendor.FindFirst() then
            exit(Vendor."No.");
    end;   
}