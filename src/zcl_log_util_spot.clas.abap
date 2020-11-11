class ZCL_LOG_UTIL_SPOT definition
  public
  final
  create public .

public section.

  methods START
    raising
      ZCX_LOG_UTIL .
  methods STOP .
  methods CONSTRUCTOR
    importing
      !SPOT type ZDT_LOG_UTIL_SPOT optional .
  methods IS_ENABLED
    returning
      value(ENABLED) type ABAP_BOOL .
protected section.

  data SPOT type ZDT_LOG_UTIL_SPOT .
  data ENABLED type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_LOG_UTIL_SPOT IMPLEMENTATION.


  method CONSTRUCTOR.

    IF spot IS NOT INITIAL.
      me->spot = spot.
    ENDIF.

  endmethod.


  method IS_ENABLED.

    enabled = me->enabled.

  endmethod.


  method START.

    IF me->spot IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_LOG_UTIL
        EXPORTING
          textid = ZCX_LOG_UTIL=>ZCX_LOG_UTIL_SPOT_EMPTY.
    ENDIF.

    me->enabled = abap_true.

  endmethod.


  method STOP.

    IF me->spot IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_LOG_UTIL
        EXPORTING
          textid = ZCX_LOG_UTIL=>ZCX_LOG_UTIL_SPOT_EMPTY.
    ENDIF.

    me->enabled = abap_false.

  endmethod.
ENDCLASS.
