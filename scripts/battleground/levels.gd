extends Node

var lines : Dictionary setget set_lines
var timers : Dictionary setget set_timers
var sounds : Dictionary setget set_sounds

const END_OF_WAVES = -1

onready var random = get_node("/root/random")
var waves : Array
var current_wave : int = 0

func set_lines(value : Dictionary) -> void:
	lines = value

func set_timers(value : Dictionary) -> void:
	timers = value

func set_sounds(value : Dictionary) -> void:
	sounds = value

func start() -> void:
	random.set_random_array([1,2,3,4,5])
	setup_waves()
	start_waves()

func last_wave_was_deployed() -> bool:
	return (current_wave == END_OF_WAVES)

func waves_concluded() -> bool:
	return (owner.num_dinosaurs <= 0 and last_wave_was_deployed())

func last_dinosaur_died() -> void:
	owner.next_level()

func setup_waves() -> void:
	return

func start_waves() -> void:
	current_wave = 0
	setup_timer(waves[0]["time"])

func setup_timer(time : float) -> void:
	timers["Waves"].set_wait_time(time)
	timers["Waves"].start()

func spawn_wave() -> void:
	var wave : Dictionary = waves[current_wave]
	
	if wave["play_sound"]:
		play_growl_sound()
	
	var ordered_lines : Array = get_lines_ordered_by_dinosaurs()
	var line_number : int
	for spawn_number in range(wave["number"]):
		line_number = ordered_lines.pop_front()
		owner.spawn_dinosaur(line_number, spawn_number)
	
	setup_next_wave()

func get_lines_ordered_by_dinosaurs() -> Array:
	var quantities : Dictionary = {}
	var count : int = 0
	var counts : Array = []
	for line in lines:
		count = lines[line].get_dinosaurs_count()
		if quantities.has(count):
			quantities[count].append(line)
		else:
			counts.append(count)
			quantities[count] = [line]
	counts.sort()
	var ordered_lines : Array = []
	for i in counts:
		for line in order_array_randomly(quantities[i]):
			ordered_lines.append(line)
	
	return ordered_lines

func order_array_randomly(array : Array) -> Array:
	var new_array : Array = []
	random.set_random_array(array)
	for i in range(array.size()):
		new_array.append(random.draw_from_random_array())
	
	return new_array

func setup_next_wave() -> void:
	current_wave += 1
	if current_wave < waves.size():
		setup_timer(waves[current_wave]["time"])
	else:
		current_wave = END_OF_WAVES

func play_growl_sound() -> void:
	var growl_sound = "Growl0" + str(random.get_rand_int(1, 3))
	sounds[growl_sound].play()
