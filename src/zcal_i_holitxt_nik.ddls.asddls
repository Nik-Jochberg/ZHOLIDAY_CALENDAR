@AbapCatalog.sqlViewName: 'ZI_HOLITXTNIK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Public Holidays Text Table'
define view ZCAL_I_HOLITXT_NIK
  as select from zcal_holitxt_nik
  association to parent ZCAL_I_HOLIDAY_NIK as _PublicHoliday on $projection.holiday_id = _PublicHoliday.holiday_id
{

      @UI.facet: [
         {
           id: 'HolidayText',
           label: 'Translation',
           targetQualifier: 'Translation',
           type: #FIELDGROUP_REFERENCE,
           position: 1
         }
       ]

            //zfcal_holidaytxt
      @UI.lineItem: [{ position: 1 }]
      @UI.fieldGroup: [{ position: 1,
                    qualifier: 'Translation',
                    label: 'Language Key'}]
      @Consumption.valueHelpDefinition: [
       {entity: {name: 'I_Language', element: 'Language' }}
      ]
  key spras,
  key holiday_id,
      @UI.fieldGroup: [{ position: 2,
                        qualifier: 'Translation',
                        label: 'Translated Text' }]
      @UI.lineItem: [{ position: 2, label: 'Translation' }]
      fcal_description,
      _PublicHoliday
}
