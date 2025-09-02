class ZCL_LOG_UTIL_SLG definition
  public
  final
  create public .

public section.

  class-data _BAL_ALT_TEXT type BALTEXT read-only value 'ZCL_LOG_UTIL_ALTEXT' ##NO_TEXT.

  methods CONSTRUCTOR .
  methods SET_OBJECT
    importing
      !I_SLG_OBJECT type BALOBJ_D
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_SUB_OBJECT
    importing
      !I_SLG_SUB_OBJECT type BALSUBOBJ
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_EXTERNAL_NUMBER
    importing
      !I_SLG_EXT_NUMBER type BALNREXT
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods SET_RETENTION
    importing
      !I_SLG_RETENTION_DAYS type I
    returning
      value(SELF) type ref to ZCL_LOG_UTIL_SLG .
  methods LOG
    importing
      !I_MSGID type SY-MSGID optional
      !I_MSGNO type SY-MSGNO optional
      !I_MSGTY type SY-MSGTY optional
      !I_MSGV1 type SY-MSGV1 optional
      !I_MSGV2 type SY-MSGV2 optional
      !I_MSGV3 type SY-MSGV3 optional
      !I_MSGV4 type SY-MSGV4 optional
      !I_MSGXX_FLG type ABAP_BOOL optional
      !I_MSGTX type STRING optional
      !I_MSGTX_FLG type ABAP_BOOL optional
      !I_LONG_TEXT type STRING optional
      !I_CUST_LONG_TEXT type BAL_S_PARM optional
    preferred parameter I_MSGTX
    changing
      !C_NEW_LOGNUMBERS type BAL_T_LGNM optional .
  methods ENABLE .
  methods DISABLE .
  methods IS_ENABLED
    returning
      value(R_ENABLED) type ABAP_BOOL .
  methods DISPLAY .
  methods _CREATE .
  methods _SAVE
    returning
      value(R_NEW_LOGNUMBERS) type BAL_T_LGNM .
  methods _DESTRUCTOR .
  methods GET_OBJECT
    returning
      value(R_SLG_OBJECT) type BALOBJ_D .
  methods GET_SUB_OBJECT
    returning
      value(R_SLG_SUB_OBJECT) type BALSUBOBJ .
  methods GET_EXTERNAL_NUMBER
    returning
      value(R_SLG_EXT_NUMBER) type BALNREXT .
  methods GET_RETENTION
    returning
      value(R_SLG_RETENTION) type I .
  methods GET_NEW_LOGNUMBER
    returning
      value(R_NEW_LOGNUMBER) type BALOGNR .
  methods GET_HANDLER
    returning
      value(R_HANDLER) type BALLOGHNDL .
  methods SET_LONG_TEXT
    importing
      !I_LONG_TEXT type STRING optional
      !I_CUST_LONG_TEXT type BAL_S_PARM optional
      !I_MSG_INDEX type BALMNR optional
      !I_MSG_HANDLE type BALLOGHNDL optional
      !I_MSG_FILTERS type BAL_S_MFIL optional
    changing
      !C_NEW_LOGNUMBERS type BAL_T_LGNM optional .
protected section.
private section.

  data _SLG_ENABLED type C .
  data _SLG_HANDLER type BALLOGHNDL .
  data _SLG_OBJECT type BALOBJ_D value 'ZLOGUTIL' ##NO_TEXT.
  data _SLG_SUB_OBJECT type BALSUBOBJ .
  data _SLG_EXT_NUMBER type BALNREXT .
  data _SLG_PROBCLASS type BALPROBCL value '4' ##NO_TEXT.
  data _SLG_RETENTION type I value 30 ##NO_TEXT.
  class-data _PROBCLASS_VERY_HIGH type BALPROBCL value '1' ##NO_TEXT.
  class-data _PROBCLASS_HIGH type BALPROBCL value '2' ##NO_TEXT.
  class-data _PROBCLASS_MEDIUM type BALPROBCL value '3' ##NO_TEXT.
  class-data _PROBCLASS_LOW type BALPROBCL value '4' ##NO_TEXT.
  class-data _PROBCLASS_NONE type BALPROBCL value ' ' ##NO_TEXT.
  data _NEW_LOGNUMBERS type BAL_T_LGNM .
  class-data _BAL_ALT_TEXT_MAX_PARAM type I value 100 ##NO_TEXT.

  methods _MAKE_BAL_MESSAGE_PARAMS
    importing
      !I_LONG_TEXT type STRING optional
    preferred parameter I_LONG_TEXT
    returning
      value(R_PARAMS) type BAL_S_PARM .
ENDCLASS.



CLASS ZCL_LOG_UTIL_SLG IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.


  method DISABLE.

    me->_slg_enabled = ''.

  endmethod.


  method DISPLAY.

    DATA:
        ls_log_filter TYPE bal_s_lfil ,
        lt_log_header TYPE balhdr_t   ,
        lt_log_handle TYPE bal_t_logh ,
        lt_log_loaded TYPE bal_t_logh .

    FIELD-SYMBOLS:
                 <fs_log_header_s> TYPE balhdr.


    " Check if SLG is enabled
    CHECK me->is_enabled( ) EQ 'X'.


    CALL FUNCTION 'BAL_FILTER_CREATE'
      EXPORTING
        i_object       = me->_slg_object       " Default "ZLOGUTIL"
        i_subobject    = me->_slg_sub_object   "
        i_extnumber    = me->_slg_ext_number   "
        i_aldate_from  = sy-datum              " 20200430
        i_aldate_to    = sy-datum              " 20200430
        i_altime_from  = '000000'              " 000000
        i_altime_to    = '235959'              " 235959
        i_probclass_to = me->_slg_probclass    "
        i_alprog       = '*'                   "
        i_altcode      = '*'                   "
        i_aluser       = '*'                   "
        i_almode       = '*'                   "
      IMPORTING
        e_s_log_filter = ls_log_filter
      EXCEPTIONS
        OTHERS         = 1.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAL_DB_SEARCH'
        EXPORTING
          i_s_log_filter = ls_log_filter
        IMPORTING
          e_t_log_header = lt_log_header
        EXCEPTIONS
          OTHERS         = 1.

      IF sy-subrc EQ 0.

        LOOP AT lt_log_header ASSIGNING <fs_log_header_s>.
          CALL FUNCTION 'BAL_LOG_EXIST'
            EXPORTING
              i_log_handle  = <fs_log_header_s>-log_handle
            EXCEPTIONS
              log_not_found = 1.
          IF sy-subrc = 0.
            INSERT <fs_log_header_s>-log_handle INTO TABLE lt_log_handle.
            DELETE lt_log_header.
          ENDIF.
        ENDLOOP.

        CALL FUNCTION 'BAL_DB_LOAD'
          EXPORTING
            i_t_log_header         = lt_log_header
            i_do_not_load_messages = ' '
          IMPORTING
            e_t_log_handle         = lt_log_loaded
          EXCEPTIONS
            OTHERS                 = 0.

        IF sy-subrc NE 0.
          " @TODO : implement error message
        ENDIF.

        INSERT LINES OF lt_log_loaded INTO TABLE lt_log_handle.

        CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
          EXPORTING
            i_t_log_handle = lt_log_handle
            "i_s_display_profile = ls_display_profile
            "i_srt_by_timstmp    = lv_sort_by_ts " True Or False
          EXCEPTIONS
            no_authority   = 1
            OTHERS         = 2.

        IF NOT lt_log_loaded[] IS INITIAL.
          CALL FUNCTION 'BAL_GLB_MEMORY_REFRESH'
            EXPORTING
              i_refresh_all            = ' ' " True or false
              i_t_logs_to_be_refreshed = lt_log_loaded
            EXCEPTIONS
              OTHERS                   = 0.
        ENDIF.
      ELSE.
        " @TODO : implement error message

      ENDIF.

    ELSE.
      " @TODO : implement error message

    ENDIF.

  endmethod.


  method ENABLE.

    me->_slg_enabled = 'X'.

  endmethod.


  method GET_EXTERNAL_NUMBER.

    r_slg_ext_number = me->_slg_ext_number.

  endmethod.


  method GET_HANDLER.

    DATA: ls_new_lognumber TYPE bal_s_lgnm .

    READ TABLE me->_new_lognumbers INTO ls_new_lognumber INDEX 1 .

    r_handler = ls_new_lognumber-log_handle .

  endmethod.


  method GET_NEW_LOGNUMBER.

    DATA: ls_lognumber TYPE bal_s_lgnm .

    READ TABLE me->_new_lognumbers INTO ls_lognumber WITH KEY log_handle = me->get_handler( ).

    r_new_lognumber = ls_lognumber-lognumber .

  endmethod.


  method GET_OBJECT.

    r_slg_object = me->_slg_object.

  endmethod.


  method GET_RETENTION.

    r_slg_retention = me->_slg_retention.

  endmethod.


  method GET_SUB_OBJECT.

    r_slg_sub_object = me->_slg_sub_object.

  endmethod.


  method IS_ENABLED.

    r_enabled = me->_slg_enabled.

  endmethod.


  method LOG.

    DATA:
        ls_s_msg      TYPE bal_s_msg                    ,
        "lv_probclass TYPE bal_s_msg-probclass          ,
        lv_free_text  TYPE c          LENGTH 1024       ,
        lv_msgtx_flag TYPE c          LENGTH 1          ,
        ls_params     TYPE bal_s_parm                   .


    " If Application Log is not handled, create BAL
    IF me->_SLG_HANDLER IS INITIAL.
      me->_create( ).
    ENDIF.

    " Let considering if ONLY i_msgtx (PREFERED) is supplied
    " So, flag indicator is not enabled => set value to X
    IF    i_msgid     IS NOT SUPPLIED
      AND i_msgno     IS NOT SUPPLIED
      AND i_msgty     IS NOT SUPPLIED
      AND i_msgv1     IS NOT SUPPLIED
      AND i_msgv2     IS NOT SUPPLIED
      AND i_msgv3     IS NOT SUPPLIED
      AND i_msgv4     IS NOT SUPPLIED
      AND i_msgxx_flg IS NOT SUPPLIED
      AND i_msgtx     IS     SUPPLIED AND i_msgtx IS NOT INITIAL
      AND i_msgtx_flg IS NOT SUPPLIED.
      lv_msgtx_flag = 'X'.
    ENDIF.

    " Handling Long Text
    " Note : IS SUPPLIED can not be use due to nesting.
    " If provided, use it as is
    ls_params = i_cust_long_text .
    " If not provided, check if long text is provided
    IF i_cust_long_text IS INITIAL AND i_long_text IS NOT INITIAL.
      ls_params = me->_make_bal_message_params( i_long_text ).
    ENDIF.

    " Managing Standard Message (sy-msgxx)
    IF i_msgxx_flg IS SUPPLIED AND i_msgxx_flg EQ 'X'.
      ls_s_msg-msgid     = i_msgid            .
      ls_s_msg-msgno     = i_msgno            .
      ls_s_msg-msgty     = i_msgty            .
      ls_s_msg-msgv1     = i_msgv1            .
      ls_s_msg-msgv2     = i_msgv2            .
      ls_s_msg-msgv3     = i_msgv3            .
      ls_s_msg-msgv4     = i_msgv4            .
      ls_s_msg-probclass = me->_slg_probclass .
      ls_s_msg-params    = ls_params          .

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_s_msg       = ls_s_msg
          i_log_handle  = me->_slg_handler
        EXCEPTIONS
          log_not_found = 1
          OTHERS        = 2.

      IF sy-subrc NE 0.
        " TODO : implement error message
      ENDIF.

    ENDIF.

    " Managing Free Message Text
    IF   ( i_msgtx_flg   IS SUPPLIED AND i_msgtx_flg EQ 'X' )
      OR ( lv_msgtx_flag EQ 'X' ).

      lv_free_text = i_msgtx.
      CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
        EXPORTING
          i_log_handle              = me->_slg_handler
          i_msgty                   = i_msgty
          i_probclass               = me->_slg_probclass
          i_text                    = lv_free_text
*         I_S_CONTEXT               =
          i_s_params                = ls_params
*         I_DETLEVEL                = '1'
*       IMPORTING
*         E_S_MSG_HANDLE            =
*         E_MSG_WAS_LOGGED          =
*         E_MSG_WAS_DISPLAYED       =
       EXCEPTIONS
          log_not_found             = 1
          msg_inconsistent          = 2
          log_is_full               = 3
          OTHERS                    = 4.

      IF sy-subrc <> 0.
        " TODO : implement error message
      ENDIF.

    ENDIF.

    " Save entry
    c_new_lognumbers = me->_save( ).

  endmethod.


  method SET_EXTERNAL_NUMBER.

    me->_slg_ext_number = i_slg_ext_number.

    self = me.

  endmethod.


  method SET_LONG_TEXT.

    DATA: lt_log_handle           TYPE                   bal_t_logh ,
          lt_msg_handle           TYPE                   bal_t_msgh ,
          lt_msg_handle_to_update TYPE STANDARD TABLE OF balmsghndl ,
          ls_msg_handle           TYPE                   balmsghndl ,
          ls_bal_msg              TYPE                   bal_s_msg  ,
          lv_lines                TYPE                   i          .

    " Set Long Text can be only use if BAL exists
    IF me->_slg_handler IS NOT INITIAL.

      " First, we have to read the current BAL
      CALL FUNCTION 'BAL_GLB_SEARCH_MSG'
        EXPORTING
*         I_S_LOG_FILTER                      =
*         I_T_LOG_CONTEXT_FILTER              =
          i_t_log_handle                      = lt_log_handle
*         I_S_MSG_FILTER                      =
*         I_T_MSG_CONTEXT_FILTER              =
*         I_T_MSG_HANDLE                      =
*         I_MSG_CONTEXT_FILTER_OPERATOR       = 'A'
       IMPORTING
*         E_T_LOG_HANDLE                      =
          e_t_msg_handle                      = lt_msg_handle
        EXCEPTIONS
          msg_not_found                       = 1
          OTHERS                              = 2     .

      " Handle 'i_msg_index' and 'i_msg_handle'
      IF sy-subrc EQ 0 .
        " Read Message Handle according to expected importing parameters
        "
        "   If multiple importing, all responding message will be updated
        "

        " IS SUPPLIED can not be use due to nesting
        IF i_msg_handle IS NOT INITIAL.
          READ TABLE lt_msg_handle INTO ls_msg_handle WITH KEY log_handle = i_msg_handle .

          IF sy-subrc EQ 0 .
            APPEND ls_msg_handle TO lt_msg_handle_to_update .
          ENDIF .
        ENDIF.

        " Considering 'Index' can be the log message number
        IF i_msg_index IS NOT INITIAL .
          READ TABLE lt_msg_handle INTO ls_msg_handle WITH KEY msgnumber  = i_msg_index .

          IF sy-subrc NE 0 .
            READ TABLE lt_msg_handle INTO ls_msg_handle INDEX i_msg_index .

            IF sy-subrc EQ 0 .
              APPEND ls_msg_handle TO lt_msg_handle_to_update .
            ENDIF .

          ELSE.
            APPEND ls_msg_handle TO lt_msg_handle_to_update .
          ENDIF .
        ENDIF.

        " If no importing parameter, update the last message
        IF i_msg_handle IS INITIAL AND i_msg_index IS INITIAL AND i_msg_filters IS INITIAL.
          DESCRIBE TABLE lt_msg_handle LINES lv_lines .
          READ TABLE lt_msg_handle INTO ls_msg_handle INDEX lv_lines .

          IF sy-subrc EQ 0 .
            APPEND ls_msg_handle TO lt_msg_handle_to_update .
          ENDIF .
        ENDIF.
      ENDIF .

      " Search again using message filters
      IF i_msg_filters IS NOT INITIAL.
        CALL FUNCTION 'BAL_GLB_SEARCH_MSG'
          EXPORTING
*           I_S_LOG_FILTER                      =
*           I_T_LOG_CONTEXT_FILTER              =
            i_t_log_handle                      = lt_log_handle
            i_s_msg_filter                      = i_msg_filters
*           I_T_MSG_CONTEXT_FILTER              =
*           I_T_MSG_HANDLE                      =
*           I_MSG_CONTEXT_FILTER_OPERATOR       = 'A'
         IMPORTING
*           E_T_LOG_HANDLE                      =
            e_t_msg_handle                      = lt_msg_handle
          EXCEPTIONS
            msg_not_found                       = 1
            OTHERS                              = 2     .

        LOOP AT lt_msg_handle INTO ls_msg_handle .
          APPEND ls_msg_handle TO lt_msg_handle_to_update .
        ENDLOOP.
      ENDIF.

      " Remove dupplicate
      SORT lt_msg_handle_to_update .
      DELETE ADJACENT DUPLICATES FROM lt_msg_handle_to_update .

      LOOP AT lt_msg_handle_to_update INTO ls_msg_handle.
        CALL FUNCTION 'BAL_LOG_MSG_READ'
          EXPORTING
            i_s_msg_handle                 = ls_msg_handle
*           I_LANGU                        = SY-LANGU
          IMPORTING
            e_s_msg                        = ls_bal_msg
*           E_EXISTS_ON_DB                 =
*           E_TXT_MSGTY                    =
*           E_TXT_MSGID                    =
*           E_TXT_DETLEVEL                 =
*           E_TXT_PROBCLASS                =
*           E_TXT_MSG                      =
*           E_WARNING_TEXT_NOT_FOUND       =
          EXCEPTIONS
            log_not_found                  = 1
            msg_not_found                  = 2
            OTHERS                         = 3 .

        " If reading OK, update it
        IF sy-subrc EQ 0 .
          " Priority is following : Custom over ZCL default one
          IF i_cust_long_text IS NOT INITIAL.
            ls_bal_msg-params = i_cust_long_text .

          ELSEIF i_long_text IS NOT INITIAL .
            ls_bal_msg-params = me->_make_bal_message_params( i_long_text ).

          ELSE.
            " Do nothing
          ENDIF.

          " Update Message
          CALL FUNCTION 'BAL_LOG_MSG_CHANGE'
            EXPORTING
              i_s_msg_handle         = ls_msg_handle
              i_s_msg                = ls_bal_msg
           EXCEPTIONS
             LOG_NOT_FOUND          = 1
             MSG_INCONSISTENT       = 2
             MSG_NOT_FOUND          = 3
             OTHERS                 = 4 .

          IF sy-subrc EQ 0 .
            c_new_lognumbers = me->_save( ) .
          ENDIF .
        ENDIF .
      ENDLOOP.
    ENDIF.

  endmethod.


  method SET_OBJECT.

    me->_slg_object = i_slg_object.

    self = me.

  endmethod.


  method SET_RETENTION.

    me->_slg_retention = i_slg_retention_days.

    self = me.

  endmethod.


  method SET_SUB_OBJECT.

    me->_slg_sub_object = i_slg_sub_object.

    self = me.

  endmethod.


  method _CREATE.

    DATA:
        ls_bal_s_log TYPE bal_s_log.


    " --------------------------------------------------------------
    " • Initialization
    " --------------------------------------------------------------
    ls_bal_s_log-object     = me->_slg_object.
    ls_bal_s_log-subobject  = me->_slg_sub_object.
    ls_bal_s_log-extnumber  = me->_slg_ext_number.
    ls_bal_s_log-aluser     = sy-uname.                     " @TODO : VOir pour customized
    ls_bal_s_log-alprog     = sy-repid.                     " @TODO : VOir pour customized
    ls_bal_s_log-aldate_del = sy-datum + me->_slg_retention.



    " --------------------------------------------------------------
    " • Starting Application Log handler
    " --------------------------------------------------------------
    IF me->_slg_handler IS INITIAL.
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = ls_bal_s_log
        IMPORTING
          e_log_handle            = me->_slg_handler
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.

      IF sy-subrc NE 0.
        " 012 :: Appl. Log is enabled but something happens wrong (check SLG Object & Sub)
        MESSAGE e012.
      ENDIF.

    ENDIF.

  endmethod.


  method _DESTRUCTOR.
  endmethod.


  method _make_bal_message_params.

    DATA: lt_chunks      TYPE STANDARD TABLE OF swastrtab  ,
          ls_chunk       TYPE                   swastrtab  ,
          ls_params      TYPE                   bal_s_parm ,
          ls_parline     TYPE                   bal_s_par  .

    " In case of unexpected call, if text is
    " empty, do nothing to prevent empty detail text
    IF i_long_text IS NOT INITIAL .
      " Source: SBAL_DEMO_02 (SE61 = SBAL_EXAMPLE_TEXT_01)
      "
      " Set ZCL_LOG_UTIL Long Text (SE61 - Dialog Text (DT) - ZCL_LOG_UTIL_ALTEXT)
      ls_params-altext = zcl_log_util_slg=>_bal_alt_text .

      " Split Text in chunk of x char (limit to 100 loop)
      lt_chunks = zcl_log_util=>split_text_to_chunks(
        i_text_to_split = i_long_text
        i_chunk_size    = 75
      ).

      LOOP AT lt_chunks INTO ls_chunk.
        " SE61 Dialog Text has limited params
        " Text will be truncate if contains more
        " than chunks as its exist params
        IF sy-tabix > zcl_log_util_slg=>_bal_alt_text_max_param .
          EXIT.
        ENDIF.

        APPEND VALUE #(
          parname  = |P{ sy-tabix }|
          parvalue = ls_chunk-str
        ) TO ls_params-t_par .
      ENDLOOP.

    ENDIF .

    r_params = ls_params .

  endmethod.


  method _SAVE.

    DATA: lt_log_hdl    TYPE bal_t_logh ,
          lt_lognumbers TYPE bal_t_lgnm .

    APPEND me->_slg_handler TO lt_log_hdl.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
*        i_client          = sy-mandt
*        i_in_update_task  = ' '
*       i_save_all        = 'X'
         i_t_log_handle   = lt_log_hdl
      IMPORTING
        e_new_lognumbers = lt_lognumbers
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    " If handler is provided (me->_slg_handler NOT INITIAL)
    " returned lt_lognumbers is empty, because we provided handler
    " So we do not update new_lognumbers
    IF lt_lognumbers IS NOT INITIAL .
      me->_new_lognumbers = lt_lognumbers .
      r_new_lognumbers   = lt_lognumbers .
    ELSE.
      r_new_lognumbers   = me->_new_lognumbers .
    ENDIF.

    IF sy-subrc NE 0.
      " @TODO : Implement error message
    ENDIF.

  endmethod.
ENDCLASS.
