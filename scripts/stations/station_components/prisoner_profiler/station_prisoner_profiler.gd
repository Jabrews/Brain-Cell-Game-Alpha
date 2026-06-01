extends Node

# components
@onready var convert_alert_symbol : Node =$ConvertAlertSymbol

var clean_strength : float = 0.0
var clean_intelligence: float = 0.0
var clean_community : float = 0.0
var strength_disabled : bool = false
var intelligence_disabled : bool = false
var community_disabled : bool = false

var strength_caution_active  : bool = false
var strength_warning_active  : bool = false
var intelligence_caution_active  : bool = false
var intelligence_warning_active  : bool = false
var community_caution_active  : bool = false
var community_warning_active  : bool = false

var prisoner_quantity : int = 0


func _toggle_alert_symbol(stat_type :String, toggleValue : bool, symbol_type : String) :
	if stat_type == 'strength' :
		match symbol_type :
			'caution' :		
				strength_caution_active = toggleValue
			'warning' :		
				strength_warning_active = toggleValue
	if stat_type == 'intelligence' :
		match symbol_type :
			'caution' :		
				intelligence_caution_active =  toggleValue
			'warning' :		
				intelligence_warning_active = toggleValue
	if stat_type == 'community' :
		match symbol_type :
			'caution' :		
				community_caution_active=  toggleValue
			'warning' :		
				community_warning_active = toggleValue
	
func _update_clean_stat_value(type : String, new_value : float) :
	
	match type :	
		'strength' :
			clean_strength = new_value 
		'intelligence' :
			clean_intelligence = new_value 
		'community' :
			clean_community = new_value 

func _toggle_stat_disabled(type : String, toggleValue : bool) :
	match type :	
		'strength' :
			strength_disabled = toggleValue
		'intelligence' :
			intelligence_disabled = toggleValue
		'community' :
			community_disabled = toggleValue
	
func _update_prisoner_quanity(quantity: int) :
	prisoner_quantity = quantity 

func _create_prisoners() -> void:

	var strength_stat_constructor = StatConstructor.new(
		"strength",
		clean_strength,
		convert_alert_symbol.convert(strength_caution_active, strength_warning_active),
		!strength_disabled
	)
	var intelligence_stat_constructor = StatConstructor.new(
		"intelligence",
		clean_intelligence,
		convert_alert_symbol.convert(intelligence_caution_active, intelligence_warning_active),
		!intelligence_disabled
	)
	var community_stat_constructor = StatConstructor.new(
		"community",
		clean_community,
		convert_alert_symbol.convert(community_caution_active , community_warning_active),	
		!community_disabled
	)
	var prisoner_cell_constructor : CellConstructor = CellConstructor.new(
		prisoner_quantity,
		0, # hidden_stat_quantity TODO
		strength_stat_constructor,
		intelligence_stat_constructor,
		community_stat_constructor
	)

	GLCellCreatorBus.emit_signal(
		"create_prisoner_cells",
		prisoner_cell_constructor
	)
