pageextension 50044 "OBF-Sales Order List" extends "Sales Order List"
{
    layout
    {
        modify("External Document No.") 
        { 
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Sell-to Contact") { Visible = false; }
        modify("Posting Date") { Visible = false; }
        modify("Due Date") { Visible = false; }
        addafter("Document Date")
        {
            field("Order Date";Rec."Order Date")
            { 
                Visible = true;
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