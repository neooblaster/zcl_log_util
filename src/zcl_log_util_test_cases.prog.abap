*&---------------------------------------------------------------------*
*& Report ZCL_LOG_UTIL_TEST_CASES
*&---------------------------------------------------------------------*
*& @author : Nicolas DUPRE
*&---------------------------------------------------------------------*
REPORT ZCL_LOG_UTIL_TEST_CASES.

TYPES: BEGIN OF ty_my_log_table,
          icon     TYPE alv_icon,
          vbeln    TYPE vbeln,
          message  TYPE string,
          filename TYPE string,
          id       TYPE sy-msgid,
          number   TYPE sy-msgno,
          type     TYPE sy-msgty,
          spot     TYPE zdt_log_util_spot,
       END   OF ty_my_log_table.

TYPES:  BEGIN OF  ty_custom_bapi_log_table.
          INCLUDE STRUCTURE bapiret2.
TYPES:    fileindex TYPE i,
          lineindex TYPE i,
        END   OF ty_custom_bapi_log_table.



DATA: " VARIABLES
    lv_string    TYPE string.

DATA: " TABLES
    lt_log_table      TYPE TABLE OF ty_my_log_table         ,
    ls_log_table      TYPE          ty_my_log_table         ,
    lt_cust_log_table TYPE TABLE OF ty_custom_bapi_log_table,
    ls_cust_log_table TYPE TABLE OF ty_custom_bapi_log_table.

DATA: " OBJECTS
    lr_log_util        TYPE REF TO zcl_log_util        ,
    lr_log_util_define TYPE REF TO zcl_log_util_define .

DATA: " EXCEPTIONS
    lx_log_util TYPE REF TO zcx_log_util.





*&---------------------------------------------------------------------*
*&  Initialization
*&---------------------------------------------------------------------*
zcl_log_util=>factory(
  " Retrieving your object to use in your program
  IMPORTING
    r_log_util  = lr_log_util
  " Linking your log table
  CHANGING
    t_log_table = lt_log_table
).


" Faire une table interne à l'instance pour le stockage des valeurs si pas de mapping
" Prévoir une zone "ignore" en plus pour la surcharge




*&---------------------------------------------------------------------*
*&  Testing DEFINE feature
*&---------------------------------------------------------------------*
*& Rule DEFINE_001 : Test Handling TABLE
*&-----------------------------------------*
* Validating :
*   - Super Method
*   - Field Name
*   - Empty Field
lr_log_util->define( lt_log_table )->set(
  msgid_field = 'ID'
  msgno_field = 'NUMBER'
  msgty_field = 'TYPE'
  msgv1_field = ''
  msgv2_field = ''
  msgv3_field = ''
  msgv4_field = ''
).


*&------------------------------------------*
*& Rule DEFINE_002 : Test Handling STRUCTURE
*&------------------------------------------*
lr_log_util->define( ls_log_table ).


*&---------------------------------------------*
*& Rule DEFINE_003 : Test Handling DATA ELEMENT
*&---------------------------------------------*
" MESSAGE e004(zlog_util)
"lr_log_util->define( lv_string ). " Test case OK


*&------------------------------------------------------*
*& Rule DEFINE_004 : Test Settting field which not exist
*&------------------------------------------------------*
" MESSAGE e005(zlog_util)
"lr_log_util->define( ls_log_table )->id( 'ID' )->number( 'MSGNO'). " Test case OK


*&-----------------------------------------------------------*
*& Rule DEFINE_003 : Defining another log table (not our ref)
*&-----------------------------------------------------------*
*
* @TODO : Include structure not managed by strucdescr (currently)
*
*DATA: lr_define TYPE REF TO zcl_log_util_define.
*lr_define = lr_log_util->define( lt_cust_log_table ).
*lr_define->id( 'ID' ).
*lr_define->number( 'NUMBER' ).
*lr_define->type( 'TYPE' ).
*lr_define->msgv1( 'MESSAGE_V1' ).
*lr_define->msgv2( 'MESSAGE_V2' ).
*lr_define->msgv3( 'MESSAGE_V3' ).
*lr_define->msgv4( 'MESSAGE_V4' ).





*&---------------------------------------------------------------------*
*&  Testing SPOT feature
*&---------------------------------------------------------------------*
*& Rule SPOT_001 : Test RAISED EXCEPTION 1
*&-----------------------------------------*
TRY.
  lr_log_util->spot( )->start( ).
  CATCH ZCX_LOG_UTIL INTO lx_log_util.
    WRITE: / 'TEST SPOT_001 : ', lx_log_util->get_text( ).
ENDTRY.


*&-----------------------------------------*
*& Rule SPOT_002 : Test RAISED EXCEPTION 2
*&-----------------------------------------*
TRY.
  lr_log_util->spot( '' )->start( ).
  CATCH ZCX_LOG_UTIL INTO lx_log_util.
    WRITE: / 'TEST SPOT_002 : ', lx_log_util->get_text( ).
ENDTRY.



*&-----------------------------------------*
*& Rule SPOT_003 : Test Starting Spot
*&-----------------------------------------*
CLEAR lr_log_util.
CREATE OBJECT lr_log_util.

" Starting.
lr_log_util->spot( 'SPOT_NAME' )->start( ).
WRITE: / 'TEST SPOT_003_01 : Enabled :', lr_log_util->spot( )->is_enabled( ).

" Stoping.
lr_log_util->spot( )->stop( ).
WRITE: / 'TEST SPOT_003_02 : Enabled :', lr_log_util->spot( )->is_enabled( ).

" Restarting (-> no dump)
lr_log_util->spot( )->start( ).
WRITE: / 'TEST SPOT_003_03 : Enabled :', lr_log_util->spot( )->is_enabled( ).





"
" In EXAMPLE
"
" [X] lr_log_util->slg->enable  " log will     create slg entry
" [X] lr_log_util->slg->disable " log will not create slg entry
" [X] lr_log_util->slg( obj, subobj, extnr )
" [X] lr_log_util->slg->set_ext_number
" [X] lr_log_util->slg->set_object @set_obj
" [X] lr_log_util->slg->set_sub_object @set_subobj
" [X] lr_log_util->slg->display
" [X] lr_log_util->slg->set_rentention
"
" [X] lr_log_util->define->set
" [X] lr_log_util->define->id
" [X] lr_log_util->define->number
" [X] lr_log_util->define->type
" [X] lr_log_util->define->msgv1
" [X] lr_log_util->define->msgv2
" [X] lr_log_util->define->msgv3
" [X] lr_log_util->define->msgv4
"
" [ ] lr_log_util->log( )               using sy-msg
" [ ] lr_log_util->log( str )
" [ ] lr_log_util->log( table )
" [ ] lr_log_util->log( type, no, id )
" [ ] lr_log_util->a( [no [, id]] )
" [ ] lr_log_util->e( [no [, id]] )
" [ ] lr_log_util->i( [no [, id]] )
" [ ] lr_log_util->s( [no [, id]] )
" [ ] lr_log_util->w( [no [, id]] )
"
" [ ] lr_log_util->set_output_table
" [ ] lr_log_util->set_input_table
"
" [X] lr_log_util->display( ) (default table / custom table)
" [X] lr_log_util->set_log_structure( )
"
"
" [-] lr_log_util->overloading( )
" [X] lr_log_util->overloading( )->setting_table( )->set( ).
" [X] lr_log_util->overloading( )->setting_table( )->set_table( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_id( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_number( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_type( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_spot( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_param_1( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_param_2( )
" [X] lr_log_util->overloading( )->setting_table( )->set_source_param_3( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_id( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_number( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_type( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_msgv1( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_msgv2( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_msgv3( )
" [X] lr_log_util->overloading( )->setting_table( )->set_overload_msgv4( )
" [X] lr_log_util->overloading( )->enable( )
" [X] lr_log_util->overloading( )->disable( )
"
"
