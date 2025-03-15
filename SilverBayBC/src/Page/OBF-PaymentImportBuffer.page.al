// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1727 - Payment Imports
page 50045 "OBF-Payment Import Buffer"
{
    Caption = 'Payment Import Buffer';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "OBF-Payment Import Buffer";
    AutoSplitKey = true;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Reference No.";Rec."Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Our Account No.";Rec."Our Account No.") 
                {
                    ApplicationArea = All;
                }
                field("Vendor No.";Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name";Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field(Amount;Rec.Amount) 
                {
                    ApplicationArea = All;
                }
                field("Subsidiary Text";Rec."Subsidiary Text") 
                {
                    ApplicationArea = All;
                }
                field("Subsidiary Code";Rec."Subsidiary Code")
                {
                    ApplicationArea = All;
                } 
                field(Memo;Rec.Memo)
                {
                    ApplicationArea = All;
                }
                field("G/L Account No.";Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account Name";Rec."G/L Account Name") 
                {
                    ApplicationArea = All;
                }
                field("Document Type";Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No.";Rec."Document No.")
                {
                    ApplicationArea = All;
                }                                                                                            
            }
        }

    }
    
    actions
    {
        area(Processing)
        {
            action(MainLoop)
            {
                ApplicationArea = All;
                Caption = 'Main Loop';
                
                trigger OnAction();
                begin
                   Rec.MainLoop(); 
                end;
            }
            action(CreateGLJournalLoop)
            {
                ApplicationArea = All;
                Caption = 'Create GL Journal Loop';
                
                trigger OnAction();
                begin
                   Rec.CreateGenJournalLines('NORTHSCOPE'); 
                end;
            }

        }
    }
}
