extends Control

# components
@export var drag_cell_entry_parent_node: Node

@onready var selected_border: TextureRect = $SelectedBorder
@onready var display_background: TextureRect = $DisplayBackground

var hovered: bool = false


func _process(_delta: float) -> void:
	var currently_hovered: bool = false
	
	for child in drag_cell_entry_parent_node.get_children():
		if child is Control:
			if display_background.get_global_rect().intersects(
				child.display_background.get_global_rect()
			):
				currently_hovered = true
				break
	
	# hover started
	if currently_hovered and not hovered:
		hovered = true
		_handle_hover_on()
	
	# hover ended
	elif not currently_hovered and hovered:
		hovered = false
		_handle_hover_off()


func _handle_hover_on() -> void:
	selected_border.visible = true


func _handle_hover_off() -> void:
	selected_border.visible = false
