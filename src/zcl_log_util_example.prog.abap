*&----------------------------------------------------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&               Report ZCL_LOG_UTIL_EXAMPLE                                  &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&----------------------------[   MAIN INOS   ]-------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&                                                                            &*
*&  Author      : Nicolas DUPRE                                               &*
*&  Release     : xx.xx.2020                                                  &*
*&  Last Change : xx.xx.2020                                                  &*
*&                                                                            &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&---------------------------[   DESCRIPTION   ]------------------------------&*
*&----------------------------------------------------------------------------&*
*& TODO: Overloading / Garder le message d'origine                            &*
*&       ALV         / Voir pour zone technique (OUI/NON)                     &*
*&                                                                            &*
*&                                                                            &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&----------------------------[   REVISIONS   ]-------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&---------------#------------------------------------------------------------&*
*& Date / Author | Updates Descriptions                                       &*
*&---------------#------------------------------------------------------------&*
*&               |                                                            &*
*&---------------#------------------------------------------------------------&*
*&               |                                                            &*
*&---------------#------------------------------------------------------------&*
*&----------------------------------------------------------------------------&*
REPORT ZCL_LOG_UTIL_EXAMPLE MESSAGE-ID zlog_util.



"&----------------------------------------------------------------------------&"
"&   Global Types Definition                                                  &"
"&----------------------------------------------------------------------------&"
" Defining my Output Log Table for ALV
TYPES:  BEGIN OF ty_my_log_str,
          icon     TYPE alv_icon,
          vbeln    TYPE vbeln,
          message  TYPE string,
          filename TYPE string,
          id       TYPE sy-msgid,
          number   TYPE sy-msgno,
          type     TYPE sy-msgty,
          spot     TYPE zdt_log_util_spot,
        END   OF ty_my_log_str.

TYPES:  BEGIN OF  ty_raw_log,
          id TYPE sy-msgid,
          no TYPE sy-msgno,
          ty TYPE sy-msgty,
          v1 TYPE sy-msgv1,
          v2 TYPE sy-msgv2,
          v3 TYPE sy-msgv3,
          v4 TYPE sy-msgv4,
        END   OF  ty_raw_log.

TYPES:  BEGIN OF  ty_custom_bapi_log_table.
          INCLUDE STRUCTURE bapiret2.
TYPES:    fileindex TYPE i,
          lineindex TYPE i,
        END   OF ty_custom_bapi_log_table.

"&----------------------------------------------------------------------------&"
"&   Global Variables                                                         &"
"&----------------------------------------------------------------------------&"
DATA:
    lr_log_util      TYPE REF TO   zcl_log_util  ,
    lt_log_table     TYPE TABLE OF ty_my_log_str ,
    lt_tmp_table     TYPE TABLE OF ty_my_log_str ,
    ls_log_table     TYPE          ty_my_log_str ,
    lt_trace_log     TYPE TABLE OF ty_raw_log    ,
    lt_ret_bapiret2  TYPE TABLE OF bapiret2      , " Example of FM : LE_DLV_DATE_CHANGE
    ls_ret_bapiret2  TYPE          bapiret2      , " Example of FM : LE_DLV_DATE_CHANGE
    lt_ret_prott     TYPE TABLE of prott         , " Example of FM : WS_DELIVERY_UPDATE_2
    ls_ret_prott     TYPE          prott         , " Example of FM : WS_DELIVERY_UPDATE_2
    lv_dummy         TYPE          string        . " Dummy variable to handle MESSAGE statement







*&----------------------------------------------------------------------------&"
*&   Initialization                                                           &"
*&----------------------------------------------------------------------------&"
"INITIALIZATION.
  " [ MANDATORY ] :: Initialization of Log Util class
  " --------------------------------------------------
  zcl_log_util=>factory(
    " Retrieving your object to use in your program
    IMPORTING
      r_log_util  = lr_log_util
    " Linking your log table
    CHANGING
      t_log_table = lt_log_table
  ).

  " [ MANDATORY FOR ] :: Mandatory for custom log tables (your own)
  " [ OPTIONAL  FOR ] :: Optionnal for known* log tables (SAP ones)
  "
  " Notes :
  "   - Here ->define( ) has no paramter. In this case, we are
  "     defining our log table lt_log_table (passed in CHANGING t_log_table)
  "
  " ----------------------------------------------------------------
  " Know Tables Types :
  "   - zcl_log_util=>ty_log_table
  "   - PROTT
  "   - BAPIRET1
  "   - BAPIRET2
  "   - BAPI_CORU_RETURN
  "   - BAPI_ORDER_RETURN
  "   - BDCMSGCOLL
  "   - RCOMP
  " ----------------------------------------------------------------
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Texte (output).
  lr_log_util->define( )->message( 'MESSAGE' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message ID.
  lr_log_util->define( )->id( 'ID' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Number.
  lr_log_util->define( )->number( 'NUMBER' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Type.
  lr_log_util->define( )->type( 'TYPE' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv1.
  lr_log_util->define( )->msgv1( '' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv2.
  lr_log_util->define( )->msgv2( '' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv3.
  lr_log_util->define( )->msgv3( '' ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv4.
  lr_log_util->define( )->msgv4( '' ).

  " [ OPTIONAL ] :: Optionnal to define another custom log table
  "
  " Notes :
  "   -Here we have to passe (at least once) the parameter
  "    to ->define( <param> ) for next methods
  "
  " ---------------------------------------------------------------
  " ──┐ Define another Custom Log Table (like BAPIRET2), Super Method.
  lr_log_util->define( lt_trace_log )->set(
    msgid_field = 'ID'
    msgno_field = 'NO'
    msgty_field = 'TY'
    msgv1_field = 'V1'
    msgv2_field = 'V2'
    msgv3_field = 'V3'
    msgv4_field = 'V4'
  ).


  " [ OPTIONAL  ] :: Configuring Application Log (SLG)
  " ---------------------------------------------------
  " ──┐ Set Main Object
*  lr_log_util->slg( )->set_object( ).
  " ──┐ Set Sub-object
*  lr_log_util->slg( )->set_sub_object( ).
  " ──┐ Set External Number
*  lr_log_util->slg( )->set_ext_number( ).
  " ──┐ Set Retention time
*  lr_log_util->slg( )->set_retention ).

  " ──┐ Configuring Application Log (Super Method)
*  lr_log_util->slg( ).

  " ──┐ Enabling Application Log
*  lr_log_util->slg( )->enable( ).
  " To Disable :
  " lr_log_util->slg( )->disable( ).


  " [ OPTIONAL  ] :: Configuring Overloading
  "
  " Notes : ZCL_LOG_UTIL comes with a dedicated table and this
  "         step is optionnal.
  "         You can configure your customer settings table
  "         to works with
  "
  " Default Table : ZLOG_UTIL_OVERLO (Cf TCODE ZOVERLOG)
  "
  " Redefining for demonstration (already set on when instanciated)
  " ---------------------------------------------------------------
  DATA lr_overload      TYPE REF TO zcl_log_util_overload.
  DATA lr_setting_table TYPE REF TO zcl_log_util_setting_table.

  lr_overload      = lr_log_util->overload( ).
  lr_setting_table = lr_overload->setting_tab( ).

  " --------------------------------------------------------------
  " • Define Table & Message ID, Number & Type Input Fields
  " --------------------------------------------------------------
  " ──┐ Set your custom setting table name
  lr_setting_table->table_name( 'ZLOG_UTIL_OVERLO' ).
  " ──┐ Set Field standing for Input Message ID
  lr_setting_table->source_id( 'INPUT1' ).
  " ──┐ Set Field standing for Input Message Number
  lr_setting_table->source_number( 'INPUT2' ).
  " ──┐ Set Field standing for Input Message Type
  lr_setting_table->source_type( 'INPUT3' ).
  " ──┐ Set Field standing for Spot ID
  lr_setting_table->source_spot( 'INPUT4' ).
  " ──┐ [ OPTIONAL ] :: Set Field standing for Input Parameter 1
  lr_setting_table->source_param1( 'INPUT5' ).
  " ──┐ [ OPTIONAL ] :: Set Field standing for Input Parameter 2
*  lr_setting_table->source_param2( 'INPUT6' ).

  " --------------------------------------------------------------
  " • Define Overload Message ID, Number & Type Output Fields
  " --------------------------------------------------------------
  " ──┐ Set Field standing for overloading Message ID
  lr_setting_table->overload_id( 'OUTPUT1' ).
  " ──┐ Set Field standing for overloading Message Number
  lr_setting_table->overload_number( 'OUTPUT2' ).
  " ──┐ Set Field standing for overloading Message Type
  lr_setting_table->overload_type( 'OUTPUT3' ).
  " ──┐ Set Field standing for overloading Message Replace Value 1
  lr_setting_table->overload_msgv1( 'OUTPUT4' ).
  " ──┐ Set Field standing for overloading Message Replace Value 2
  lr_setting_table->overload_msgv2( 'OUTPUT5' ).
  " ──┐ Set Field standing for overloading Message Replace Value 3
  lr_setting_table->overload_msgv3( 'OUTPUT6' ).
  " ──┐ Set Field standing for overloading Message Replace Value 4
  lr_setting_table->overload_msgv4( 'OUTPUT7' ).

  " --------------------------------------------------------------
  " • [ OPTIONAL ] :: Define Pre filters on table data entries
  " --------------------------------------------------------------
  "
  " Notes : In SAP, many customers has own "global settings table
  "         used in their Core Model.
  "         Entries are ofter identified by WRICEF (DevCode),
  "         the functionnal domain and finally by a code
  "         to identify the entry data kind.
  "         To prevent Overloading using rule dedicated for specific
  "         Program, I advise to use the following filter if
  "         your settings table works like as describe herebefore.
  "
  " --------------------------------------------------------------
  " ──┐ Set Field standing for "Development code"
  lr_setting_table->filter_devcode( 'CODE' ).
  " ──┐ Set Field standing for "Development Domain"
  lr_setting_table->filter_domain( 'DOMAINE' ). " <<< With E due to DOMAIN is Keyword
  " ──┐ Set Field standing for "Kind of data"
  lr_setting_table->filter_data( 'DATA' ).


  " ──┐ Set your custom setting table (Super Method)
  " (here we are overwriting previous setting)
  lr_setting_table->set(
      i_table_name            = 'ZLOG_UTIL_OVERLO'
      i_filter_devcode_field  = 'CODE'              " Optionable
      i_filter_domain_field   = 'DOMAINE'           " Optionable
      i_filter_data_field     = 'DATA'              " Optionable
      i_source_id_field       = 'INPUT1'
      i_source_number_field   = 'INPUT2'
      i_source_type_field     = 'INPUT3'
      i_source_spot_field     = 'INPUT4'
*      i_source_param1_field   = 'INPUT5'            " Optionable
*      i_source_param2_field   = 'INPUT6'            " Optionable
      i_overload_id_field     = 'OUTPUT1'
      i_overload_number_field = 'OUTPUT2'
      i_overload_type_field   = 'OUTPUT3'
      i_overload_msgv1_field  = 'OUTPUT4'            " Optionable
      i_overload_msgv2_field  = 'OUTPUT5'            " Optionable
      i_overload_msgv3_field  = 'OUTPUT6'            " Optionable
      i_overload_msgv4_field  = 'OUTPUT7'            " Optionable
  ).


  " [ OPTIONAL  ] :: Set Overloading Filter value
  " ----------------------------------------------
  lr_overload->set_filter_devcode_value( 'ZCLLOGUTIL' ).
  lr_overload->set_filter_domain_value( 'BC' ).
  lr_overload->set_filter_data_value( 'OVER_LOG' ).


  " [ OPTIONAL  ] :: Enable Overloading
  " ------------------------------------
  lr_overload->enable( ).
  " To disable :
  "lr_overload->disable( ).


  " [ OPTIONAL  ] :: Manage Message Type for Batch Job going to SPOOL
  "
  " Notes : By default, all types will be displayed in Spool
  "         If a type is enable for an output, recalling will disabled it
  "
  " ------------------------------------------------------------------
  DATA: lo_batch TYPE REF TO zcl_log_util_batch.
  lo_batch = lr_log_util->batch( ).

  " ---------------------------------------------------------
  " <<<---[ Managing Spool ]---------------------------------
  " " ──┐
  "lo_batch->spool( )->a( ).
  "lo_batch->spool( )->a( ).
  "lo_batch->spool( )->a( ).
  " <<<---[ Managing Spool ]---------------------------------
  " ---------------------------------------------------------

  " ---------------------------------------------------------
  " <<<---[ Managing Protocol ]------------------------------
  " ──┐ By Default, all are disabled
  "lo_batch->protocol( )->all( ). " All checked for Protocol
  "lo_batch->protocol( )->e( ).   " So recall disabled it
  lo_batch->e( )->all( ).
  " <<<---[ Managing Protocol ]------------------------------
  " ---------------------------------------------------------


*  lr_log_util->batch( )->spool( ).           " All going to spool
*  lr_log_util->batch( )->a( )->spool( ).
*  lr_log_util->batch( )->e( )->spool( ).
*  lr_log_util->batch( )->w( )->spool( ).
*  lr_log_util->batch( )->s( )->spool( ).
*  lr_log_util->batch( )->i( )->spool( ).


  " [ OPTIONAL  ] :: Manage Message Type for Batch Job going to Protocol
  " ---------------------------------------------------------------------
*  lr_log_util->batch( )->protocol( ).        " All going to protocol
*  lr_log_util->batch( )->a( )->protocol( ).
*  lr_log_util->batch( )->e( )->protocol( ).
*  lr_log_util->batch( )->w( )->protocol( ).
*  lr_log_util->batch( )->s( )->protocol( ).
*  lr_log_util->batch( )->i( )->protocol( ).


  " [ OPTIONAL  ] :: Manage Column Display Name
  " --------------------------------------------






*&----------------------------------------------------------------------------&"
*&   Start of processing                                                      &"
*&----------------------------------------------------------------------------&"
"START-OF-SELECTION.



*&----------------------------------------------------------------------------&"
*&   End of processing                                                        &"
*&----------------------------------------------------------------------------&"
"END-OF-SELECTION.

  " ---------------------------------------------------------
  "   How To Logging
  " ---------------------------------------------------------
  "   Management rule for method log( )
  "
  "   • Used without parameter     :
  "     -> Will add entry to your log table with value
  "        available in SY-MSGxx
  "
  "   • Used with one parameter    :
  "
  "   • Used with two parameters   :
  "
  "   • Used with three parameters :
  "
  " ---------------------------------------------------------

  " ---------------------------------------------------------
  " <<<---[ Standard Logging (SY-MSGXX) ]--------------------
  " ──┐ Sent message to dummy to enrich SY-MSGXX
  MESSAGE e100 INTO lv_dummy. " Do not display but allow use case.
  lr_log_util->log( ).

  " ──┐ Sent message to dummy to enrich SY-MSGXX
  MESSAGE e000 INTO lv_dummy. " Do not display but allow use case.
  " e000 will be overload by e107 (cf zoverlog TCODE)
  lr_log_util->log( ).

  " ──┐  Sent message to dummy to enrich SY-MSGXX
  MESSAGE e100 INTO lv_dummy.      " Do not display but allow use case.
  " ──┐ Add own data to my structure
  ls_log_table-icon = '@5C@'.      " Add my own data for log
  " ──┐ Log & Complete data by merging
  lr_log_util->log( )->merging( ls_log_table ).    " Merge them

  " >>>---[ Standard Logging (SY-MSGXX) ]--------------------
  " ---------------------------------------------------------



  " ---------------------------------------------------------
  " <<<---[ Logging Simple Text ]----------------------------
  lr_log_util->log( 'Log simple text (default is type I)'(t01) ).
  lr_log_util->log( 'Very very long text message (maximum handle is 200char. Message will be trim is length is upper than 250 char.'(t02) ).
  " >>>---[ Logging Simple Text ]----------------------------
  " ---------------------------------------------------------



  " ---------------------------------------------------------
  " <<<---[ Logging using Standard* Structure ]--------------
  " * Standard can be a custom if structure has been defined.
  " ──┐ Simulating BAPI Return in structure
  ls_ret_bapiret2-id = 'VL'.
  ls_ret_bapiret2-number = '504'.
  ls_ret_bapiret2-type = 'E'.
  ls_ret_bapiret2-message_v1 = 'PH_BAPIRET2_MSGV1'.
  ls_ret_bapiret2-message_v2 = 'PH_BAPIRET2_MSGV2'.
  ls_ret_bapiret2-message_v3 = 'PH_BAPIRET2_MSGV3'.
  ls_ret_bapiret2-message_v4 = 'PH_BAPIRET2_MSGV4'.

  " ──┐ Log BAPI Structure to my log table
  lr_log_util->log( ls_ret_bapiret2 ).

  " >>>---[ Logging using Standard* Structure ]--------------
  " ---------------------------------------------------------


  " ---------------------------------------------------------
  " <<<---[ Logging using Standard* Tables ]-----------------
  " * Standard can be a custom if table structure has been
  "   defined.
  " ──┐ Simulating BAPI Return in table
  APPEND VALUE #(
    msgno = '505'
    msgid = 'VL'
    msgty = 'W'
    msgv1 = 'PH_PROTT_MSGV1_L1'
    msgv2 = 'PH_PROTT_MSGV2_L1'
    msgv3 = 'PH_PROTT_MSGV3_L1'
    msgv4 = 'PH_PROTT_MSGV4_L1'
  ) TO lt_ret_prott.
  APPEND VALUE #(
    msgno = '506'
    msgid = 'VL'
    msgty = 'E'
    msgv1 = 'PH_PROTT_MSGV1_L2'
    msgv2 = 'PH_PROTT_MSGV2_L2'
    msgv3 = 'PH_PROTT_MSGV3_L2'
    msgv4 = 'PH_PROTT_MSGV4_L2'
  ) TO lt_ret_prott.
  APPEND VALUE #(
    msgno = '507'
    msgid = 'VL'
    msgty = 'I'
    msgv1 = 'PH_PROTT_MSGV1_L3'
    msgv2 = 'PH_PROTT_MSGV2_L3'
    msgv3 = 'PH_PROTT_MSGV3_L3'
    msgv4 = 'PH_PROTT_MSGV4_L3'
  ) TO lt_ret_prott.

  " - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  " ──┐ Log BAPI table to my log table
  ls_log_table-icon = '@J1@'.      " Add my own data for log
  lr_log_util->log( lt_ret_prott )->merging( ls_log_table ). " Mergin will append my 1 lines (structure) to all BAPI message

  " - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  " ──┐ Complete data for BAPI (Only 2 line for 3 message)
  APPEND VALUE #(
    icon = '@5D@'
  ) TO lt_tmp_table.
  APPEND VALUE #(
    icon = '@5C@'
  ) TO lt_tmp_table.

  lr_log_util->log( lt_ret_prott )->merging( lt_tmp_table ). " Mergin will append my 2 lines on 2 first entry of BAPI


  " >>>---[ Logging using Standard* Tables ]-----------------
  " ---------------------------------------------------------


  " ---------------------------------------------------------
  " <<<---[ Quick Logging ]----------------------------------
  " All following method same import parameter than LOG
  " except I_LOG_MSGTY
  " ──┐ Abort
  MESSAGE i108 INTO lv_dummy. " Raised as I, Log as Abort
  lr_log_util->a(  ).

  " ──┐ Error
  MESSAGE i109 INTO lv_dummy. " Raised as I, Log as Error
  lr_log_util->e(  ).

  " ──┐ Warning
  MESSAGE i110 INTO lv_dummy. " Raised as I, Log as Warning
  lr_log_util->w(  ).

  " ──┐ Info
  MESSAGE i111 INTO lv_dummy. " Raised as I, Log as Info
  lr_log_util->i(  ).

  " ──┐ Success
  MESSAGE i112 INTO lv_dummy. " Raised as I, Log as Success
  lr_log_util->s(  ).





  " ---------------------------------------------------------
  "   How To display my log table
  " ---------------------------------------------------------
  " ──┐ Display Collected Log
  lr_log_util->display( ).

  " ──┐ Display Application Log
*  lr_log_util->slg( )->display( ).
