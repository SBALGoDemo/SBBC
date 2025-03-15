// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1700 - "Your Reference" and "External Document No." Usage
pageextension 50015 "OBF-Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        modify("No.") {Visible =false;}
        moveafter("No.";"Your Reference")
        modify("Your Reference") 
        { 
            ToolTip = '"Your Reference"; Specifies the customer''s reference. The contents will be printed on sales documents.';
            Visible = true;
        }
        modify("External Document No.") 
        { 
            ToolTip = '"External Document No."; Specifies a document number that refers to the customer''s numbering system.';
        }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify("Location Code") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Sell-to Contact") { Visible = false; }
        modify("Posting Date") { Visible = false; }
        modify("Due Date") { Visible = false; }
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