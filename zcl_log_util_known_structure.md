Please find below structure which are natively handle by ``zcl_log_util`` :

| Name | Msg. Text | Msg. Type | Msg. ID | Msg. Number | Msg. Val. 1 | Msg. Val. 2 | Msg. Val. 3 | Msg. Val. 4 |
|---|---|---|---|---|---|---|---|---|
| zcl_log_util=>ty_log_table | MESSAGE | TYPE | ID | NUMBER | MSGV1 | MSGV2 | MSGV3 | MSGV4 | 
| sy | - | MSGTY | MSGID | MSGNO | MSGV1 | MSGV2 | MSGV3 | MSGV4 | 
| prott | - | MSGTY | MSGID | MSGNO | MSGV1 | MSGV2 | MSGV3 | MSGV4 | 
| bapiret1 | MESSAGE | TYPE | ID | NUMBER | MESSAGE_V1 | MESSAGE_V2 | MESSAGE_V3 | MESSAGE_V4 | 
| bapiret2 | MESSAGE | TYPE | ID | NUMBER | MESSAGE_V1 | MESSAGE_V2 | MESSAGE_V3 | MESSAGE_V4 | 
| bapi_coru_return | - | TYPE | ID | NUMBER | MESSAGE_V1 | MESSAGE_V2 | MESSAGE_V3 | MESSAGE_V4 | 
| bapi_order_return | - | TYPE | ID | NUMBER | MESSAGE_V1 | MESSAGE_V2 | MESSAGE_V3 | MESSAGE_V4 | 
| bdcmsgcoll | - | MSGTYP | MSGID | MSGNR | MSGV1 | MSGV2 | MSGV3 | MSGV4 | 

See chapter ``Set your own definitions`` / `Set a custom log table type or unregistred SAP standard type`
to register a unknown structure. [Jump](README.md#)
