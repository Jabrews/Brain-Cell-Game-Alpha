extends Label 


func _ready() -> void:
	GLMutationFileCabinetBus.connect('toggle_player_entered_cabinet_area', _toggle_player_entered_cabinet_area )

func _toggle_player_entered_cabinet_area(toggle_value : bool) :
	self.visible = toggle_value
