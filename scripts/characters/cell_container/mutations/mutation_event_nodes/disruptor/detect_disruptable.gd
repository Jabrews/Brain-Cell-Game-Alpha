extends Area3D

var found_disruptable_receivers: Array[Area3D] = []


func _ready() -> void:
	area_entered.connect(_handle_area_entered)
	area_exited.connect(_handle_area_exited)

	monitoring = false


func _search() -> void:
	monitoring = true


func _stop_search() -> void:
	monitoring = false

func _handle_area_entered(area: Area3D) -> void:
	if area.is_in_group("disruptable_reciever"):
		if not found_disruptable_receivers.has(area):
			found_disruptable_receivers.append(area)


func _handle_area_exited(area: Area3D) -> void:
	if area.is_in_group("disruptable_reciever"):
		found_disruptable_receivers.erase(area)
