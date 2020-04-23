@AbapCatalog.sqlViewName: 'ZI_HOLITXTNIK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Public Holidays Text Table'
define view ZCAL_I_HOLITXT_NIK
  as select from zcal_holitxt_nik
  association to parent ZCAL_I_HOLIDAY_NIK as _PublicHoliday on $projection.holiday_id = _PublicHoliday.holiday_id
{
      //zfcal_holidaytxt
  key spras,
  key holiday_id,
      fcal_description,
      _PublicHoliday
}
