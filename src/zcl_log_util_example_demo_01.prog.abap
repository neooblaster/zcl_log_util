*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_01
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Initialization of ZCL_LOG_UTIL
*&  • 2.) How to log an error
*&  • 3.) How to display logs
*&
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*& • 1.) Initialization of ZCL_LOG_UTIL
*&----------------------------------------------------------------------*
" Here, we will use default provided table type with ZCL_LOG_UTIL
DATA: lt1_log_table TYPE TABLE OF zcl_log_util=>ty_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr1_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr1_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt1_log_table
).



*&----------------------------------------------------------------------*
*& • 2.) How to log an error
*&----------------------------------------------------------------------*
" Logging a standard message error.
" We use dummy variable to prevent standard display of message
" Like this, you can perform "USE CASE" on error message.
DATA: lv1_dummy TYPE string.

MESSAGE e504(vl) INTO lv1_dummy.
lr1_log_util->log( ).



*&----------------------------------------------------------------------*
*& • 3.) How to display logs
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
lr1_log_util->display( ).
