// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 50005 "OBF-Sales Header" extends "Sales Header"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1655 - Need "Point of Title Transfer" address on Sales Invoices
        field(50000; "OBF-FOB Location"; Code[20])
        {
            Caption = 'Point of Title Transfer';
            TableRelation = "OBF-FOB Location";
            DataClassification = CustomerContent;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        field(50002; "OBF-MSC Certification"; Boolean)
        {
            Caption = 'MSC Certification';
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "OBF-MSC Certification" = const(true)));
            Editable = false;
        }
        field(50003; "OBF-RFM Certification"; Boolean)
        {
            Caption = 'RFM Certification';
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "OBF-RFM Certification" = const(true)));
            Editable = false;
        }
        field(50004; "OBF-Certification Text"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Certification Text';
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
        field(50005; "OBF-Header Summary Line 1"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Header Summary Line';
            Editable = false;
        }
        field(50006; "OBF-Header Summary Line 2"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Header Summary Line 2';
            Editable = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
        field(51004; "OBF-Add-on POs Exist"; Boolean)
        {
            CaptionML = ENU = 'Add-on POs Exist';
            FieldClass = FlowField;
            CalcFormula = exist("Item Charge Assignment (Purch)" where("Applies-to Doc. Type" = const("Sales Order"),
                                                                                 "Applies-to Doc. No." = field("No.")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
        field(51020; "OBF-PO Acknowledgement (855)"; Boolean)
        {
            Caption = 'PO Acknowledgement (855)';
        }
        field(51021; "OBF-PO Acknowledgement Note"; enum "OBF-PO Acknowledgement Note")
        {
            Caption = 'PO Acknowledgement Note';
            Editable = false;
        }
        field(51017; "OBF-PO Ack. (855) Transmitted"; Boolean)
        {
            Caption = 'PO Ack. (855) Transmitted';
        }
        field(51018; "OBF-Revision No. (855)"; Integer)
        {
            Caption = 'Revision No. (855)';
        }
        field(51022; "OBF-PO Inbound Change (860)"; Boolean)
        {
            Caption = 'PO Inbound Change (860)';
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }
        field(51023; "OBF-Whse. Sh. Rel. (940)"; Boolean)
        {
            Caption = 'Whse. Shipping Release (940)';
        }
        field(51024; "OBF-Whse. Sh. Rel. Note"; Option)
        {
            Caption = 'Whse. Shipping Release Note';
            OptionCaption = '" ,*** Shipping Release has not been sent ***,*** Shipping Release has been sent ***,*** Shipping Release is pending ***,*** Shipping Release Revision is pending ***,*** Shipping Release Cancellation is pending *** "';
            OptionMembers = " ","*** Shipping Release has not been sent ***","*** Shipping Release has been sent ***","*** Shipping Release is pending ***","*** Shipping Release Revision is pending ***","*** Shipping Release Cancellation is pending ***";
            Editable = false;
        }
        field(51025; "OBF-Customer EDI Enabled"; Boolean)
        {
            Caption = 'EDI Customer';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."OBF-EDI Enabled" where("No." = field("Sell-to Customer No.")));
            Editable = false;
        }
        field(51026; "OBF-Location EDI Enabled"; Boolean)
        {
            Caption = 'EDI Location';
            FieldClass = FlowField;
            CalcFormula = Lookup(Location."OBF-EDI Enabled" where(Code = field("Location Code")));
            Editable = false;
        }
        field(51028; "OBF-Multiple Locations"; Boolean)
        {
            Caption = 'Multiple Locations';
            Editable = false;
        }
        field(51030; "OBF-Bypass 940 Release Check"; Boolean)
        {
            Caption = 'Bypass 940 Release Check';
        }
        field(51034; "OBF-Release Pending (940)"; Boolean)
        {
            Caption = 'Release Pending (940)';
        }
        field(51035; "OBF-Revision Pending (940)"; Boolean)
        {
            Caption = 'Revision Pending (940)';
        }
        field(51036; "OBF-Cancellation Pending (940)"; Boolean)
        {
            Caption = 'Cancellation Pending (940)';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(52000; "OBF-Workflow Step No."; Integer)
        {
            Caption = 'Workflow Step No.';
            TableRelation = "OBF-SO Workflow Step"."Step No." where("Sales Order No." = field("No."));
            Editable = false;
            trigger OnValidate();
            begin
                UpdateWorkflowStep("OBF-Workflow Step No.");
            end;
        }
        field(52001; "OBF-Workflow Step Description"; Text[30])
        {
            Caption = 'Workflow Step Description';
            Editable = false;
        }
        field(52002; "OBF-W. Step Assigned to User"; Code[50])
        {
            Caption = 'Workflow Step Assigned to User';
            TableRelation = "User Setup";
            Editable = false;
        }
        field(52003; "OBF-Assigned Traffic Person"; Code[50])
        {
            Caption = 'Assigned Traffic Person';
            TableRelation = "Workflow User Group Member"."User Name" WHERE("Workflow User Group Code" = CONST('TRAFFIC'));

            trigger OnValidate();
            var
                SOWorkflowStep: Record "OBF-SO Workflow Step";
            begin
                if (Rec."OBF-Workflow Step No." > 0) then
                    Rec.TestField("OBF-Assigned Traffic Person");
                SOWorkflowStep.SetRange("Sales Order No.", Rec."No.");
                SOWorkflowStep.SetRange("Assigned to Type", SOWorkflowStep."Assigned to Type"::"Individual User");
                SOWorkflowStep.SetRange("Assigned to W. User Group", 'TRAFFIC');
                SOWorkflowStep.SetRange(Completed, false);
                SOWorkflowStep.ModifyAll("Assigned to User", Rec."OBF-Assigned Traffic Person");
                SOWorkflowStep.ModifyAll("Assigned to User Name", SOWorkflowStep.GetUserName(Rec."OBF-Assigned Traffic Person"))
            end;
        }
        field(52006; "OBF-Workflow Step Acknowledged"; Boolean)
        {
            Caption = 'Workflow Step Acknowledged';
            Editable = false;
        }
        field(52008; "OBF-W. Step Ass. to User Name"; Code[50])
        {
            Caption = 'Workflow Step Assigned to User Name';
            Editable = false;
        }
        field(52010; "OBF-No. of Revisions"; Integer)
        {
            Caption = 'No. of Revisions';
            Editable = false;
        }
        field(52011; "OBF-Workflow Salesperson Code"; Code[20])
        {
            Caption = 'Workflow Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate();
            var
                SOWorkflowStep: Record "OBF-SO Workflow Step";
                SalespersonUserID: Code[50];
                MissingSalespersonMessageSent: Boolean;
            begin
                if (Rec."OBF-Workflow Step No." > 0) then
                    Rec.TestField("OBF-Workflow Salesperson Code");
                SalespersonUserID := SOWorkflowStep.GetUserForSalesperson("OBF-Workflow Salesperson Code", MissingSalespersonMessageSent);
                SOWorkflowStep.SetRange("Sales Order No.", Rec."No.");
                SOWorkflowStep.SetRange("Assigned to Type", SOWorkflowStep."Assigned to Type"::"Individual User");
                SOWorkflowStep.SetRange("Assigned to W. User Group", 'SALES');
                SOWorkflowStep.SetRange(Completed, false);
                SOWorkflowStep.ModifyAll("Assigned to User", SalespersonUserID);
                SOWorkflowStep.ModifyAll("Assigned to User Name", SOWorkflowStep.GetUserName(SalespersonUserID));
            end;
        }
        field(52013; "OBF-Submittal Timestamp"; DateTime)
        {
            Caption = 'Submittal Timestamp';
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(53000; "OBF-Off Invoice Rebate Total"; Decimal)
        {
            Caption = 'Off-Invoice Rebate Total';
            CalcFormula = Sum("OBF-Rebate Entry"."Rebate Amount"
            where("Source Type" = field("Document Type"),
                    "Source No." = field("No."),
                    "Rebate Type" = const("Off-Invoice")));
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53001; "OBF-Accrual Rebate Total"; Decimal)
        {
            Caption = 'Accrual Rebate Total';
            CalcFormula = Sum("OBF-Rebate Entry"."Rebate Amount"
            where("Source Type" = field("Document Type"),
                    "Source No." = field("No."),
                    "Rebate Type" = const(Accrual)));
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53002; "OBF-Bypass Rebate Calculation"; Boolean)
        {
            Caption = 'Bypass Rebate Calculation';
        }


        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                Rec."Your Reference" := Rec."No.";
            end;
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

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
        modify("Your Reference")
        {
            Caption = 'Invoice No. to Print';
            trigger OnAfterValidate()
            begin
                Rec.TestField("Your Reference");
            end;
        }

        modify("External Document No.")
        {
            Caption = 'Customer PO';
        }

    }

    local procedure RemoveSubDimensionsFromLines()
    var
        SubDimension: Codeunit "OBF-Sub Dimension";
        SalesLine: Record "Sales Line";
        SiteCodeMessage: Label 'The Site Code Dimension was cleared for all Sales Lines.';
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then begin
            Message(SiteCodeMessage);
            repeat
                SubDimension.RemoveSubDimensionsFromDimSetID(SalesLine."Dimension Set ID");
                SalesLine."OBF-Site Code" := '';
                SalesLine.Modify();
            until (SalesLine.Next() = 0);
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
    procedure PrepareToPrint()
    begin
        Rec.CopyVansToSalesLine();
        Rec.SetCertificationText();
        Rec.CreateHeaderSummaryLines();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
    procedure SetCertificationText()
    var
        Certification: Record "OBF-Certification";
        CertificationText: Text[100];
    begin
        CertificationText := '';
        Rec.CalcFields("OBF-MSC Certification", "OBF-RFM Certification");
        if Rec."OBF-MSC Certification" then
            CertificationText := CertificationTextForCode('MSC') + '    ';
        if Rec."OBF-RFM Certification" then
            CertificationText += CertificationTextForCode('RFM');
        if Rec."OBF-Certification Text" <> CertificationText then begin
            Rec."OBF-Certification Text" := CertificationText;
            Rec.Modify();
        end;

        CopyCertificationTextToSalesLineComment();

    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
    procedure CopyCertificationTextToSalesLineComment()
    var
        SalesLine: Record "Sales Line";
        SeparatorLineText: Label '-----------';
        LineNo: Integer;
    begin
        Rec.TestField("No.");

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("OBF-Is Certification Info Line", true);
        if not SalesLine.IsEmpty then
            SalesLine.DeleteAll();

        if Rec."OBF-Certification Text" = '' then
            exit;

        SalesLine.SetRange("OBF-Is Certification Info Line");
        SalesLine.FindLast();
        LineNo := SalesLine."Line No.";

        SalesLine.Init();
        LineNo += 10000;
        SalesLine."Line No." := LineNo;
        SalesLine.Type := SalesLine.Type::" ";
        SalesLine.Description := SeparatorLineText;
        SalesLine."OBF-Is Certification Info Line" := true;
        SalesLine.Insert();

        SalesLine.Init();
        LineNo += 10000;
        SalesLine."Line No." := LineNo;
        SalesLine.Type := SalesLine.Type::" ";
        SalesLine.Description := Rec."OBF-Certification Text";
        SalesLine."OBF-Is Certification Info Line" := true;
        SalesLine.Insert();
    end;

    local procedure CertificationTextForCode(CertificationCode: Code[20]): Text
    var
        Certification: Record "OBF-Certification";
    begin
        Certification.Get(CertificationCode);
        exit(Certification.Code + ': ' + Certification.Name);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1627 - Including Van Numbers on Invoices
    procedure ShowVanList()
    var
        SalesHeaderVan: Record "OBF-SalesHeader Van";
        SalesHeaderVanList: Page "OBF-Sales Header Van List";
    begin
        SalesHeaderVan.SetRange("Document Type", Rec."Document Type");
        SalesHeaderVan.SetRange("Document No.", Rec."No.");
        SalesHeaderVanList.SetTableView(SalesHeaderVan);
        SalesHeaderVanList.RunModal();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
    procedure CreateHeaderSummaryLines()
    var
        PaymentTerms: Record "Payment Terms";
        FOBLocation: Record "OBF-FOB Location";
        Spaces: Label '              ';
    begin
        if Rec."Payment Terms Code" <> '' then
            PaymentTerms.Get(Rec."Payment Terms Code");
        if Rec."OBF-FOB Location" <> '' then
            FOBLocation.Get(Rec."OBF-FOB Location");
        Rec.TestField("Shipment Method Code");
        Rec."OBF-Header Summary Line 1" := 'Terms: ' + PaymentTerms.Description + Spaces
            + 'Due Date: ' + format(Rec."Due Date") + Spaces
            + 'PO #: ' + Rec."External Document No." + Spaces
            + Rec."Shipment Method Code" + ': ' + FOBLocation.Description;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts    
    procedure CopyVansToSalesLine()
    var
        SalesHeaderVan: Record "OBF-SalesHeader Van";
        SalesLine: Record "Sales Line";
        SeparatorLineText: Label '-----------';
        LineNo: Integer;
        NumLinesAdded: Integer;
    begin
        SalesHeaderVan.SetRange("Document Type", Rec."Document Type");
        SalesHeaderVan.SetRange("Document No.", Rec."No.");
        if not SalesHeaderVan.FindSet() then
            exit;

        DeleteVansFromSalesLines();

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.FindLast();
        LineNo := SalesLine."Line No.";

        SalesLine.Init();
        LineNo += 10000;
        SalesLine."Line No." := LineNo;
        SalesLine.Type := SalesLine.Type::" ";
        SalesLine.Description := SeparatorLineText;
        SalesLine."OBF-Is Van Info Line" := true;
        SalesLine.Insert();

        repeat
            SalesLine.Init();
            LineNo += 10000;
            SalesLine."Line No." := LineNo;
            SalesLine.Type := SalesLine.Type::" ";
            SalesLine.Description := 'VAN: ' + SalesHeaderVan."Van No.";
            SalesLine."OBF-Is Van Info Line" := true;
            SalesLine.Insert();
            NumLinesAdded += 1;
        until (SalesHeaderVan.Next() = 0);
    end;

    procedure DeleteVansFromSalesLines()
    var
        SalesHeaderVan: Record "OBF-SalesHeader Van";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        LineCount: Integer;
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("OBF-Is Van Info Line", true);
        LineCount := SalesLine.Count;
        if LineCount > 0 then begin
            SalesLine.DeleteAll();
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
    procedure CheckIfOrderIsFullyAllocated(): Boolean;
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        FullyAllocated: Boolean;
    begin
        FullyAllocated := true;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("OBF-Item Type", SalesLine."OBF-Item Type"::Inventory);
        SalesLine.SetFilter("OBF-Item Tracking Code", '<>%1', '');
        SalesLine.SetFilter(Quantity, '>0');
        if SalesLine.FindSet then
            repeat
                SalesLine.GetLotNoAndAllocatedQty(SalesLine);
                if SalesLine."OBF-Allocated Quantity" < SalesLine.Quantity then
                    FullyAllocated := false;
            until (SalesLine.Next = 0);
        exit(FullyAllocated);
    end;

    procedure AcknowledgeCurrentStep();
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        Rec.TestField("OBF-Workflow Step Acknowledged", false);
        SOWorkflowStep.Get(Rec."No.", Rec."OBF-Workflow Step No.");
        SOWorkflowStep.CalcFields("Assigned to Type");
        if SOWorkflowStep."Assigned to Type" = SOWorkflowStep."Assigned to Type"::"Individual User" then
            Rec.TestField("OBF-W. Step Assigned to User", UserId);
        Rec."OBF-Workflow Step Acknowledged" := true;
        Rec.Modify(false);
    end;

    procedure UpdateWorkflowStep(NewWorkflowStep: Integer);
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        if NewWorkflowStep = 0 then begin
            Rec."OBF-Workflow Step Description" := '';
            Rec."OBF-W. Step Assigned to User" := '';
            Rec."OBF-W. Step Ass. to User Name" := '';
        end else begin
            SOWorkflowStep.Get(Rec."No.", NewWorkflowStep);
            SOWorkflowStep.TestField(Completed, false);
            Rec."OBF-Workflow Step Description" := SOWorkflowStep.Description;
            Rec."OBF-W. Step Assigned to User" := SOWorkflowStep."Assigned to User";
            Rec."OBF-W. Step Ass. to User Name" := SOWorkflowStep."Assigned to User Name";
        end;
    end;

    procedure ChangeWorkflowStep();
    var
        NextStep: Record "OBF-SO Workflow Step";
        PreviousStepAssignedTo: code[50];
        NextStepNo: Integer;
    begin
        CheckIfSubmitOrderToShippingStep(Rec."OBF-Workflow Step No.");
        NextStep.CheckUserAllowedToEdit;
        NextStepNo := NextStep.LookupNextStep(Rec."No.", Rec."OBF-Workflow Step No.");
        NextStep.Get(Rec."No.", NextStepNo);
        PreviousStepAssignedTo := Rec."OBF-W. Step Assigned to User";
        Rec.Validate("OBF-Workflow Step No.", NextStepNo);
        if Rec."OBF-W. Step Assigned to User" <> PreviousStepAssignedTo then
            Rec."OBF-Workflow Step Acknowledged" := false;
        Rec.Modify(false);
    end;

    procedure CompleteCurrentStep();
    var
        SOWorkflowStep: Record "OBF-SO Workflow Step";
    begin
        CheckIfSubmitOrderToShippingStep(Rec."OBF-Workflow Step No.");

        SOWorkflowStep.Get(Rec."No.", Rec."OBF-Workflow Step No.");
        SOWorkflowStep.CompleteStep(false);
        SOWorkflowStep.Modify;
    end;

    procedure CheckIfSubmitOrderToShippingStep(StepNo: Integer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if StepNo = SalesSetup."OBF-Submit to Shipping Step" then
            Error('The Sales Order must be resubmitted to Shipping.');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - Copy EDI Fields and Code from Orca Bay to Silver Bay   
    procedure SetPOAckNote();
    begin
        SelectLatestVersion;
        CalcFields("OBF-Customer EDI Enabled");
        if ("Sell-to Customer No." = '') or not "OBF-Customer EDI Enabled" then begin
            "OBF-PO Acknowledgement Note" := "OBF-PO Acknowledgement Note"::" ";
            exit;
        end;
        if "OBF-PO Acknowledgement (855)" then
            "OBF-PO Acknowledgement Note" := "OBF-PO Acknowledgement Note"::"*** Acknowledgement Sent ***"
        else if "OBF-PO Ack. (855) Transmitted" then
            "OBF-PO Acknowledgement Note" := "OBF-PO Acknowledgement Note"::"*** Acknowledgement Transmitted ***"
        else
            "OBF-PO Acknowledgement Note" := "OBF-PO Acknowledgement Note"::"*** This Order has not been confirmed ***";
    end;

    procedure SetWhseShippingReleaseNote();
    begin
        SelectLatestVersion;
        CalcFields("OBF-Location EDI Enabled");
        if ("Location Code" = '') or not "OBF-Location EDI Enabled" then begin
            "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::" ";
            exit;
        end;
        if "OBF-Release Pending (940)" then
            "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::"*** Shipping Release is pending ***"
        else
            if "OBF-Cancellation Pending (940)" then
                "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::"*** Shipping Release Cancellation is pending ***"
            else
                if "OBF-Revision Pending (940)" then
                    "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::"*** Shipping Release Revision is pending ***"
                else
                    if "OBF-Whse. Sh. Rel. (940)" then
                        "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::"*** Shipping Release has been sent ***"
                    else
                        "OBF-Whse. Sh. Rel. Note" := "OBF-Whse. Sh. Rel. Note"::"*** Shipping Release has not been sent ***"

    end;

    procedure CheckIf940ReleaseFlagIsSet()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if Rec."OBF-Bypass 940 Release Check" then
            exit;

        SalesSetup.Get();
        if Rec."OBF-Workflow Step No." = SalesSetup."OBF-Shipping Release Step" then begin
            Rec.CalcFields("OBF-Location EDI Enabled");
            if Rec."OBF-Location EDI Enabled" then begin
                if not Rec."OBF-Whse. Sh. Rel. (940)" then
                    if not Rec."OBF-Release Pending (940)" then
                        Error('You must send the Shipping Release (940) before completing this step');
            end
        end;
    end;

    procedure PrintShippingRelease();
    var
        SalesHeader: Record "Sales Header";
        ShippingRelease: Report "OBF-Shipping Release";
    begin
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."No.");
        ShippingRelease.SetTableView(SalesHeader);
        ShippingRelease.Run;
    end;

    procedure SendPOAck(var SalesHeader: Record "Sales Header");
    begin
        SalesHeader.CalcFields("OBF-Customer EDI Enabled");
        SalesHeader.TestField("OBF-Customer EDI Enabled", true);
        if "OBF-Customer EDI Enabled" then begin
            if not SalesHeader.CheckIfOrderIsFullyAllocated then
                error('This order is not fully allocated.');
            SalesHeader."OBF-PO Acknowledgement (855)" := true;
            SalesHeader."OBF-PO Ack. (855) Transmitted" := false;
            SalesHeader.SetPOAckNote;
        end;
    end;

    procedure SendShippingReleaseViaEDI(var SalesHeader: Record "Sales Header");
    var
        UserSetup: Record "User Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingRelease940WasSent: Boolean;
        EnterOrderCommentCancelled: Boolean;
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("OBF-Allow Send Sh. Release");
        SalesHeader.TestField("Location Code");
        SalesHeader.CalcFields("OBF-Location EDI Enabled");
        SalesHeader.TestField("OBF-Location EDI Enabled", true);
        SalesHeader.TestField("Shipping Agent Code");
        if not SalesHeader.CheckIfOrderIsFullyAllocated then
            error('This order is not fully allocated.');
        SalesSetup.Get;
        SalesHeader.TestField("OBF-Workflow Step No.", SalesSetup."OBF-Shipping Release Step");
        if SalesSetup."OBF-Req. Ext. Doc. for 940" then
            SalesHeader.TestField("External Document No.");
        if SalesHeader."OBF-Release Pending (940)" then
            Error('"Release Pending (940)" is already set to true');
        if SalesHeader."OBF-Revision Pending (940)" then
            Error('"Revision Pending (940)" is already set to true');
        SalesHeader.TestField("OBF-Cancellation Pending (940)", false);
        ShippingRelease940WasSent := SalesHeader."OBF-Whse. Sh. Rel. (940)";
        if ShippingRelease940WasSent then
            SalesHeader."OBF-Revision Pending (940)" := true
        else
            SalesHeader."OBF-Release Pending (940)" := true;
        SalesHeader.SetWhseShippingReleaseNote;
        Commit();
        Sleep(500);
        Message('The Shipping Release Status is %1', SalesHeader."OBF-Whse. Sh. Rel. Note");
    end;

    procedure CancelShippingRelease(var SalesHeader: Record "Sales Header");
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("OBF-Allow Send Sh. Release");
        SalesHeader.CalcFields("OBF-Location EDI Enabled");
        SalesHeader.TestField("OBF-Location EDI Enabled", true);
        SalesHeader.TestField("OBF-Whse. Sh. Rel. (940)", true);
        SalesHeader.TestField("OBF-Cancellation Pending (940)", false);
        SalesHeader.TestField("OBF-Revision Pending (940)", false);
        SalesHeader."OBF-Cancellation Pending (940)" := true;
        SalesHeader."OBF-Whse. Sh. Rel. Note" := SalesHeader."OBF-Whse. Sh. Rel. Note"::"*** Shipping Release Cancellation is pending ***";
        Message('The Shipping Release Status is %1', SalesHeader."OBF-Whse. Sh. Rel. Note");
        SalesHeader.Modify(false);
    end;

    procedure SimulatePOAckTransmitted(var SalesHeader: Record "Sales Header");
    begin
        if (UserId <> 'JOSEPHG') and (UserId <> 'MATTT') then
            Error('User %1 is not permitted to use this Simulate PO Ack Transmitted action', UserId);

        if (not SalesHeader."OBF-PO Acknowledgement (855)") or (SalesHeader."OBF-PO Ack. (855) Transmitted") then
            Error('This Sales Order is not in a state to simulate transmitting the PO Acknowledgement');

        SalesHeader."OBF-PO Acknowledgement (855)" := false;
        SalesHeader."OBF-PO Ack. (855) Transmitted" := true;
        SalesHeader."OBF-Revision No. (855)" += 1;
        Message('The PO Ack. (855) transmission was simulated');
    end;

    procedure SimulateSPSProcessShippingReleasePending()
    begin
        Rec.TestField("OBF-Whse. Sh. Rel. (940)", false);
        Rec.TestField("OBF-Release Pending (940)", true);
        Rec."OBF-Whse. Sh. Rel. (940)" := true;
        Rec."OBF-Release Pending (940)" := false;
        Message('Simulated Process Shipping Release Pending Completed');
    end;

    procedure SimulateSPSCancelShippingReleasePending()
    begin
        Rec.TestField("OBF-Cancellation Pending (940)", true);
        Rec."OBF-Whse. Sh. Rel. (940)" := false;
        Rec."OBF-Cancellation Pending (940)" := false;
        Message('Simulated Cancel Shipping Release Pending Completed');
    end;

    procedure SimulateSPSRevisionPending()
    begin
        Rec.TestField("OBF-Revision Pending (940)", true);
        Rec."OBF-Revision Pending (940)" := false;
        Rec."OBF-Whse. Sh. Rel. (940)" := true;
        Message('Simulated Process Revision Pending Completed');
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1956 - Migrate Shipping Release report to Silver Bay
    procedure RunReport_ShippingRelease()
    var
        SalesHeader: Record "Sales Header";
        ShippingRelease: Report "OBF-Shipping Release";
    begin
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."No.");
        ShippingRelease.SetTableView(SalesHeader);
        ShippingRelease.RunModal();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1989 - Migrate Orca Bay Item Charge Assignment modifications to Silver Bay   
    procedure ShowPurchaseOrdersAllocatedAgainstSalesOrder(SalesHeader: Record "Sales Header");
    var
        AddOnPurchaseOrders: Page "OBF-Add-on Purchase Orders";
    begin
        AddOnPurchaseOrders.SetSalesOrder(SalesHeader);
        AddOnPurchaseOrders.RunModal();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1992 - Add Zetadocs Delivery Plus functionality to Silver Bay
    procedure OBF_SendOrderConfirmation();
    // This functions uses the Zetadocs Send functionality to add the Order Confirmation
    // to the Zetadocs Documents Factbox.  It can also be used to email the Order Confirmation
    // to one or more Customer email addresses based on the Zetadocs Customer Rules
    var
        ZdServerSend: Codeunit "Zetadocs Server Send";
        ZdCommon: Codeunit "Zetadocs Common";
        SalesEvents: Codeunit "OBF-Sales Events";
        ZdReportSelections: Record "Report Selections";
        SalesSetup: Record "Sales & Receivables Setup";
        ZdRecRef: RecordRef;
        ZdReportId: Integer;
    begin
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1331 - Periodic Zetadocs Lockup Issue
        SalesEvents.DeleteItemSalesLineWithQuantityZero(Rec);

        SalesSetup.Get;
        SalesEvents.AutoCreateCustRuleForDocSet(Rec."Sell-to Customer No.", SalesSetup."OBF-Doc. Set for Order Conf.", true);
        ZdRecRef.GetTable(Rec);
        ZdCommon.FindSelectionReportId(ZdReportSelections.Usage::"S.Order", ZdReportId);
        ZdServerSend.SendViaZetadocs(ZdRecRef, ZdReportId, '', true);
    end;

    procedure OBF_SendShippingReleaseToFactbox();
    // This function uses the Zetadocs Send functionality to add the Shipping Release
    // to the Zetadocs Documents Factbox.
    var
        ZdServerSend: Codeunit "Zetadocs Server Send";
        ZdCommon: Codeunit "Zetadocs Common";
        SalesEvents: Codeunit "OBF-Sales Events";
        ZdReportSelections: Record "Report Selections";
        SalesSetup: Record "Sales & Receivables Setup";
        ZdRecRef: RecordRef;
        ZdReportId: Integer;
        ZdDocumentCategory: Option "Assembly Header","Custom Usage","Purchase Header","Purchase Header Archive","Sales Header","Sales Header Archive","Sales Order Usage","Service Header","Service Contract Header";
    begin
        SalesSetup.Get;
        SalesEvents.AutoCreateCustRuleForDocSet(Rec."Sell-to Customer No.", SalesSetup."OBF-Doc. Set for Shipping Rel.", false);
        ZdRecRef.GetTable(Rec);
        ZdCommon.FindSelectionReportId(ZdReportSelections.Usage::"S.Order Pick Instruction", ZdReportId);
        ZdServerSend.SendViaZetadocs(ZdRecRef, ZdReportId, '', true);
    end;

}
