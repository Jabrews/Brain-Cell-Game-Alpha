extends Node

# display components
@onready var skull : TextureRect = $"../../../../SeatCellLoading/DeathChanceDisplay/Skull"
@onready var left_total_death_chance_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/LeftDeathChanceDisplay/TotalDeathChance/DeathChancePercant"
@onready var right_total_death_chance_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/DeathChancePercant"

# timers
@onready var flash_delay_timer : Timer = $"../../DeathChanceSkullTimers/FlashDelayTimer"


var curr_color : String = 'white'

var left_side_danger : bool = false
var right_side_danger : bool = false

var scale_tween : Tween


func _ready() -> void:
	flash_delay_timer.connect('timeout', _handle_flash_delay_timer_timeout)


func _display_cells(cell_1 : BrainCell, cell_2 : BrainCell) -> void:
	
	# reset
	flash_delay_timer.stop()
	
	left_side_danger = false
	right_side_danger = false
	
	curr_color = 'white'
	update_display()
	toggle_scale_tween(false)
	
	
	# get death chances
	var cell_1_death_chance : float = 0.0
	var cell_2_death_chance : float = 0.0
	
	if cell_1:
		cell_1_death_chance = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell_1, false)
	
	if cell_2:
		cell_2_death_chance = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell_2, false)
	
	
	# determine danger
	left_side_danger = cell_1_death_chance > 50.0
	right_side_danger = cell_2_death_chance > 50.0
	
	
	# both dangerous
	if left_side_danger and right_side_danger:
		print('both danger')
		
		flash_delay_timer.wait_time = 0.25
		flash_delay_timer.start()
		
		toggle_scale_tween(true)
		return
	
	#if left_side_danger:
		#print('left danger')
		#
	#if right_side_danger:
		#print('right danger')
	
	
	if left_side_danger or right_side_danger:
		flash_delay_timer.wait_time = 0.50
		flash_delay_timer.start()


func _handle_flash_delay_timer_timeout() -> void:
	switch_color()
	update_display()


func switch_color() -> void:
	if curr_color == 'white':
		curr_color = 'red'
	else:
		curr_color = 'white'


func update_display() -> void:
	
	var display_color : Color = Color.WHITE
	
	if curr_color == 'red':
		display_color = Color.RED
	
	
	if left_side_danger:
		left_total_death_chance_label.modulate = display_color
	else:
		left_total_death_chance_label.modulate = Color.WHITE
	
	
	if right_side_danger:
		right_total_death_chance_label.modulate = display_color
	else:
		right_total_death_chance_label.modulate = Color.WHITE
	
	
	if left_side_danger or right_side_danger:
		skull.modulate = display_color
	else:
		skull.modulate = Color.WHITE


func toggle_scale_tween(toggle_value : bool) -> void:
	
	if scale_tween:
		scale_tween.kill()
		scale_tween = null
	
	skull.scale = Vector2(1.0, 1.0)
	
	if not toggle_value:
		return
	
	scale_tween = create_tween()
	scale_tween.set_loops()
	
	scale_tween.tween_property(
		skull,
		'scale',
		Vector2(1, 1),
		0.5
	)
	
	scale_tween.tween_property(
		skull,
		'scale',
		Vector2(1.3, 1.3),
		0.3
	)
