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
      !I_STRUCTURE type ANY default 'INITIAL'
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_DEFINE .
  methods OVERLOAD
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_OVERLOAD .
  methods LOG
    importing
      !I_LOG_CONTENT type ANY default 'INITIAL' .
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
  class-methods GET_ABSOLUTE_NAME
    importing
      !I_ELEMENT type ANY
    returning
      value(R_ABS_NAME) type STRING .
  class-methods _UPDATE_FIELD_OF_STRUCTURE
    importing
      !I_COMP_NAME type NAME_FELD
      !I_VALUE type ANY
    changing
      !C_STRUCTURE type ANY .
protected section.

  class-data TRUE type C value 'X' ##NO_TEXT.
  class-data FALSE type C value ' ' ##NO_TEXT.
private section.

  data _LOG_TABLE type ref to DATA .
  data _LOG_TABLE_BUFFER type ref to DATA .
  data _SPOT type ref to ZCL_LOG_UTIL_SPOT .
  data _DEFINE type ref to ZCL_LOG_UTIL_DEFINE .
  data _OVERLOAD type ref to ZCL_LOG_UTIL_OVERLOAD .

  methods SET_LOG_TABLE
    changing
      !T_LOG_TABLE type STANDARD TABLE .
  methods _CONVERT_TABLE
    importing
      !I_TABLE_TO_CONVERT type ANY TABLE
      !I_TABLE_TO_COPY type ANY TABLE optional
      !I_STRUCTURE_TO_COPY type ANY optional
    returning
      value(R_TABLE_CONVERTED) type ref to DATA .
ENDCLASS.



CLASS ZCL_LOG_UTIL IMPLEMENTATION.


  METHOD CONSTRUCTOR.

  ENDMETHOD.


  method DEFINE.
    DATA:
        lv_element_name TYPE string ,
        lv_i_struc_type TYPE string .

    FIELD-SYMBOLS:
                 <fs_structure> TYPE ANY.

    " Define can only working with structures & tables.
    DESCRIBE FIELD i_structure TYPE lv_i_struc_type.

    " When I_STRUCTURE is not provided, initial value is 'INITIAL' and struc_type is 'C'
    IF lv_i_struc_type NE 'h' AND lv_i_struc_type NE 'v' AND lv_i_struc_type NE 'u' AND i_structure NE 'INITIAL'.
      " 004 :: ZCL_LOG_UTIL->DEFINE expected an internal table or a structure (h,v or u)
      MESSAGE e004.
      EXIT.
    ENDIF.

    " Set handler to specified structure (lv_i_struc_type prevent dump due to it position)
    IF lv_i_struc_type EQ 'C' AND i_structure EQ 'INITIAL'.
      ASSIGN me->_log_table->* TO <fs_structure>.
      me->_define->handling( <fs_structure> ).
    ELSE.
      me->_define->handling( i_structure ).
    ENDIF.

    " Return Instance of define
    self = me->_define.

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

    " --------------------------------------------------------------
    " • Instanciations of sub objects
    " --------------------------------------------------------------
    CREATE OBJECT r_log_util.
    CREATE OBJECT r_log_util->_define.
    CREATE OBJECT r_log_util->_overload.

    r_log_util->set_log_table(
      CHANGING
        t_log_table = t_log_table
    ).



    " --------------------------------------------------------------
    " • Define Structure Field roles
    " --------------------------------------------------------------
    DATA lr_define TYPE REF TO zcl_log_util_define.

    " ──┐ Default Log Table (ty_log_table)

    " ──┐ SY Log Table
    DATA lt_sy TYPE sy.
    lr_define = r_log_util->define( lt_sy ).
    lr_define->set(
      msgid_field = 'MSGID'
      msgno_field = 'MSGNO'
      msgty_field = 'MSGTY'
      msgv1_field = 'MSGV1'
      msgv2_field = 'MSGV2'
      msgv3_field = 'MSGV3'
      msgv4_field = 'MSGV4'
    ).
    " ──┐ PROTT Log Table
    DATA lt_prott TYPE prott.
    lr_define = r_log_util->define( lt_prott ).
    lr_define->set(
      msgid_field = 'MSGID'
      msgno_field = 'MSGNO'
      msgty_field = 'MSGTY'
      msgv1_field = 'MSGV1'
      msgv2_field = 'MSGV2'
      msgv3_field = 'MSGV3'
      msgv4_field = 'MSGV4'
    ).
    " ──┐ BAPIRET1 Log Table
    DATA lt_bapiret1 TYPE bapiret1.
    lr_define = r_log_util->define( lt_bapiret1 ).
    lr_define->set(
      msgid_field = 'ID'
      msgno_field = 'NUMBER'
      msgty_field = 'TYPE'
      msgv1_field = 'MESSAGE_V1'
      msgv2_field = 'MESSAGE_V2'
      msgv3_field = 'MESSAGE_V3'
      msgv4_field = 'MESSAGE_V4'
    ).
    " ──┐ BAPIRET2 Log Table
    DATA lt_bapiret2 TYPE bapiret2.
    lr_define = r_log_util->define( lt_bapiret2 ).
    lr_define->set(
      msgid_field = 'ID'
      msgno_field = 'NUMBER'
      msgty_field = 'TYPE'
      msgv1_field = 'MESSAGE_V1'
      msgv2_field = 'MESSAGE_V2'
      msgv3_field = 'MESSAGE_V3'
      msgv4_field = 'MESSAGE_V4'
    ).
    " ──┐ BAPI_CORU_RETURN Log Table
    DATA lt_bapi_coru_ret TYPE bapi_coru_return.
    lr_define = r_log_util->define( lt_bapi_coru_ret ).
    lr_define->set(
      msgid_field = 'ID'
      msgno_field = 'NUMBER'
      msgty_field = 'TYPE'
      msgv1_field = 'MESSAGE_V1'
      msgv2_field = 'MESSAGE_V2'
      msgv3_field = 'MESSAGE_V3'
      msgv4_field = 'MESSAGE_V4'
    ).
    " ──┐ BAPI_ORDER_RETURN Log Table
    DATA lt_bapi_oder_ret TYPE bapi_order_return.
    lr_define = r_log_util->define( lt_bapi_oder_ret ).
    lr_define->set(
      msgid_field = 'ID'
      msgno_field = 'NUMBER'
      msgty_field = 'TYPE'
      msgv1_field = 'MESSAGE_V1'
      msgv2_field = 'MESSAGE_V2'
      msgv3_field = 'MESSAGE_V3'
      msgv4_field = 'MESSAGE_V4'
    ).
    " ──┐ BDCMSGCOLL Log Table
    DATA lt_bdcmsgcoll TYPE bdcmsgcoll.
    lr_define = r_log_util->define( lt_bdcmsgcoll ).
    lr_define->set(
      msgid_field = 'MSGID'
      msgno_field = 'MSGNR'
      msgty_field = 'MSGTYP'
      msgv1_field = 'MSGV1'
      msgv2_field = 'MSGV2'
      msgv3_field = 'MSGV3'
      msgv4_field = 'MSGV4'
    ).
    " ──┐ HRPAD_MESSAGE Log Table
*
* @TODO : Include structure not managed by strucdescr (currently)
*
*    DATA lt_hrpad_message TYPE hrpad_message.
*    lr_define = r_log_util->define( lt_hrpad_message ).
*    lr_define->set(
*      msgid_field = 'MSGID'
*      msgno_field = 'MSGNO'
*      msgty_field = 'MSGTY'
*      msgv1_field = 'MSGV1'
*      msgv2_field = 'MSGV2'
*      msgv3_field = 'MSGV3'
*      msgv4_field = 'MSGV4'
*    ).
    " ──┐ RCOMP Log Tablessage.
*
* @TODO : Include structure not managed by strucdescr (currently)
*
*    DATA lt_rcomp TYPE rcomp.
*    lr_define = r_log_util->define( lt_rcomp ).
*    lr_define->set(
*      msgid_field = 'MSGID'
*      msgno_field = 'MSGNO'
*      msgty_field = 'MSGTY'
*      msgv1_field = 'MSGV1'
*      msgv2_field = 'MSGV2'
*      msgv3_field = 'MSGV3'
*      msgv4_field = 'MSGV4'
*    ).



    " --------------------------------------------------------------
    " • Defining Default Settings table provided with ZCL_LOG_UTIL
    " --------------------------------------------------------------
    DATA lr_overload      TYPE REF TO zcl_log_util_overload.
    DATA lr_setting_table TYPE REF TO zcl_log_util_setting_table.
    lr_overload      = r_log_util->overload( ).
    lr_setting_table = lr_overload->setting_tab( ).
    lr_setting_table->set(
      i_table_name            = 'ZLOG_UTIL_OVERLO'
      i_filter_devcode_field  = 'CODE'
      i_filter_domain_field   = 'DOMAINE'
      i_filter_data_field     = 'DATA'
      i_source_id_field       = 'INPUT1'
      i_source_number_field   = 'INPUT2'
      i_source_type_field     = 'INPUT3'
      i_source_spot_field     = 'INPUT4'
      i_source_param1_field   = 'INPUT5'
*      i_source_param2_field   = 'INPUT6'
      i_overload_id_field     = 'OUTPUT1'
      i_overload_number_field = 'OUTPUT2'
      i_overload_type_field   = 'OUTPUT3'
      i_overload_msgv1_field  = 'OUTPUT4'
      i_overload_msgv2_field  = 'OUTPUT5'
      i_overload_msgv3_field  = 'OUTPUT6'
      i_overload_msgv4_field  = 'OUTPUT7'
    ).


  endmethod.


  method GET_ABSOLUTE_NAME.

    r_abs_name = zcl_log_util_define=>get_absolute_name( i_element ).

  endmethod.


  method GET_RELATIVE_NAME.

    r_rel_name = zcl_log_util_define=>get_relative_name( i_element ).

  endmethod.


  method LOG.

    DATA: " Variable & Internal Tables
        lv_msgid              TYPE          sy-msgid    ,
        lv_msgno              TYPE          sy-msgno    ,
        lv_msgty              TYPE          sy-msgty    ,
        lv_msgv1              TYPE          sy-msgv1    ,
        lv_msgv2              TYPE          sy-msgv2    ,
        lv_msgv3              TYPE          sy-msgv3    ,
        lv_msgv4              TYPE          sy-msgv4    ,
        lv_msgtx              TYPE          string      ,

        lv_i_log_content_type TYPE          string      ,

        ls_field_definition   TYPE          zcl_log_util_define=>ty_field_map ,
        ls_buff_field_def     TYPE          zcl_log_util_define=>ty_field_map ,
        lt_sy                 TYPE TABLE OF sy          .

    DATA: " References
        lr_converted          TYPE REF TO   data ,
        lr_data               TYPE REF TO   data .

    DATA: " Flags
        lv_flg_use_symsg      TYPE c             . " Log working with sy-msgxx (most basic usage)
                                                   " Log working with entered message texte
                                                   " Log working with entered structure (use definition)
                                                   " Log working with entered table     (use definition)

    FIELD-SYMBOLS:
                 <fs_log_table_t>      TYPE STANDARD TABLE , " Internal Table
                 <fs_log_table_s>      TYPE ANY            , " Structure
                 <fs_log_table_c>      TYPE ANY            , " Component
                 <fs_table_to_convert> TYPE STANDARD TABLE , " Table to convert
                 <fs_table_to_copy>    TYPE STANDARD TABLE , " Table to copy type
                 <fs_buff_structure>   TYPE ANY            . " Structure type of log buffer



    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    " ──┐ Get final (user) table for appending.
    ASSIGN me->_log_table->* TO <fs_log_table_t>.

    " ──┐ Create Structure of user log table.
    CREATE DATA lr_data LIKE LINE OF <fs_log_table_t>.
    ASSIGN lr_data->* TO <fs_log_table_s>.

    " ──┐ Create Structure of buffer table.
    ASSIGN me->_log_table_buffer->* TO <fs_table_to_convert>.
    CREATE DATA lr_converted LIKE LINE OF <fs_table_to_convert>.
    ASSIGN lr_converted->* TO <fs_buff_structure>.

    " ──┐ Get table definition
    ls_field_definition = me->_define->get_definition(
      i_structure = <fs_log_table_s>
    ).



    " --------------------------------------------------------------
    " • Import Parameters management
    " --------------------------------------------------------------
    " ──┐ Import parameters identification
    DESCRIBE FIELD i_log_content TYPE lv_i_log_content_type.

    IF lv_i_log_content_type EQ 'C'.
      IF i_log_content EQ 'INITIAL'.
        lv_flg_use_symsg = zcl_log_util=>true.
      ELSE.
        " @TODO : Only use text (no id no ty) (MESSAGE)
      ENDIF.
    ELSEIF lv_i_log_content_type EQ 'h' OR lv_i_log_content_type EQ 'v' OR lv_i_log_content_type EQ 'u'.
    ENDIF.



    " --------------------------------------------------------------
    " • Message components assignments
    " --------------------------------------------------------------
    " ──┐ Used without parameters
    IF lv_flg_use_symsg EQ zcl_log_util=>true.
      APPEND sy TO lt_sy.
      ASSIGN lt_sy TO <fs_table_to_convert>.
    ENDIF.



    " --------------------------------------------------------------
    " • Convert input to buffer table
    " --------------------------------------------------------------
    me->_log_table_buffer = me->_convert_table(
      EXPORTING
        i_table_to_convert  = <fs_table_to_convert>
        i_structure_to_copy = <fs_buff_structure>
    ).



    " --------------------------------------------------------------
    " • Overloading Buffer
    " --------------------------------------------------------------
    " ──┐ Get Buffer table definition
    ls_buff_field_def = me->_define->get_definition(
      i_structure = <fs_log_table_s>
    ).

    " ──┐ Perform Overloading
    me->overload( )->overload(
      EXPORTING
        i_log_field_def = ls_buff_field_def
      CHANGING
        c_log_table     = me->_log_table_buffer
    ).



    " --------------------------------------------------------------
    " • Registring Buffer in user table
    " --------------------------------------------------------------
      " --------------------------------------------------------------
      " • Making message texte
      " --------------------------------------------------------------
      " -> dans la loop d'appending buff -> userlog



    " --------------------------------------------------------------
    " • Registring in Application Log
    " --------------------------------------------------------------
    " @TODO : Make SLG



  endmethod.


  method OVERLOAD.

    " Return Instance of define
    self = me->_overload.

  endmethod.


  method SET_LOG_TABLE.

    " Referencing User Log Table
    GET REFERENCE OF t_log_table INTO me->_log_table.

    " Create a buffer table for internal manipulations.
    CREATE DATA me->_log_table_buffer TYPE TABLE OF syst.

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


  method _CONVERT_TABLE.

    DATA:
        lr_data_src_t    TYPE REF TO data                              ,
        lr_data_src_s    TYPE REF TO data                              ,
        lr_data_ref      TYPE REF TO data                              ,

        lt_src_field_def TYPE        zcl_log_util_define=>ty_field_map ,
        lt_tgt_field_def TYPE        zcl_log_util_define=>ty_field_map ,

        lv_ref_type      TYPE        string                            ,
        lv_def_idx       TYPE        i                                 .

    FIELD-SYMBOLS:
                 <fs_ref_structure> TYPE ANY            ,
                 <fs_src_structure> TYPE ANY            ,
                 <fs_src_table>     TYPE ANY TABLE      ,
                 <fs_tgt_table>     TYPE STANDARD TABLE ,
                 <fs_sdef_comp>     TYPE ANY            ,
                 <fs_tdef_comp>     TYPE ANY            ,
                 <fs_src_comp>      TYPE ANY            ,
                 <fs_tgt_comp>      TYPE ANY            .



    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    " To perform copy, we need at least a structure
    IF i_table_to_copy IS NOT SUPPLIED AND i_structure_to_copy IS NOT SUPPLIED.
      " 010 :: ZCL_LOG_UTIL->_CONVERT_TABLE expect a table or a structure
      MESSAGE e010.
    ENDIF.

    " If bot are supplied, structure has the priority (performance reason)
    " ──┐ Managing entered structure
    IF i_structure_to_copy IS SUPPLIED.
      lv_ref_type = me->get_absolute_name( i_structure_to_copy ).
    ENDIF.

    " ──┐ Managing entered table only is structure has not been used.
    IF i_table_to_copy IS SUPPLIED AND <fs_ref_structure> IS NOT ASSIGNED.
      lv_ref_type = me->get_absolute_name( i_table_to_copy ).
    ENDIF.

    CREATE DATA lr_data_ref TYPE (lv_ref_type) .
    ASSIGN lr_data_ref->* TO <fs_ref_structure>.

    CREATE DATA r_table_converted TYPE TABLE OF (lv_ref_type).
    ASSIGN r_table_converted->* TO <fs_tgt_table>.



    " --------------------------------------------------------------
    " • Getting definitions
    " --------------------------------------------------------------
    " Get source table structure
    CREATE DATA lr_data_src_s LIKE LINE OF i_table_to_convert.
    ASSIGN lr_data_src_s->* TO <fs_src_structure>.


    " Retrieve both map definition
    lt_src_field_def = me->_define->get_definition(
      i_structure = <fs_src_structure>
    ).
    lt_tgt_field_def = me->_define->get_definition(
      i_structure = <fs_ref_structure>
    ).



    " --------------------------------------------------------------
    " • Perform conversion
    " --------------------------------------------------------------
    ASSIGN i_table_to_convert[] TO <fs_src_table>.
    LOOP AT <fs_src_table> ASSIGNING <fs_src_structure>.
      CLEAR <fs_ref_structure>.

      " Index to read definition structure component
      " Source & Target use the same structure of definition
      " So we can loop to perform convertion (instead of managing each field)
      lv_def_idx = 3. " First field is the TYPE_NAME and the second one will handle MESSAGE_TEXT

      DO.
        ASSIGN COMPONENT lv_def_idx OF STRUCTURE lt_src_field_def TO <fs_sdef_comp>.
        ASSIGN COMPONENT lv_def_idx OF STRUCTURE lt_tgt_field_def TO <fs_tdef_comp>.

        " End of reading of definition structure
        IF sy-subrc NE 0.
          EXIT.
        ENDIF.

        " Get component of Source table
        ASSIGN COMPONENT <fs_sdef_comp> OF STRUCTURE <fs_src_structure> TO <fs_src_comp>.

        " Get component of Target table
        ASSIGN COMPONENT <fs_tdef_comp> OF STRUCTURE <fs_ref_structure> TO <fs_tgt_comp>.

        " Updating
        IF <fs_src_comp> IS ASSIGNED AND <fs_tgt_comp> IS ASSIGNED.
          <fs_tgt_comp> = <fs_src_comp>.
        ENDIF.

        " Next component
        lv_def_idx = lv_def_idx + 1.
      ENDDO.

      " Append converted to table
      APPEND <fs_ref_structure> TO <fs_tgt_table>.

    ENDLOOP.

  endmethod.


  method _UPDATE_FIELD_OF_STRUCTURE.

    FIELD-SYMBOLS:
                 <fs_comp> TYPE ANY.

    ASSIGN COMPONENT i_comp_name OF STRUCTURE c_structure TO <fs_comp>.

    " @TODO : Check for field validation (type & lenght)
    IF <fs_comp> IS ASSIGNED.
      TRY.
        <fs_comp> = i_value.
      ENDTRY.
    ENDIF.

  endmethod.
ENDCLASS.
