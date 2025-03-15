// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1651 -Multi Entity Accounting addon 
// page 50055 "OBF-MEM Intercompany Setup"
// {
//     Caption = 'OBF-MEM Intercompany Setup';
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = BssiMEMIntercompanySetup;
//     Editable = false;

//     layout
//     {
//         area(Content)
//         {
//             Repeater(MEM_Intercompany_Setup)
//             {
//                 field(BssiOriginEntityID;Rec.BssiOriginEntityID)
//                 {
//                     ApplicationArea = All;                   
//                 }
//                 field(BssiDestinationEntityId;Rec.BssiDestinationEntityId)
//                 {
//                     ApplicationArea = All;                   
//                 }
//                 field(BssiOriginDueToActCode;Rec.BssiOriginDueToActCode)
//                 {
//                     ApplicationArea = All;                   
//                 }
//                 field(BssiOriginDueFromActCode;Rec.	BssiOriginDueFromActCode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(BssiDestinationDueToActCode; Rec.BssiDestinationDueToActCode)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(BssiDestinationDueFromActCode; Rec.BssiDestinationDueFromActCode)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Caption = 'MEM Intercompany Setup Card';             
//                 trigger OnAction()
//                 var
//                     BssiMEMInterCompanySetupCard: Page BssiMEMInterCompanySetupCard;
//                 begin
//                     BssiMEMInterCompanySetupCard.RunModal();              
//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }