extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

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

func _ready() -> void:
	total_frame.material = total_frame.material.duplicate()
	
	for pot : TextureRect in stat_danger_pots : 
		pot.material = pot.material.duplicate()
	
	for stat_chance_increase_label : Label in stat_danger_chance_increase_labels : 
		stat_chance_increase_label.text = ''
	
	lifespan_death_chance_increase_label.text = ''

func _display_cell(cell : BrainCell) : 
	
	if not cell : 
		return
	
	display_total_death_chance(cell)
	display_stat_danger(cell)
	display_hidden_stat(cell)
	display_off_blockers(cell)
	display_life_span_danger(cell)
	
func display_total_death_chance(cell: BrainCell) -> void:
	
	# Get death chance as a percentage
	var total_death_chance: float = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell, false)
	
	# Display percentage
	total_percant_label.text = str(int(total_death_chance)) + "%"
	
	# Convert 0-100% to 0.0-1.0 for shader
	var progress: float = total_death_chance / 100.0
	
	total_frame.material.set_shader_parameter("progress", progress)
	
func display_stat_danger(cell : BrainCell) :
	
	
	for i: int in STAT_TYPES.size():
		
		## death chance label
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = cell.get(stat_type)
		
		var increase_label : Label = stat_danger_chance_increase_labels[i]			
		
		var increase_amount : float = GAMECellBreeder.death_chance_helper.evluate_defect(cell_stat.defect)
		
		if increase_amount != 0.0 :
			increase_label.text = '(+' + str(int(increase_amount)) + '%)'
		
		## stat pot
		var pot: TextureRect = stat_danger_pots[i]

		# Current defect
		var max_stat_value: float = IVCellCreator.max_stat_value
		var defect_value: float = cell_stat.defect

		# Convert defect values from 0 -> max_stat_value into 0.0 -> 1.0
		var current_defect_value: float = defect_value / max_stat_value

		# Next/increased defect
		var next_defect_value: float = GAMECellBreeder.death_chance_helper.decrease_old_cell._get_increased_defect_stat(defect_value)

		# Convert next defect to 0.0 -> 1.0
		var secondary_defect_value: float = next_defect_value / max_stat_value

		# Set shader values
		pot.material.set_shader_parameter("current_value", current_defect_value)
		pot.material.set_shader_parameter("secondary_value", secondary_defect_value)

func display_hidden_stat(cell : BrainCell) :
	for i: int in STAT_TYPES.size():
		
		## death chance label
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = cell.get(stat_type)
		
		var hidden_sprite : Sprite2D = hidden_stat_sprites[i]
		
		if cell_stat.hidden : 
			hidden_sprite.visible = true

func display_off_blockers(cell : BrainCell) :
	for i: int in STAT_TYPES.size():
		
		## death chance label
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = cell.get(stat_type)
		
		var stat_off_blocker : Control = off_blockers[i]
		
		if not cell_stat.enabled: 
			stat_off_blocker.visible = true
	
	
		
func display_life_span_danger(cell : BrainCell) : 
	
	# set life span labels
	lifespan_num_label.text = str(cell.life_span)	
	next_lifespan_num_label.text = str(cell.life_span - 1)
	
	# death chance label
	var increase_amount : float = GAMECellBreeder.death_chance_helper.evaluate_lifespan(cell.life_span)
	if increase_amount != 0.0 :
		lifespan_death_chance_increase_label.text = '(+' + str(int(increase_amount)) + '%)'
	
	
	
		
	
	
	
	
	
	
	
