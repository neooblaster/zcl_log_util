*&---------------------------------------------------------------------*
*&  Include           ZCL_LOG_UTIL_EXAMPLE_DEMO_085
*&---------------------------------------------------------------------*



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
*& •  1.) Log Util Initialization
*&----------------------------------------------------------------------*
" Data Declaration
DATA: lt85_log_table TYPE TABLE OF zcl_log_util=>ty_log_table ,
      lr85_log_util  TYPE REF TO   zcl_log_util               ,
      lv85_dummy     TYPE          string                     .

" Initialization
zcl_log_util=>factory(
    IMPORTING
        e_log_util  = lr85_log_util
    CHANGING
        c_log_table = lt85_log_table
).



*&----------------------------------------------------------------------*
*& •  2.) SLG Setup
*&----------------------------------------------------------------------*
lr85_log_util->slg( )->set_object( 'ZLOGUTIL' ).
lr85_log_util->slg( )->set_sub_object( 'PO_CHANGE' ).
lr85_log_util->slg( )->enable( ).



*&----------------------------------------------------------------------*
*& •  3.) Simple Log Message as Witness
*&----------------------------------------------------------------------*
MESSAGE i000 WITH 'First Log' 'As' 'Witness Message' INTO lv85_dummy .
lr85_log_util->log( ).



*&----------------------------------------------------------------------*
*& •  4.) Add Log Message With long Text
*&----------------------------------------------------------------------*
DATA: lv85_long_text TYPE string .

lv85_long_text = |{ lv85_long_text }This is a very long text| .
lv85_long_text = |{ lv85_long_text }It is a long established fact that a reader will be distracted by the| .
lv85_long_text = |{ lv85_long_text }readable content of a page when looking at its layout. The point of| .
lv85_long_text = |{ lv85_long_text }using Lorem Ipsum is that it has a more-or-less normal distribution| .
lv85_long_text = |{ lv85_long_text }of letters, as opposed to using 'Content here, content here',| .
lv85_long_text = |{ lv85_long_text }making it look like readable English. Many desktop publishing| .
lv85_long_text = |{ lv85_long_text }packages and web page editors now use Lorem Ipsum as their| .
lv85_long_text = |{ lv85_long_text }default model text, and a search for 'lorem ipsum' will uncover| .
lv85_long_text = |{ lv85_long_text }many web sites still in their infancy. Various versions have evolved| .
lv85_long_text = |{ lv85_long_text }over the years, sometimes by accident, sometimes on purpose| .
lv85_long_text = |{ lv85_long_text }(injected humour and the like).| .

lr85_log_util->log(
  i_log_msgid = 'ZLOG_UTIL'
  i_log_msgno = '000'
  i_log_msgty = 'I'
  i_log_msgv1 = 'Second Log'
  i_log_msgv2 = 'With'
  i_log_msgv3 = 'Long Text'
  i_log_msgv4 = 'i_long_text = <str_txt>'
  i_long_text = lv85_long_text
).



*&----------------------------------------------------------------------*
*& •  5.) Add Log Message With Custom long Text
*&----------------------------------------------------------------------*
DATA: ls85_bal_parm TYPE bal_s_parm .

ls85_bal_parm-altext = 'ZCL_LOG_UTIL_ALTEXT' . " Specify YOUR SE61 Dialog Texts
APPEND VALUE #(
  parname  = 'P1'
  parvalue = 'This is a very long text'
) TO ls85_bal_parm-t_par .
APPEND VALUE #(
  parname  = 'P2'
  parvalue = ' It is a long established fact that a reader will be distracted by the'
) TO ls85_bal_parm-t_par .
APPEND VALUE #(
  parname  = 'P3'
  parvalue = ' readable content of a page when looking at its layout.'
) TO ls85_bal_parm-t_par .
APPEND VALUE #(
  parname  = 'P4'
  parvalue = ' P1, P2, P3 and P4 are placeholders set in Dialog Text'
) TO ls85_bal_parm-t_par .
APPEND VALUE #(
  parname  = 'P5'
  parvalue = ' ZCL_LOG_UTIL_ALTEXT(...)'
) TO ls85_bal_parm-t_par .

lr85_log_util->log(
  i_log_msgid      = 'ZLOG_UTIL'
  i_log_msgno      = '000'
  i_log_msgty      = 'I'
  i_log_msgv1      = 'Third Log'
  i_log_msgv2      = 'With'
  i_log_msgv3      = 'Long Text'
  i_log_msgv4      = 'i_cust_long_text = <structure>'
  i_cust_long_text = ls85_bal_parm
).



*&----------------------------------------------------------------------*
*& •  6.) Set Deferred Long Text
*&----------------------------------------------------------------------*
MESSAGE i000 WITH 'Message #4 - i000(zlog_util)' 'msgv2=a' 'msgv3=b' 'msgv4=c' INTO lv85_dummy .
lr85_log_util->log( ).
MESSAGE i000 WITH 'Message #5 - i000(zlog_util)' 'msgv2=a' 'msgv3=d' 'msgv4=e' INTO lv85_dummy .
lr85_log_util->log( ).
MESSAGE i000 WITH 'Message #6 - i000(zlog_util)' 'msgv2=f' 'msgv3=d' 'msgv4=g' INTO lv85_dummy .
lr85_log_util->log( ).
MESSAGE i000 WITH 'Message #7 - i000(zlog_util)' 'msgv2=h' 'msgv3=i' 'msgv4=g' INTO lv85_dummy .
lr85_log_util->log( ).
MESSAGE i000 WITH 'Message #8 - i000(zlog_util)' 'msgv2=k' 'msgv3=l' 'msgv4=m' INTO lv85_dummy .
lr85_log_util->log( ).

" i_long_text AND i_cust_long_text will have the same behavior
" So to simplify demo, we will use i_long_text

" Very simple case : set to the last logged message
lr85_log_util->set_long_text( 'Must be found to Message #8' ).

" Using Message Index
lr85_log_util->set_long_text(
  i_msg_index = 4
  i_long_text = 'Must be found to Message #4'
).

" Using Message Filters
DATA: ls_msg_filter TYPE bal_s_mfil .

APPEND VALUE #(
  sign   = 'I'
  option = 'EQ'
  low    = 'msgv3=d'
) TO ls_msg_filter-msgv3 .

lr85_log_util->set_long_text(
  i_long_text   = 'Must be found to Message #5 & #6'
  i_msg_filters = ls_msg_filter
).

CLEAR ls_msg_filter .

APPEND VALUE #(
  sign   = 'I'
  option = 'EQ'
  low    = 'msgv2=h'
) TO ls_msg_filter-msgv2 .

lr85_log_util->set_long_text(
  i_long_text   = 'Must be found to Message #7'
  i_msg_filters = ls_msg_filter
).



*&----------------------------------------------------------------------*
*& • 7.) Displaying Application Logs
*&----------------------------------------------------------------------*
lr85_log_util->slg( )->display( ).
