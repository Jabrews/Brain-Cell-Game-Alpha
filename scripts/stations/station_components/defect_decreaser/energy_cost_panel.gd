extends Node

#components
@onready var energy_cost_label : Label3D = $CostEnergy
@onready var curr_energy_label : Label3D = $CurrEnergy
@onready var station_disabled_label : Label3D = $StationDisabled

# visual components
@onready var visual_componnets : Array[Node] = [
	$CostEnergyText,
	$CurrEnergyText,
	$EnergyIcon,
	$EnergyIcon3
]
@onready var out_of_energy_label : Label3D = $NotEnoughEnergy

func _ready() -> void:
	#GLGameManagerBus.connect('proceed_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn_changed)
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)

func _handle_next_round() :
	check_panel_disabled()
	load_cost()	
	load_curr_energy()

func _handle_energy_turn_changed() :
	check_panel_disabled()
	load_cost()
	load_curr_energy()

func check_panel_disabled() :
	
	var toggleValue : bool = false	
	
	if IVCellDefectDecreaser.station_enabled :	
		toggleValue = true
	
	energy_cost_label.visible = toggleValue 
	curr_energy_label.visible = toggleValue 
	station_disabled_label.visible = !toggleValue # opposite
	for visual_child : Node in visual_componnets :
		visual_child.visible = toggleValue 

func load_cost() :
	var energy_decrease_amount = IVCellDefectDecreaser.energy_cost
	energy_cost_label.text = str(energy_decrease_amount)
	
func load_curr_energy()	 :
	var total_energy = GLGameManagerBus.curr_energy
	curr_energy_label.text = str(total_energy)
	
func display_out_of_energy() -> void:

	# hide normal display
	energy_cost_label.visible = false
	curr_energy_label.visible = false
	station_disabled_label.visible = false

	for visual_child: Node in visual_componnets:
		visual_child.visible = false

	# show warning
	out_of_energy_label.visible = true

	await get_tree().create_timer(0.3).timeout

	# hide warning
	out_of_energy_label.visible = false

	# restore proper state
	check_panel_disabled()
	load_cost()
	load_curr_energy()
	
	
func _handle_energy_changed() :
	check_panel_disabled()
	load_cost()
	load_curr_energy()
	
	
