// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1615-Setup Users and Permission Sets
permissionset 50005 "OBF-Admin Item"
{
    Caption = 'OBF-Admin Item';
    Assignable = true;
    IncludedPermissionSets = "D365 Item, EDIT";
    Permissions = tabledata "Item Category"=RIMD,
        tabledata "Planning Assignment"=Rimd;
}
