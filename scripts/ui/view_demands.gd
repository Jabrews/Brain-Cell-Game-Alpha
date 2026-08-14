extends Label 


func _ready() -> void:
	GLShareholderDemandState.connect('toggle_player_entered_provider_area', toggle_player_entered_provider_area)

func toggle_player_entered_provider_area(toggle_value : bool) :
	self.visible = toggle_value
