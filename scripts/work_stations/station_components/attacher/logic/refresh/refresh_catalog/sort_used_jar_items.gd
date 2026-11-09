extends Node

func _find() -> Dictionary:
	var used: Array[JarItem] = []
	var unused: Array[JarItem] = []

	var jar_items: Array[JarItem] = GLJarComponentBus.jar_items
	var replacement_state: Dictionary[String, StatJarItem] = GLAttacherComponentBus.main_stat_replacement_state

	for jar_item: JarItem in jar_items:
		if jar_item in replacement_state.values():
			used.append(jar_item)
		# other cases here (such as bloodtype) (elif)
		else:
			unused.append(jar_item)

	return {
		"used": used,
		"unused": unused
	}
