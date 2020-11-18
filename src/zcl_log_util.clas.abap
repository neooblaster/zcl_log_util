class ZCL_LOG_UTIL definition
  public
  final
  create public
  shared memory enabled .

public section.

  types:
    BEGIN OF ty_log_table ,
            icon    TYPE alv_icon,
            message TYPE md_message_text,
            id      TYPE sy-msgid,
            number  TYPE sy-msgno,
            type    TYPE sy-msgty,
            spot    TYPE zdt_log_util_spot,
          END   OF ty_log_table .

  methods CONSTRUCTOR .
  class-methods FACTORY
    exporting
      !R_LOG_UTIL type ref to ZCL_LOG_UTIL
    changing
      !T_LOG_TABLE type STANDARD TABLE .
  methods DEFINE
    importing
      !I_STRUCTURE type ANY
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods LOG .
  methods DISPLAY .
  methods SPOT
    importing
      !SPOT type ZDT_LOG_UTIL_SPOT optional
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SPOT
    raising
      ZCX_LOG_UTIL .
  class-methods GET_RELATIVE_NAME
    importing
      !I_ELEMENT type ANY
    returning
      value(R_REL_NAME) type STRING .
protected section.

  class-data TRUE type C value 'X' ##NO_TEXT.
  class-data FALSE type C value ' ' ##NO_TEXT.
private section.

  data _LOG_TABLE type ref to DATA .
  data _SPOT type ref to ZCL_LOG_UTIL_SPOT .
  data _DEFINE type ref to ZCL_LOG_UTIL_DEFINE .
  data _DEFINE_STRUCTURE type STRING .

  methods SET_LOG_TABLE
    changing
      !T_LOG_TABLE type STANDARD TABLE .
  class-methods _GET_TABLE_REL_NAME
    importing
      !I_TABLE type STANDARD TABLE
    returning
      value(R_NAME) type STRING .
ENDCLASS.



CLASS ZCL_LOG_UTIL IMPLEMENTATION.


  METHOD CONSTRUCTOR.

  ENDMETHOD.


  method DEFINE.
    DATA:
        lv_element_name TYPE string ,
        lv_i_struc_type TYPE string .

    " Define can only working with structures & tables.
    DESCRIBE FIELD i_structure TYPE lv_i_struc_type.

    IF lv_i_struc_type NE 'h' AND lv_i_struc_type NE 'v' AND lv_i_struc_type NE 'u'.
      " 004 :: ZCL_LOG_UTIL->DEFINE expected an internal table or a structure (h,v or u)
      MESSAGE e004.
      EXIT.
    ENDIF.

    " Get the relative name of provided element
    lv_element_name = zcl_log_util=>get_relative_name( i_structure ).


    "
    self = me->_define.



    " [X]Récupérer le type absolute
    " [ ]Si type de structure différent, on reinstancy
    " [ ]si pas bound, le bound



*    DATA:
*    lr_log_util_spot TYPE REF TO zcl_log_util_spot
*    .
*
*    " If not yet instanciated
*    IF me->_spot IS NOT BOUND.
*      CREATE OBJECT lr_log_util_spot
*        EXPORTING spot = spot.
*
*      lr_log_util_spot = me->_spot = lr_log_util_spot.
*    ENDIF.
*
*    self = me->_spot.

  endmethod.


  METHOD DISPLAY.

    DATA:
        lr_table       TYPE REF TO   cl_salv_table            ,
        lr_functions   TYPE REF TO   cl_salv_functions        ,
        lr_display     TYPE REF TO   cl_salv_display_settings ,
        lr_columns     TYPE REF TO   cl_salv_columns_table    ,
        lr_column      TYPE REF TO   cl_salv_column_table     ,
        key            TYPE          salv_s_layout_key        ,
        lv_error_msg   TYPE          string                   ,
        lr_tabl_desc   TYPE REF TO   cl_abap_structdescr      ,
        lt_tabl_comp   TYPE          abap_compdescr_tab       ,
        lr_data        TYPE REF TO   data                     ,
        lv_assigned(1) TYPE          c                        .

    FIELD-SYMBOLS:
                 <fst_log_table> TYPE any table ,
                 <fss_log_table> TYPE any       .




    " @TODO : temp table
    DATA lt_tmp_table TYPE TABLE OF ekko.


    " @TODO : Depending of mode (sy-batch)
    " CHECK lines( lt_error_rep ) > 0.


    " Convert Reference Data to table
    ASSIGN me->_log_table->* TO <fst_log_table>.

    " @TODO : voir si lines marche sur field symbol
    " Check if table is not empty
    LOOP AT <fst_log_table> ASSIGNING <fss_log_table>.
      lv_assigned = 'X'.
      EXIT.
    ENDLOOP.

    "CHECK lv_assigned EQ 'X'.
    IF lv_assigned NE 'X'.
      " 003 :: There is no entry in the log table to display
      MESSAGE i003.
      EXIT.
    ENDIF.

    TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lr_table
        CHANGING
          t_table      = <fst_log_table>
      ).
      CATCH cx_salv_msg.
    ENDTRY.

    lr_functions = lr_table->get_functions( ).
    lr_functions->set_all( zcl_log_util=>true ).

    lr_display = lr_table->get_display_settings( ).
    lr_display->set_striped_pattern( cl_salv_display_settings=>true ).

    lr_columns = lr_table->get_columns( ).
    lr_columns->set_optimize( cl_salv_display_settings=>true ).

    " @TODO : Management des colonnes (nom des colonnes)
    " Nom d'affichage de la colonne NUMOP
*    TRY.
*        lr_column ?= lr_columns->get_column( 'NUMOP' ).
*      CATCH cx_salv_not_found.
*    ENDTRY.
*    lr_column->set_long_text( 'Livraison'(901) ).   " l 40
*    lr_column->set_medium_text( 'Livraison'(901) ). " l 20
*    lr_column->set_short_text( 'Livraison'(901) ).  " l 10

*    lr_layout = lr_table->get_layout( ).
*    key-report = sy-repid.
*    lr_layout->set_key( key ).
*    lr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).
    lr_table->display( ).

  ENDMETHOD.


  method FACTORY.

    CREATE OBJECT r_log_util.
    CREATE OBJECT r_log_util->_define.

    r_log_util->set_log_table(
      CHANGING
        t_log_table = t_log_table
    ).


    " Define Structure Field roles
    " ──┐ Default Log Table (ty_log_table)
    " ──┐ PROTT Log Table
    " ──┐ BAPIRET1 Log Table
    " ──┐ BAPIRET2 Log Table
    " ──┐ BAPI_CORU_RETURN Log Table
    " ──┐ BAPI_ORDER_RETURN Log Table
    " ──┐ BDCMSGCOLL Log Table
    " ──┐ HRPAD_MESSAGE Log Table
    " ──┐ RCOMP Log Table

  endmethod.


  method GET_RELATIVE_NAME.

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
        lv_strnam = zcl_log_util=>_get_table_rel_name( i_element ).
        lv_obtain = zcl_log_util=>true.

      "WHEN 'v'. " Deep Structure

      "WHEN 'u'. " Flat Structure

      WHEN OTHERS.
        ASSIGN i_element TO <fs_struct>.

    ENDCASE.

    " If relative name has not been already obtained (depending of type)
    IF lv_obtain NE zcl_log_util=>true.
      lr_typedesc ?= cl_abap_typedescr=>describe_by_data( <fs_struct> ).
      lv_strnam    = lr_typedesc->get_relative_name( ).
    ENDIF.

    r_rel_name = lv_strnam.

  endmethod.


  method LOG.

    FIELD-SYMBOLS:
                 <fst_log_table> TYPE ANY TABLE ,
                 <fss_log_table> TYPE ANY       ,
                 <fsf_field>     TYPE ANY       .

    " Assign referenced table data for manipulation
    ASSIGN me->_log_table->* TO <fst_log_table>.

    IF <fst_log_table> IS ASSIGNED.
      LOOP AT <fst_log_table> ASSIGNING <fss_log_table>.
        IF <fss_log_table> IS ASSIGNED.
          "ASSIGN COMPONENT (lv_comp)
          ASSIGN COMPONENT 'MESSAGE' OF STRUCTURE <fss_log_table> TO <fsf_field>.

          IF <fsf_field> IS ASSIGNED.
            <fsf_field> = sy-msgid.
            UNASSIGN <fsf_field>.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

  endmethod.


  method SET_LOG_TABLE.

    " Referencing User Log Table
    GET REFERENCE OF t_log_table INTO me->_log_table.

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
    ENDIF.

    self = me->_spot.

  endmethod.


  method _GET_TABLE_REL_NAME.

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

    r_name = lr_typedesc->get_relative_name( ).

  endmethod.
ENDCLASS.
