*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_110
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  •  1.) Explanation about Overloading
*&  •  2.) Declaring own specific log table type
*&  •  3.) Initialization of ZCL_LOG_UTIL with our table
*&  •  4.) Define role of our field
*&  •  5.) Define your setting table
*&  •  6.) Enabling Overloading
*&  •  7.) Logging a Message 1 which will overload
*&  •  8.) Logging a Message 2 which will overload
*&  •  9.) Disabling Overloading
*&  • 10.) Relogging Message 2 which will not overload
*&  • 11.) Displaying Log
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*& • 1.) Explanation about Overloading
*&----------------------------------------------------------------------*
*&
*&  In custom programs, you have to manage your own messages
*&  (preferably manage with Message Class), but you have also to
*&  message return next to call functions (BAPI/BAI).
*&
*&  You can not get an exhaustiv list of all possible message that
*&  BAPI can return.
*&
*&  Sometime, some of message are raised with type Error (E), but
*&  in your case, BAPI has been executed successfully
*&  (Object created or modification done successfully).
*&  So we can consider these error message as False Positiv
*&
*&  In another way, BAPI message can be too complexe or technical
*&  and you want to display a message more readable for business men.
*&
*&  In both cases, it not recommanded to modify your program to add
*&  management rule using IF/ENDIF statements.
*&  Updating these ùanagement rules need a DEVELOPER key.
*&
*&  The best way is to use a Customizing table to manage rule and
*&  to adjust behavior. Moreover, that can be done by functionnal
*&  increasing the reactivity time.
*&
*&  Overloading offers a way to manipulate messages using a Customizing
*&  table.
*&
*&  The Class ZCL_LOG_UTIL come with it own customizing table that you
*&  can use to manage Overloading Rules.
*&  You can also set your own Customzing table specifying how
*&  to read your entries and perform overloading.
*&
*&  Please find below the default Customzing Table with role of fields :
*&  • Go to SE11 to take acknoledge of table ZLOG_UTIL_OVERLO
*&  • Table ZLOG_UTIL_OVERLO can be manage using TCODE ZOVERLOG
*&  • This is the technical names
*&
*&
*&  #-----------#-----------#-----------#---------#---------#---------#----------#--------#---------#---------#---------#---------#---------#---------#---------#---------#
*&  | CODE       | DOMAINE  | DATA      | INPUT1  | INPUT2  | INPUT3  | INPUT4   | INPUT5 | OUTPUT1 | OUTPUT2 | OUTPUT3 | OUTPUT4 | OUTPUT5 | OUTPUT6 | OUTPUT7 | OUTPUT8 |
*&  #-----------#-----------#-----------#---------#---------#---------#----------#--------#---------#---------#---------#---------#---------#---------#---------#---------#
*&  | <filter1> | <filter2> | <filter2> | <msgid> | <msgno> | <msgty> | <spotid> |        | <msgid> | <msgno> | <msgty> | <msgv1> | <msgv2> | <msgv3> | <msgv4> |         |
*&  #-----------#-----------#-----------#---------#---------#---------#----------#--------#---------#---------#---------#---------#---------#---------#---------#---------#
*&
*&  Detail about field roles :
*&    • Field CODE    : In Development world, especially in SAP, development have a WRICEF code
*&                      Whith these field you can prefilter result to perform Overloading
*&    • Field DOMAINE : The application domain also comes with WRICEF (Eg : SD, MM, WM, PP, QM, FI, CO etc)
*&                      DOMAINE with E because DOMAIN is a table keyword
*&    • Field DATA    : Data field ofter stand to identify the kind of data the entry reprensent
*&                      in the customzing table (eg: EMAIL, BODY, SUBJECT or here OVERLOADING)
*&    • Field INPUT1  : Input 1 will handle the Message Class ID
*&                      This is the source message ID that overloading will use to find if message must be overload
*&    • Field INPUT2  : Input 2 will handle the Message Number
*&                      This is the source message Number that overloading will use to find if message must be overload
*&    • Field INPUT3  : Input 3 will handle the Message Type
*&                      This is the source message Type that overloading will use to find if message must be overload
*&    • Field INPUT4  : Input 4 will handle an extra identifiant called Spot ID
*&                      Spot ID allow you to overload message in a specific location / moment of your program
*&                      Spot ID will be explain in another example
*&                      This is the source message Type that overloading will use to find if message must be overload
*&    • Field OUTPUT1 : Output 1 will handle the new Message Class ID.
*&                      Left blank, original Message Class ID will be kept.
*&    • Field OUTPUT2 : Output 2 will handle the new Message Number.
*&                      Left blank, original Message Number will be kept.
*&    • Field OUTPUT3 : Output 3 will handle the new Message Type.
*&                      Left blank, original Message Type will be kept.
*&    • Field OUTPUT4 : Output 4 will handle the new Message Value 1.
*&                      Left blank, original Message Value 1 will be kept.
*&    • Field OUTPUT5 : Output 5 will handle the new Message Value 2.
*&                      Left blank, original Message Value 2 will be kept.
*&    • Field OUTPUT6 : Output 6 will handle the new Message Value 3.
*&                      Left blank, original Message Value 3 will be kept.
*&    • Field OUTPUT7 : Output 7 will handle the new Message Value 4.
*&                      Left blank, original Message Value 4 will be kept.
*&
*&
*&
*&
*&
*&  How Overloading Works :
*&
*&    Considering the following entries in your table for Custom Message Classe ZLOG_UTIL
*&
*&    ZLOG_UTIL :
*&      000 :: &1&2&3&4
*&      100 :: ZCL_LOG_UTIL_EXAMPLE - Message Number 1 without placeholders
*&      101 :: ZCL_LOG_UTIL_EXAMPLE - Message Number 2 with 1 placeholders : &
*&      102 :: ZCL_LOG_UTIL_EXAMPLE - Message Number 3 with 2 placeholders : & and &
*&      103 :: ZCL_LOG_UTIL_EXAMPLE - Message Number 4 with 3 placeholders : &, & ADN &
*&      104 :: ZCL_LOG_UTIL_EXAMPLE - Message Number 5 with 4 placeholders : &, &, & n &
*&
*&
*&  #------#---------#------#------------#---------#---------#----------#--------#-----------#---------#---------#---------#---------#---------#---------#---------#
*&  | CODE | DOMAINE | DATA | INPUT1     | INPUT2  | INPUT3  | INPUT4   | INPUT5 | OUTPUT1   | OUTPUT2 | OUTPUT3 | OUTPUT4 | OUTPUT5 | OUTPUT6 | OUTPUT7 | OUTPUT8 |
*&  #------#---------#------#------------#---------#---------#----------#--------#-----------#---------#---------#---------#---------#---------#---------#---------#
*&  |      |         |      | ZLOG_UTIL  | 110     | E       |          |        | ZLOG_UTIL | 000     | W       | AL      | PHA     | BE      | TA      |         | << ENTRY 1
*&  |      |         |      | ZLOG_UTIL  | 104     | E       |          |        |           |         | S       | NOT     | AN      | ERROR   |         |         | << ENTRY 2
*&  #------#---------#------#------------#---------#---------#----------#--------#-----------#---------#---------#---------#---------#---------#---------#---------#
*&
*&  Case 1 :
*&  ---------
*&    Logging the followging message :
*&
*&       e100(zlog_util) which displays without overloading : "ZCL_LOG_UTIL_EXAMPLE - Message Number 1 without placeholders" with type (E)
*&
*&    After overloading using entry 1 becomes :
*&
*&       w000(zlog_util) which displays : "ALPHABETA" (With type W)
*&
*&
*&
*&  Case 2 :
*&  ---------
*&    Logging the followging message :
*&
*&       e104(zlog_util) WITH 'a' 'b' 'c' 'd' which displays without overloading : "ZCL_LOG_UTIL_EXAMPLE - Message Number 5 with 4 placeholders : a, b, c n d" (With type E)
*&
*&    After overloading using entry 2 becomes :
*&
*&       s104(zlog_util) which displays : "ZCL_LOG_UTIL_EXAMPLE - Message Number 5 with 4 placeholders : NOT, AN, ERROR n d" (With type S)
*&
*&
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*& • 2.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty110_my_log_table         ,
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
       END   OF ty110_my_log_table         .



*&----------------------------------------------------------------------*
*& • 3.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt110_log_table TYPE TABLE OF ty110_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr110_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr110_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt110_log_table
).



*&----------------------------------------------------------------------*
*& • 4.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr110_log_util->define( )->set(
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
*& •  5.) Define your setting table
*&----------------------------------------------------------------------*
" You can define you SAP Custom Settings table
" Note : here we will set same fields as default ones. It's just for
"        the demonstration
lr110_log_util->overload( )->setting_tab( )->set(
  I_TABLE_NAME            = 'ZLOG_UTIL_OVERLO' "          " DDIC Table Name
  I_FILTER_DEVCODE_FIELD  = 'CODE'             " OPTIONAL " Pre-filter field standing for WRICEF
  I_FILTER_DOMAIN_FIELD	  = 'DOMAINE'          " OPTIONAL " Pre-filter field standing for dev domain
  I_FILTER_DATA_FIELD    	= 'DATA'             " OPTIONAL " Pre-filter field standing for kind of data
  I_SOURCE_ID_FIELD	      = 'INPUT1'           "          " Field read for checking Source Message ID
  I_SOURCE_NUMBER_FIELD	  = 'INPUT2'           "          " Field read for checking Source Message Number
  I_SOURCE_TYPE_FIELD	    = 'INPUT3'           "          " Field read for checking Source Message Type
  I_SOURCE_SPOT_FIELD     = 'INPUT4'           "          " Field read for checking Spot ID (when enabled)
  I_SOURCE_PARAM1_FIELD	  = 'INPUT5'           " OPTIONAL " Field read for checking extra parameter (when set) (eg to handle SPRAS)
*  I_SOURCE_PARAM2_FIELD    = ''                 " OPTIONAL " Field read for checking extra parameter (when set)
  I_OVERLOAD_ID_FIELD     = 'OUTPUT1'          "          " Field read to replace Message ID (when not initial)
  I_OVERLOAD_NUMBER_FIELD	= 'OUTPUT2'          "          " Field read to replace Message Number (when not initial)
  I_OVERLOAD_TYPE_FIELD	  = 'OUTPUT3'          "          " Field read to replace Message Type (when not initial)
  I_OVERLOAD_MSGV1_FIELD  = 'OUTPUT4'          " OPTIONAL " Field read to replace Message Variable 1 (when not initial)
  I_OVERLOAD_MSGV2_FIELD  = 'OUTPUT5'          " OPTIONAL " Field read to replace Message Variable 2 (when not initial)
  I_OVERLOAD_MSGV3_FIELD  = 'OUTPUT6'          " OPTIONAL " Field read to replace Message Variable 3 (when not initial)
  I_OVERLOAD_MSGV4_FIELD  = 'OUTPUT7'          " OPTIONAL " Field read to replace Message Variable 4 (when not initial)
  I_OVERLOAD_IGNORE_FIELD	= 'OUTPUT8'          " OPTIONAL " Field read to check if message must be completely ignored (Not ignored in SLG)
).



*&----------------------------------------------------------------------*
*& •  6.) Enabling Overloading
*&----------------------------------------------------------------------*
lr110_log_util->overload( )->enable( ).



*&----------------------------------------------------------------------*
*& •  7.) Logging a Message 1 which will overload
*&----------------------------------------------------------------------*
" Logging directly to change using MESSAGE ID ... INTO dummy variable.
lr110_log_util->e(
  i_log_msgid = 'ZLOG_UTIL'
  i_log_msgno = '100'
).
">>> Expected : "ALPHABETA" with type W



*&----------------------------------------------------------------------*
*& •  8.) Logging a Message 2 which will overload
*&----------------------------------------------------------------------*
" Logging directly to change using MESSAGE ID ... INTO dummy variable.
lr110_log_util->e(
  i_log_msgid = 'ZLOG_UTIL'
  i_log_msgno = '104'
  i_log_msgv1 = 'a'
  i_log_msgv2 = 'b'
  i_log_msgv3 = 'c'
  i_log_msgv4 = 'd'
).
">>> Expected : "ZCL_LOG_UTIL_EXAMPLE - Message Number 5 with 4 placeholders : NOT, AN, ERROR n d" with type S



*&----------------------------------------------------------------------*
*& •  9.) Disabling Overloading
*&----------------------------------------------------------------------*
lr110_log_util->overload( )->disable( ).



*&----------------------------------------------------------------------*
*& • 10.) Relogging Message 2 which will not overload
*&----------------------------------------------------------------------*
" Logging directly to change using MESSAGE ID ... INTO dummy variable.
lr110_log_util->e(
  i_log_msgid = 'ZLOG_UTIL'
  i_log_msgno = '104'
  i_log_msgv1 = 'a'
  i_log_msgv2 = 'b'
  i_log_msgv3 = 'c'
  i_log_msgv4 = 'd'
).
">>> Expected : "ZCL_LOG_UTIL_EXAMPLE - Message Number 5 with 4 placeholders : a, b, c n d"


*&----------------------------------------------------------------------*
*& • 11.) Displaying Log
*&----------------------------------------------------------------------*
lr110_log_util->display( ).
