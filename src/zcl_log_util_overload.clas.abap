class ZCL_LOG_UTIL_OVERLOAD definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SETTING_TAB
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SET_FILTER_DEVCODE_VALUE
    importing
      !I_VALUE type C optional .
  methods SET_FILTER_DOMAIN_VALUE
    importing
      !I_VALUE type C optional .
  methods SET_FILTER_DATA_VALUE
    importing
      !I_VALUE type C optional .
  methods OVERLOAD .
protected section.
private section.

  data _SETTING_TAB type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  data _CODE_VALUE type STRING .
  data _DOMAIN_VALUE type STRING .
  data _DATA_VALUE type STRING .
  data _SETTING_TAB_DATA type ref to DATA .
  data _SETTING_TAB_LOADED type C value ' ' ##NO_TEXT.

  methods _LOAD_SETTING_TABLE .
  methods _GET_SETTING_MAP
    returning
      value(R_SETTING_MAP) type ZCL_LOG_UTIL_SETTING_TABLE=>TY_SETTING_FIELD_MAP .
ENDCLASS.



CLASS ZCL_LOG_UTIL_OVERLOAD IMPLEMENTATION.


  method CONSTRUCTOR.

    CREATE OBJECT me->_setting_tab.

  endmethod.


  method OVERLOAD.
    "
    " Load data if it has not been done yet
    " Can be containt data, but change filter implie reloading
    "
    " Only load data on overloading for performance & ease reasons.
    " We only need data for overloading, so perform load just once
    " before overloading.
    "
    IF me->_setting_tab_loaded NE zcl_log_util_setting_table=>true.
      me->_load_setting_table( ).
    ENDIF.

  endmethod.


  method SETTING_TAB.

    self = me->_setting_tab.

  endmethod.


  method SET_FILTER_DATA_VALUE.

    " Set provided value
    me->_data_value = i_value.

    " Indicating data has not been load (indeed change implies reloading)
    me->_setting_tab_loaded = zcl_log_util_setting_table=>false.


  endmethod.


  method SET_FILTER_DEVCODE_VALUE.

    " Set provided value
    me->_code_value = i_value.

    " Indicating data has not been load (indeed change implies reloading)
    me->_setting_tab_loaded = zcl_log_util_setting_table=>false.

  endmethod.


  method SET_FILTER_DOMAIN_VALUE.

    " Set provided value
    me->_domain_value = i_value.

    " Indicating data has not been load (indeed change implies reloading)
    me->_setting_tab_loaded = zcl_log_util_setting_table=>false.

  endmethod.


  method _GET_SETTING_MAP.

    r_setting_map = me->setting_tab( )->get_setting_map( ).

  endmethod.


  method _LOAD_SETTING_TABLE.

    DATA:
        ls_setting_map     TYPE zcl_log_util_setting_table=>ty_setting_field_map ,
        lv_setting_tabname TYPE tabname                                          ,
        lv_where_clause    TYPE string                                           ,
        lv_where_operand   TYPE string                                           ,
        lv_where_member    TYPE string                                           .

    FIELD-SYMBOLS:
                 <fs_setting_tab_t> TYPE ANY TABLE ,
                 <fs_setting_tab_s> TYPE ANY       .

    " Get setting map
    ls_setting_map = me->_get_setting_map( ).
    lv_setting_tabname = ls_setting_map-table_name.

    " Select entries from table
    CREATE DATA me->_setting_tab_data TYPE TABLE OF (lv_setting_tabname).
    ASSIGN me->_setting_tab_data->* TO <fs_setting_tab_t>.

    " Composing SQL Clause
    " ──┐ handling Filter DEVCODE
    IF ls_setting_map-field_fcode IS NOT INITIAL AND me->_code_value IS NOT INITIAL.
      IF lv_where_clause IS NOT INITIAL.
        lv_where_operand = 'AND'.
      ENDIF.

      CONCATENATE lv_where_operand ls_setting_map-field_fcode INTO lv_where_operand SEPARATED BY space.
      CONCATENATE lv_where_operand ' = ''' me->_code_value '''' INTO lv_where_member.
      CONCATENATE lv_where_clause lv_where_member INTO lv_where_clause SEPARATED BY space.

      CLEAR : lv_where_operand, lv_where_member.
    ENDIF.

    " ──┐ handling Filter DOMAIN
    IF ls_setting_map-field_fdomain IS NOT INITIAL AND me->_domain_value IS NOT INITIAL.
      IF lv_where_clause IS NOT INITIAL.
        lv_where_operand = 'AND'.
      ENDIF.

      CONCATENATE lv_where_operand ls_setting_map-field_fdomain INTO lv_where_operand SEPARATED BY space.
      CONCATENATE lv_where_operand ' = ''' me->_domain_value '''' INTO lv_where_member.
      CONCATENATE lv_where_clause lv_where_member INTO lv_where_clause SEPARATED BY space.

      CLEAR : lv_where_operand, lv_where_member.
    ENDIF.

    " ──┐ handling Filter DATA
    IF ls_setting_map-field_fdata IS NOT INITIAL AND me->_data_value IS NOT INITIAL.
      IF lv_where_clause IS NOT INITIAL.
        lv_where_operand = 'AND'.
      ENDIF.

      CONCATENATE lv_where_operand ls_setting_map-field_fdata INTO lv_where_operand SEPARATED BY space.
      CONCATENATE lv_where_operand ' = ''' me->_data_value '''' INTO lv_where_member.
      CONCATENATE lv_where_clause lv_where_member INTO lv_where_clause SEPARATED BY space.

      CLEAR : lv_where_operand, lv_where_member.
    ENDIF.

    IF lv_where_clause IS INITIAL.
      SELECT * FROM (lv_setting_tabname) INTO CORRESPONDING FIELDS OF TABLE <fs_setting_tab_t>.
    ELSE.
      SELECT * FROM (lv_setting_tabname) INTO CORRESPONDING FIELDS OF TABLE <fs_setting_tab_t> WHERE (lv_where_clause).
    ENDIF.

  endmethod.
ENDCLASS.
