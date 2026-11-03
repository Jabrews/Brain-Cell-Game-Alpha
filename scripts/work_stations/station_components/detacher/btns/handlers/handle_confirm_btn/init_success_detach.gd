extends Node


func _success(loaded_cell : BrainCell, selected_stat_type : String) :
	
	var selected_stat : BrainCellStat = loaded_cell.get_stat(selected_stat_type)
	
	if not selected_stat : 
		push_error('unable to find selected stat for type : ', selected_stat_type )
		return
	
	if not selected_stat.enabled or selected_stat.hidden : 
		push_error('invalid stat selected, hidden or disabled')
		return
	
	# add to jar state
	
	var jar_item_stat : JarCellStat = JarCellStat.new(selected_stat)
	
	if len(GLWorkstationBus.jar_items) >= 4 : 
		print_debug('should deal with jar being over filled, let user know')
		return
	else  :
		GLWorkstationBus.jar_items.append(jar_item_stat)
	
	# get rid of enabled stat on cell and update
	# scale cell + sound 
		# how did breeder do it
	# show success parent on main screen and breeder screen 
		# use a component specific bus
		# will dissapear after breif timer
	
	return
