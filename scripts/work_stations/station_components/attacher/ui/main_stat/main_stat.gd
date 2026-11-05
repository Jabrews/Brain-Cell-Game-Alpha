extends Node

@export var stat_type : String = 'strength'

# components
@onready var stat_type_label : Label = $StatTypeLabel


func _ready() -> void:
	stat_type_label.text = str(stat_type)
