*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_08
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  •  1.) Declaring own specific log table type
*&  •  2.) Initialization of ZCL_LOG_UTIL with our table
*&  •  3.) Define role of our field
*&  •  4.) Configuration Application Log
*&  •  5.) Logging an error message
*&  •  6.) Disabling Application Log
*&  •  7.) Logging an another error message
*&  •  8.) Re-enabling Application Log
*&  •  9.) Logging an last another error message
*&  • 10.) Displaying Application Logs
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty8_my_log_table         ,
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
       END   OF ty8_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt8_log_table TYPE TABLE OF ty8_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr8_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr8_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt8_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr8_log_util->define( )->set(
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
*& • 4.) Configuration Application Log
*&----------------------------------------------------------------------*
" You can directly use ZCL_LOG_UTIL instance to manipulate SLG
" but for readibility, I use another data reference
DATA: lr8_slg TYPE REF TO zcl_log_util_slg.

" ──┐ Get SLG Instance
lr8_slg = lr8_log_util->slg( ).

" ──┐ Set Application Log Main Object & Sub-object
"     !! Sub-object is mandatory if your main has at least one sub-object.
lr8_slg->set_object( 'ZMYPO' ).
lr8_slg->set_sub_object( 'PO_CHANGE' ).

" ──┐ You can provided External Number (Like PO Number)
lr8_slg->set_external_number( '4500001189' ).

" ──┐ You can also set retention time of logs
"lr8_slg->set_external_number( '4500001189' ).


" ──┐ Finally, we enable the functionnality
lr8_slg->enable( ).
" <<<--- From here, all call of method log( ) will add an entry(ies) to Application Log


*&----------------------------------------------------------------------*
*& • 5.) Logging an error message
*&----------------------------------------------------------------------*
lr8_log_util->log( 'Logging Message 1 - Expected in Application Log' ).



*&----------------------------------------------------------------------*
*& •  6.) Disabling Application Log
*&----------------------------------------------------------------------*
lr8_slg->disable( ).



*&----------------------------------------------------------------------*
*& •  7.) Logging an another error message
*&----------------------------------------------------------------------*
lr8_log_util->log( 'Logging Message 2 - Not Expected in Application Log' ).



*&----------------------------------------------------------------------*
*& •  8.) Re-enabling Application Log
*&----------------------------------------------------------------------*
lr8_slg->enable( ).



*&----------------------------------------------------------------------*
*& •  9.) Logging an last another error message
*&----------------------------------------------------------------------*
lr8_log_util->log( 'Logging Message 3 - Expected in Application Log' ).



*&----------------------------------------------------------------------*
*& • 10.) Displaying Application Logs
*&----------------------------------------------------------------------*
lr8_slg->display( ).
