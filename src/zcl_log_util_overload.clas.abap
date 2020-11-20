class ZCL_LOG_UTIL_OVERLOAD definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SETTING_TAB
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SETTING_TABLE .
  methods SET_FILTER_DEVCODE_VALUE
    importing
      !I_VALUE type C optional .
  methods SET_FILTER_DOMAIN_VALUE
    importing
      !I_VALUE type C optional .
  methods SET_FILTER_DATA_VALUE
    importing
      !I_VALUE type C optional .
protected section.
private section.

  data _SETTING_TAB type ref to ZCL_LOG_UTIL_SETTING_TABLE .
ENDCLASS.



CLASS ZCL_LOG_UTIL_OVERLOAD IMPLEMENTATION.


  method CONSTRUCTOR.

    CREATE OBJECT me->_setting_tab.

  endmethod.


  method SETTING_TAB.

    self = me->_setting_tab.

  endmethod.


  method SET_FILTER_DATA_VALUE.
  endmethod.


  method SET_FILTER_DEVCODE_VALUE.
  endmethod.


  method SET_FILTER_DOMAIN_VALUE.
  endmethod.
ENDCLASS.
