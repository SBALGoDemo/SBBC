// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Document Page Cleanup
pageextension 50018 "OBF-Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {

        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify("Location Code") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        addafter("Vendor Invoice No.")
        {
            field("OBF-Coupa Internal Invoice ID";Rec."OBF-Coupa Internal Invoice ID")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field(CreatedByUser;CreatedByUser) 
            { 
                Visible = true;
                ApplicationArea = all;
                Caption = 'Created by User';
            }
        }
    }

    var
        CreatedByUser: Code[50];

    trigger OnAfterGetRecord()
    begin 
        CreatedByUser := GetUserNameFromSecurityId(Rec.SystemCreatedBy);
    end; 
    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        User.Get(UserSecurityID);
        exit(User."User Name");
    end;
}