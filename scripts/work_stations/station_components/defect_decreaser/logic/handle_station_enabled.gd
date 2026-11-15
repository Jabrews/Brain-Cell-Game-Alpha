extends Node

# components
@onready var parent_defect_decreaser : Node3D = $"../.."
@onready var refresh_displays : Node = $"../RefreshDisplays"

func _ready() -> void:
	GLGameManagerBus.connect('process_new_ivs', _handle_process_new_ivs)

func _handle_process_new_ivs() :
	
	if GLWorkstationBus.defect_decreaser_enabled == true  : 
		
		if parent_defect_decreaser.enabled == false : 
			
			parent_defect_decreaser.enabled = true
			
			refresh_displays._refresh()
	
	else : 
		# handle hologram
		parent_defect_decreaser.enabled = false 
		
		refresh_displays._refresh()
		
		
