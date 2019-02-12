extends Node

var was_randomized : bool = false

var original_random_array : Array
var random_array : Array

func randomize_seed():
	if not was_randomized:
		randomize()
		was_randomized = true

func set_random_array(value : Array) -> void:
	randomize_seed()
	
	random_array = value
	original_random_array = value.duplicate()

func reset_random_array() -> void:
	random_array = original_random_array.duplicate()

func draw_from_random_array():
	if random_array.size() == 0:
		if original_random_array.size() > 0:
			random_array = original_random_array.duplicate()
		else:
			return null
	
	var position : int = get_rand_int(0, random_array.size() - 1)
	var value = random_array[position]
	random_array.remove(position)
	
	return value

func get_rand_int(from : int, to : int) -> int:
	randomize_seed()
	
	if from > to:
		var aux = from
		from = to
		to = aux
	elif from == to:
		return from
	
	return randi() % (to - from + 1) + from
