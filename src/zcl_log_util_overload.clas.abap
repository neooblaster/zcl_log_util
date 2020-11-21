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
  methods ENABLE .
  methods DISABLE .
  methods OVERLOAD
    importing
      !I_LOG_FIELD_DEF type ZCL_LOG_UTIL_DEFINE=>TY_FIELD_MAP
    changing
      !C_LOG_TABLE type ref to DATA .
protected section.
private section.

  data _SETTING_TAB type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  data _CODE_VALUE type STRING .
  data _DOMAIN_VALUE type STRING .
  data _DATA_VALUE type STRING .
  data _SETTING_TAB_DATA type ref to DATA .
  data _SETTING_TAB_LOADED type C value ' ' ##NO_TEXT.
  data _ENABLED type C .

  methods _LOAD_SETTING_TABLE .
  methods _GET_SETTING_MAP
    returning
      value(R_SETTING_MAP) type ZCL_LOG_UTIL_SETTING_TABLE=>TY_SETTING_FIELD_MAP .
ENDCLASS.



CLASS ZCL_LOG_UTIL_OVERLOAD IMPLEMENTATION.


  method CONSTRUCTOR.

    CREATE OBJECT me->_setting_tab.

  endmethod.


  method DISABLE.

    me->_enabled = zcl_log_util_setting_table=>false.

  endmethod.


  method ENABLE.

    me->_enabled = zcl_log_util_setting_table=>true.

  endmethod.


  method OVERLOAD.

    DATA:
        lr_setting_tab       TYPE REF TO data                                      ,

        lt_log_field_def     TYPE zcl_log_util_define=>ty_field_map                ,
        ls_setting_field_map TYPE zcl_log_util_setting_table=>TY_SETTING_FIELD_MAP ,

        lv_log_tab_name      TYPE string                                           ,

        " Variable to ease code reading
        lv_tname             TYPE name_feld                                        , " Setting Table Table Name
        lv_fsid              TYPE name_feld                                        , " Setting Table Source ID Field
        lv_fsno              TYPE name_feld                                        , " Setting Table Source Number Field
        lv_fsty              TYPE name_feld                                        , " Setting Table Source Type Field
        lv_fssp              TYPE name_feld                                        , " Setting Table Source Spot ID Filed
        lv_fsp1              TYPE name_feld                                        , " Setting Table Source Param 1 Field
        lv_fsp2              TYPE name_feld                                        , " Setting Table Source Param 2 Field
        lv_foid              TYPE name_feld                                        , " Setting Table Overload ID Field
        lv_fono              TYPE name_feld                                        , " Setting Table Overload Number Field
        lv_foty              TYPE name_feld                                        , " Setting Table Overload Type Field
        lv_fov1              TYPE name_feld                                        , " Setting Table Overload Message V1 Field
        lv_fov2              TYPE name_feld                                        , " Setting Table Overload Message V2 Field
        lv_fov3              TYPE name_feld                                        , " Setting Table Overload Message V3 Field
        lv_fov4              TYPE name_feld                                        . " Setting Table Overload Message V4 Field

    FIELD-SYMBOLS:
                 <fs_buff_table_t>  TYPE STANDARD TABLE ,
                 <fs_buff_table_s>  TYPE ANY            ,
                 <fs_setting_tab_t> TYPE STANDARD TABLE ,
                 <fs_setting_tab_s> TYPE ANY            .

    " Do nothing if feature is not enabled
    CHECK me->_enabled EQ zcl_log_util_setting_table=>true.

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

    " Get settings table field map & assign to variable to reduce var names
    ls_setting_field_map = me->_get_setting_map( ).
    lv_tname = ls_setting_field_map-table_name .
    lv_fsid  = ls_setting_field_map-field_sid .
    lv_fsno  = ls_setting_field_map-field_snumber .
    lv_fsty  = ls_setting_field_map-field_stype .
    lv_fssp  = ls_setting_field_map-field_sspot .
    lv_fsp1  = ls_setting_field_map-field_sparam1 .
    lv_fsp2  = ls_setting_field_map-field_sparam2 .
    lv_foid  = ls_setting_field_map-field_oid .
    lv_fono  = ls_setting_field_map-field_onumber .
    lv_foty  = ls_setting_field_map-field_otype .
    lv_fov1  = ls_setting_field_map-field_omsgv1 .
    lv_fov2  = ls_setting_field_map-field_omsgv2 .
    lv_fov3  = ls_setting_field_map-field_omsgv3 .
    lv_fov4  = ls_setting_field_map-field_omsgv4 .

    " Performing Overloading
    ASSIGN c_log_table->* TO <fs_buff_table_t>.

    " Create structure of setting tab
    CREATE DATA lr_setting_tab TYPE (lv_tname).
    ASSIGN lr_setting_tab->* TO <fs_setting_tab_s>.

    " Get setting table data as Internal Table
    ASSIGN me->_setting_tab_data->* TO <fs_setting_tab_t>.



    LOOP AT <fs_buff_table_t> ASSIGNING <fs_buff_table_s>.

      " Retrieve corresponding component for overloading

      " Get Overloading rule (if exist)
      " @TODO : Handle Params 1 & 2 input field (dynamic SQL clause for them)
      READ TABLE <fs_setting_tab_t> INTO <fs_setting_tab_s> WITH KEY (lv_fsid) = 'VL'
                                                                     (lv_fsno) = '504'
                                                                     (lv_fsty) = 'E'
                                                                     (lv_fssp) = ''.

      " If rule not found, process next entry
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      " Update Entry




        "WHERE lv_fsid = '1'.
        "WHERE lv_fsid = ( <comp_id> ).
          "AND ( 'input2' ) = ( <comp_no> )
          "AND ( 'input3' ) = ( <comp_ty> )
          "AND ( 'input4' ) = ( <comp_sp> ).

      " lire la table _SETTING_TAB_DATA avec <settingtabl> = <valeur du field correspondant>


      " _SETTING_TAB

*TABLE_NAME
*FIELD_FCODE
*FIELD_FDOMAIN
*FIELD_FDATA
*FIELD_SID
*FIELD_SNUMBER
*FIELD_STYPE
*FIELD_SSPOT
*FIELD_SPARAM1
*FIELD_SPARAM2
*FIELD_OID
*FIELD_ONUMBER
*FIELD_OTYPE
*FIELD_OMSGV1
*FIELD_OMSGV2
*FIELD_OMSGV3
*FIELD_OMSGV4



    ENDLOOP.

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
