*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_09
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  •  1.) Declaring own specific log table type
*&  •  2.) Initialization of ZCL_LOG_UTIL with our table
*&  •  3.) Define role of our field
*&  •  4.) Default logging Type
*&  •  5.) Logging Abort Message
*&  •  6.) Logging Error Message
*&  •  7.) Logging Warning Message
*&  •  8.) Logging Info Message
*&  •  9.) Logging Success Message
*&  • 10.) Logging passing all messages components
*&  • 11.) Displaying Log
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty9_my_log_table         ,
         icon     TYPE alv_icon          ,
         vbeln    TYPE vbeln             ,
         vbelp    TYPE vbelp             ,
         message  TYPE md_message_text   ,
         filename TYPE rlgrap-filename   ,
         id       TYPE sy-msgid          ,
         number   TYPE sy-msgno          ,
         type     TYPE sy-msgty          ,
         val1     TYPE sy-msgv1          ,
         val2     TYPE sy-msgv1          ,
         val3     TYPE sy-msgv1          ,
         val4     TYPE sy-msgv1          ,
       END   OF ty9_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt9_log_table TYPE TABLE OF ty9_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr9_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr9_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt9_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr9_log_util->define( )->set(
  msgtx_field  = 'MESSAGE' " << Field which will received generated message
  msgid_field  = 'ID'      " << Message Class ID
  msgno_field  = 'NUMBER'  " << Message Number from message class
  msgty_field  = 'TYPE'    " << Message Type
  msgv1_field  = 'VAL1'    " << Message Value 1
  msgv2_field  = 'VAL2'    " << Message Value 2
  msgv3_field  = 'VAL3'    " << Message Value 3
  msgv4_field  = 'VAL4'    " << Message Value 4
).



*&----------------------------------------------------------------------*
*& •  4.) Default logging Type
*&----------------------------------------------------------------------*
DATA: lv9_dummy TYPE string.

" ──┐ Raising an error (type = E)
MESSAGE e100(vl) INTO lv9_dummy.

" ──┐ Messages logged with Type E
lr9_log_util->log( ).



*&----------------------------------------------------------------------*
*& •  5.) Logging Abort Message
*&----------------------------------------------------------------------*
" ──┐ Raising a warning (type = W)
MESSAGE w101(vl) INTO lv9_dummy.

" ──┐ Messages logged with Type E
lr9_log_util->a( ).



*&----------------------------------------------------------------------*
*& •  6.) Logging Error Message
*&----------------------------------------------------------------------*
" ──┐ Log free error message
lr9_log_util->e( 'This message is an error (Type = E )' ).



*&----------------------------------------------------------------------*
*& •  7.) Logging Warning Message
*&----------------------------------------------------------------------*
DATA: ls_bapiret2 TYPE bapiret2.

ls_bapiret2-id         = '00'.
ls_bapiret2-number     = '123'.
ls_bapiret2-type       = 'E'.
ls_bapiret2-message_v1 = 'PH_BPIRET2_MSGV1'.
ls_bapiret2-message_v2 = 'PH_BPIRET2_MSGV2'.
ls_bapiret2-message_v3 = 'PH_BPIRET2_MSGV3'.
ls_bapiret2-message_v4 = 'PH_BPIRET2_MSGV4'.

" ──┐ Log BAPI structure message as SUCCESS
lr9_log_util->s( ls_bapiret2 ).



*&----------------------------------------------------------------------*
*& •  8.) Logging Info Message
*&----------------------------------------------------------------------*
DATA: lt_prott TYPE TABLE OF prott.

" ──┐ BAPI Prott return table Message 1
APPEND VALUE #(
  msgid = '01'
  msgno = '234'
  msgty = 'W'
  msgv1 = 'PH_PROTT_MSGV1#1'
  msgv2 = 'PH_PROTT_MSGV2#1'
  msgv3 = 'PH_PROTT_MSGV3#1'
  msgv4 = 'PH_PROTT_MSGV4#1'
) TO lt_prott.

" ──┐ BAPI Prott return table Message 2
APPEND VALUE #(
  msgid = '01'
  msgno = '234'
  msgty = 'W'
  msgv1 = 'PH_PROTT_MSGV1#2'
  msgv2 = 'PH_PROTT_MSGV2#2'
  msgv3 = 'PH_PROTT_MSGV3#2'
  msgv4 = 'PH_PROTT_MSGV4#2'
) TO lt_prott.

" ──┐ BAPI Prott return table Message 2
APPEND VALUE #(
  msgid = '01'
  msgno = '234'
  msgty = 'W'
  msgv1 = 'PH_PROTT_MSGV1#3'
  msgv2 = 'PH_PROTT_MSGV2#3'
  msgv3 = 'PH_PROTT_MSGV3#3'
  msgv4 = 'PH_PROTT_MSGV4#3'
) TO lt_prott.

" ──┐ Log all Prott message as Info
lr9_log_util->i( lt_prott ).



*&----------------------------------------------------------------------*
*& •  9.) Logging Success Message
*&----------------------------------------------------------------------*
" ──┐ All are optional but MSGID, MSGNO and MSGTY must be provided in same time
lr9_log_util->log(
  i_log_msgid = '00'
  i_log_msgno = '101'
  i_log_msgty = 'E'
  i_log_msgv1 = 'PH_LOG_MSGV1'
  i_log_msgv2 = 'PH_LOG_MSGV2'
  i_log_msgv3 = 'PH_LOG_MSGV3'
  i_log_msgv4 = 'PH_LOG_MSGV4'
).



*&----------------------------------------------------------------------*
*& • 10.) Displaying Log
*&----------------------------------------------------------------------*
lr9_log_util->display( ).
