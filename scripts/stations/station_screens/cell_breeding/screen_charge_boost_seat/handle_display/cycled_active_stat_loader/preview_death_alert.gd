extends Node

# death alert sprites
@onready var death_alert_sprites : Array[Sprite2D] = [
	$"../../../StatDisplay/DeathAlert/StrengthDeathAlert",
	$"../../../StatDisplay/DeathAlert/IntelligenceDeathAlert",
	$"../../../StatDisplay/DeathAlert/CommunityDeathAlert"
]

@onready var parent_screen : Node2D =$"../../.."


func _reset() :
	for death_alert : Sprite2D in death_alert_sprites : 
		death_alert._toggle_skull(false)

func _handle_preview_death_alert(cycled_stat : String, energy_seat_cell : BrainCell): 
	
	var death_active = GAMECellBreeder.reduced_cell_charge_stat_helper._check_death(cycled_stat, energy_seat_cell)
	
	if death_active :	
		
		var side : String =  parent_screen.side
		GLBreedingComponetsBus.emit_signal('play_sound_skull_warning', side)
		
		match cycled_stat : 	
			'strength' : 
				death_alert_sprites[0]._toggle_skull(true)
			'intelligence' :
				death_alert_sprites[1]._toggle_skull(true)
			'community' :
				death_alert_sprites[2]._toggle_skull(true)
		
