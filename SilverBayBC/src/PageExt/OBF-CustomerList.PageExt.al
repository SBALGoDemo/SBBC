// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Page Cleanup
pageextension 50024 "OBF-Customer List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Our Account No.";Rec."Our Account No.")
            {
                ApplicationArea = all;
            }

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1855 - Add Broker to Customer Card and List
            field("OBF-Broker";Rec."OBF-Broker")
            {
                ApplicationArea = all;
            }
            
        }
    }

    actions
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        addfirst(processing)
        {
            action(PostRebatesToCustomer)
            {
                Caption = 'Post Rebates to Customer';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;  
                trigger OnAction()
                var
                    Customer: Record Customer;
                    PostRebateHeader: Page "OBF-Post Rebates Header";
                begin
                    Customer.SetRange("No.",Rec."No.");
                    Customer.Get(Rec."No.");
                    PostRebateHeader.SetTableView(Customer);
                    PostRebateHeader.SetRecord(Customer);
                    PostRebateHeader.RunModal();
                    CurrPage.Update();
                end;
            }
        }
    }
}