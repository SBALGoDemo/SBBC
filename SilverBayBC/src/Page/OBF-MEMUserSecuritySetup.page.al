// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1651 -Multi Entity Accounting addon 
page 50056 "OBF-MEM User Security Setup"
{
    Caption = 'OBF-MEM User Security Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 	BssiMEMUserSecurity;
    Editable = false;
    
    layout
    {
        area(Content)
        {
            Repeater(MEM_Intercompany_Setup)
            {
                field(BssiOriginEntityID;Rec.BssiUserSecurityID)
                {
                    ApplicationArea = All;                   
                }
                field(BssiDestinationEntityId;Rec.BssiUserName)
                {
                    ApplicationArea = All;                   
                }
                field(BssiOriginDueToActCode;Rec.BssiEntityCode)
                {
                    ApplicationArea = All;                   
                }
                field(BssiOriginDueFromActCode;Rec.BssiEntityID)
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
            action(UserSecurityCard)
            {
                Caption = 'MEM User Security Card';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;               
                trigger OnAction()
                var
                    BssiMEMUserSecurityCard: Page BssiMEMUserSecurityCard;
                begin
                    BssiMEMUserSecurityCard.RunModal();            
                end;
            }
        }
    }
}