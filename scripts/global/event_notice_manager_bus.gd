extends Node

signal create_event_notice(event_notice : EventNotice) 

signal toggle_hide_event_notice(toggle_value : bool)


# delete notice mutation event sigals
signal delete_event_notice_mutation(cell_name : String)
signal delete_event_notice_hidden_stat_interpreter(stat_type : String)
signal delete_event_notice_defect_cell(cell_name : String)
signal delete_event_notice_shareholder_item_offer(serve_num : int)
