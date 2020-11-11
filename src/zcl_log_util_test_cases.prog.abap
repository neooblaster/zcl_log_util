*&---------------------------------------------------------------------*
*& Report ZCL_LOG_UTIL_TEST_CASES
*&---------------------------------------------------------------------*
*&
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
*& Rule SPOT_001 : Test RAISED EXCEPTION
*&-----------------------------------------*
TRY.
  lr_log_util->spot( )->start( ).
  CATCH ZCX_LOG_UTIL INTO lx_log_util.
    WRITE: / 'TEST SPOT_001 : ', lx_log_util->get_text( ).
ENDTRY.


*&-----------------------------------------*
*& Rule SPOT_002 : Test RAISED EXCEPTION
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
