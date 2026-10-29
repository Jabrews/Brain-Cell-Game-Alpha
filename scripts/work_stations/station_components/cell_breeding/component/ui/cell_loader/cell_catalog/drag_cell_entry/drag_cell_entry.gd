extends Control

# components
@onready var display_drag_cell_entry : Node = $DisplayDragCellEntry
@onready var dragging_border : TextureRect = $DraggingBorder
@onready var handle_drop : Node = $HandleDrop

@onready var display_background : ColorRect = $DisplayBackground

var loaded_cell : BrainCell

var mode : String = ''


func _ready() -> void:
	mode = GAMEInputTypeDetector.input_type


func _process(_delta: float) -> void:
	if mode == "keyboard":
		global_position = (
			get_viewport().get_mouse_position()
			+ Vector2(-30, -30)
	)

	else:
		var focused_control := get_viewport().gui_get_focus_owner()

		if focused_control:
			var focus_rect := focused_control.get_global_rect()

			global_position = (
				focus_rect.position
				+ focus_rect.size / 6.0
				- size / 6.0
			)
			
			
	
	
	
# when created
func _load_cell(cell : BrainCell) :
	
	loaded_cell = cell	
	
	display_drag_cell_entry._display(cell)
	
	dragging_border.visible = true
	
# when let go of
func _delete() :
	
	dragging_border.visible = false
	
	
	var scale_tween : Tween = create_tween()
	
	scale_tween.tween_property(self, 'scale', Vector2(0.1, 0.1), 0.15)
	
	await scale_tween.finished
	
	handle_drop._handle()
	

	
	self.queue_free()
