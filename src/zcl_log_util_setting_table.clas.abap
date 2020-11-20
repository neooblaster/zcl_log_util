class ZCL_LOG_UTIL_SETTING_TABLE definition
  public
  final
  create public .

public section.

  data TRUE type C value 'X' ##NO_TEXT.
  data FALSE type C value ' ' ##NO_TEXT.
  data _CONFIG_VALIDATED type C value ' ' ##NO_TEXT.

  methods CONSTRUCTOR .
  methods SET
    importing
      !I_TABLE_NAME type TABNAME
      !I_FILTER_DEVCODE_FIELD type NAME_FELD optional
      !I_FILTER_DOMAIN_FIELD type NAME_FELD optional
      !I_FILTER_DATA_FIELD type NAME_FELD optional
      !I_SOURCE_ID_FIELD type NAME_FELD
      !I_SOURCE_NUMBER_FIELD type NAME_FELD
      !I_SOURCE_TYPE_FIELD type NAME_FELD
      !I_SOURCE_SPOT_FIELD type NAME_FELD
      !I_SOURCE_PARAM1_FIELD type NAME_FELD optional
      !I_SOURCE_PARAM2_FIELD type NAME_FELD optional
      !I_OVERLOAD_ID_FIELD type NAME_FELD
      !I_OVERLOAD_NUMBER_FIELD type NAME_FELD
      !I_OVERLOAD_TYPE_FIELD type NAME_FELD
      !I_OVERLOAD_MSGV1_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV2_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV3_FIELD type NAME_FELD optional
      !I_OVERLOAD_MSGV4_FIELD type NAME_FELD optional .
  methods TABLE_NAME
    importing
      !I_TABLE_NAME type TABNAME
    preferred parameter I_TABLE_NAME .
  methods SOURCE_ID
    importing
      !I_SOURCE_ID_FIELD type NAME_FELD .
  methods SOURCE_NUMBER
    importing
      !I_SOURCE_NUMBER_FIELD type NAME_FELD .
  methods SOURCE_TYPE
    importing
      !I_SOURCE_TYPE_FIELD type NAME_FELD .
  methods SOURCE_SPOT
    importing
      !I_SOURCE_SPOT_FIELD type NAME_FELD .
  methods SOURCE_PARAM1
    importing
      !I_SOURCE_PARAM1_FIELD type NAME_FELD .
  methods SOURCE_PARAM2
    importing
      !I_SOURCE_PARAM2_FIELD type NAME_FELD .
  methods OVERLOAD_ID
    importing
      !I_OVERLOAD_ID_FIELD type NAME_FELD .
  methods OVERLOAD_NUMBER
    importing
      !I_OVERLOAD_NUMBER_FIELD type NAME_FELD .
  methods OVERLOAD_TYPE
    importing
      !I_OVERLOAD_NUMBER_FIELD type NAME_FELD .
  methods OVERLOAD_MSGV1
    importing
      !I_OVERLOAD_MSGV1_FIELD type NAME_FELD .
  methods OVERLOAD_MSGV2
    importing
      !I_OVERLOAD_MSGV2_FIELD type NAME_FELD .
  methods OVERLOAD_MSGV3
    importing
      !I_OVERLOAD_MSGV3_FIELD type NAME_FELD .
  methods OVERLOAD_MSGV4
    importing
      !I_OVERLOAD_MSGV4_FIELD type NAME_FELD .
  methods FILTER_DEVCODE
    importing
      !I_FILTER_DEVCODE_FIELD type NAME_FELD .
  methods FILTER_DOMAIN
    importing
      !I_FILTER_DOMAIN_FIELD type NAME_FELD .
  methods FILTER_DATA
    importing
      !I_FILTER_DATA_FIELD type NAME_FELD .
protected section.
private section.

  methods _CHECK_SETTING .
  methods _CHECK_TABLE .
ENDCLASS.



CLASS ZCL_LOG_UTIL_SETTING_TABLE IMPLEMENTATION.


  method CONSTRUCTOR.
  endmethod.


  method FILTER_DATA.
  endmethod.


  method FILTER_DEVCODE.
  endmethod.


  method FILTER_DOMAIN.
  endmethod.


  method OVERLOAD_ID.
  endmethod.


  method OVERLOAD_MSGV1.
  endmethod.


  method OVERLOAD_MSGV2.
  endmethod.


  method OVERLOAD_MSGV3.
  endmethod.


  method OVERLOAD_MSGV4.
  endmethod.


  method OVERLOAD_NUMBER.
  endmethod.


  method OVERLOAD_TYPE.
  endmethod.


  method SET.
  endmethod.


  method SOURCE_ID.
  endmethod.


  method SOURCE_NUMBER.
  endmethod.


  method SOURCE_PARAM1.
  endmethod.


  method SOURCE_PARAM2.
  endmethod.


  method SOURCE_SPOT.
  endmethod.


  method SOURCE_TYPE.
  endmethod.


  method TABLE_NAME.
  endmethod.


  method _CHECK_SETTING.
  endmethod.


  method _CHECK_TABLE.
  endmethod.
ENDCLASS.
