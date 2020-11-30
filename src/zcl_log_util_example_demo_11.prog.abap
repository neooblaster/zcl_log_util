*&---------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_11
*&---------------------------------------------------------------------*
DATA lr_util TYPE REF TO zcl_log_util.
DATA lv_obj TYPE BALOBJ_D.
DATA lv_sobj TYPE BALSUBOBJ.
DATA lv_extnr TYPE BALNREXT.
DATA lv_ret TYPE i.

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

DATA: lt_log TYPE TABLE OF zcl_log_util=>ty_log_table.

lr_util->set_log_table(
  CHANGING
    t_log_table = lt_log
).
lr_util->log( 'test' ).
lr_util->slg( )->log( 'test' ).

lr_util->slg( )->display( ).

IF 1 = 2. ENDIF.
