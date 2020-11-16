*&---------------------------------------------------------------------*
*& Report ZCL_LOG_UTIL_TEST_CASES
*&---------------------------------------------------------------------*
*& @author : Nicolas DUPRE
*&---------------------------------------------------------------------*
REPORT ZCL_LOG_UTIL_TEST_CASES.

DATA:
    lr_log_util TYPE REF TO zcl_log_util
    .

DATA:
    lx_log_util TYPE REF TO zcx_log_util.
    .

CREATE OBJECT lr_log_util.


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
" [X] lr_log_util->slg->enable  " log will     create slg entry
" [X] lr_log_util->slg->disable " log will not create slg entry
" [X] lr_log_util->slg( obj, subobj, extnr )
" [X] lr_log_util->slg->set_ext_number
" [X] lr_log_util->slg->set_object @set_obj
" [X] lr_log_util->slg->set_sub_object @set_subobj
" [X] lr_log_util->slg->display
" [X] lr_log_util->slg->set_rentention
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
