extends Node

# components
@onready var refresh_ui: Node = $"../../../RefreshUi"
@onready var handle_display_ui: Node = $"../../../HandleDisplayUi"
@onready var success_particles: GPUParticles3D = $"../../../../Particles/SuccessParticles"
# floating label stuff
@onready var defect_scrap_floating_label_p_s : PackedScene = preload("res://scenes/work_stations/station_components/defect_scrap_floating_label/defect_scrap_floating_label.tscn")
@onready var floating_label_spawn_pos : Node3D = $"../../../../FloatingLabelSpawnPos"

var stats: Array[String] = ['strength', 'intelligence', 'community']


func _success(
	loaded_cell: BrainCell,
	main_stat_replacement_state: Dictionary[String, StatJarItem]
) -> void:

	# Create new cell without modifying original
	var new_cell: BrainCell = loaded_cell.copy()

	for stat_type in stats:
		var stat_replacement_item: StatJarItem = main_stat_replacement_state[stat_type]

		if stat_replacement_item:
			var replacement_stat: BrainCellStat = stat_replacement_item.corrisponding_stat._copy()

			# Replace corresponding stat in new cell
			match stat_type:
				'strength':
					new_cell.strength = replacement_stat
				'intelligence':
					new_cell.intelligence = replacement_stat
				'community':
					new_cell.community = replacement_stat
		
			GLJarComponentBus.emit_signal('remove_jar_item', stat_replacement_item)
		

	# Update collected cell
	GLCellManagerBus.emit_signal('collected_cell_changed', new_cell)

	# increase defect scrap
	GLDefectScrapsBus.emit_signal('defect_scraps_changed', GLDefectScrapsBus.curr_defect_scraps + 10)
	
	# floating label
	var defect_scrap_floating_label_instance : Node3D = defect_scrap_floating_label_p_s.instantiate()	
	add_child(defect_scrap_floating_label_instance)
	defect_scrap_floating_label_instance.global_position = floating_label_spawn_pos.global_position
	defect_scrap_floating_label_instance.start(10)

	GLAttacherComponentBus.emit_signal('play_sound', 'confirm_success')

	# Success visuals
	handle_display_ui._toggle_display(false)
	GLCellManagerBus.emit_signal('scale_cell', loaded_cell.name)
	success_particles.restart()
	GLAttacherComponentBus.emit_signal('hologram_show_result', true)
	
	
