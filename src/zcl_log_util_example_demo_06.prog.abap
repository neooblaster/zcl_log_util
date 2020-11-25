*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_06
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Declaring own specific log table type
*&  • 2.) Initialization of ZCL_LOG_UTIL with our table
*&  • 3.) Define role of our field
*&  • 4.) Simulating Log Table
*&  • 5.) Log Simulated table with extra data
*&  • 6.) Displaying logs
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty6_my_log_table         ,
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
       END   OF ty6_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt6_log_table TYPE TABLE OF ty6_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr6_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr6_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt6_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr6_log_util->define( )->set(
  msgtx_field  = 'MESSAGE' " << Field which will received generated message
  msgid_field  = 'ID'      " << Message Class ID
  msgno_field  = 'NUMBER'  " << Message Number from message class
  msgty_field  = 'TYPE'    " << Message Type
  msgv1_field  = 'VAL1'    " << Message Value 1
  msgv2_field  = 'VAL2'    " << Message Value 2
  msgv3_field  = 'VAL3'    " << Message Value 3
  msgv4_field  = 'VAL4'    " << Message Value 4
).



**&----------------------------------------------------------------------*
**& • 4.) Simulating Log Table
**&----------------------------------------------------------------------*
DATA: lt6_bapi_ret_tab TYPE TABLE OF bapiret2 .
DATA: ls6_bapi_ret_tab TYPE          bapiret2 .

" Document 1
ls6_bapi_ret_tab-id     = 'MEPO' .
ls6_bapi_ret_tab-number = '2'    .
ls6_bapi_ret_tab-type   = 'E'    .
APPEND ls6_bapi_ret_tab TO lt6_bapi_ret_tab.

" Document 2
ls6_bapi_ret_tab-id     = 'MEPO' .
ls6_bapi_ret_tab-number = '2'    .
ls6_bapi_ret_tab-type   = 'E'    .
APPEND ls6_bapi_ret_tab TO lt6_bapi_ret_tab.

" Document 3
ls6_bapi_ret_tab-id     = 'MEPO' .
ls6_bapi_ret_tab-number = '2'    .
ls6_bapi_ret_tab-type   = 'E'    .
APPEND ls6_bapi_ret_tab TO lt6_bapi_ret_tab.

" Document 4
ls6_bapi_ret_tab-id     = 'MEPO' .
ls6_bapi_ret_tab-number = '2'    .
ls6_bapi_ret_tab-type   = 'E'    .
APPEND ls6_bapi_ret_tab TO lt6_bapi_ret_tab.


*&----------------------------------------------------------------------*
*& • 5.) Log Simulated table with extra data
*&----------------------------------------------------------------------*
" Now we want to log returned table
"
" !! Some standard table are natively manage by ZCL_LOG_UTIL.
"    If table is not know, you can define field as you already done for
"    your own custom table using DEFINE( )->SET( )
"
"    List available here :
"
"
lr6_log_util->log( lt6_bapi_ret_tab ).

" In log we want to display the PO Number foe each lines of BAPI
DATA: lt6_log_table_x TYPE TABLE OF ty5_my_log_table.
DATA: ls6_log_table_x TYPE          ty5_my_log_table.

ls6_log_table_x-vbeln = '4500001189'.
APPEND ls6_log_table_x TO lt6_log_table_x.
ls6_log_table_x-vbeln = '4500001190'.
APPEND ls6_log_table_x TO lt6_log_table_x.
ls6_log_table_x-vbeln = '4500001191'.
APPEND ls6_log_table_x TO lt6_log_table_x.

" I log MANY entries and I want to merge my data
" I provided MANY line with table
" When number of extra data lines in lesser than log data
" remaining log data are left unmodified
lr6_log_util->merging( lt6_log_table_x ).



*&----------------------------------------------------------------------*
*& • 6.) Displaying logs
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
lr6_log_util->display( ).
