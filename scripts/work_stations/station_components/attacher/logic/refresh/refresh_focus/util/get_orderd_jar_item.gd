extends Node

# components
@onready var catalog_parent: VBoxContainer = $"../../../../AttacherUI/Content/JarItemCatalog/CenterContainer/ScrollContainer/CatalogParent"


func _get_items() -> Array[Control]:
	var jar_items: Array[Control] = []

	for child in catalog_parent.get_children():
		if not child is Control:
			continue

		if child.is_queued_for_deletion():
			continue

		if not child.get("bg") is TextureRect:
			continue

		jar_items.append(child)

	return jar_items


func _get_ordered(order: String) -> Control:
	var jar_items: Array[Control] = _get_items()

	if jar_items.is_empty():
		return null

	match order:
		"first":
			return jar_items.front()

		"last":
			return jar_items.back()

		_:
			push_error("Attempting to get non specified order: ", order)
			return null
