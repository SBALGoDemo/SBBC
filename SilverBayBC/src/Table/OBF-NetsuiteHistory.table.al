// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions - for initial import
table 50061 "OBF-Netsuite History"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Document Type"; Text[30])
        {
            DataClassification = CustomerContent;           
        }

        field(3; "Document Number"; Code[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; Memo; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; Status; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Invoice No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(8; Item; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(9; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; Terms; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }    
        field(14; Account; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(15; Period; Text[20])
        {
            DataClassification = CustomerContent;
        }  
        field(16; "Transaction Number"; Code[35])
        {
            DataClassification = CustomerContent;
        }         
        field(30; Subsidiary; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SUBSIDIARY'));
            Caption = 'Subsidiary Code';
        }
        field(32; "Subsidiary Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SUBSIDIARY'), Code = field("Subsidiary Code")));
            Caption = 'Subsidiary Name';
            Editable = false;
        }
        field(33; "AP Invoice No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'AP Invoice No.';
        }
        field(40; Site; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(41; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Subsidiary Code"));
            Caption = 'Site Code';
        }
        field(42; "Site Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = const('SITE'), Code = field("Site Code")));
            Caption = 'Site Name';
            Editable = false;
        }
        field(100;"Customer No.";Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(101;"Vendor No.";Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(110;"Bal. Account No.";Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bal. Account No.';
            TableRelation = "G/L Account";
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }
        field(120; "Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(130; "Item No.";Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(140; "Item Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description';
        }
        field(150; "Account No.";Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
            TableRelation = "G/L Account";
        }
        field(160; "Account Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Description';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    // procedure MainLoop()
    // var
    //     NetSuiteHistory: Record "OBF-Netsuite History";
    // begin 
    //     // NetSuiteHistory.SetRange("Line No.",1,1);
    //     // NetSuiteHistory.SetFilter("Item No.",'');
    //     // NetSuiteHistory.SetFilter("Account No.",'');
    //     NetSuiteHistory.FindSet();
    //     repeat
    //         case NetSuiteHistory."Document Type" of
    //             'Purchase Invoice','AP Credit Memo' : NetSuiteHistory.SetVendor();
    //             'Sales Invoice','Sales Credit Memo' : NetSuiteHistory.SetCustomer();
    //         end;
    //         NetSuiteHistory."Subsidiary Code" := FindSubsidiary(NetSuiteHistory."Subsidiary Name");
    //         NetSuiteHistory."Site Code" := TempSiteLookup.FindSite(NetSuiteHistory."Subsidiary Code",NetSuiteHistory."Site Name");

    //         NetSuiteHistory.SetSubsidiary();
    //         NetSuiteHistory.SetSite();
    //         NetSuiteHistory.SetPaymentTerms();
    //         NetSuiteHistory.SetItemNo();
    //         NetSuiteHistory.SetAccountNo();
    //         NetSuiteHistory.Modify();       
    //     until ( NetSuiteHistory.Next()=0);
    // end;

    // procedure CopyToNetsuiteSalesInvoice()
    // var
    //     NetSuiteHistory: Record "OBF-Netsuite History";
    //     NetsuiteSalesInvHeader: Record "OBF-Netsuite Sales Inv. Header";
    //     NetsuiteSalesInvLine: Record "OBF-Netsuite Sales Inv. Line";
    //     DocumentNo: Code[20];
    //     ExternalDocumentNo: Code[35];
    //     LastDocumentNo: Code[35];
    //     LineNo: Integer;
    // begin 
    //     DocumentNo := 'NS_SI000000';
    //     NetsuiteSalesInvHeader.DeleteAll();
    //     NetsuiteSalesInvLine.DeleteAll();
    //     //NetSuiteHistory.SetRange("Line No.",400,600);
    //     NetSuiteHistory.SetRange("Document Type",'Sales Invoice');
    //     NetSuiteHistory.FindSet();
    //     repeat
    //         ExternalDocumentNo := CopyStr(NetSuiteHistory."Document Number",1,35);
    //         if LastDocumentNo <> ExternalDocumentNo then begin 
    //             NetsuiteSalesInvHeader.Init();
    //             DocumentNo := IncStr(DocumentNo);
    //             NetsuiteSalesInvHeader."No." := DocumentNo;
    //             NetsuiteSalesInvHeader."External Document No." := ExternalDocumentNo;
    //             NetsuiteSalesInvHeader."Posting Date" := NetSuiteHistory."Posting Date";
    //             NetsuiteSalesInvHeader."Sell-to Customer No." := NetSuiteHistory."Customer No.";
    //             NetsuiteSalesInvHeader."Sell-to Customer Name" := NetSuiteHistory.Name;
    //             NetsuiteSalesInvHeader.Status := NetSuiteHistory.Status;
    //             NetsuiteSalesInvHeader.Insert();
    //             LastDocumentNo := ExternalDocumentNo;
    //             LineNo := 0;
    //         end;

    //         LineNo += 10000;
    //         NetsuiteSalesInvLine."Document No." := DocumentNo;
    //         NetsuiteSalesInvLine."Line No." := LineNo;
    //         if NetSuiteHistory."Item No." <> '' then begin 
    //             NetsuiteSalesInvLine.Type := NetsuiteSalesInvLine.Type::Item;
    //             NetsuiteSalesInvLine."No." := NetSuiteHistory."Item No.";
    //         end else if NetSuiteHistory."Account No." <> '' then begin 
    //             NetsuiteSalesInvLine.Type := NetsuiteSalesInvLine.Type::"G/L Account";
    //             NetsuiteSalesInvLine."No." := NetSuiteHistory."Account No.";
    //         end else
    //             NetsuiteSalesInvLine.Type := NetsuiteSalesInvLine.Type::" ";
            
    //         NetsuiteSalesInvLine.Description := CopyStr(NetSuiteHistory.Memo,1,100);
    //         NetsuiteSalesInvLine.Quantity := 1.0;
    //         NetsuiteSalesInvLine.Amount := NetSuiteHistory.Amount;
    //         NetsuiteSalesInvLine."Unit Price" := Round(NetsuiteSalesInvLine.Amount/NetsuiteSalesInvLine.Quantity);
    //         NetsuiteSalesInvLine."Subsidiary Code" := NetSuiteHistory."Subsidiary Code";
    //         NetsuiteSalesInvLine."Site Code" := NetSuiteHistory."Site Code";
    //         NetsuiteSalesInvLine.Insert();


    //     until ( NetSuiteHistory.Next()=0);
    // end;

    // procedure CopyToNetsuitePurchaseInvoice()
    // var
    //     NetSuiteHistory: Record "OBF-Netsuite History";
    //     NetsuitePurchInvHeader: Record "OBF-Netsuite Purch Inv. Header";
    //     NetsuitePurchInvLine: Record "OBF-Netsuite Purch Inv. Line";
    //     DocumentNo: Code[20];
    //     ExternalDocumentNo: Code[35];
    //     LastDocumentNo: Code[35];
    //     LineNo: Integer;
    // begin 
    //     DocumentNo := 'NS_SI000000';
    //     NetsuitePurchInvHeader.DeleteAll();
    //     NetsuitePurchInvLine.DeleteAll();
    //     //NetSuiteHistory.SetRange("Line No.",400,600);
    //     NetSuiteHistory.SetRange("Document Type",'Purchase Invoice');
    //     NetSuiteHistory.FindSet();
    //     repeat
    //         ExternalDocumentNo := CopyStr(NetSuiteHistory."Document Number",1,35);
    //         if LastDocumentNo <> ExternalDocumentNo then begin 
    //             NetsuitePurchInvHeader.Init();
    //             DocumentNo := IncStr(DocumentNo);
    //             NetsuitePurchInvHeader."No." := DocumentNo;
    //             NetsuitePurchInvHeader."External Document No." := ExternalDocumentNo;
    //             NetsuitePurchInvHeader."Posting Date" := NetSuiteHistory."Posting Date";
    //             NetsuitePurchInvHeader."Vendor No." := NetSuiteHistory."Vendor No.";
    //             NetsuitePurchInvHeader."Vendor Name" := NetSuiteHistory.Name;
    //             NetsuitePurchInvHeader.Status := NetSuiteHistory.Status;
    //             NetsuitePurchInvHeader.Insert();
    //             LastDocumentNo := ExternalDocumentNo;
    //             LineNo := 0;
    //         end;

    //         LineNo += 10000;
    //         NetsuitePurchInvLine."Document No." := DocumentNo;
    //         NetsuitePurchInvLine."Line No." := LineNo;
    //         if NetSuiteHistory."Item No." <> '' then begin 
    //             NetsuitePurchInvLine.Type := NetsuitePurchInvLine.Type::Item;
    //             NetsuitePurchInvLine."No." := NetSuiteHistory."Item No.";
    //         end else if NetSuiteHistory."Account No." <> '' then begin 
    //             NetsuitePurchInvLine.Type := NetsuitePurchInvLine.Type::"G/L Account";
    //             NetsuitePurchInvLine."No." := NetSuiteHistory."Account No.";
    //         end else
    //             NetsuitePurchInvLine.Type := NetsuitePurchInvLine.Type::" ";
            
    //         NetsuitePurchInvLine.Description := CopyStr(NetSuiteHistory.Memo,1,100);
    //         NetsuitePurchInvLine.Quantity := 1.0;
    //         NetsuitePurchInvLine.Amount := NetSuiteHistory.Amount;
    //         NetsuitePurchInvLine."Unit Price" := Round(NetsuitePurchInvLine.Amount/NetsuitePurchInvLine.Quantity);
    //         NetsuitePurchInvLine."Subsidiary Code" := NetSuiteHistory."Subsidiary Code";
    //         NetsuitePurchInvLine."Site Code" := NetSuiteHistory."Site Code";
    //         NetsuitePurchInvLine.Insert();


    //     until ( NetSuiteHistory.Next()=0);
    // end;

    // procedure SetCustomer()
    // var
    //     Customer: Record Customer;
    //     CustomerPostingGroup: Record "Customer Posting Group";
    // begin 
    //     Customer.SetRange(Name,Rec.Name);
    //     if Customer.FindFirst() then begin
    //         Rec."Customer No." := Customer."No.";
    //         if CustomerPostingGroup.Get(Customer."Customer Posting Group") then
    //             Rec."Bal. Account No." := CustomerPostingGroup."Receivables Account";
    //     end;
    // end;
    
    // procedure SetVendor()
    // var
    //     Vendor: Record Vendor;
    //     VendorPostingGroup: Record "Vendor Posting Group";
    // begin 
    //     Vendor.SetRange(Name,Rec.Name);
    //     if Vendor.FindFirst() then begin
    //         Rec."Vendor No." := Vendor."No.";
    //         if VendorPostingGroup.Get(Vendor."Vendor Posting Group") then
    //             Rec."Bal. Account No." := VendorPostingGroup."Payables Account";
    //     end;
    // end;
    // procedure SetSubsidiary(); 
    // begin 
    //     case Rec.Subsidiary of
    //         ''    : Rec."Subsidiary Code" := '';
    //         'CAS' : Rec."Subsidiary Code" := '14-CALIF. SEAFOODS';
    //         'FSP' : Rec."Subsidiary Code" := '09-FALSE PASS';
    //         'KOD' : Rec."Subsidiary Code" := '11-KODIAK';
    //         'NAK' : Rec."Subsidiary Code" := '05-NAKNEK';
    //         'SBS' : Rec."Subsidiary Code" := '01-CORP';
    //         'SE'  : Rec."Subsidiary Code" := '13-SOUTHEAST';
    //         'VDZ' : Rec."Subsidiary Code" := '04-VALDEZ';
    //     end;
    // end;


    
    // procedure SetSite()
    // var
    //     SubsidiarySite: Record "OBF-Subsidiary Site";
    // begin
    //     case Rec.Site of
    //         '3050 Hilltop' : Rec."Site Code" := '210-CAL.HILLTOP';
    //         'California Seafoods' : Rec."Site Code" := '';
    //         'California Seafoods : Seal Control' : Rec."Site Code" := '220-CAL.SEAL_CONTROL ';
    //         'California Seafoods : California - Westport' : Rec."Site Code" := '';
    //         'California Seafoods : Ventura Boatyard'  : Rec."Site Code" := '270-CAL.VENTURA';
    //         'Corporate' : Rec."Site Code" := '010-CORPORATE';
    //         'Corporate : Seattle-Office' : Rec."Site Code" := '010-CORPORATE';
    //         'Craig Plant'  : Rec."Site Code" := '420-SBSE.CRAIG';
    //         'Craig Plant (New SE)' : Rec."Site Code" := '420-SBSE.CRAIG';
    //         'False Pass Plant' : Rec."Site Code" := '310-FP.FALSE_PATH';
    //         'False Pass Plant : FSP Store(s) : King Cove Store'  : Rec."Site Code" := '320-FP.KINGCOVE';
    //         'Fullerton' : Rec."Site Code" := '250-CAL.FULLERTON';
    //         'Kodiak ISA' : Rec."Site Code" := '350-KODIAK';
    //         'Kodiak Plant' : Rec."Site Code" := '350-KODIAK';
    //         'Naknek Plant' : Rec."Site Code" := '110-NAKNEK';
    //         'Naknek Plant : Westward Wind Tender'  : Rec."Site Code" := '120-NAKNEK.WSTWRDWND';
    //         'Naknek Plant : SBS Opportunity Tender'  : Rec."Site Code" := '140-NAKNEK.SBS_OPP';
    //         'Naknek Plant : Lady Kodiak Tender'  : Rec."Site Code" := '130-NAKNEK.LADYKOD';
    //         'Overhead (San Pedro Office)'  : Rec."Site Code" := '240-CAL.SAN_PEDRO';
    //         'Sitka Plant' : Rec."Site Code" := '410-SBSE.SITKA';
    //         'Sitka Plant (New SE)' : Rec."Site Code" := '410-SBSE.SITKA';
    //         'Valdez Plant' : Rec."Site Code" := '030-VALDEZ';
    //         'Wilmington' : Rec."Site Code" := '230-CAL.WILMINGTON';
    //     end;

    //     if ( Rec."Subsidiary Code" = '' ) and ( Rec."Site Code" <> '' ) then begin 
    //         SubsidiarySite.SetRange("Site Code",Rec."Site Code");
    //         if SubsidiarySite.FindFirst() then
    //             Rec."Subsidiary Code" := SubsidiarySite."Subsidiary Code";
    //     end;
    // end;

    // procedure SetPaymentTerms()
    // var
    //     PaymentTerms: Record "Payment Terms";
    // begin
    //     if Rec.Terms <> '' then begin 
    //         PaymentTerms.SetRange(Description,Rec.Terms);
    //         if PaymentTerms.FindFirst() then
    //             Rec."Payment Terms Code" := PaymentTerms.Code;
    //     end; 

    // end;

    // procedure SetItemNo()
    // var
    //     Item: Record Item;
    //     ItemNo: Code[20];
    // begin
    //     if Rec.Item = '' then
    //         exit;

    //     if Rec.Item = 'Partner Discount' then begin 
    //         Rec."Account No." := '4510';
    //         Rec."Account Description" := 'Sales Discount and Commision';
    //     end;

    //     if StrLen(Rec.Item)>10 then
    //         exit;

    //     ItemNo := 'S-'+Rec.Item;
    //     if Item.Get(ItemNo) then begin
    //         Rec."Item No." := ItemNo;
    //         Rec."Item Description" := Item.Description;
    //     end;

    // end;

    // procedure SetAccountNo()
    // var
    //     GLAccount: Record "G/L Account";
    //     GLAccountNo: Code[20];
    //     ColonPosition: Integer;
    //     Char5and6: Code[2];
    // begin
    //     if Rec.Account = '' then
    //         exit;

    //         ColonPosition := StrPos(Rec.Account,':');
    //         Char5and6 := CopyStr(Rec.Account,ColonPosition+5,2);
    //         Rec."Account No." := CopyStr(Rec.Account,ColonPosition+1,4);
    //         if Char5and6 = '-I' then begin 
    //             case Rec."Account No." of 
    //                 '1420' : Rec."Account No." := '1421';
    //                 '2500' : Rec."Account No." := '2501';
    //                 '4200' : Rec."Account No." := '4201';
    //                 '7010' : Rec."Account No." := '7011';
    //                 '7250' : Rec."Account No." := '7251';
    //                 '7260' : Rec."Account No." := '7261';
    //                 '8010' : Rec."Account No." := '8011';
    //             end;
    //         end;

    //     GLAccountNo := CopyStr(Rec.Account,1,4);
    //     case Rec.Account of 
    //         '32000 Opening Balance' : GLAccountNo := Rec."Bal. Account No.";
    //         'Partner Discount' : GLAccountNo := '4510';
    //     end;

    //     case GLAccountNo of 
    //         '4050' : GLAccountNo := '4510';
    //         '7400' : GLAccountNo := '7460';
    //     end;

    //     if GLAccount.Get(GLAccountNo) then begin
    //         Rec."Account No." := GLAccountNo;
    //         Rec."Account Description" := GLAccount.Name;
    //     end;

    // end;
    //     procedure FindSubsidiary(SubsidiaryText: Text[250]): Code[20]
    // var
    //     DimensionValue: Record "Dimension Value";
    //     SubsidiaryName: Text[24];
    // begin
    //     DimensionValue.SetRange("Dimension Code", 'SUBSIDIARY');
    //     SubsidiaryName := CopyStr(SubsidiaryText, 1, 24);
    //     DimensionValue.SetFilter(Name, STRSUBSTNO('%1*', SubsidiaryName));
    //     DimensionValue.SetRange(Blocked, false);
    //     if DimensionValue.Count > 1 then
    //         exit('*** MULTIPLE ***')
    //     else
    //         if DimensionValue.FindFirst() then
    //             exit(DimensionValue.Code)
    //         else
    //             exit('');
    // end;

    // procedure FindCustomer(CustomerText: Text[250]): Code[20]
    // var
    //     Customer: Record Customer;
    //     SubsidiaryName: Text[24];
    // begin
    //     Customer.SetRange(Name, CustomerText);
    //     if Customer.Count > 1 then
    //         exit('*** MULTIPLE ***')
    //     else
    //         if Customer.FindFirst() then
    //             exit(Customer."No.")
    //         else
    //             exit('');
    // end;

    // procedure FindVendor(VendorText: Text[250]): Code[20]
    // var
    //     Vendor: Record Vendor;
    //     SpacePosition: Integer;
    //     Name2: Text[50];
    //     Name2Length: Integer;
    // begin
    //     SpacePosition := StrPos(VendorText, ' ');
    //     if SpacePosition = 0 then
    //         SpacePosition := StrLen(VendorText)+1;
    //     if SpacePosition < 8 then
    //         error('Vendor not found in VendorText %1', VendorText);
    //     Name2Length := SpacePosition - 8;
    //     Name2 := CopyStr(VendorText, 8, Name2Length);
    //     Vendor.Reset();
    //     Vendor.SetRange("Name 2", Name2);
    //     if Vendor.Count > 1 then
    //         exit('*** MULTIPLE ***')
    //     else
    //         if Vendor.FindFirst() then
    //             exit(Vendor."No.")
    //         else begin 
    //             Vendor.Reset();
    //             Vendor.SetRange(Name, VendorText);
    //             if Vendor.Count > 1 then
    //                 exit('*** MULTIPLE ***')
    //             else
    //                 if Vendor.FindFirst() then
    //                     exit(Vendor."No.")
    //                 else
    //                     exit('');
    //         end;
    // end;   
}