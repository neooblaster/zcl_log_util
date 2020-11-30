class ZCL_LOG_UTIL_SETTING_TABLE definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_setting_field_map   ,
            table_name      TYPE tabname   ,
            field_fcode     TYPE name_feld ,
            field_fdomain   TYPE name_feld ,
            field_fdata     TYPE name_feld ,
            field_sid       TYPE name_feld ,
            field_snumber   TYPE name_feld ,
            field_stype     TYPE name_feld ,
            field_sspot     TYPE name_feld ,
            field_sparam1   TYPE name_feld ,
            field_sparam2   TYPE name_feld ,
            field_oid       TYPE name_feld ,
            field_onumber   TYPE name_feld ,
            field_otype     TYPE name_feld ,
            field_omsgv1    TYPE name_feld ,
            field_omsgv2    TYPE name_feld ,
            field_omsgv3    TYPE name_feld ,
            field_omsgv4    TYPE name_feld ,
            field_oignore   TYPE name_feld ,
          END   OF ty_setting_field_map .

  class-data TRUE type C value 'X' ##NO_TEXT.
  class-data FALSE type C value ' ' ##NO_TEXT.
  data _CONFIG_VALIDATED type C value ' ' ##NO_TEXT.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR .
  methods SET
    importing
      !I_TABLE_NAME type TABNAME
      !I_FILTER_DEVCODE_FIELD type NAME_FELD optional
      !I_FILTER_DOMAIN_FIELD type NAME_FELD optional
      !I_FILTER_DATA_FIELD type NAME_FELD optional
      !I_SOURCE_ID_FIELD type NAME_FELD
      !I_SOURCE_NUMBER_FIELD type NAME_FELD
      !I_SOURCE_TYPE_FIELD type NAME_FELD
      !I_SOURCE_SPOT_FIELD type NAME_FELD
      !I_SOURCE_PARAM1_FIELD type NAME_FELD optional
      !I_SOURCE_PARAM2_FIELD type NAME_FELD optional
      !I_OVERLOAD_ID_FIELD type NAME_FELD
      !I_OVERLOAD_NUMBER_FIELD type NAME_FELD
      !I_OVERLOAD_TYPE_FIELD type NAME_FELD
      !I_OVERLOAD_MSGV1_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV2_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV3_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV4_FIELD type NAME_FELD optional
      !I_OVERLOAD_IGNORE_FIELD type NAME_FELD optional .
  methods TABLE_NAME
    importing
      !I_TABLE_NAME type TABNAME
    preferred parameter I_TABLE_NAME
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_ID
    importing
      !I_SOURCE_ID_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_NUMBER
    importing
      !I_SOURCE_NUMBER_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_TYPE
    importing
      !I_SOURCE_TYPE_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_SPOT
    importing
      !I_SOURCE_SPOT_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_PARAM1
    importing
      !I_SOURCE_PARAM1_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SOURCE_PARAM2
    importing
      !I_SOURCE_PARAM2_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_ID
    importing
      !I_OVERLOAD_ID_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_NUMBER
    importing
      !I_OVERLOAD_NUMBER_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_TYPE
    importing
      !I_OVERLOAD_TYPE_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_MSGV1
    importing
      !I_OVERLOAD_MSGV1_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_MSGV2
    importing
      !I_OVERLOAD_MSGV2_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_MSGV3
    importing
      !I_OVERLOAD_MSGV3_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_MSGV4
    importing
      !I_OVERLOAD_MSGV4_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods OVERLOAD_IGNORE
    importing
      !I_OVERLOAD_IGNORE_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods FILTER_DEVCODE
    importing
      !I_FILTER_DEVCODE_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods FILTER_DOMAIN
    importing
      !I_FILTER_DOMAIN_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods FILTER_DATA
    importing
      !I_FILTER_DATA_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods GET_SETTING_MAP
    returning
      value(R_SETTING_MAP) type TY_SETTING_FIELD_MAP .
PROTECTED SECTION.
private section.

  data _SETTING_MAP type TY_SETTING_FIELD_MAP .

  methods _CHECK_SETTING
    importing
      !I_FIELD_NAME type NAME_FELD optional .
  methods _CHECK_TABLE
    importing
      !I_TABLE_NAME type TABNAME .
ENDCLASS.



CLASS ZCL_LOG_UTIL_SETTING_TABLE IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  endmethod.


  METHOD constructor.
  ENDMETHOD.


  METHOD filter_data.

    " Store settings.
    me->_setting_map-field_fdata = i_filter_data_field.

    " Check if all settings are done.
    me->_check_setting( i_filter_data_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD filter_devcode.

    " Store settings.
    me->_setting_map-field_fcode = i_filter_devcode_field.

    " Check if all settings are done.
    me->_check_setting( i_filter_devcode_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD filter_domain.

    " Store settings.
    me->_setting_map-field_fdomain = i_filter_domain_field.

    " Check if all settings are done.
    me->_check_setting( i_filter_domain_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  method GET_SETTING_MAP.

    r_setting_map = me->_setting_map.

  endmethod.


  METHOD overload_id.

    " Store settings.
    me->_setting_map-field_oid = i_overload_id_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_id_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  method OVERLOAD_IGNORE.

    " Store settings.
    me->_setting_map-field_oignore = I_OVERLOAD_IGNORE_FIELD.

    " Check if all settings are done.
    me->_check_setting( I_OVERLOAD_IGNORE_FIELD ).

    " Returning for chaining.
    self = me.

  endmethod.


  METHOD overload_msgv1.

    " Store settings.
    me->_setting_map-field_omsgv1 = i_overload_msgv1_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_msgv1_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD overload_msgv2.

    " Store settings.
    me->_setting_map-field_omsgv2 = i_overload_msgv2_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_msgv2_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD overload_msgv3.

    " Store settings.
    me->_setting_map-field_omsgv3 = i_overload_msgv3_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_msgv3_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD overload_msgv4.

    " Store settings.
    me->_setting_map-field_omsgv4 = i_overload_msgv4_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_msgv4_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD overload_number.

    " Store settings.
    me->_setting_map-field_onumber = i_overload_number_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_number_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD overload_type.

    " Store settings.
    me->_setting_map-field_otype = i_overload_type_field.

    " Check if all settings are done.
    me->_check_setting( i_overload_type_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD set.

    me->table_name( i_table_name ).
    me->filter_devcode( i_filter_devcode_field ).
    me->filter_domain( i_filter_domain_field ).
    me->filter_data( i_filter_data_field ).
    me->source_id( i_source_id_field ).
    me->source_number( i_source_number_field ).
    me->source_type( i_source_type_field ).
    me->source_spot( i_source_spot_field ).
    me->source_param1( i_source_param1_field ).
    me->source_param2( i_source_param2_field ).
    me->overload_id( i_overload_id_field ).
    me->overload_number( i_overload_number_field ).
    me->overload_type( i_overload_type_field ).
    me->overload_msgv1( i_overload_msgv1_field ).
    me->overload_msgv2( i_overload_msgv2_field ).
    me->overload_msgv3( i_overload_msgv3_field ).
    me->overload_msgv4( i_overload_msgv4_field ).
    me->overload_ignore( i_overload_ignore_field ).

  ENDMETHOD.


  METHOD source_id.

    " Store settings.
    me->_setting_map-field_sid = i_source_id_field.

    " Check if all settings are done.
    me->_check_setting( i_source_id_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD source_number.

    " Store settings.
    me->_setting_map-field_snumber = i_source_number_field.

    " Check if all settings are done.
    me->_check_setting( i_source_number_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD source_param1.

    " Store settings.
    me->_setting_map-field_sparam1 = i_source_param1_field.

    " Check if all settings are done.
    me->_check_setting( i_source_param1_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD source_param2.

    " Store settings.
    me->_setting_map-field_sparam2 = i_source_param2_field.

    " Check if all settings are done.
    me->_check_setting( i_source_param2_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD source_spot.

    " Store settings.
    me->_setting_map-field_sspot = i_source_spot_field.

    " Check if all settings are done.
    me->_check_setting( i_source_spot_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD source_type.

    " Store settings.
    me->_setting_map-field_stype = i_source_type_field.

    " Check if all settings are done.
    me->_check_setting( i_source_type_field ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD table_name.

    " Check if table exist
    me->_check_table( i_table_name ).

    " Store settings.
    me->_setting_map-table_name = i_table_name.

    " Check if all settings are done.
    me->_check_setting( ).

    " Returning for chaining.
    self = me.

  ENDMETHOD.


  METHOD _check_setting.

    DATA:
        lr_data_tab   TYPE REF TO data                                 ,
        lr_data_str   TYPE REF TO data                                 ,
        lr_strucdescr TYPE REF TO cl_abap_structdescr                  ,
        lt_components TYPE        cl_abap_structdescr=>component_table .

    FIELD-SYMBOLS:
                 <fs_setting_tab_t> TYPE ANY TABLE ,
                 <fs_setting_tab_s> TYPE any       .

    IF i_field_name IS SUPPLIED AND i_field_name IS NOT INITIAL.
      " If table_name is set, check if field exist
      IF me->_setting_map-table_name IS NOT INITIAL.
        " Create table from string table name.
        CREATE DATA lr_data_tab TYPE TABLE OF (me->_setting_map-table_name).
        ASSIGN lr_data_tab->* TO <fs_setting_tab_t>.

        " Get component of dynamic table
        lr_strucdescr = zcl_log_util_define=>get_table_structdescr( <fs_setting_tab_t> ).
        lt_components = lr_strucdescr->get_components( ).

        " Check Component
        READ TABLE lt_components TRANSPORTING NO FIELDS WITH KEY name = i_field_name.

        IF sy-subrc NE 0.
          " 009 :: Field & does not exist in table &
          MESSAGE e009 WITH i_field_name me->_setting_map-table_name.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

    " Check if all required field are configured
    IF ( me->_setting_map-table_name    IS INITIAL
      OR me->_setting_map-field_sid     IS INITIAL
      OR me->_setting_map-field_snumber IS INITIAL
      OR me->_setting_map-field_stype   IS INITIAL
      OR me->_setting_map-field_sspot   IS INITIAL
      OR me->_setting_map-field_oid     IS INITIAL
      OR me->_setting_map-field_onumber IS INITIAL
      OR me->_setting_map-field_otype   IS INITIAL
    ).
      me->_config_validated = zcl_log_util_setting_table=>false.
    ELSE.
      me->_config_validated = zcl_log_util_setting_table=>true.
    ENDIF.

  ENDMETHOD.


  METHOD _check_table.

    DATA:
        ls_dd02l TYPE dd02l.

    " Check if table exist
    SELECT SINGLE * FROM DD02L INTO ls_dd02l WHERE tabname EQ i_table_name.

    IF sy-subrc NE 0.
      " 008 :: Table & does not exist
      MESSAGE e008 WITH i_table_name.
      EXIT.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
