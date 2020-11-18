class ZCL_LOG_UTIL_DEFINE definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SET
    importing
      !MSGID_FIELD type NAME_FELD
      !MSGNO_FIELD type NAME_FELD
      !MSGTY_FIELD type NAME_FELD
      !MSGV1_FIELD type NAME_FELD
      !MSGV2_FIELD type NAME_FELD
      !MSGV3_FIELD type NAME_FELD
      !MSGV4_FIELD type NAME_FELD .
  methods ID
    importing
      !MSGID_FIELD type NAME_FELD .
  methods NUMBER
    importing
      !MSGNO_FIELD type NAME_FELD .
  methods TYPE
    importing
      !MSGTY_FIELD type NAME_FELD .
  methods MSGV1
    importing
      !MSGV1_FIELD type NAME_FELD .
  methods MSGV2
    importing
      !MSGV2_FIELD type NAME_FELD .
  methods MSGV3
    importing
      !MSGV3_FIELD type NAME_FELD .
  methods MSGV4
    importing
      !MSGV4_FIELD type NAME_FELD .
protected section.
private section.
ENDCLASS.



CLASS ZCL_LOG_UTIL_DEFINE IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.


  method ID.
  endmethod.


  method MSGV1.
  endmethod.


  method MSGV2.
  endmethod.


  method MSGV3.
  endmethod.


  method MSGV4.
  endmethod.


  method NUMBER.
  endmethod.


  method SET.

    me->id( msgid_field ).
    me->number( msgno_field ).
    me->type( msgty_field ).
    me->msgv1( msgv1_field ).
    me->msgv2( msgv2_field ).
    me->msgv3( msgv3_field ).
    me->msgv4( msgv4_field ).

  endmethod.


  method TYPE.
  endmethod.
ENDCLASS.
