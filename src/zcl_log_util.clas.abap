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
      !I_LOG_CONTENT type ANY default 'INITIAL'
    returning
      value(SELF) type ref to ZCL_LOG_UTIL .
  methods MERGING
    importing
      !I_STRUCTURE type ANY optional .
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
  data _LOG_LINES_BEFORE_LOG type I .
  data _LOG_LINES_AFTER_LOG type I .
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
  class-methods _COUNT_TABLE_LINES
    importing
      !I_TABLE type STANDARD TABLE
    returning
      value(R_LINES) type I .
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
        lt_sy                 TYPE TABLE OF sy          ,

        " ──┐ Definition Table Field Names
        lv_fmms               TYPE name_feld            , " Definition Table Message Text
        lv_fmid               TYPE name_feld            , " Definition Table Message ID
        lv_fmno               TYPE name_feld            , " Definition Table Message Numbert
        lv_fmty               TYPE name_feld            , " Definition Table Message Type
        lv_fmv1               TYPE name_feld            , " Definition Table Message Value 1
        lv_fmv2               TYPE name_feld            , " Definition Table Message Value 2
        lv_fmv3               TYPE name_feld            , " Definition Table Message Value 3
        lv_fmv4               TYPE name_feld            . " Definition Table Message Value 4

    DATA: " References
        lr_converted          TYPE REF TO   data ,
        lr_data               TYPE REF TO   data .

    DATA: " Flags
        lv_flg_use_symsg      TYPE c             , " Log working with sy-msgxx (most basic usage)
        lv_flg_use_msgtx      TYPE c             , " Log working with entered message texte
        lv_flg_use_struc      TYPE c             , " Log working with entered structure (use definition)
        lv_flg_use_table      TYPE c             . " Log working with entered table     (use definition)

    FIELD-SYMBOLS:
                 <fs_log_table_t>      TYPE STANDARD TABLE , " Internal Table
                 <fs_log_table_s>      TYPE ANY            , " Structure
                 <fs_log_table_c>      TYPE ANY            , " Component
                 <fs_table_to_convert> TYPE STANDARD TABLE , " Table to convert
                 <fs_sruct_to_convert> TYPE ANY            , " Structure to convert
                 <fs_table_to_copy>    TYPE STANDARD TABLE , " Table to copy type
                 <fs_buff_structure>   TYPE ANY            , " Structure type of log buffer
                 <fs_buff_table>       TYPE STANDARD TABLE , " Buffer Table

                 <fs_msgid>            TYPE ANY            , " Value of Message ID from Buffer
                 <fs_msgno>            TYPE ANY            , " Value of Message Number from Buffer
                 <fs_msgty>            TYPE ANY            , " Value of Message Type from Buffer
                 <fs_msgv1>            TYPE ANY            , " Value of Message V1 from Buffer
                 <fs_msgv2>            TYPE ANY            , " Value of Message V2 from Buffer
                 <fs_msgv3>            TYPE ANY            , " Value of Message V3 from Buffer
                 <fs_msgv4>            TYPE ANY            . " Value of Message V4 from Buffer



    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    " ──┐ Get final User table log for appending.
    ASSIGN me->_log_table->* TO <fs_log_table_t>.

    " ──┐ Count current number lines of logs
    DESCRIBE TABLE <fs_log_table_t> LINES me->_log_lines_before_log.

    " ──┐ Create Structure of user log table.
    CREATE DATA lr_data LIKE LINE OF <fs_log_table_t>.
    ASSIGN lr_data->* TO <fs_log_table_s>.

    " ──┐ Create Structure of buffer table.
*    ASSIGN me->_log_table_buffer->* TO <fs_table_to_convert>.
*    CREATE DATA lr_converted LIKE LINE OF <fs_table_to_convert>.
*    ASSIGN lr_converted->* TO <fs_buff_structure>.
    ASSIGN me->_log_table_buffer->* TO <fs_buff_table>.
    CREATE DATA lr_converted LIKE LINE OF <fs_buff_table>.
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

    ELSEIF lv_i_log_content_type EQ 'h'.
      lv_flg_use_table = zcl_log_util=>true.

    ELSEIF lv_i_log_content_type EQ 'v' OR lv_i_log_content_type EQ 'u'.
      lv_flg_use_struc = zcl_log_util=>true.

    ENDIF.



    " --------------------------------------------------------------
    " • Bufferization depending of message component
    " --------------------------------------------------------------
    " ──┐ Used without parameters
    IF lv_flg_use_symsg EQ zcl_log_util=>true.
      APPEND sy TO lt_sy.

      " Convert input to buffer
      me->_log_table_buffer = me->_convert_table(
        EXPORTING
          i_table_to_convert  = lt_sy
          i_structure_to_copy = <fs_buff_structure>
      ).
    ENDIF.

    " ──┐ Used one parameters (Entered texte, structure or table)
    " ─────┐ Message texte entered
    IF lv_flg_use_msgtx EQ zcl_log_util=>true.
      " @TODO : Managing simple message texte
    ENDIF.
    " ─────┐ Structure with message components
    IF lv_flg_use_struc EQ zcl_log_util=>true.
      CREATE DATA lr_data LIKE TABLE OF i_log_content.
      ASSIGN lr_data->* TO <fs_table_to_convert>.
      APPEND i_log_content TO <fs_table_to_convert>.

      " Convert input to buffer
      me->_log_table_buffer = me->_convert_table(
        EXPORTING
          i_table_to_convert  = <fs_table_to_convert>
          i_structure_to_copy = <fs_buff_structure>
      ).
    ENDIF.
    " ─────┐ Log message table with message components
    IF lv_flg_use_table EQ zcl_log_util=>true.
      " Convert input to buffer
      me->_log_table_buffer = me->_convert_table(
        EXPORTING
          i_table_to_convert  = i_log_content
          i_structure_to_copy = <fs_buff_structure>
      ).
    ENDIF.



    " --------------------------------------------------------------
    " • Overloading Buffer
    " --------------------------------------------------------------
    " ──┐ Get Buffer table definition
    ls_buff_field_def = me->_define->get_definition(
      i_structure = <fs_buff_structure>
    ).

    " ──┐ Get Field containing Messagae component (variable to ease readability)
    lv_fmid  = ls_buff_field_def-field_id .
    lv_fmno  = ls_buff_field_def-field_number .
    lv_fmty  = ls_buff_field_def-field_type .
    lv_fmv1  = ls_buff_field_def-field_msgv1 .
    lv_fmv2  = ls_buff_field_def-field_msgv2 .
    lv_fmv3  = ls_buff_field_def-field_msgv3 .
    lv_fmv4  = ls_buff_field_def-field_msgv4 .

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
    ASSIGN me->_log_table_buffer->* TO <fs_buff_table>.

    LOOP AT <fs_buff_table> ASSIGNING <fs_buff_structure>.
      " Set to initial value
      CLEAR : lv_msgid ,
              lv_msgno ,
              lv_msgty ,
              lv_msgv1 ,
              lv_msgv2 ,
              lv_msgv3 ,
              lv_msgv4 .

      " Get Back Message component from buffer table
      " ──┐ ID
      IF lv_fmid IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmid OF STRUCTURE <fs_buff_structure> TO <fs_msgid>.
        IF <fs_msgid> IS ASSIGNED.
          lv_msgid = <fs_msgid>.
        ENDIF.
      ENDIF.

      " ──┐ Number
      IF lv_fmno IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmno OF STRUCTURE <fs_buff_structure> TO <fs_msgno>.
        IF <fs_msgno> IS ASSIGNED.
          lv_msgno = <fs_msgno>.
        ENDIF.
      ENDIF.

      " ──┐ Type
      IF lv_fmty IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmty OF STRUCTURE <fs_buff_structure> TO <fs_msgty>.
        IF <fs_msgty> IS ASSIGNED.
          lv_msgty = <fs_msgty>.
        ENDIF.
      ENDIF.

      " ──┐ Message V1
      IF lv_fmv1 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmv1 OF STRUCTURE <fs_buff_structure> TO <fs_msgv1>.
        IF <fs_msgv1> IS ASSIGNED.
          lv_msgv1 = <fs_msgv1>.
        ENDIF.
      ENDIF.

      " ──┐ Message V2
      IF lv_fmv2 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmv2 OF STRUCTURE <fs_buff_structure> TO <fs_msgv2>.
        IF <fs_msgv2> IS ASSIGNED.
          lv_msgv2 = <fs_msgv2>.
        ENDIF.
      ENDIF.

      " ──┐ Message V3
      IF lv_fmv3 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmv3 OF STRUCTURE <fs_buff_structure> TO <fs_msgv3>.
        IF <fs_msgv3> IS ASSIGNED.
          lv_msgv3 = <fs_msgv3>.
        ENDIF.
      ENDIF.

      " ──┐ Message V4
      IF lv_fmv4 IS NOT INITIAL.
        ASSIGN COMPONENT lv_fmv4 OF STRUCTURE <fs_buff_structure> TO <fs_msgv4>.
        IF <fs_msgv4> IS ASSIGNED.
          lv_msgv4 = <fs_msgv4>.
        ENDIF.
      ENDIF.

      " Making Message Texte (Only if ID, Number & Type are provided)
      IF lv_msgid IS NOT INITIAL AND lv_msgno IS NOT INITIAL AND lv_msgty IS NOT INITIAL.
        MESSAGE ID lv_msgid TYPE lv_msgty NUMBER lv_msgno
        INTO lv_msgtx
        WITH lv_msgv1 lv_msgv1 lv_msgv1 lv_msgv1.
      ENDIF.


      " ──┐ Fill fields of structure
      " ──────┐ Processing MESSAGE
      IF ls_field_definition-field_message IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_message
            i_value     = lv_msgtx
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing ID
      IF ls_field_definition-field_id IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_id
            i_value     = lv_msgid
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing NUMBER
      IF ls_field_definition-field_number IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_number
            i_value     = lv_msgno
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing TYPE
      IF ls_field_definition-field_type IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_type
            i_value     = lv_msgty
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing MSGV1
      IF ls_field_definition-field_msgv1 IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_msgv1
            i_value     = lv_msgv1
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing MSGV2
      IF ls_field_definition-field_msgv2 IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_msgv2
            i_value     = lv_msgv2
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing MSGV3
      IF ls_field_definition-field_msgv3 IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_msgv3
            i_value     = lv_msgv3
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.

      " ──────┐ Processing MSGV4
      IF ls_field_definition-field_msgv4 IS NOT INITIAL.
        zcl_log_util=>_update_field_of_structure(
          EXPORTING
            i_comp_name = ls_field_definition-field_msgv4
            i_value     = lv_msgv4
          CHANGING
            c_structure = <fs_log_table_s>
        ).
      ENDIF.


      " ──┐ Append entry (IMPORTANT : <fs_log_table_t> must be type STANDARD TABLE)
      APPEND <fs_log_table_s> TO <fs_log_table_t>.

    ENDLOOP.

    " Clear Buffer Table
    REFRESH <fs_buff_table>.

    " Count number lines of logs after appending
    DESCRIBE TABLE <fs_log_table_t> LINES me->_log_lines_after_log.



    " --------------------------------------------------------------
    " • Registring in Application Log
    " --------------------------------------------------------------
    " @TODO : Make SLG





    " --------------------------------------------------------------
    " • Returning Self
    " --------------------------------------------------------------
    self = me.

  endmethod.


  method MERGING.

    TYPES: BEGIN OF ty_comp_list  ,
             comp  TYPE name_feld ,
           END   OF ty_comp_list  .

    DATA:
        lv_appended_lines    TYPE           i      ,
        lv_provded_lines     TYPE           i      ,
        lv_starting_index    TYPE           i      ,
        lv_i_struct_type     TYPE           string ,
        lv_merge_mode        TYPE           string ,

        ls_log_def           TYPE zcl_log_util_define=>ty_field_map    ,
        lt_log_comp          TYPE cl_abap_structdescr=>component_table ,
        lr_log_structdescr   TYPE REF TO cl_abap_structdescr           ,
        ls_merge_def         TYPE zcl_log_util_define=>ty_field_map    ,
        lt_merge_comp        TYPE cl_abap_structdescr=>component_table ,
        ls_merge_comp        LIKE LINE OF  lt_merge_comp               ,
        lr_merge_structdescr TYPE REF TO cl_abap_structdescr           ,
        lt_def_comp          TYPE cl_abap_structdescr=>component_table ,
        lr_def_structdescr   TYPE REF TO cl_abap_structdescr           ,
        lv_type_name         TYPE          string                      ,
        lr_data              TYPE REF TO   data                        ,
        lr_data2             TYPE REF TO   data                        ,

        lt_comp_list         TYPE TABLE OF ty_comp_list                ,
        ls_comp_list         TYPE          ty_comp_list                ,
        lv_comp              TYPE          name_feld                   .


    FIELD-SYMBOLS:
                 <fs_log_table_t>   TYPE STANDARD TABLE ,
                 <fs_log_table_s>   TYPE ANY            ,
                 <fs_mer_table_t>   TYPE ANY TABLE      ,
                 <fs_mer_table_s>   TYPE ANY            ,
                 <fs_def_comp>      TYPE ANY            ,
                 <fs_comp>          TYPE ANY            .



    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    " ──┐ Count number of line appended
    lv_appended_lines = me->_log_lines_after_log - me->_log_lines_before_log.

    " ──┐ Count providing line for merging
    DESCRIBE FIELD i_structure TYPE lv_i_struct_type.

    IF lv_i_struct_type EQ 'h'.
      lv_provded_lines = zcl_log_util=>_count_table_lines( i_structure ).

    ELSE.
      lv_provded_lines = 1.
    ENDIF.

    " ──┐ Determining the merging process :
    IF lv_provded_lines EQ 1.
      " When merge is a structure, complete field (one to many)
      " With these data.
      lv_merge_mode = 'ONE_TO_ALL'.

    ELSEIF lv_appended_lines EQ lv_provded_lines.
      " When merge is a table with the same number of append
      " log, we complete field one by one (n to n).
      lv_merge_mode = 'ONE_TO_ONE'.

    ELSE.
      " Else, we have a difference between appended log and
      " provided completing data
      " Merge ONE_TO_ONE and left other to blank
      " -> In fine, the same process (until change management rule)
      "    -> To see if we complete all leaving entries with the last
      "       line provided for completion ??? In that case, a third process
      "       will come.
      lv_merge_mode = 'ONE_TO_ONE'.

    ENDIF.

    " ──┐ Identifying source data (Definition & Components)
    " ─────┐ Log Table
    ASSIGN me->_log_table->* TO <fs_log_table_t>.
    CREATE DATA lr_data LIKE <fs_log_table_t>.
    ASSIGN lr_data->* TO <fs_log_table_t>.
    lr_log_structdescr   = zcl_log_util_define=>get_table_structdescr( <fs_log_table_t> ).
    lt_log_comp          = lr_log_structdescr->get_components( ).
    ls_log_def           = me->_define->get_definition( <fs_log_table_t> ).
    " ─────┐ Provided structure for merge
    CREATE DATA lr_data LIKE TABLE OF i_structure.
    ASSIGN lr_data->* TO <fs_log_table_t>.
    lr_merge_structdescr   = zcl_log_util_define=>get_table_structdescr( <fs_log_table_t> ).
    lt_merge_comp          = lr_merge_structdescr->get_components( ).
    ls_merge_def           = me->_define->get_definition( <fs_log_table_t> ).
    " ─────┐ Definition Structure Component to get values
    CREATE DATA lr_data LIKE TABLE OF ls_log_def.
    ASSIGN lr_data->* TO <fs_log_table_t>.
    lr_def_structdescr   = zcl_log_util_define=>get_table_structdescr( <fs_log_table_t> ).
    lt_def_comp          = lr_def_structdescr->get_components( ).

    " From Definition structure components, retrieve
    " fields to exclude on log & provided structures
    LOOP AT lt_def_comp INTO DATA(ls_def_comp).
      ASSIGN COMPONENT ls_def_comp-name OF STRUCTURE ls_log_def TO <fs_def_comp>.

      IF <fs_def_comp> IS ASSIGNED AND <fs_def_comp> IS NOT INITIAL.
        ls_comp_list-comp = <fs_def_comp>.
        APPEND ls_comp_list TO lt_comp_list.
      ENDIF.
    ENDLOOP.


    " --------------------------------------------------------------
    " • Merge data
    " --------------------------------------------------------------
    CASE lv_merge_mode.
      WHEN 'ONE_TO_ALL'.
        lv_starting_index = me->_log_lines_before_log + 1.

        " We will loop on User Log Table, only on new lines
        ASSIGN me->_log_table->* TO <fs_log_table_t>.
        LOOP AT <fs_log_table_t> ASSIGNING <fs_log_table_s> FROM lv_starting_index.

          " Loop on field of provided structure
          LOOP AT lt_merge_comp INTO ls_merge_comp.
            lv_comp = ls_merge_comp-name.
            " Retrive provided value to for merging
            ASSIGN COMPONENT lv_comp OF STRUCTURE i_structure TO <fs_comp>.

            " Merging
            IF <fs_comp> IS ASSIGNED AND <fs_comp> IS NOT INITIAL.
              zcl_log_util=>_update_field_of_structure(
                EXPORTING
                  i_comp_name = lv_comp
                  i_value     = <fs_comp>
                CHANGING
                  c_structure = <fs_log_table_s>
              ).
            ENDIF.
          ENDLOOP.

        ENDLOOP.



      WHEN 'ONE_TO_ONE'.
      WHEN OTHERS.

    ENDCASE.

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


  method _COUNT_TABLE_LINES.

    " Has input parameter is type "ANY", we can not perform "lines( )"
    " on structures. This method specifies type "STANDARD TABLE"
    " so ABAP ocmpiler accept statement.

    r_lines = lines( i_table ).

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
