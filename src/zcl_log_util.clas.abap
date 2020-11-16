class ZCL_LOG_UTIL definition
  public
  final
  create public .

public section.

  methods SPOT
    importing
      !SPOT type ZDT_LOG_UTIL_SPOT optional
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SPOT
    raising
      ZCX_LOG_UTIL .
  methods CONSTRUCTOR .
  methods DISPLAY .
  methods SET_LOG_STRUCTURE .
  methods LOG .
protected section.
private section.

  data _SPOT type ref to ZCL_LOG_UTIL_SPOT .
ENDCLASS.



CLASS ZCL_LOG_UTIL IMPLEMENTATION.


  method CONSTRUCTOR.
  endmethod.


  method DISPLAY.
  endmethod.


  method LOG.
  endmethod.


  method SET_LOG_STRUCTURE.
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
ENDCLASS.
