extends Node

@onready var skull : TextureRect = $"../../../../SeatCellLoading/DeathChanceDisplay/Skull"
@onready var left_total_death_chance_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/LeftDeathChanceDisplay/TotalDeathChance/DeathChancePercant"
@onready var right_total_death_chance_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/DeathChancePercant"

@onready var display_helper : Node = $"../../Display/DisplayDeathChanceSkull"


# timers
@onready var flash_delay_timer : Timer = $"../../DeathChanceSkullTimers/FlashDelayTimer"

func _reset() :
	flash_delay_timer.stop()

	skull.modulate = Color.WHITE
	left_total_death_chance_label.modulate = Color.WHITE
	right_total_death_chance_label.modulate = Color.WHITE
	
	display_helper.curr_color = 'white'
	display_helper.left_side_danger = false
	display_helper.right_side_danger = false
	
