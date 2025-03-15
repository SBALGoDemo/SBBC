// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1624 - ACH Setup for Wells Fargo
table 50121 "INVC WF Payment Export Buffer"
{
    fields
    {
        field(1; TRANNO; Text[50])
        { }
        field(2; "Line No."; Integer)
        {
            MinValue = 0;
        }
        field(3; PAYMTHD; Text[50])
        { }
        field(4; CRDDBTFL; Text[50])
        { }
        field(6; VALDT; Text[50])
        { }
        field(7; PAYAMT; Text[50])
        { }
        field(8; PMTFMTCD; Text[50])
        { }
        field(9; CUR; Text[50])
        { }
        field(10; ORIGACCTTY; Text[50])
        { }
        field(11; ORIGACCT; Text[50])
        { }
        field(12; ORIGBNKIDTY; Text[50])
        { }
        field(13; ORIGBNKID; Text[50])
        { }
        field(14; RCVPRTYACCTTY; Text[50])
        { }
        field(15; RCVPRTYACCT; Text[50])
        { }
        field(16; RCVACCTCUR; Text[50])
        { }
        field(17; RCVBNKIDTY; Text[50])
        { }
        field(18; RCVBNKID; Text[50])
        { }
        field(19; RCVBNKSECID; Text[50])
        { }
        field(20; ORIGTORCVPRTYINF; Text[50])
        { }
        field(21; ORIGPRTYNM; Text[50])
        { }
        field(22; ORIGPRTYADDR1; Text[50])
        { }
        field(23; ORIGPRTYADDR2; Text[50])
        { }
        field(24; ORIGPRTYADDR3; Text[50])
        { }
        field(25; ORIGPRTYCTY; Text[50])
        { }
        field(26; ORIGPRTYSTPRO; Text[50])
        { }
        field(27; ORIGPRTYPSTCD; Text[50])
        { }
        field(28; ORIGPRTYCTRYCD; Text[50])
        { }
        field(29; ORIGPRTYCTRYNM; Text[50])
        { }
        field(30; ORIGPRTYEMLADDR; Text[50])
        { }
        field(31; RCVPRTYNM; Text[50])
        { }
        field(32; RCVPRTYID; Text[50])
        { }
        field(33; RCVPRTYADDR1; Text[50])
        { }
        field(34; RCVPRTYADDR2; Text[50])
        { }
        field(35; RCVPRTYADDR3; Text[50])
        { }
        field(36; RCVPRTYCTY; Text[50])
        { }
        field(37; RCVPRTYSTPRO; Text[50])
        { }
        field(38; RCVPRTYPSTCD; Text[50])
        { }
        field(39; RCVPRTYCTRYCD; Text[50])
        { }
        field(40; RCVBNKNM; Text[50])
        { }
        field(41; RCVBNKADDR1; Text[50])
        { }
        field(42; RCVBNKCTY; Text[50])
        { }
        field(43; RCVBNKSTPRO; Text[50])
        { }
        field(44; RCVBNKPSTCD; Text[50])
        { }
        field(45; RCVBNKCTRYCD; Text[50])
        { }
        field(46; CHKNO; Text[50])
        { }
        field(47; DOCTMPLNO; Text[50])
        { }
        field(48; CHKDELCD; Text[50])
        { }
        field(49; ACHCMPID; Text[50])
        { }
        field(50; FILEFRMT; Text[50])
        { }
        field(51; DELTYPE_1; Text[50])
        { }
        field(52; DELCONTNM_1; Text[50])
        { }
        field(53; DELEMLADDR_1; Text[50])
        { }
        field(54; SECTYP_1; Text[50])
        { }
        field(55; INVNO; Text[50])
        { }
        field(56; INVDT; Text[50])
        { }
        field(57; INVDESC; Text[100])
        { }
        field(58; INVNET; Text[50])
        { }
        field(59; INVGROSS; Text[50])
        { }
        field(60; INVDISCT; Text[50])
        { }
        field(61; PONUM; Text[50])
        { }
        field(62; INVTYPE; Text[50])
        { }
        field(63; INVONLYREC; Text[50])
        { }
        field(100; "Journal Template Name"; Code[10])
        { }
        field(101; "Journal Batch Name"; Code[10])
        { }
        field(102; "Journal Line No."; Integer)
        { }
        field(103; "Vendor No."; Code[20])
        { }
        field(200; "Bank Payment Type"; Enum "INVC Wells Fargo Payment Type")
        { }
    }
    keys
    {
        key(Key1; TRANNO, "Line No.")
        {
            Clustered = true;
        }
    }
}