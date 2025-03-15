// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
page 50009 "OBF-Post Rebates Header"
{
    PageType = Document;
    SourceTable = "Customer";
    Caption = 'Post Rebates Header';
    Editable = true;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name;Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Contact;Rec.Contact)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Balance;Rec.Balance)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(DocumentNo;DocumentNo)
                {
                    Caption = 'Document No.';
                    ApplicationArea = all;
                }
                field(PostingDate;PostingDate)
                {
                    Caption = 'Posting Date';
                    ApplicationArea = all;
                }
 
            }
            part(Subform; "OBF-Post Rebates Subform")
            {
                SubPageLink = "Bill-to Customer No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PostRebatesToCustomer)
            {
                Caption = 'Post Rebates to Customer';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    if DocumentNo = '' then
                        Message('You must enter a Document No.')
                    else if PostingDate = 0D then
                        Message('You must enter the Posting Date')
                    else begin
                        CurrPage.Subform.Page.AccrueRebates(DocumentNo,PostingDate);
                        DocumentNo := '';
                        PostingDate := 0D;
                    end;
                end;
            }
            action("Close Rebates Without Posting")
            {
                Caption = 'Close Rebates Without Posting';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CurrPage.Subform.Page.CloseRebatesWithoutPosting;
                end;
            }
        }
    }

    var
        DocumentNo: Code[20];
        PostingDate: Date;
}
