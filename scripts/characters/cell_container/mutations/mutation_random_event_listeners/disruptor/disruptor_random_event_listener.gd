extends RandomMutationEventListener 

@onready var detect_disruptable_reciever_area : Area3D = $DetectDisruptableArea

func _ready() -> void:
	detect_disruptable_reciever_area.connect('area_entered', _handle_area_entered)
	detect_disruptable_reciever_area.connect('area_exited', _handle_area_exited)
	
func _handle_area_entered(area : Area3D) :
	if area.is_in_group('disruptable_reciever') :
		_toggle_mutation_event_situation_increase(true, designated_mutation_event.mutation_name, designated_mutation_event.event_name)

func _handle_area_exited(area : Area3D) :
	if area.is_in_group('disruptable_reciever') :
		_toggle_mutation_event_situation_increase(false, designated_mutation_event.mutation_name, designated_mutation_event.event_name)



	
	
