// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
pageextension 50028 "OBF-Sales Credit Memo" extends "Sales Credit Memo"  
{
  layout
  {
    addafter(Status)
    {
      field("OBF-Bypass Rebate Calculation";Rec."OBF-Bypass Rebate Calculation")
      {
        ApplicationArea = all;
      }
     
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    addafter(SalesDocCheckFactbox)
    {
        part(SalesDocRebateFactbox; "OBF-Sales Doc. Rebate FactBox")
        {
            SubPageLink = "Document Type" = FIELD("Document Type"),
                          "No." = FIELD("No.");
            Visible = true;
            ApplicationArea = all;
            Caption = 'Rebate';
        }
    }
  }

  actions
  {
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    addafter(CFDIRelationDocuments)
    {
        action("Page OBF-Rebate Entries")
        {
            Image = DepositLines;
            Caption = 'Rebate Entries';
            ApplicationArea = all;  
            trigger OnAction()
            var
                RebateEntries: Page "OBF-Rebate Entries";
                RebateEntry: Record "OBF-Rebate Entry";
            begin
                RebateEntry.SetRange("Source Type", Rec."Document Type");
                RebateEntry.SetRange("Source No.", Rec."No.");
                RebateEntries.SetTableView(RebateEntry);
                RebateEntries.SetSalesHeader(Rec);
                RebateEntries.RunModal();
            end;
        }
    }
  }
}