CLASS lhc_holidaytext DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS val_transport FOR VALIDATION HolidayText~val_transport
      IMPORTING keys FOR HolidayText.

ENDCLASS.

CLASS lhc_holidaytext IMPLEMENTATION.

  METHOD val_transport.

*    DATA(holiday_transport) = NEW zcl_cal_holiday_transport_nik( ).
*
*    holiday_transport->transport(
*      EXPORTING
*        i_check_mode    = abap_true
*        i_holidaytxt_table = CORRESPONDING #( keys )
*      IMPORTING
*        e_messages      = DATA(result_messages) ).
*
*    LOOP AT result_messages INTO DATA(message).
*      IF message-msgty CA 'AEX'.
*        failed = VALUE #( FOR key IN keys ( %key = key-%key ) ).
*      ENDIF.
*
*      APPEND VALUE #( %key = CORRESPONDING #( keys[ 1 ] )
*                      %msg = new_message(
*                               id       = message-msgid
*                               number   = message-msgno
*                               severity = CONV #( message-msgty )
*                               v1       = message-msgv1
*                               v2       = message-msgv2
*                               v3       = message-msgv3
*                               v4       = message-msgv4 )
*                             ) TO reported.
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_holidayroot_1 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS val_transport FOR VALIDATION HolidayRoot~val_transport
      IMPORTING keys FOR HolidayRoot.

ENDCLASS.

CLASS lhc_holidayroot_1 IMPLEMENTATION.

  METHOD val_transport.

*    DATA(holiday_transport) = NEW zcl_cal_holiday_transport_nik( ).
*
*    holiday_transport->transport(
*      EXPORTING
*        i_check_mode    = abap_true
*        i_holiday_table = CORRESPONDING #( keys )
*      IMPORTING
*        e_messages      = DATA(result_messages) ).
*
*    LOOP AT result_messages INTO DATA(message).
*      IF message-msgty CA 'AEX'.
*        failed = VALUE #( FOR key IN keys ( %key = key-%key ) ).
*      ENDIF.
*
*      APPEND VALUE #( %key = CORRESPONDING #( keys[ 1 ] )
*                      %msg = new_message(
*                               id       = message-msgid
*                               number   = message-msgno
*                               severity = CONV #( message-msgty )
*                               v1       = message-msgv1
*                               v2       = message-msgv2
*                               v3       = message-msgv3
*                               v4       = message-msgv4 )
*                             ) TO reported.
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_HolidayRoot  DEFINITION INHERITING
  FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS det_create_and_change_texts
      FOR DETERMINATION HolidayRoot~det_create_and_change_texts
      IMPORTING keys FOR HolidayRoot.

    METHODS create_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id_nik
        i_description TYPE zcal_description_nik.

    METHODS update_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id_nik
        i_description TYPE zcal_description_nik.

ENDCLASS.

CLASS lhc_HolidayRoot IMPLEMENTATION.

  METHOD det_create_and_change_texts.

    READ ENTITIES OF zcal_i_holiday_nik
      ENTITY HolidayRoot
      FROM VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
      RESULT DATA(public_holidays_table).


    LOOP AT public_holidays_table INTO DATA(public_holiday).
      READ ENTITIES OF zcal_i_holiday_nik
        ENTITY HolidayRoot BY \_HolidayTxt
        FROM VALUE #( ( %key = public_holiday-%key ) )
        RESULT DATA(description_table).
      IF line_exists( description_table[
                        spras      = sy-langu
                        holiday_id = public_holiday-holiday_id ] ).
        update_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).

      ELSE.
        create_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD create_description.
    DATA:
      description_table TYPE TABLE FOR CREATE zcal_i_holiday_nik\_HolidayTxt,
      description       TYPE STRUCTURE FOR CREATE zcal_i_holiday_nik\_HolidayTxt.

    description-%key    = i_holiday_id.
    description-%target =
      VALUE #(
               ( holiday_id       = i_holiday_id
                 spras            = sy-langu
                 fcal_description = i_description
                 %control = VALUE
                            #( holiday_id       = cl_abap_behv=>flag_changed
                               spras            = cl_abap_behv=>flag_changed
                               fcal_description = cl_abap_behv=>flag_changed
                             )
               )
             ).

    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday_nik IN LOCAL MODE
      ENTITY HolidayRoot CREATE BY \_HolidayTxt FROM description_table.
  ENDMETHOD.

  METHOD update_description.
    DATA:
      description_table TYPE TABLE FOR UPDATE zcal_i_holitxt_nik,
      description       TYPE STRUCTURE FOR UPDATE zcal_i_holitxt_nik.

    description-holiday_id       = i_holiday_id.
    description-spras            = sy-langu.
    description-fcal_description = i_description.

    description-%control-fcal_description = cl_abap_behv=>flag_changed.
    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday_nik IN LOCAL MODE
      ENTITY HolidayText UPDATE FROM description_table.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.
  " Importing CREATE-subEntityName
  " Table of instance data of all instances that have been created
  " and afterwards have been updated but not deleted
  " Use %Control to get information what attributes have been set
  " Importing UPDATE-subEntityName
  " Table of keys of all instances that have been updated,
  " but not deleted.
  " Use %Control to get information what attributes have been updated
  " Importing DELETE-subEntityName
  " Table of keys of all instances, that are deleted

  METHOD save_modified.
    DATA(all_root_keys) = create-HolidayRoot.
    APPEND LINES OF update-HolidayRoot TO all_root_keys.
    APPEND LINES OF delete-HolidayRoot TO all_root_keys.

    DATA(all_text_keys) = create-HolidayText.
    APPEND LINES OF update-holidaytext TO all_text_keys.
    APPEND LINES OF delete-holidaytext TO all_text_keys.

    DATA(holiday_transport) = NEW zcl_cal_holiday_transport_nik( ).
    holiday_transport->transport(
      EXPORTING
        i_check_mode       = abap_false
        i_holiday_table    = CORRESPONDING #( all_root_keys )
        i_holidaytxt_table = CORRESPONDING #( all_text_keys )
      IMPORTING
        e_messages         = DATA(result_messages) ).

    IF line_exists( result_messages[ msgty = 'E' ] ) OR
       line_exists( result_messages[ msgty = 'A' ] ) OR
       line_exists( result_messages[ msgty = 'X' ] ).
      ASSERT 1 EQ 2.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
