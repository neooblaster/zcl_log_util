class ZCL_LOG_UTIL_SPOT definition
  public
  final
  create public .

public section.

  class-data TRUE type C value 'X' ##NO_TEXT.
  class-data FALSE type C value ' ' ##NO_TEXT.

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
  methods GET_SPOT_ID
    returning
      value(R_SPOT) type ZDT_LOG_UTIL_SPOT .
  methods SET_SPOT_ID
    importing
      !I_SPOT_ID type ZDT_LOG_UTIL_SPOT .
protected section.

  data SPOT type ZDT_LOG_UTIL_SPOT .
  data ENABLED type C .
private section.
ENDCLASS.



CLASS ZCL_LOG_UTIL_SPOT IMPLEMENTATION.


  method CONSTRUCTOR.

    IF spot IS NOT INITIAL.
      me->spot = spot.
    ENDIF.

  endmethod.


  method GET_SPOT_ID.

    r_spot = me->spot.

  endmethod.


  method IS_ENABLED.

    enabled = me->enabled.

  endmethod.


  method SET_SPOT_ID.

    me->spot = i_spot_id.

  endmethod.


  method START.

    IF me->spot IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_LOG_UTIL
        EXPORTING
          textid = ZCX_LOG_UTIL=>ZCX_LOG_UTIL_SPOT_EMPTY.
    ENDIF.

    me->enabled = zcl_log_util_spot=>true.

  endmethod.


  method STOP.

    IF me->spot IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_LOG_UTIL
        EXPORTING
          textid = ZCX_LOG_UTIL=>ZCX_LOG_UTIL_SPOT_EMPTY.
    ENDIF.

    me->enabled = zcl_log_util_spot=>false.

  endmethod.
ENDCLASS.
