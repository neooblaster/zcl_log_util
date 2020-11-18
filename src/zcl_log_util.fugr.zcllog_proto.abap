FUNCTION ZCLLOG_PROTO.
*"----------------------------------------------------------------------
*"*"Interface locale :
*"  TABLES
*"      I_TABLE TYPE  STANDARD TABLE
*"----------------------------------------------------------------------



    DATA:
        lr_typedesc TYPE REF TO cl_abap_typedescr   ,
        lr_struct   TYPE REF TO cl_abap_structdescr ,
        lv_strnam   TYPE        string              .

    lr_typedesc ?= cl_abap_typedescr=>describe_by_data( I_TABLE ).
    lv_strnam    = lr_typedesc->get_relative_name( ).

  IF 1 = 2.ENDIF.



ENDFUNCTION.
