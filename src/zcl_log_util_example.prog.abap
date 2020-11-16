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
REPORT ZCL_LOG_UTIL_EXAMPLE.



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



"&----------------------------------------------------------------------------&"
"&   Global Variables                                                         &"
"&----------------------------------------------------------------------------&"
DATA:
    lr_log_util      TYPE REF TO   zcl_log_util,
    lt_log_table     TYPE TABLE OF ty_my_log_str,
    ls_log_table     TYPE          ty_my_log_str,
    lt_ret_bapiret2  TYPE TABLE OF bapiret2,        " Example of FM : LE_DLV_DATE_CHANGE
    lt_ret_prott     TYPE TABLE of prott            " Example of FM : WS_DELIVERY_UPDATE_2
    .






*&----------------------------------------------------------------------------&"
*&   Initialization                                                           &"
*&----------------------------------------------------------------------------&"
INITIALIZATION.
  " [ MANDATORY ] :: Initialization of Log Util class
  " --------------------------------------------------
  CREATE OBJECT lr_log_util.


  " [ OPTIONAL  ] :: Defining my type of log table
  " -----------------------------------------------
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message ID.
*  lr_log_util->define( )->id( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Number.
*  lr_log_util->define( )->number( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Type.
*  lr_log_util->define( )->type( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv1.
*  lr_log_util->define( )->msgv1( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv2.
*  lr_log_util->define( )->msgv2( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv3.
*  lr_log_util->define( )->msgv3( ).
  " ──┐ Define Custom Log Table (like BAPIRET2), field receiving Message Msgv4.
*  lr_log_util->define( )->msgv4( ).

  " ──┐ Define Custom Log Table (like BAPIRET2), Super Method.
*  lr_log_util->define( ).


  " [ OPTIONAL  ] :: Specifing With Log Table definition will use
  " --------------------------------------------------------------


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
  " -----------------------------------------
  " ──┐ Set your custom setting table name
*  lr_log_util->overloading( )->setting_table( )->set_table( ).
  " ──┐ Set Field standing for Input Message ID
*  lr_log_util->overloading( )->setting_table( )->set_source_id( ).
  " ──┐ Set Field standing for Input Message Number
*  lr_log_util->overloading( )->setting_table( )->set_source_number( ).
  " ──┐ Set Field standing for Input Message Type
*  lr_log_util->overloading( )->setting_table( )->set_source_type( ).
  " ──┐ Set Field standing for Spot ID
*  lr_log_util->overloading( )->setting_table( )->set_source_spot( ).
  " ──┐ [ OPTIONAL ] :: Set Field standing for Input Parameter 1
*  lr_log_util->overloading( )->setting_table( )->set_source_param_1( ).
  " ──┐ [ OPTIONAL ] :: Set Field standing for Input Parameter 2
*  lr_log_util->overloading( )->setting_table( )->set_source_param_2( ).
  " ──┐ [ OPTIONAL ] :: Set Field standing for Input Parameter 3
*  lr_log_util->overloading( )->setting_table( )->set_source_param_3( ).
  " ──┐ Set Field standing for overloading Message ID
*  lr_log_util->overloading( )->setting_table( )->set_overload_id( ).
  " ──┐ Set Field standing for overloading Message Number
*  lr_log_util->overloading( )->setting_table( )->set_overload_number( ).
  " ──┐ Set Field standing for overloading Message Type
*  lr_log_util->overloading( )->setting_table( )->set_overload_type( ).
  " ──┐ Set Field standing for overloading Message Replace Value 1
*  lr_log_util->overloading( )->setting_table( )->set_overload_msgv1( ).
  " ──┐ Set Field standing for overloading Message Replace Value 2
*  lr_log_util->overloading( )->setting_table( )->set_overload_msgv2( ).
  " ──┐ Set Field standing for overloading Message Replace Value 3
*  lr_log_util->overloading( )->setting_table( )->set_overload_msgv3( ).
  " ──┐ Set Field standing for overloading Message Replace Value 4
*  lr_log_util->overloading( )->setting_table( )->set_overload_msgv4( ).

  " ──┐ Set your custom setting table (Super Method)
*  lr_log_util->overloading( )->set( ).


  " [ OPTIONAL  ] :: Enable Overloading
  " ------------------------------------
*  lr_log_util->overloading( )->enable( )
  " To disable :
  " lr_log_util->overloading( )->disable( )


  " [ OPTIONAL  ] :: Manage Message Type for Batch Job going to SPOOL
  " ------------------------------------------------------------------
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
START-OF-SELECTION.



*&----------------------------------------------------------------------------&"
*&   End of processing                                                        &"
*&----------------------------------------------------------------------------&"
END-OF-SELECTION.
  " Define

  " Log My Entries
  " ──┐ Working with current SY-MSGxx values
  lr_log_util->log( ).
  " ──┐ Working with current SY-MSGxx values and complet with my structure
*  MESSAGE ID                             " Classic Way for Usage Case
*  lr_log_util->log( )->assign( str ).    " Now log sy-msgxx with my values
  " ──┐ Working with my structure
*  lr_log_util->log( ls_log_table ).
  " ──┐ Working with table
*  lr_log_util->log( ls_log_table ).




  " Log FM return table (BAPIRET2)
  " ──┐
*  lr_log_util->log( lt_ret_bapiret2 ).

  " Log FM 2 return table (PROTT)
*  lr_log_util->log( lt_ret_prott ).

  " Display collected logs
  lr_log_util->display( ).

  " Display Application Log
*  lr_log_util->slg( )->display( ).
