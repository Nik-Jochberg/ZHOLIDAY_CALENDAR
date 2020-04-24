CLASS zcl_cal_holiday_transport_nik DEFINITION  PUBLIC  FINAL  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES:
      tt_holiday    TYPE TABLE OF zcal_holiday_nik
                         WITH NON-UNIQUE DEFAULT KEY,
      tt_holidaytxt TYPE TABLE OF zcal_holitxt_nik
                         WITH NON-UNIQUE DEFAULT KEY.

    METHODS:
      constructor,
      transport
        IMPORTING
          i_check_mode              TYPE abap_bool
          VALUE(i_holiday_table)    TYPE tt_holiday OPTIONAL
          VALUE(i_holidaytxt_table) TYPE tt_holidaytxt OPTIONAL
        EXPORTING
          e_messages                TYPE if_a4c_bc_handler=>tt_message.

  PROTECTED SECTION.
    DATA: transport_api TYPE REF TO if_a4c_bc_handler.

ENDCLASS.

CLASS zcl_cal_holiday_transport_nik IMPLEMENTATION.

  METHOD constructor.
   " me->transport_api = cl_a4c_bc_factory=>get_handler( ). " fehl. Berechtigung
  ENDMETHOD.


  METHOD transport.

    DATA: object_keys TYPE if_a4c_bc_handler=>tt_object_tables,
          object_key  TYPE if_a4c_bc_handler=>ts_object_list.

    CHECK i_holiday_table IS NOT INITIAL.

    IF i_holiday_table IS NOT INITIAL.
      object_key-objname = 'ZCAL_HOLIDAY_NIK'.
      object_key-tabkeys = REF #( i_holiday_table ).
      APPEND object_key TO object_keys.
    ENDIF.

    IF i_holidaytxt_table IS NOT INITIAL.
      object_key-objname = 'ZCAL_HOLITXT_NIK'.
      object_key-tabkeys = REF #( i_holidaytxt_table ).
      APPEND object_key TO object_keys.
    ENDIF.

    TRY.
        transport_api->add_to_transport_request(
          EXPORTING
            iv_check_mode         = i_check_mode
            it_object_tables      = object_keys
            iv_mandant_field_name = 'CLIENT'
          IMPORTING
            rt_messages           = e_messages
            rv_success            = DATA(success_flag) ).

        IF success_flag NE 'S'.
          RAISE EXCEPTION TYPE cx_a4c_bc_exception.
        ENDIF.
      CATCH cx_a4c_bc_exception INTO DATA(bc_exception).
        APPEND
          VALUE #( msgty = 'E'
                   msgid = 'SY'
                   msgno = '002'
                   msgv1 = bc_exception->get_text( ) )
          TO e_messages.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
