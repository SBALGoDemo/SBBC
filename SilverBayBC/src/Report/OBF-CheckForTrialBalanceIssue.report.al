// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2367 - Create report to check for trial balance issue
report 50001 "OBF-Check For Trial Bal. Issue"
{
    Caption = 'Check For Trial Balance Issue';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src/ReportLayouts/OBF-CheckForTrialBalanceIssue.xlsx';

    dataset
    {
        dataitem(GLRegister; "G/L Register")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Creation Date";
            RequestFilterHeading = 'Check For Trial Balance Issue';
            column(No_;"No.")
            {
            }
            column(From_Entry_No_;"From Entry No.")
            {

            }
            column(To_Entry_No_;"To Entry No.")
            {
            }
            column(NumberOfKodiakGLEntries;NumberOfKodiakGLEntries)
            {
            }
            column(TotalForKodiak;TotalForKodiak)
            {
            }
            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                BalanceForKodiak: Decimal;
            begin 
                GLEntry.SetRange("Entry No.",GLRegister."From Entry No.",GLRegister."To Entry No.");
                GLEntry.SetRange("Global Dimension 1 Code",'11-KODIAK');
                NumberOfKodiakGLEntries := GLEntry.Count;
                GLEntry.CalcSums(Amount);
                TotalForKodiak := GLEntry.Amount;
                // if abs(TotalForKodiak)<0.01 then
                //     CurrReport.Skip();
                if NumberOfKodiakGLEntries = 0 then
                    CurrReport.Skip();
            end;
        }
    }
    var
        NumberOfKodiakGLEntries: Integer;
        TotalForKodiak: Decimal;
}