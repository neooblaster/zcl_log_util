*&----------------------------------------------------------------------*
*& Include          ZCL_LOG_UTIL_EXAMPLE_DEMO_070
*&----------------------------------------------------------------------*



*&----------------------------------------------------------------------*
*&-------------------[  PURPOSE OF THE EXAMPLE  ]-----------------------*
*&----------------------------------------------------------------------*
*&
*&  • 1.) Declaring own specific log table type
*&  • 2.) Initialization of ZCL_LOG_UTIL with our table
*&  • 3.) Define role of our field
*&  • 4.) Configuration Application Log
*&  • 5.) Call BAPI generating error
*&  • 6.) Log BAPI messages
*&  • 7.) Displaying logs
*&
*&----------------------------------------------------------------------*
*&----------------------------------------------------------------------*


*&----------------------------------------------------------------------*
*& • 1.) Declaring own specific log table type
*&----------------------------------------------------------------------*
" Depending of our need, we probably need to display some other data
" with our log message like "Document Number", "Source File", "Source Line" etc
TYPES: BEGIN OF ty70_my_log_table         ,
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
       END   OF ty70_my_log_table         .



*&----------------------------------------------------------------------*
*& • 2.) Initialization of ZCL_LOG_UTIL with our table
*&----------------------------------------------------------------------*
" Now we will declare Internal Table using our type
DATA: lt70_log_table TYPE TABLE OF ty70_my_log_table.

" Declaring reference to ZCL_LOG_UTIL
DATA: lr70_log_util TYPE REF TO zcl_log_util.


" Instanciation need to use "Factory"
zcl_log_util=>factory(
  " Receiving Instance of ZCL_LOG_UTIL
  IMPORTING
    e_log_util  = lr70_log_util
  " Passing our log table
  CHANGING
    c_log_table = lt70_log_table
).



*&----------------------------------------------------------------------*
*& • 3.) Define role of our field
*&----------------------------------------------------------------------*
" The ZCL_UTIL_LOG need to know wich field of your table stands for standard message one
"
" !! Value stand for field name of your structure, so name must be in UPPERCASE
lr70_log_util->define( )->set(
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
DATA: lr70_slg TYPE REF TO zcl_log_util_slg.

" ──┐ Get SLG Instance
lr70_slg = lr70_log_util->slg( ).

" ──┐ Set Application Log Main Object & Sub-object
"     !! Sub-object is mandatory if your main has at least one sub-object.
lr70_slg->set_object( 'ZLOGUTIL' ).
lr70_slg->set_sub_object( 'PO_CHANGE' ).

" ──┐ You can provided External Number (Like PO Number)
lr70_slg->set_external_number( '4500001189' ).

" ──┐ You can also set retention time of logs in days
lr70_slg->set_retention( 30 ).


" ──┐ Finally, we enable the functionnality
lr70_slg->enable( ).
" <<<--- From here, all call of method log( ) will add an entry(ies) to Application Log


*&----------------------------------------------------------------------*
*& • 5.) Call BAPI generating error
*&----------------------------------------------------------------------*
DATA: lt70_bapi_ret_tab TYPE TABLE OF bapiret2 .
DATA: ls70_poheader     TYPE bapimepoheader    .
DATA: ls70_poheaderx    TYPE bapimepoheaderx   .

ls70_poheader-doc_type  = 'ZTYP'.
ls70_poheaderx-doc_type = 'X'.


CALL FUNCTION 'BAPI_PO_CHANGE'
  EXPORTING
    purchaseorder                = '4500001189'
    poheader                     = ls70_poheader
    POHEADERX                    = ls70_poheaderx
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
    return                       = lt70_bapi_ret_tab
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
*& • 6.) Log BAPI messages
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
lr70_log_util->log( lt70_bapi_ret_tab ).



*&----------------------------------------------------------------------*
*& • 7.) Displaying logs
*&----------------------------------------------------------------------*
" ZCL_LOG_UTIL offer a display feature using ALV
" It prevent use to make your own routine using ALV on your table
" ──┐ Display my Log Table
lr70_log_util->display( ).

" ──┐ Display Application Log result
lr70_slg->display( ).
" You can run like this : r7_log_util->slg( )->display( ).
