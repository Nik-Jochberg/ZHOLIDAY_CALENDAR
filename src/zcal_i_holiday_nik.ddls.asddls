@AbapCatalog.sqlViewName: 'ZCAL_I_HOLID_NIK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View Data Def. ZCAL_I_HOLIDAY'
define root view ZCAL_I_HOLIDAY_NIK as select from zcal_holiday_nik 
composition [0..*] of ZCAL_I_HOLITXT_NIK as _HolidayTxt 
{
 @UI.facet: [
         {
           id: 'PublicHoliday',
           label: 'Public Holiday',
           type: #COLLECTION,
           position: 1
         },
         {
           id: 'General',
           parentId: 'PublicHoliday',
           label: 'General Data',
           type: #FIELDGROUP_REFERENCE,
           targetQualifier: 'General',
           position: 1
         },
         {
        id: 'Translation',
        label: 'Translation',
        type: #LINEITEM_REFERENCE,
        position: 3,
        targetElement: '_HolidayTxt'
        } 
        ]
         
    //zcal_holiday_nik
    //@Semantics.user.createdBy: true
    @UI.fieldGroup: [ { qualifier: 'General', position: 1 } ]
    @UI.lineItem:   [ { position: 1 } ]
    key holiday_id,
    //@Semantics.user.lastChangedBy: true    
    @UI.fieldGroup: [ { qualifier: 'General', position: 2 } ]
    @UI.lineItem:   [ { position: 2 } ]
    month_of_holiday,
    //@Semantics.systemDateTime.lastChangedAt: true
    @UI.fieldGroup: [ { qualifier: 'General', position: 3 } ]
    @UI.lineItem:   [ { position: 3 } ]
    day_of_holiday,
    @Semantics.systemDateTime.lastChangedAt: true    
    changedat,
    _HolidayTxt 
}
