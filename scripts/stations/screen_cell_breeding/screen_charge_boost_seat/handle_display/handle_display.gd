extends Node

# display helper loader componnets
@onready var energy_seat_loader : Node = $EnergySeatLoader
@onready var cycled_active_stat_loader : Node = $CycledActiveStatLoader

# feedback screen
@onready var feedback_screen_parent : Control = $"../FeedbackScreen"
@onready var feedback_bg : ColorRect = $"../FeedbackScreen/Bg"
@onready var feedback_text_label: Label =$"../FeedbackScreen/Text"

func _ready() -> void:
	GLBreedingComponetsBus.connect('breeding_station_feedback_requested', _handle_feedback_requested)


func _handle_display(
		energy_seat_cell : BrainCell,
		cycled_index : int,
		cycled_stat : String,
	) :
		
		
	# update main cell loader
	energy_seat_loader._handle_recieve_energy_seat_cell(
		energy_seat_cell,
	)
	
	cycled_active_stat_loader._handle_recieve_cycled(
		energy_seat_cell,
		cycled_index,
		cycled_stat
	)

func _handle_feedback_requested(side : String, type : String) :
	
	if side == get_parent().side : 
		match type : 
			'main_cell_removed': 
				display_feedback(3.0, Color.DARK_RED, Color.RED, 'Main Cell\nRemoved')
			'main_cell_missing' :
				var text = "Cannot load\ncell\n\nMain Breeding\npanel empty"
				display_feedback(2.0, Color.html('#520000'), Color.RED, text)
			'main_cell_stat_invalid' :
				var text = "Main Cell's\nStat is\ninvalid"
				display_feedback(2.0, Color.html('#520000'), Color.RED, text)
	

func display_feedback(duration : float, bg_color : Color, text_color : Color, text : String) :
	
	feedback_screen_parent.visible = true	
	
	feedback_bg.color = bg_color
	feedback_text_label.add_theme_color_override("font_color", text_color)	
	feedback_text_label.text = text
	
	await get_tree().create_timer(duration).timeout
	
	feedback_screen_parent.visible = false 
	
	
