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
  methods SPOT
    importing
      !SPOT type ZDT_LOG_UTIL_SPOT optional
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SPOT .
protected section.
private section.

  data _SETTING_TAB type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  data _CODE_VALUE type STRING .
  data _DOMAIN_VALUE type STRING .
  data _DATA_VALUE type STRING .
  data _SETTING_TAB_DATA type ref to DATA .
  data _SETTING_TAB_LOADED type C value ' ' ##NO_TEXT.
  data _ENABLED type C .
  data _SPOT type ref to ZCL_LOG_UTIL_SPOT .

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
        lv_spot_id           TYPE zdt_log_util_spot                                ,

        " Variable to ease code reading
        " ──┐ Settings Table
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
        lv_fov4              TYPE name_feld                                        , " Setting Table Overload Message V4 Field
        " ──┐ Definition Table
        lv_fmms              TYPE name_feld                                        , " Definition Table Message Text
        lv_fmid              TYPE name_feld                                        , " Definition Table Message ID
        lv_fmno              TYPE name_feld                                        , " Definition Table Message Numbert
        lv_fmty              TYPE name_feld                                        , " Definition Table Message Type
        lv_fmv1              TYPE name_feld                                        , " Definition Table Message Value 1
        lv_fmv2              TYPE name_feld                                        , " Definition Table Message Value 2
        lv_fmv3              TYPE name_feld                                        , " Definition Table Message Value 3
        lv_fmv4              TYPE name_feld                                        . " Definition Table Message Value 4



    FIELD-SYMBOLS:
                 <fs_buff_table_t>  TYPE STANDARD TABLE ,
                 <fs_buff_table_s>  TYPE ANY            ,
                 <fs_setting_tab_t> TYPE STANDARD TABLE ,
                 <fs_setting_tab_s> TYPE ANY            ,

                 " ──┐ Settings Table (For Overloading)
                 <fs_ovr_comp_sid>  TYPE ANY            ,
                 <fs_ovr_comp_sno>  TYPE ANY            ,
                 <fs_ovr_comp_sty>  TYPE ANY            ,
                 <fs_ovr_comp_oid>  TYPE ANY            ,
                 <fs_ovr_comp_ono>  TYPE ANY            ,
                 <fs_ovr_comp_oty>  TYPE ANY            ,
                 <fs_ovr_comp_ov1>  TYPE ANY            ,
                 <fs_ovr_comp_ov2>  TYPE ANY            ,
                 <fs_ovr_comp_ov3>  TYPE ANY            ,
                 <fs_ovr_comp_ov4>  TYPE ANY            ,

                 " ──┐ Buffer Log Table (To Overload)
                 <fs_log_comp_id>   TYPE ANY            ,
                 <fs_log_comp_no>   TYPE ANY            ,
                 <fs_log_comp_ty>   TYPE ANY            ,
                 <fs_log_comp_v1>   TYPE ANY            ,
                 <fs_log_comp_v2>   TYPE ANY            ,
                 <fs_log_comp_v3>   TYPE ANY            ,
                 <fs_log_comp_v4>   TYPE ANY            .


    " Do nothing if feature is not enabled
    CHECK me->_enabled EQ zcl_log_util_setting_table=>true.

    " Get Spot ID if enabled
    IF me->spot( )->is_enabled( ) EQ zcl_log_util_spot=>true.
      lv_spot_id = me->spot( )->get_spot_id( ).
    ENDIF.

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
    " ──┐ Settings Table
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
    " ──┐ Definition Table
    lv_fmid  = i_log_field_def-field_id .
    lv_fmno  = i_log_field_def-field_number .
    lv_fmty  = i_log_field_def-field_type .
    lv_fmv1  = i_log_field_def-field_msgv1 .
    lv_fmv2  = i_log_field_def-field_msgv2 .
    lv_fmv3  = i_log_field_def-field_msgv3 .
    lv_fmv4  = i_log_field_def-field_msgv4 .

    " Performing Overloading
    ASSIGN c_log_table->* TO <fs_buff_table_t>.

    " Create structure of setting tab
    CREATE DATA lr_setting_tab TYPE (lv_tname).
    ASSIGN lr_setting_tab->* TO <fs_setting_tab_s>.

    " Get setting table data as Internal Table
    ASSIGN me->_setting_tab_data->* TO <fs_setting_tab_t>.



    LOOP AT <fs_buff_table_t> ASSIGNING <fs_buff_table_s>.

      " Retrieve current component to find overloading rule
      " ──┐ Initial Message ID
      IF lv_fmid IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmid OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_id>.
      ENDIF.

      " ──┐ Initial Message Number
      IF lv_fmno IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmno OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_no>.
      ENDIF.

      " ──┐ Initial Message Type
      IF lv_fmty IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmty OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_ty>.
      ENDIF.


      " Get Overloading rule (if exist)
      " @TODO : Handle Params 1 & 2 input field (dynamic SQL clause for them)
      READ TABLE <fs_setting_tab_t> INTO <fs_setting_tab_s> WITH KEY (lv_fsid) = <fs_log_comp_id>
                                                                     (lv_fsno) = <fs_log_comp_no>
                                                                     (lv_fsty) = <fs_log_comp_ty>
                                                                     (lv_fssp) = lv_spot_id.

      " If rule not found, process next entry
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      " Overloading Entry
      " ──┐ ID
      IF lv_foid IS NOT INITIAL.
        ASSIGN COMPONENT lv_foid OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_oid>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_oid> IS ASSIGNED AND <fs_ovr_comp_oid> IS NOT INITIAL AND lv_fmid IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmid OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_id>.
          <fs_log_comp_id> = <fs_ovr_comp_oid>.
        ENDIF.
      ENDIF.

      " ──┐ Number
      IF lv_fono IS NOT INITIAL.
        ASSIGN COMPONENT lv_fono OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_ono>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_ono> IS ASSIGNED AND <fs_ovr_comp_ono> IS NOT INITIAL AND lv_fmno IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmno OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_no>.
          <fs_log_comp_no> = <fs_ovr_comp_ono>.
        ENDIF.
      ENDIF.

      " ──┐ Type
      IF lv_foty IS NOT INITIAL.
        ASSIGN COMPONENT lv_foty OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_oty>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_oty> IS ASSIGNED AND <fs_ovr_comp_oty> IS NOT INITIAL AND lv_fmty IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmty OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_ty>.
          <fs_log_comp_ty> = <fs_ovr_comp_oty>.
        ENDIF.
      ENDIF.

      " ──┐ Message V1
      IF lv_fov1 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fov1 OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_ov1>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_ov1> IS ASSIGNED AND <fs_ovr_comp_ov1> IS NOT INITIAL AND lv_fmv1 IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmv1 OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_v1>.
          <fs_log_comp_v1> = <fs_ovr_comp_ov1>.
        ENDIF.
      ENDIF.

      " ──┐ Message V2
      IF lv_fov2 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fov2 OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_ov2>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_ov2> IS ASSIGNED AND <fs_ovr_comp_ov2> IS NOT INITIAL AND lv_fmv2 IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmv2 OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_v2>.
          <fs_log_comp_v2> = <fs_ovr_comp_ov2>.
        ENDIF.
      ENDIF.

      " ──┐ Message V3
      IF lv_fov3 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fov3 OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_ov3>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_ov3> IS ASSIGNED AND <fs_ovr_comp_ov3> IS NOT INITIAL AND lv_fmv3 IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmv3 OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_v3>.
          <fs_log_comp_v3> = <fs_ovr_comp_ov3>.
        ENDIF.
      ENDIF.

      " ──┐ Message V4
      IF lv_fov4 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fov4 OF STRUCTURE <fs_setting_tab_s> TO <fs_ovr_comp_ov4>.
        " Check Settings field found (assigned), it have a value and if target field is defined
        IF <fs_ovr_comp_ov4> IS ASSIGNED AND <fs_ovr_comp_ov4> IS NOT INITIAL AND lv_fmv4 IS NOT INITIAL.
          ASSIGN COMPONENT lv_fmv4 OF STRUCTURE <fs_buff_table_s> TO <fs_log_comp_v4>.
          <fs_log_comp_v4> = <fs_ovr_comp_ov4>.
        ENDIF.
      ENDIF.

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


  method SPOT.

    DATA:
        lr_log_util_spot TYPE REF TO zcl_log_util_spot
        .

    " If not yet instanciated
    IF me->_spot IS NOT BOUND.
      CREATE OBJECT lr_log_util_spot
        EXPORTING spot = spot.

      lr_log_util_spot = me->_spot = lr_log_util_spot.
    ELSE.
      IF spot IS SUPPLIED.
        me->_spot->set_spot_id( spot ).
      ENDIF.
    ENDIF.

    self = me->_spot.

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

    me->_setting_tab_loaded = zcl_log_util_setting_table=>true.

  endmethod.
ENDCLASS.
