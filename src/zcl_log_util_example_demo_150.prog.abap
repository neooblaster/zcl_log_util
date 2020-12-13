*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_150
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  •  1.) Explanation about Log with Batch Job
*&  •  2.) Declaring own specific log table type
*&  •  3.) Initialization of ZCL_LOG_UTIL with our table
*&  •  4.) Define role of our field
*&  •  5.) Logging Message
*&  •  6.) Making output using display
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*& • 1.) Explanation about Overloading and Params
*&----------------------------------------------------------------------*
*&
*&  Batch Job have two existing outputs :
*&
*&    -> Spool    : an equivalent to our screen.
*&    -> Protocol : an equivalent of processing log.
*&
*&
*&
*&  Please take acknoledge about standard behavior of MESSAGE statement
*&  with batch job :
*&    - Message Type A : Job will be put in "Canceled" state :
*&                       "<Your Message>"
*&                       "Job canceled"
*&
*&    - Message Type E : Job will be put in "Canceled" state :
*&                       "<Your Message>"
*&                       "Job canceled after system exception ERROR_MESSAGE"
*&
*&    - Message Type W : Job will be put in "Canceled" state :
*&                       "<Your Message>"
*&                       "Job canceled after system exception ERROR_MESSAGE"
*&
*&    - Message Type I : Job will be put in "Finished" state.
*&                       Message is entered in protocol
*&
*&    - Message Type S : Job will be put in "Finished" state.
*&                       Message is entered in protocol
*&
*&
*&
*&  You can use ALV to display a internal table in the job spool.
*&  So you can display log in the Spool.
*&  Depending of the purpose of your batch job (probably interface job),
*&  you may want to add messages in Spool only when error occured.
*&  Doing like that, you will get "Scroll Icon" only when error occured.
*&  That will simplify Job Monitoring.
*&  Moreover, you may want to get Job in status finished even is error occured.
*&
*&  With ZCL_LOG_UTIL, you can configure which types of message have to
*&  return in Spool and Protocol without changing the job status.
*&
*&  By default :
*&    - for protocol : all messages types are displayed.
*&    - for spool    : no message type are displayed.
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*& • 2.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty150_my_log_table         ,
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
       END   OF ty150_my_log_table         .



*&----------------------------------------------------------------------*
*& • 3.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt150_log_table TYPE TABLE OF ty150_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr150_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr150_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt150_log_table
).



*&----------------------------------------------------------------------*
*& • 4.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr150_log_util->define( )->set(
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
*& •  5.) Logging Message
*&----------------------------------------------------------------------*
DATA: lv150_msgtx TYPE string.
MESSAGE a000 WITH 'Abort Message' INTO lv150_msgtx.
lr150_log_util->log( ).
MESSAGE e000 WITH 'Error Message' INTO lv150_msgtx.
lr150_log_util->log( ).
MESSAGE w000 WITH 'Warning Message' INTO lv150_msgtx.
lr150_log_util->log( ).
MESSAGE i000 WITH 'Info Message' INTO lv150_msgtx.
lr150_log_util->log( ).
MESSAGE s000 WITH 'Success Message' INTO lv150_msgtx.
lr150_log_util->log( ).



*&----------------------------------------------------------------------*
*& •  6.) Making output using display
*&----------------------------------------------------------------------*
IF sy-batch NE 'X'.
  MESSAGE i000 WITH 'Run the job in background task'
                    ' Set Schedule to immediatly'
                    ' Then run TCODE SM37 to control execution'
                    ' Please find in ALV expected log in protocol'.
ENDIF.

lr150_log_util->display( ).
