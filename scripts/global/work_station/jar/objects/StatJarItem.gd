extends JarItem 

class_name StatJarItem

var corrisponding_stat : BrainCellStat

func _init(
	new_corrisponding_stat : BrainCellStat
) -> void:
	
	super('stat')
	
	corrisponding_stat = new_corrisponding_stat
	

func print_jar_item() : 
	super.print_jar_item()
	
	print('Corrisponding Stat : ', corrisponding_stat)
	
