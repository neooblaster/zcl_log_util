*&---------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_11
*&---------------------------------------------------------------------*
DATA lr_util TYPE REF TO zcl_log_util.
DATA lv_obj TYPE BALOBJ_D.
DATA lv_sobj TYPE BALSUBOBJ.
DATA lv_extnr TYPE BALNREXT.
DATA lv_ret TYPE i.
DATA lv_dummy type string.

zcl_log_util=>factory(
  IMPORTING
    e_log_util = lr_util
).

lr_util->slg( )->set_object( 'ZMYPO' ).
lr_util->slg( )->set_sub_object( 'PO_CREATE' ).
lr_util->slg( )->set_external_number( '20201130' ).
lr_util->slg( )->set_retention( 7 ).
lr_util->slg( )->enable( ).
lv_obj = lr_util->slg( )->get_object( ).
lv_sobj = lr_util->slg( )->get_sub_object( ).
lv_extnr = lr_util->slg( )->get_external_number( ).
lv_ret = lr_util->slg( )->get_retention( ).

lr_util->overload( )->setting_tab( )->source_param1( 'INPUT5' ).
lr_util->overload( )->setting_tab( )->overload_ignore( 'OUTPUT8' ).
lr_util->overload( )->enable( ).

DATA: lt_log TYPE TABLE OF zcl_log_util=>ty_log_table.

lr_util->set_log_table(
  CHANGING
    t_log_table = lt_log
).

MESSAGE i105(zlog_util) INTO lv_dummy.
lr_util->log( ).
lr_util->spot( 'MYSPOT' )->start( ).
MESSAGE i105(zlog_util) INTO lv_dummy.
lr_util->log( ).
lr_util->overload( )->set_params( i_param_1 = 'F' ).
MESSAGE i105(zlog_util) INTO lv_dummy.
lr_util->log( ).
lr_util->overload( )->set_params( i_param_1 = 'E' ).
MESSAGE i105(zlog_util) INTO lv_dummy.
lr_util->log( ).
lr_util->overload( )->set_params( i_param_1 = 'X' ).
MESSAGE i105(zlog_util) INTO lv_dummy.
lr_util->log( ).

lr_util->log( 'test' ).
lr_util->slg( )->log( 'test' ).


lr_util->display( ).
lr_util->slg( )->display( ).

IF 1 = 2. ENDIF.


" For ignore feature, MSGV4 is mandatory to be functionnal
