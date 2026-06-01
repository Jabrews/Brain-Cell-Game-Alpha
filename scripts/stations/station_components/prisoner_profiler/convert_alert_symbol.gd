extends Node

func convert(caution_active : bool , warning_active : bool) : 
	if caution_active  :
		return 'caution'
	elif warning_active :
		return 'warning'
	else : 
		return 'none'		
	
	
	
