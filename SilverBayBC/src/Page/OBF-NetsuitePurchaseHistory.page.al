// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions 
page 50029 "OBF-Netsuite Purchase History"
{
    PageType = List;
    UsageCategory = History;
    AutoSplitKey = true;
    Caption = 'Netsuite Purchase History';
    Editable = false;
    LinksAllowed = false;
    SourceTable = "OBF-Netsuite Purch Inv. Line";
    SourceTableView = sorting("Vendor No.")
                    order(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor No.";Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor Name";Rec."Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type";Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No.";Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No.";Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity;Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price";Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount;Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subsidiary Code";Rec."Subsidiary Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Site Code";Rec."Site Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SetData)
            {
                Caption = 'Set Data';
                Image = SetPriorities;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                begin
                    Rec.SetAdditionalFields();                  
                end; 
            }
        }
    }
}