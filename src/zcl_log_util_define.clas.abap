class ZCL_LOG_UTIL_DEFINE definition
  public
  final
  create public .

public section.

  types:
    begin of ty_field_map,
            abs_name      TYPE string    ,
            field_message TYPE name_feld ,
            field_id      TYPE name_feld ,
            field_number  TYPE name_feld ,
            field_type    TYPE name_feld ,
            field_msgv1   TYPE name_feld ,
            field_msgv2   TYPE name_feld ,
            field_msgv3   TYPE name_feld ,
            field_msgv4   TYPE name_feld ,
          end   of ty_field_map .

  methods CONSTRUCTOR .
  methods SET
    importing
      !MSGTX_FIELD type NAME_FELD optional
      !MSGID_FIELD type NAME_FELD optional
      !MSGNO_FIELD type NAME_FELD optional
      !MSGTY_FIELD type NAME_FELD optional
      !MSGV1_FIELD type NAME_FELD optional
      !MSGV2_FIELD type NAME_FELD optional
      !MSGV3_FIELD type NAME_FELD optional
      !MSGV4_FIELD type NAME_FELD optional .
  methods MESSAGE
    importing
      !MSGTX_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods ID
    importing
      !MSGID_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods NUMBER
    importing
      !MSGNO_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods TYPE
    importing
      !MSGTY_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods MSGV1
    importing
      !MSGV1_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods MSGV2
    importing
      !MSGV2_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods MSGV3
    importing
      !MSGV3_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods MSGV4
    importing
      !MSGV4_FIELD type NAME_FELD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods HANDLING
    importing
      !I_STRUCTURE type ANY .
  class-methods GET_ABSOLUTE_NAME
    importing
      !I_ELEMENT type ANY
    returning
      value(R_ABS_NAME) type STRING .
  class-methods GET_RELATIVE_NAME
    importing
      !I_ELEMENT type ANY
    returning
      value(R_REL_NAME) type STRING .
  class-methods GET_TABLE_TYPEDESCR
    importing
      !I_TABLE type STANDARD TABLE
    returning
      value(R_TYPEDESCR) type ref to CL_ABAP_TYPEDESCR .
  class-methods GET_TABLE_STRUCTDESCR
    importing
      !I_TABLE type STANDARD TABLE
    returning
      value(R_STRUCTDESCR) type ref to CL_ABAP_STRUCTDESCR .
  methods GET_DEFINITION
    importing
      !I_ABSOLUTE_NAME type STRING optional
      !I_STRUCTURE type ANY optional
    preferred parameter I_STRUCTURE
    returning
      value(R_DEFINITION) type TY_FIELD_MAP .
protected section.

  data:
    _LOG_TABLE_MAP type TABLE OF ty_field_map .
  class-data TRUE type C value 'X' ##NO_TEXT.
  class-data FALSE type C value ' ' ##NO_TEXT.
private section.

  data _HANDLE type ref to DATA .

  methods _SET_FIELD_MAP
    importing
      !I_MSG_FIELD type NAME_FELD
      !I_MAP_FIELD type NAME_FELD .
  methods _CHECK_COMPONENT
    importing
      !I_COMP_NAME type NAME_FELD .
  class-methods _GET_STRUCT_NAME
    importing
      !I_ELEMENT type ANY
      !I_NAME_KIND type STRING
    returning
      value(R_NAME) type STRING .
ENDCLASS.



CLASS ZCL_LOG_UTIL_DEFINE IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.


  method GET_ABSOLUTE_NAME.

    r_abs_name = zcl_log_util_define=>_GET_STRUCT_NAME(
      i_element   = i_element
      i_name_kind = 'ABSOLUTE'
    ).

  endmethod.


  method GET_DEFINITION.
    " --------------------------------------------------------------
    " GET_DEFINITION can retrieve definition from absolute type name
    " (string I_ABSOLUTE_NAME) or relating to provided structure or table
    " (any I_STRUCTURE).
    "
    " If both parameter are provided, the first one have the priority
    " (I_ABSOLUTE_NAME)
    " --------------------------------------------------------------
    DATA:
        lv_absolute_name TYPE string.

    IF i_absolute_name IS SUPPLIED.
      lv_absolute_name = i_absolute_name.
    ENDIF.

    IF lv_absolute_name IS INITIAL AND i_structure IS NOT SUPPLIED.
      " 006 :: ZCL_LOG_UTIL->GET_DEFINITION expected at least one parameter
      MESSAGE e006.
      EXIT.

    ELSE.
      lv_absolute_name = zcl_log_util_define=>get_absolute_name( i_structure ).
    ENDIF.

    READ TABLE me->_log_table_map INTO r_definition WITH KEY abs_name = lv_absolute_name.

    IF sy-subrc NE 0.
      " 007 :: ZCL_LOG_UTIL->GET_DEFINITION, type & undefined
      MESSAGE e007 WITH lv_absolute_name.
      EXIT.
    ENDIF.

  endmethod.


  method GET_RELATIVE_NAME.

    r_rel_name = zcl_log_util_define=>_GET_STRUCT_NAME(
      i_element   = i_element
      i_name_kind = 'RELATIVE'
    ).

  endmethod.


  method GET_TABLE_STRUCTDESCR.

    DATA:
        lv_relnam      TYPE        string              ,
        "lr_typedesc TYPE REF TO cl_abap_typedescr ,
        lr_structdescr TYPE REF TO cl_abap_structdescr ,
        lr_data        TYPE REF TO data                .

    FIELD-SYMBOLS:
                 <fs_i_table> TYPE ANY.

    " Relative Name can not be obtain when table is empty
    " Create a structure to hack technical constraint.
    IF lines( i_table ) EQ 0.
      " Create structure with type of our empty table
      CREATE DATA lr_data LIKE LINE OF i_table.
      ASSIGN lr_data->* TO <fs_i_table>.

      lr_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_i_table> ).

    ELSE.
      lr_structdescr ?= cl_abap_structdescr=>describe_by_data( i_table ).
    ENDIF.

    r_structdescr = lr_structdescr.

  endmethod.


  method GET_TABLE_TYPEDESCR.

    DATA:
        lv_relnam   TYPE        string            ,
        lr_typedesc TYPE REF TO cl_abap_typedescr ,
        lr_data     TYPE REF TO data              .

    FIELD-SYMBOLS:
                 <fs_i_table> TYPE ANY.

    " Relative Name can not be obtain when table is empty
    " Create a structure to hack technical constraint.
    IF lines( i_table ) EQ 0.
      " Create structure with type of our empty table
      CREATE DATA lr_data LIKE LINE OF i_table.
      ASSIGN lr_data->* TO <fs_i_table>.

      lr_typedesc ?= cl_abap_typedescr=>describe_by_data( <fs_i_table> ).

    ELSE.
      lr_typedesc ?= cl_abap_typedescr=>describe_by_data( i_table ).
    ENDIF.

    r_typedescr = lr_typedesc.

  endmethod.


  method HANDLING.

    GET REFERENCE OF i_structure INTO me->_handle.

  endmethod.


  method ID.

    me->_set_field_map(
      i_msg_field = 'FIELD_ID'
      i_map_field = msgid_field
    ).

    self = me.

  endmethod.


  method MESSAGE.

    me->_set_field_map(
      i_msg_field = 'FIELD_MESSAGE'
      i_map_field = msgtx_field
    ).

    self = me.

  endmethod.


  method MSGV1.

    me->_set_field_map(
      i_msg_field = 'FIELD_MSGV1'
      i_map_field = msgv1_field
    ).

    self = me.

  endmethod.


  method MSGV2.

    me->_set_field_map(
      i_msg_field = 'FIELD_MSGV2'
      i_map_field = msgv2_field
    ).

    self = me.

  endmethod.


  method MSGV3.

    me->_set_field_map(
      i_msg_field = 'FIELD_MSGV3'
      i_map_field = msgv3_field
    ).

    self = me.

  endmethod.


  method MSGV4.

    me->_set_field_map(
      i_msg_field = 'FIELD_MSGV4'
      i_map_field = msgv4_field
    ).

    self = me.

  endmethod.


  method NUMBER.

    me->_set_field_map(
      i_msg_field = 'FIELD_NUMBER'
      i_map_field = msgno_field
    ).

    self = me.

  endmethod.


  method SET.

    " Super Method using dedicated field method
    me->message( msgtx_field ).
    me->id( msgid_field ).
    me->number( msgno_field ).
    me->type( msgty_field ).
    me->msgv1( msgv1_field ).
    me->msgv2( msgv2_field ).
    me->msgv3( msgv3_field ).
    me->msgv4( msgv4_field ).

  endmethod.


  method TYPE.

    me->_set_field_map(
      i_msg_field = 'FIELD_TYPE'
      i_map_field = msgty_field
    ).

    self = me.

  endmethod.


  method _CHECK_COMPONENT.

    DATA:
        lr_typedescr  TYPE REF TO   cl_abap_typedescr                     ,
        lr_strucdescr TYPE REF TO   cl_abap_structdescr                   ,
        lv_type_name  TYPE          string                                ,
        lt_components TYPE          cl_abap_structdescr=>component_table  .

    FIELD-SYMBOLS:
                 <fs_handle> TYPE ANY.


    ASSIGN me->_handle->* TO <fs_handle>.

    lv_type_name = zcl_log_util_define=>get_absolute_name( <fs_handle> ).
    lr_strucdescr ?= cl_abap_structdescr=>describe_by_name( lv_type_name ).
    lt_components = lr_strucdescr->get_components( ).

    READ TABLE lt_components TRANSPORTING NO FIELDS WITH KEY name = i_comp_name.

    IF sy-subrc NE 0.
      " 005 :: Field component & not found in type &
      MESSAGE e005 WITH i_comp_name lv_type_name .
    ENDIF.

  endmethod.


  method _GET_STRUCT_NAME.

    DATA:
        lr_typedesc  TYPE REF TO cl_abap_typedescr   ,
        lr_struct    TYPE REF TO cl_abap_structdescr ,
        lv_strnam    TYPE        string              ,
        lv_obtain(1) TYPE        c                   .

    FIELD-SYMBOLS:
                 <fs_itab>   TYPE ANY TABLE ,
                 <fs_struct> TYPE ANY       ,
                 <fs_comp>   TYPE ANY       .


    DESCRIBE FIELD i_element TYPE DATA(lv_type).

    CASE lv_type.
      WHEN 'h'. " Internal Table
        lr_typedesc = zcl_log_util_define=>get_table_typedescr( i_element ).
        lv_obtain = zcl_log_util_define=>true.

      "WHEN 'v'. " Deep Structure

      "WHEN 'u'. " Flat Structure

      WHEN OTHERS.
        ASSIGN i_element TO <fs_struct>.

    ENDCASE.

    " If typedescr not obtain
    IF lv_obtain NE zcl_log_util_define=>true.
      lr_typedesc ?= cl_abap_typedescr=>describe_by_data( <fs_struct> ).
    ENDIF.



    CASE i_name_kind.
      WHEN 'ABSOLUTE'.
        r_name = lr_typedesc->absolute_name.

      WHEN 'RELATIVE'.
        r_name = lr_typedesc->get_relative_name( ).

      WHEN OTHERS.
        r_name = lr_typedesc->get_relative_name( ).

    ENDCASE.

  endmethod.


  method _SET_FIELD_MAP.

    DATA:
        lt_log_table_map TYPE TABLE OF ty_field_map ,
        ls_log_table_map TYPE          ty_field_map ,
        lv_abs_name      TYPE          string       .

    FIELD-SYMBOLS:
                 <fs_struct>        TYPE any          ,
                 <fs_log_table_map> TYPE ty_field_map ,
                 <fs_comp>          TYPE any          .


    " First of all, check if parameter send is not empty
    CHECK i_map_field IS NOT INITIAL.

    " Next, check if request component exist in handling structure
    me->_check_component( i_map_field ).

    " Get Abs Name of structure
    ASSIGN me->_handle->* TO <fs_struct>.
    lv_abs_name = zcl_log_util_define=>get_absolute_name( <fs_struct> ).

    " Check if structure exist in define table
    READ TABLE me->_log_table_map ASSIGNING <fs_log_table_map> WITH KEY abs_name = lv_abs_name.

    " Assigned only if entry exist
    " -> Update entry
    IF <fs_log_table_map> IS ASSIGNED.
      ASSIGN COMPONENT i_msg_field OF STRUCTURE <fs_log_table_map> TO <fs_comp>.

      IF <fs_comp> IS ASSIGNED.
        <fs_comp> = i_map_field.
      ENDIF.

    " Else
    " -> Create new entry & set.
    ELSE.
      CLEAR ls_log_table_map.
      ls_log_table_map-abs_name = lv_abs_name.
      APPEND ls_log_table_map TO me->_log_table_map.

      me->_set_field_map(
        i_msg_field = i_msg_field
        i_map_field = i_map_field
      ).

    ENDIF.

  endmethod.
ENDCLASS.
