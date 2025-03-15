// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1727 - Payment Imports
table 50006 "OBF-Payment Import Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(30; "Subsidiary Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SUBSIDIARY'), Code = field("Subsidiary Code")));
            Caption = 'Subsidiary Name';
            Editable = false;
        }
        field(40; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(70; "Reference No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reference No.';
        }
        field(80; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(90; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(100; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Editable = false;
        }
        field(110; Memo; Text[1000])
        {
            Caption = 'Memo/Description';
        }

        field(120; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(130; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(140; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(150; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Editable = false;
        }

        field(200; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(210; "Subsidiary Text"; Code[20])
        {
            Caption = 'Subsidiary Text';
        }
        field(220; "Is Void"; Boolean)
        {
            Caption = 'Is Void';
        }
        field(230; "External ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Account ID';
        }
        field(240; "Invoice No."; Code[100])
        {
            Caption = 'Invoice No.';
        }

    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    procedure MainLoop()
    var
        Vendor: Record Vendor;
        PaymentImportBuffer: Record "OBF-Payment Import Buffer";
        DimensionValue: Record "Dimension Value";
        Num: Integer;
    begin
        PaymentImportBuffer.FindSet();
        repeat
            PaymentImportBuffer."Document Type" := PaymentImportBuffer."Document Type"::Invoice;
            PaymentImportBuffer."Vendor No." := Vendor.FindVendorNoFromOurAccountNo("Our Account No.");
            PaymentImportBuffer."Subsidiary Code" := DimensionValue.FindSubsidiaryFromCoupaID(PaymentImportBuffer."Subsidiary Text");
            PaymentImportBuffer.Modify();
            Num += 1;
        until (PaymentImportBuffer.Next() = 0);
        Message('%1 records were updated', Num);
    end;


    procedure CreateGenJournalLines(JournalBatchName: Code[10])
    var
        GenJournalLine: Record "Gen. Journal Line";
        PaymentImportBuffer: Record "OBF-Payment Import Buffer";
        LineNo: integer;
    begin
        PaymentImportBuffer.SetFilter("Vendor No.", '<>%1', '');
        PaymentImportBuffer.FindSet();
        LineNo := 0;
        repeat
            LineNo += 10000;
            GenJournalLine."Journal Template Name" := 'PURCHASES';
            GenJournalLine."Journal Batch Name" := JournalBatchName;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Posting Date" := PaymentImportBuffer."Posting Date";
            GenJournalLine."Document Type" := PaymentImportBuffer."Document Type";
            if PaymentImportBuffer."Document No." <> '' then
                GenJournalLine."Document No." := PaymentImportBuffer."External ID"
            else if PaymentImportBuffer."External ID" <> '' then
                GenJournalLine."Document No." := PaymentImportBuffer."External ID"
            else
                GenJournalLine."Document No." := PaymentImportBuffer."Reference No.";
            GenJournalLine."External Document No." := PaymentImportBuffer."Reference No.";
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
            GenJournalLine.validate("Account No.", PaymentImportBuffer."Vendor No.");
            GenJournalLine.Validate(Amount, -PaymentImportBuffer.Amount);
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Bal. Account No." := PaymentImportBuffer."G/L Account No.";
            GenJournalLine.validate("Shortcut Dimension 1 Code", PaymentImportBuffer."Subsidiary Code");
            // GenJournalLine.Validate(BssiEntityID,PaymentImportBuffer."Subsidiary Code");
            GenJournalLine.Comment := PaymentImportBuffer.Memo;
            if PaymentImportBuffer.Memo <> '' then
                GenJournalLine.Description := copystr(PaymentImportBuffer.Memo, 1, 100)
            else begin
                PaymentImportBuffer.CalcFields("Vendor Name");
                GenJournalLine.Description := PaymentImportBuffer."Vendor Name";
            end;
            GenJournalLine.Insert();
        until (PaymentImportBuffer.Next() = 0);
        message('Done');
    end;

}