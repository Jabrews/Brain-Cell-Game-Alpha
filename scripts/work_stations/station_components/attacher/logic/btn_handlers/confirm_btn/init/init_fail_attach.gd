
extends Node

# components
@onready var simulate_stat_defect_increase: Control = $"../../../../AttacherUI/SimulateStatDefectIncrease"
@onready var refresh_ui : Node = $"../../../RefreshUi"
@onready var handle_display_ui : Node = $"../../../HandleDisplayUi"
@onready var fail_particles : GPUParticles3D = $"../../../../Particles/FailedParticles"

var stats: Array[String] = ['strength', 'intelligence', 'community']


func _ready() -> void:
	GLAttacherComponentBus.connect('simulation_ended', _handle_simulation_ended)


func _failed(loaded_cell: BrainCell, main_stat_replacement_state: Dictionary[String, StatJarItem], failure_rate: int) -> void:
	
	
	# keep reference to original cell without defect increases
	var old_cell: BrainCell = loaded_cell.copy()
	var new_cell: BrainCell = loaded_cell.copy()

	var increase_amount: float 

	# <= 50% : increase defects only on replaced stats
	if failure_rate <= 50:
		increase_amount = round(IVCellCreator.max_stat_value * 0.15 * 10.0) / 10.0

		var used_stats: Array[String] = []
		var fallback_count: int = 0

		# First pass: apply increases to valid replaced stats
		for stat_type in stats:
			var stat_replacement_item: StatJarItem = main_stat_replacement_state[stat_type]
			var cell_stat: BrainCellStat = new_cell.get_stat(stat_type)

			if not stat_replacement_item:
				continue

			if cell_stat.enabled:
				cell_stat.defect = minf(
					cell_stat.defect + increase_amount,
					IVCellCreator.max_stat_value
				)

				used_stats.append(stat_type)
			else:
				fallback_count += 1

		# Second pass: redirect increases from disabled stats
		for i in range(fallback_count):
			for stat_type in stats:
				if stat_type in used_stats:
					continue

				var cell_stat: BrainCellStat = new_cell.get_stat(stat_type)

				if not cell_stat.enabled:
					continue

				cell_stat.defect = minf(
					cell_stat.defect + increase_amount,
					IVCellCreator.max_stat_value
				)

				used_stats.append(stat_type)
				break

	# > 50% : increase defects on all enabled stats
	else:
		increase_amount = round(IVCellCreator.max_stat_value * 0.20 * 10.0) / 10.0

		for stat_type in stats:
			var cell_stat: BrainCellStat = new_cell.get_stat(stat_type)

			if cell_stat.enabled:
				cell_stat.defect = minf(
					cell_stat.defect + increase_amount,
					IVCellCreator.max_stat_value
				)

	# Update collected cell
	GLCellManagerBus.emit_signal('collected_cell_changed', new_cell)

	# reset main stats and penality stat
	for key in GLAttacherComponentBus.main_stat_replacement_state:
		GLAttacherComponentBus.main_stat_replacement_state[key] = null
		
	for key in GLAttacherComponentBus.main_stat_replacement_failure_penality:
		GLAttacherComponentBus.main_stat_replacement_failure_penality[key] = false
	
	# refresh. I dont want to show anything
	refresh_ui._refresh()

	# Simulate defect increase visually
	simulate_stat_defect_increase._start(old_cell, new_cell)
	
	GLAttacherComponentBus.emit_signal('play_sound', 'confirm_failed')
	
	# hacky but lazy
	GLCellManagerBus.emit_signal('scale_cell', old_cell.name)
	
	# await for this to finish before rest of logic
	

func _handle_simulation_ended() -> void:
	handle_display_ui._toggle_display(false)
	fail_particles.restart()

	GLAttacherComponentBus.emit_signal('hologram_show_result', false)
