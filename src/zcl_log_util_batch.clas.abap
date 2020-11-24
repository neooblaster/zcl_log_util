class ZCL_LOG_UTIL_BATCH definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SPOOL
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods PROTOCOL
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods A
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods E
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods W
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods S
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods I
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods ALL
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_BATCH .
  methods GET .
protected section.
private section.

  types:
    BEGIN OF TY_MESSAGE_TYPES ,
      a TYPE c LENGTH 1       ,
      e TYPE c LENGTH 1       ,
      w TYPE c LENGTH 1       ,
      s TYPE c LENGTH 1       ,
      i TYPE c LENGTH 1       ,
    END   OF TY_MESSAGE_TYPES .
  types:
    BEGIN OF TY_OUTPUTS_HDL    ,
      spool    TYPE c LENGTH 1 ,
      protocol TYPE c LENGTH 1 ,
    END   OF TY_OUTPUTS_HDL .

  data _SPOOL type TY_MESSAGE_TYPES .
  data _PROTOCOL type TY_MESSAGE_TYPES .
  data _HANDLING_TYPES type TY_MESSAGE_TYPES .
  data _HANDLING_OUTPUT type TY_OUTPUTS_HDL .

  methods _UPDATE .
  methods _UPDATE_VALUE
    importing
      !I_TYPE type NAME_FELD
    changing
      !C_OUTPUT type ANY .
ENDCLASS.



CLASS ZCL_LOG_UTIL_BATCH IMPLEMENTATION.


  method A.

    me->_handling_types-a = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method ALL.
    DATA:
        lv_skip TYPE c LENGTH 1 .

    " If at least one output is checked, we want to handle types
    IF   me->_handling_output-spool    IS NOT INITIAL
      OR me->_handling_output-protocol IS NOT INITIAL.
      me->_handling_types-a = 'X'.
      me->_handling_types-e = 'X'.
      me->_handling_types-w = 'X'.
      me->_handling_types-i = 'X'.
      me->_handling_types-s = 'X'.
      lv_skip = 'X'.
    ENDIF.

    " If at least one types is checked, we want to handle output
    IF (  me->_handling_types-a IS NOT INITIAL
       OR me->_handling_types-e IS NOT INITIAL
       OR me->_handling_types-w IS NOT INITIAL
       OR me->_handling_types-i IS NOT INITIAL
       OR me->_handling_types-s IS NOT INITIAL
    ) AND lv_skip               NE 'X'         .
       me->_handling_output-spool    = 'X'.
       me->_handling_output-protocol = 'X'.
    ENDIF.

    me->_update( ).

    self = me.

  endmethod.


  method CONSTRUCTOR.

    " Set Defaults
    " ──┐ All to Spool
    me->_spool-a = 'X'.
    me->_spool-e = 'X'.
    me->_spool-w = 'X'.
    me->_spool-i = 'X'.
    me->_spool-s = 'X'.

  endmethod.


  method E.

    me->_handling_types-e = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method GET.
  endmethod.


  method I.

    me->_handling_types-i = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method PROTOCOL.

    me->_handling_output-protocol = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method S.

    me->_handling_types-s = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method SPOOL.

    me->_handling_output-spool = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method W.

    me->_handling_types-w = 'X'.
    me->_update( ).

    self = me.

  endmethod.


  method _UPDATE.

    TYPES: BEGIN OF TY_TYPE_LIST ,
             type TYPE name_feld ,
           END   OF TY_TYPE_LIST .

    DATA:
        lv_flg_output_checked TYPE c LENGTH 1            ,
        lv_flg_type_checked   TYPE c LENGTH 1            ,
        lt_type_list          TYPE TABLE OF ty_type_list ,
        ls_type_list          TYPE          ty_type_list .

    " Check if at least one output is checked
    IF   me->_handling_output-spool    IS NOT INITIAL
      OR me->_handling_output-protocol IS NOT INITIAL.
      lv_flg_output_checked = 'X'.
    ENDIF.

    " Check if at least one type is checked
    IF   me->_handling_types-a IS NOT INITIAL
      OR me->_handling_types-e IS NOT INITIAL
      OR me->_handling_types-w IS NOT INITIAL
      OR me->_handling_types-i IS NOT INITIAL
      OR me->_handling_types-s IS NOT INITIAL.
      lv_flg_type_checked = 'X'.
    ENDIF.

    " Apply
    IF lv_flg_output_checked EQ 'X' AND lv_flg_type_checked EQ 'X'.
      APPEND VALUE #( type = 'A' ) TO lt_type_list.
      APPEND VALUE #( type = 'E' ) TO lt_type_list.
      APPEND VALUE #( type = 'W' ) TO lt_type_list.
      APPEND VALUE #( type = 'I' ) TO lt_type_list.
      APPEND VALUE #( type = 'S' ) TO lt_type_list.

     " Updating
      " ──┐ Updating Spool
      IF me->_handling_output-spool IS NOT INITIAL.
        LOOP AT lt_type_list INTO ls_type_list.
         me->_update_value(
           EXPORTING
             i_type   = ls_type_list-type
           CHANGING
             c_output = me->_spool
         ).
        ENDLOOP.
      ENDIF.

      " ──┐ Updating Protocol
      IF me->_handling_output-protocol IS NOT INITIAL.
        LOOP AT lt_type_list INTO ls_type_list.
         me->_update_value(
           EXPORTING
             i_type   = ls_type_list-type
           CHANGING
             c_output = me->_protocol
         ).
        ENDLOOP.
      ENDIF.

     " Updating finished, clear bufferized data.
     CLEAR: me->_handling_output ,
            me->_handling_types  .
    ENDIF.

  endmethod.


  method _UPDATE_VALUE.

    DATA:
        lv_new_value TYPE c LENGTH 1.

    FIELD-SYMBOLS:
                 <fs_comp_hdl> TYPE any ,
                 <fs_comp_out> TYPE any .

    ASSIGN COMPONENT i_type OF STRUCTURE me->_handling_types TO <fs_comp_hdl>.

    IF <fs_comp_hdl> IS ASSIGNED AND <fs_comp_hdl> IS NOT INITIAL.
      ASSIGN COMPONENT i_type OF STRUCTURE c_output TO <fs_comp_out>.

      IF <fs_comp_out> IS ASSIGNED.
        IF <fs_comp_out> EQ 'X'.
          lv_new_value = ''.
        ELSE.
          lv_new_value = 'X'.
        ENDIF.
      ENDIF.
      <fs_comp_out> = lv_new_value.
    ENDIF.

  endmethod.
ENDCLASS.
