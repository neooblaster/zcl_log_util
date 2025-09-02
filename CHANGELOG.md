# Changelog

## Version ``0.2.0`` - `02.09.2025`

### Additions

* **[Methods]** :
    * **[Added]** : Add ``Static`` method
      `zcl_log_util=>get_func_module_exception( )`
      to return the exception name of function module using `SY-SUBRC`.
    * **[Added]** : Add ``Static`` method
      `zcl_log_util=>get_func_module_exception_text( )` to return
      the exception text message of function module using `SY-SUBRC`.
    * **[Added]** : Add ``Static`` method
      `zcl_log_util=>get_func_module_exceptions( )` to return
      the available exceptions to the function module.
    * **[Added]** : Add ``Instance`` method `zcl_log_util->set_long_text( )` to
      set long text on an existing message !
        * It performs the same call method on class
          ``zcl_log_util_slg->set_long_text( )``
    * **[Added]** : Add ``Static`` method
      `zcl_log_util=>split_text_to_chunks( )`to split any text in chunks on
      length (max=255), having a non-breaking word option.
    * **[Added]** : Add ``Static`` method `zcl_log_util=>msgvx_simplify( )` to
      **CONDENSE** and remove **LEADING 0**
      on message **MSGVx**.
    * **[Added]** : Add method ``zcl_log_util_slg->get_new_lognumber( )`` to retrieve
    current BAL Log instance (number).
    * **[Added]** : Add method ``zcl_log_util_slg->get_handler( )`` to retrieve
    current BAL Log handler.
    * **[Added]** : Add method ``zcl_log_util_slg->set_long_text( )`` to set long text
    to message(s) in BAL Log using message **handler**, **number**, **index** or **MSGxx** filters.
* **[Side Objects]** :
    * **[Added]** : ``Dialog Text (DT)`` `ZCL_LOG_UTIL_ALTEXT` (`SE61`)
* **[Definitions]** :
    * **[Added]** : Add table type ``BDIDOCSTAT`` as know table definition :
        * Note: this table type does not have field ``Message``

### Changes

* [Changes] : Method ``zcl_log_util->log( )`` :
    * Introducing **Optional Importing** parameter ``i_long_text``, type of
      `STRING` to attach long text to the current message
        * Raw text to add as long text, Length limit is `100` chunks of length
          `75` = `7500`
        * Chunks are managed by the log util.
    * Introducing **Optional Importing** parameter ``i_cust_long_text``, type of
      `BAL_S_PARM` to attach long text to the current message
        * You can set your own BAL Message Param with your own **Dialog Text**
          and params with values.
    * Introducing **Optional Changing** parameter ``c_log_numbers``, type of
      `BAL_T_LGNM` containing
      the BAL log handle and number for further reuse (E.G. to link IDOC with
      App Log).
    * ``i_cust_long_text`` has the priority on `i_long_text` if both are provided.
* [Changes] : Method ``zcl_log_util_slg->log( )`` :
    * Introducing **Optional Importing** parameter ``i_long_text``, type of
      `STRING` :
        * Raw text to add as long text, Length limit is `100` chunks of length
          `75` = `7500`
        * Chunks are managed by the log util.
    * Introducing **Optional Importing** parameter ``i_cust_long_text``, type of
      `BAL_S_PARM` :
        * You can set your own BAL Message Param with your own **Dialog Text**
          and parms with values.
    * Introducing **Optional Changing** parameter ``c_log_numbers``, type of
      `BAL_T_LGNM` containing
      the BAL log handle and number for further reuse (E.G. to link IDOC with
      App Log).
    * ``i_cust_long_text`` has the priority on `i_long_text` if both are provided.

### Fixes and updates

* [Fixed] : Fix statement
  ``Making Message Texte (Only if ID, Number & Type are provided)`` in method
  ``LOG`` of class `ZCL_LOG_UTIL` where operand on **number** was missing.
* [Fixed] : Fix demos `070` and `080` to use **SLG** object `ZLOGUTIL` instead
  of `ZMYPO` which was system dependant.