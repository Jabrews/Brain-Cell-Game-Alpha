extends Node

# comp 
@onready var energy_sprite : Sprite2D = $EnergySprite
@onready var energy_left_label : Label = $EnergyLeftLabel


func _ready() -> void:
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn)

	await get_tree().process_frame
	
	energy_left_label.text = str(GLGameManagerBus.max_energy)

func _handle_energy_changed() : 
	print('handle energy changed : ', GLGameManagerBus.curr_energy)
	energy_left_label.text = str(GLGameManagerBus.curr_energy)
	
func _handle_energy_turn():
	print('handle energy turn : ', GLGameManagerBus.curr_energy)
	energy_left_label.text = str(GLGameManagerBus.curr_energy)
