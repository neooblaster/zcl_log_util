*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_04
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Declaring own specific log table type
*&  • 2.) Initialization of ZCL_LOG_UTIL with our table
*&  • 3.) Define role of our field
*&  • 4.) Call BAPI generating error
*&  • 5.) Log BAPI messages
*&  • 6.) Displaying logs
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty4_my_log_table         ,
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
       END   OF ty4_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt4_log_table TYPE TABLE OF ty4_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr4_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr4_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt4_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr4_log_util->define( )->set(
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
*& • 4.) Call BAPI generating error
*&----------------------------------------------------------------------*
DATA: lt4_bapi_ret_tab TYPE TABLE OF bapiret2 .
DATA: ls4_poheader     TYPE bapimepoheader    .
DATA: ls4_poheaderx    TYPE bapimepoheaderx   .

ls4_poheader-doc_type  = 'ZTYP'.
ls4_poheaderx-doc_type = 'X'.


CALL FUNCTION 'BAPI_PO_CHANGE'
  EXPORTING
    purchaseorder                = '4500001189'
    poheader                     = ls4_poheader
    POHEADERX                    = ls4_poheaderx
*   POADDRVENDOR                 =
    testrun                      = 'X'
*   MEMORY_UNCOMPLETE            =
*   MEMORY_COMPLETE              =
*   POEXPIMPHEADER               =
*   POEXPIMPHEADERX              =
*   VERSIONS                     =
*   NO_MESSAGING                 =
*   NO_MESSAGE_REQ               =
*   NO_AUTHORITY                 =
*   NO_PRICE_FROM_PO             =
*   PARK_UNCOMPLETE              =
*   PARK_COMPLETE                =
* IMPORTING
*   EXPHEADER                    =
*   EXPPOEXPIMPHEADER            =
 TABLES
    return                       = lt4_bapi_ret_tab
*   POITEM                       =
*   POITEMX                      =
*   POADDRDELIVERY               =
*   POSCHEDULE                   =
*   POSCHEDULEX                  =
*   POACCOUNT                    =
*   POACCOUNTPROFITSEGMENT       =
*   POACCOUNTX                   =
*   POCONDHEADER                 =
*   POCONDHEADERX                =
*   POCOND                       =
*   POCONDX                      =
*   POLIMITS                     =
*   POCONTRACTLIMITS             =
*   POSERVICES                   =
*   POSRVACCESSVALUES            =
*   POSERVICESTEXT               =
*   EXTENSIONIN                  =
*   EXTENSIONOUT                 =
*   POEXPIMPITEM                 =
*   POEXPIMPITEMX                =
*   POTEXTHEADER                 =
*   POTEXTITEM                   =
*   ALLVERSIONS                  =
*   POPARTNER                    =
*   POCOMPONENTS                 =
*   POCOMPONENTSX                =
*   POSHIPPING                   =
*   POSHIPPINGX                  =
*   POSHIPPINGEXP                =
*   POHISTORY                    =
*   POHISTORY_TOTALS             =
*   POCONFIRMATION               =
*   SERIALNUMBER                 =
*   SERIALNUMBERX                =
*   INVPLANHEADER                =
*   INVPLANHEADERX               =
*   INVPLANITEM                  =
*   INVPLANITEMX                 =
*   POHISTORY_MA                 =
*   NFMETALLITMS                 =
.



*&----------------------------------------------------------------------*
*& • 5.) Log BAPI messages
*&----------------------------------------------------------------------*
" Now we want to log returned table
"
" !! Some standard table are natively manage by ZCL_LOG_UTIL.
"    If table is not know, you can define field as you already done for
"    your own custom table using DEFINE( )->SET( )
"
"    List available here : zcl_log_util=>factory( ) :
"
"        - zcl_log_util=>ty_log_table
"        - PROTT
"        - BAPIRET1
"        - BAPIRET2
"        - BAPI_CORU_RETURN
"        - BAPI_ORDER_RETURN
"        - BDCMSGCOLL
"        - RCOMP
"
*&----------------------------------------------------------------------*
lr4_log_util->log( lt4_bapi_ret_tab ).



*&----------------------------------------------------------------------*
*& • 6.) Displaying logs
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
lr4_log_util->display( ).
