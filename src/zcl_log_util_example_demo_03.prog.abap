*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_03
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Declaring own specific log table type
*&  • 2.) Initialization of ZCL_LOG_UTIL with our table
*&  • 3.) Define role of our field
*&  • 4.) Login entry with extra data
*&  • 5.) Displaying logs
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty3_my_log_table         ,
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
       END   OF ty3_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt3_log_table TYPE TABLE OF ty3_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr3_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr3_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt3_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr3_log_util->define( )->set(
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
*& • 4.) Login entry with extra data
*&----------------------------------------------------------------------*
" Logging a standard message error.
" We use dummy variable to prevent standard display of message
" Like this, you can perform "USE CASE" on error message.
DATA: lv3_dummy TYPE string.

MESSAGE e504(vl) INTO lv3_dummy.
lr3_log_util->log( ).

" Bellow, my extra data :
DATA: ls3_log_table TYPE ty3_my_log_table.
ls3_log_table-icon     = '@5C@'.
ls3_log_table-vbeln    = '500000123'.
ls3_log_table-vbelp    = '00010'.
ls3_log_table-filename = 'po_500000123.txt'.

" I log ONE entry and I want to merge my data
" I provided ONE structure (1 line)
lr3_log_util->merging( ls3_log_table ).




*&----------------------------------------------------------------------*
*& • 5.) Displaying logs
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
lr3_log_util->display( ).
