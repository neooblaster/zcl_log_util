*&----------------------------------------------------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&               Report ZCL_LOG_UTIL_EXAMPLES                                 &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&----------------------------[   MAIN INOS   ]-------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&                                                                            &*
*&  Author      : Nicolas DUPRE                                               &*
*&  Release     : xx.xx.2020                                                  &*
*&  Last Change : xx.xx.2020                                                  &*
*&                                                                            &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&----------------------------[   DEMO LIST   ]-------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&  #010 : ZCL_LOG_UTIL - Get started                                         &*
*&  #020 : Logging using own table                                            &*
*&  #030 : Adding extra data on log entry                                     &*
*&  #040 : Logging BAPI return tables                                         &*
*&  #050 : Logging BAPI return tables filled with extra data                  &*
*&  #060 : Logging many entries with extra data                               &*
*&  #065 : Changing Logging table during execution                            &*
*&  #070 : Logging in Application Log                                         &*
*&  #080 : Enabling / Disabling Application Log                               &*
*&  #090 : Logging specifying type                                            &*
*&  #100 : Overloading Log Messages                                           &*
*&  #110 : Overloading Log Messages using my own Setting Table                &* <<<
*&  #120 : Overloading using "Spot ID"                                        &*
*&  #130 : Overloading an existing log table                                  &*
*&  #140 : Logging for Batch Job                                              &*
*&  #150 : Managing outpus for Batch Job                                      &*
*&                                                                            &*
*&                                                                            &*
*&   xx : Change Log Table                                                    &*
*&                                                                            &*
*&  #R1 : List of object that can be logged (text, std, str, tab)             &*
*&                                                                            &*
*&                                                                            &*
*&   add parameter vbeln pour demo 4 & demo 5                                 &*
*&   add parameter to choose display in demo 7                                &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&--------------------------[   PROJECT TODO   ]------------------------------&*
*&----------------------------------------------------------------------------&*
*&  • OVERLOADING ::                                                          &*
*&    • Keep original msgid, msgno and msgty after overload                   &*
*&                                                                            &*
*&  • ALV Display ::                                                          &*
*&    • Handle column display                                                 &*
*&                                                                            &*
*&----------------------------------------------------------------------------&*
*&----------------------------[   REVISIONS   ]-------------------------------&*
*&----------------------------------------------------------------------------&*
*&                                                                            &*
*&---------------#------------------------------------------------------------&*
*& Date / Author | Updates Descriptions                                       &*
*&---------------#------------------------------------------------------------&*
*&               |                                                            &*
*&---------------#------------------------------------------------------------&*
*&               |                                                            &*
*&---------------#------------------------------------------------------------&*
*&----------------------------------------------------------------------------&*
REPORT ZCL_LOG_UTIL_EXAMPLES MESSAGE-ID zlog_util.


INCLUDE ZCL_LOG_UTIL_EXAMPLES_TOP.
INCLUDE ZCL_LOG_UTIL_EXAMPLES_SCR.
INCLUDE ZCL_LOG_UTIL_EXAMPLES_F01.



"&-------------------------------------------------------------------------&"
"&   Initialization                                                        &"
"&-------------------------------------------------------------------------&"
INITIALIZATION.



"&-------------------------------------------------------------------------&"
"&   Start of processing                                                   &"
"&-------------------------------------------------------------------------&"
START-OF-SELECTION.
  "&--------------------------------------&"
  "&---[  Demo Number 010  ]--------------&"
  "&--------------------------------------&"
  IF p_dem010 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_010.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 020  ]--------------&"
  "&--------------------------------------&"
  IF p_dem020 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_020.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 030  ]--------------&"
  "&--------------------------------------&"
  IF p_dem030 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_030.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 040  ]--------------&"
  "&--------------------------------------&"
  IF p_dem040 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_040.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 050  ]--------------&"
  "&--------------------------------------&"
  IF p_dem050 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_050.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 060  ]--------------&"
  "&--------------------------------------&"
  IF p_dem060 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_060.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 065  ]--------------&"
  "&--------------------------------------&"
  IF p_dem065 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_065.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 070  ]--------------&"
  "&--------------------------------------&"
  IF p_dem070 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_070.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 080  ]--------------&"
  "&--------------------------------------&"
  IF p_dem080 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_080.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 090  ]--------------&"
  "&--------------------------------------&"
  IF p_dem090 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_090.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 100  ]--------------&"
  "&--------------------------------------&"
  IF p_dem100 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_100.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 110  ]--------------&"
  "&--------------------------------------&"
  IF p_dem110 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_110.
  ENDIF.

  "&--------------------------------------&"
  "&---[  Demo Number 120  ]--------------&"
  "&--------------------------------------&"
  IF p_dem120 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_120.
  ENDIF.

  " ZCL_LOG_UTIL - Example #11

  IF p_dem999 EQ 'X'.
    INCLUDE ZCL_LOG_UTIL_EXAMPLE_DEMO_999.
  ENDIF.





"&-------------------------------------------------------------------------&"
"&   End of processing                                                     &"
"&-------------------------------------------------------------------------&"
END-OF-SELECTION.
