*&---------------------------------------------------------------------*
*& Report ZCL_LOG_UTIL_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCL_LOG_UTIL_EXAMPLE.


DATA:
    lr_log_util TYPE REF TO zcl_log_util
    .


INITIALIZATION.
  CREATE OBJECT lr_log_util.
  lr_log_util->spot( ).


START-OF-SELECTION.


END-OF-SELECTION.
