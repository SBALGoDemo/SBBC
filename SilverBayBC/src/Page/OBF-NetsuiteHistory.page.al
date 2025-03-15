// // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1670 - Importing Historical Transactions - For initial import
// page 50035 "OBF-Netsuite History List"
// {
//     Caption = 'Netsuite History List';
//     PageType = List;
//     UsageCategory = Lists;
//     ApplicationArea = All;
//     SourceTable = "OBF-Netsuite History";
    
//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field("Line No.";Rec."Line No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Document Type";Rec."Document Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Posting Date";Rec."Posting Date")
//                 {
//                     ApplicationArea = All;
//                 }     
//                 field("Document Number";Rec."Document Number")  
//                 {
//                     ApplicationArea = All;
//                 }         
//                 field(Name;Rec.Name)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Customer No.";Rec."Customer No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Vendor No.";Rec."Vendor No.")
//                 {
//                     ApplicationArea = All;
//                 }                
//                 field("Bal. Account No.";Rec."Bal. Account No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Subsidiary;Rec.Subsidiary)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Subsidiary Code";Rec."Subsidiary Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Subsidiary Name";Rec."Subsidiary Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Site;Rec.Site)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Site Code";Rec."Site Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Site Name";Rec."Site Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Item;Rec.Item)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Item No.";Rec."Item No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Item Description";Rec."Item Description")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Account;Rec.Account)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Account No.";Rec."Account No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Account Description";Rec."Account Description")
//                 {
//                     ApplicationArea = All;
//                 } 
//                 field(Quantity;Rec.Quantity)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Amount;Rec.Amount)
//                 {
//                     ApplicationArea = All;
//                 }                          
//             }
//         }
//         area(Factboxes)
//         {
            
//         }
//     }
    
//     actions
//     {
//         area(Processing)
//         {
//             action(MainLoop)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Main Loop';
                
//                 trigger OnAction();
//                 begin
//                     Rec.MainLoop();
//                 end;
//             }
//             action(CreateNetsuiteSalesInvoices)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Create Netsuite Sales Invoices';
                
//                 trigger OnAction();
//                 begin
//                     Rec.CopyToNetsuiteSalesInvoice();
//                 end;
//             }
//             action(CreateNetsuitePurchaseInvoices)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Create Netsuite Purchase Invoices';
                
//                 trigger OnAction();
//                 begin
//                     Rec.CopyToNetsuitePurchaseInvoice();
//                 end;
//             }
//         }
//     }
// }
