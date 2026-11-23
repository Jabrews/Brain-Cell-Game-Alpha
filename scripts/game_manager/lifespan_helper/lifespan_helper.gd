extends Node


@export var prisoner_life_span_chance : Dictionary[int, int] = {
	2 : 15,
	3 : 50,
	4 : 25,
	5 : 10,
}

@export var breeding_life_span_chance : Dictionary[int, float] = {
	3 : 30,
	4 : 50,
	5 : 15,
}


func _get_lifespan(type : String) -> int:
	var lifespan_chance : Dictionary
	
	match type:
		"prisoner":
			lifespan_chance = prisoner_life_span_chance
		
		"breeding":
			lifespan_chance = breeding_life_span_chance
		
		_:
			return 0
	
	var ran_num := randf() * _get_total_chance(lifespan_chance)
	var current_chance := 0.0
	
	for lifespan in lifespan_chance:
		current_chance += lifespan_chance[lifespan]
		
		if ran_num <= current_chance:
			return lifespan
	
	return lifespan_chance.keys()[-1]


func _get_total_chance(chances : Dictionary) -> float:
	var total := 0.0
	
	for chance in chances.values():
		total += chance
	
	return total
