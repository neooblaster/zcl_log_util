*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_065
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Declaring own specific log tables types
*&  • 2.) Initialization of ZCL_LOG_UTIL without log table
*&  • 3.) Define role of our field for both log table
*&  • 4.) Simulating Return log tables
*&  • 5.) Set log table & log return table 1
*&  • 6.) Set log table & log return table 2
*&  • 7.) Set log table & log return table All
*&  • 8.) Displaying logs table 1
*&  • 9.) Displaying logs table 2
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log tables types
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty65_my_log_table        ,
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
       END   OF ty65_my_log_table        .

TYPES: BEGIN OF ty65_my_log_table_2      ,
         lifnr    TYPE lifnr             ,
         msgtx    TYPE md_message_text   ,
         mggid    TYPE sy-msgid          ,
         msgno    TYPE sy-msgno          ,
         msgty    TYPE sy-msgty          ,
         msgv1    TYPE sy-msgv1          ,
         msgv2    TYPE sy-msgv1          ,
         msgv3    TYPE sy-msgv1          ,
         msgv4    TYPE sy-msgv1          ,
       END   OF ty65_my_log_table_2      .

TYPES: BEGIN OF ty65_my_log_table_all    ,
         txt    TYPE md_message_text     ,
         id     TYPE sy-msgid            ,
         nr     TYPE sy-msgno            ,
         typ    TYPE sy-msgty            ,
         mv1    TYPE sy-msgv1            ,
         mv2    TYPE sy-msgv1            ,
         mv3    TYPE sy-msgv1            ,
         mv4    TYPE sy-msgv1            ,
       END   OF ty65_my_log_table_all    .



*&----------------------------------------------------------------------*
*&  • 2.) Initialization of ZCL_LOG_UTIL without log table
" Declaring reference to ZCL_LOG_UTIL
DATA: lr65_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr65_log_util
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field for both log table
*&----------------------------------------------------------------------*
DATA: lt65_log_table_1   TYPE TABLE OF ty65_my_log_table.
DATA: lt65_log_table_2   TYPE TABLE OF ty65_my_log_table_2.
DATA: lt65_log_table_all TYPE TABLE OF ty65_my_log_table_all.

" Defining field role of table 1
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr65_log_util->define( lt65_log_table_1 )->set(
  msgtx_field  = 'MESSAGE' " << Field which will received generated message
  msgid_field  = 'ID'      " << Message Class ID
  msgno_field  = 'NUMBER'  " << Message Number from message class
  msgty_field  = 'TYPE'    " << Message Type
  msgv1_field  = 'VAL1'    " << Message Value 1
  msgv2_field  = 'VAL2'    " << Message Value 2
  msgv3_field  = 'VAL3'    " << Message Value 3
  msgv4_field  = 'VAL4'    " << Message Value 4
).

" Defining field role of table 2
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr65_log_util->define( lt65_log_table_2 )->set(
  msgtx_field  = 'MSGTX'    " << Field which will received generated message
  msgid_field  = 'MGGID'    " << Message Class ID
  msgno_field  = 'MSGNO'    " << Message Number from message class
  msgty_field  = 'MSGTY'    " << Message Type
  msgv1_field  = 'MSGV1'    " << Message Value 1
  msgv2_field  = 'MSGV2'    " << Message Value 2
  msgv3_field  = 'MSGV3'    " << Message Value 3
  msgv4_field  = 'MSGV4'    " << Message Value 4
).

" Defining field role of table ALL
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr65_log_util->define( lt65_log_table_all )->set(
  msgtx_field  = 'TXT'    " << Field which will received generated message
  msgid_field  = 'ID'     " << Message Class ID
  msgno_field  = 'NR'     " << Message Number from message class
  msgty_field  = 'TYP'    " << Message Type
  msgv1_field  = 'MV1'    " << Message Value 1
  msgv2_field  = 'MV2'    " << Message Value 2
  msgv3_field  = 'MV3'    " << Message Value 3
  msgv4_field  = 'MV4'    " << Message Value 4
).



**&----------------------------------------------------------------------*
**& • 4.) Simulating Return log tables
**&----------------------------------------------------------------------*
DATA: lt65_bapiret2 TYPE TABLE OF bapiret2 .
DATA: lt65_prott    TYPE TABLE OF prott    .

" Simulating Return Table BAPIRET2
APPEND VALUE #(
  type   = 'S'
  id     = '00'
  number = '31'
) TO lt65_bapiret2.

APPEND VALUE #(
  type   = 'E'
  id     = '00'
  number = '32'
) TO lt65_bapiret2.

APPEND VALUE #(
  type   = 'W'
  id     = '00'
  number = '33'
) TO lt65_bapiret2.

" Simulating Return Table PROTT
APPEND VALUE #(
  msgid = 'VL'
  msgno = '23'
  msgty = 'E'
) TO lt65_prott.

APPEND VALUE #(
  msgid = 'VL'
  msgno = '24'
  msgty = 'W'
) TO lt65_prott.

APPEND VALUE #(
  msgid = 'VL'
  msgno = '25'
  msgty = 'S'
) TO lt65_prott.


*&----------------------------------------------------------------------*
*& • 5.) Set log table & log return table 1
*&----------------------------------------------------------------------*
" Set "Log Table 1" for our BAPIRET2 errors
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_1
).

" Log Messages
lr65_log_util->log( lt65_bapiret2 ).


*&----------------------------------------------------------------------*
*& • 6.) Set log table & log return table 2
*&----------------------------------------------------------------------*
" Set "Log Table 2" for our PROTT errors
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_2
).

" Log Messages
lr65_log_util->log( lt65_prott ).


*&----------------------------------------------------------------------*
*& • 7.) Set log table & log return table All
*&----------------------------------------------------------------------*
" Set "Log Table All" for al encountered errors
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_all
).

" Log Messages
lr65_log_util->log( lt65_bapiret2 ).
lr65_log_util->log( lt65_prott ).



*&----------------------------------------------------------------------*
*& • 8.) Displaying logs table 1
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
"
" Change table :
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_1
).
" and display
lr65_log_util->display( ).


*&----------------------------------------------------------------------*
*& • 9.) Displaying logs table 2
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
"
" Change table :
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_2
).
" and display
lr65_log_util->display( ).



*&----------------------------------------------------------------------*
*& • 9.) Displaying logs table All
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
"
" Change table :
lr65_log_util->set_log_table(
  CHANGING
    t_log_table = lt65_log_table_all
).
" and display
lr65_log_util->display( ).
