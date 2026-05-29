extends InteractableBtn 

@onready var on_off_label : Label3D = $"../OnOffLabel"



func _on_btn_interacted():
	
	GLPlayerState.player_invincible = !GLPlayerState.player_invincible 
	
	match GLPlayerState.player_invincible  :
		true : 
			on_off_label.text = 'on'
		false : 
			on_off_label.text = 'off'	
	
	
	
