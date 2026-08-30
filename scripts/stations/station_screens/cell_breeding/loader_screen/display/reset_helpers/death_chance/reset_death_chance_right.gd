extends Node

# total death chance
@onready var total_frame : TextureRect = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/Frame"
@onready var total_percant_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/DeathChancePercant"

# stat danger
@onready var stat_danger_chance_increase_labels : Array[Label] = [
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Strength/DeathChance",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Intelligence/DeathChance",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Community/DeathChance"
]
@onready var stat_danger_pots : Array[TextureRect] =  [
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Strength/Pot",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Intelligence/Pot",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/StatDanger/Community/Pot"
]

# lifespan danger
@onready var lifespan_num_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/LifeSpanDanger/LifeNum"
@onready var next_lifespan_num_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/LifeSpanDanger/NextAgeArrow/LifeNum"
@onready var lifespan_death_chance_increase_label : Label = $"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/LifeSpanDanger/DeathChance"

# hidden stat
@onready var hidden_stat_sprites : Array[Sprite2D]=  [
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/HiddenStats/StrengthHide",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/HiddenStats/IntelligenceHide",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/HiddenStats/CommunityHide"
]
# off blockers
@onready var off_blockers : Array[Control] = [
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/OffDisableLabels/Strength",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/OffDisableLabels/Intelligence",
	$"../../../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay/OffDisableLabels/Community"
]


func _reset() :
	
	reset_total_death_chance()
	reset_stat_danger()
	reset_life_span_danger()
	reset_hidden_stat()
	reset_off_blocker()

func reset_total_death_chance(): 
	total_frame.material.set_shader_parameter("progress", 0.0)
	total_percant_label.text = ''

func reset_stat_danger(): 
	for	stat_increase_label : Label in stat_danger_chance_increase_labels : 
		stat_increase_label.text = ''
	
	for pot : TextureRect in stat_danger_pots : 
		pot.material.set_shader_parameter("current_value", 0.0)
		pot.material.set_shader_parameter("secondary_value", 0.0)
	
func reset_hidden_stat() :
	for hidden_sprite : Sprite2D in hidden_stat_sprites: 
		hidden_sprite.visible = false

func reset_off_blocker() :
	for off_blocker : Control in off_blockers : 
		off_blocker.visible = false
	
func reset_life_span_danger(): 
	lifespan_death_chance_increase_label.text = ''
	lifespan_num_label.text = ''
	next_lifespan_num_label.text = ''
