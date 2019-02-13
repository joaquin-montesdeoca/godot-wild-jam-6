extends Node2D

const END_OF_WAVES = -1

onready var game = get_node("/root/game")
onready var random = get_node("/root/random")
var waves : Array
var current_wave : int = 0
var dinosaur_scene = preload("res://scenes/dinosaur.tscn")

func _ready():
	game.set_battleground(self)
	game.set_num_cacti(1)
	game.update_cacti_gui()

	random.set_random_array([1,2,3,4,5])
	setup_waves()
	start_waves()

func setup_waves() -> void:
	waves = [
		{"time" : 20.0, "number" : 1},
		{"time" : 20.0, "number" : 1},
		{"time" : 15.0, "number" : 1},
		{"time" : 20.0, "number" : 2},
		{"time" : 20.0, "number" : 2},
	]

func start_waves() -> void:
	current_wave = 0
	setup_timer(waves[0]["time"])

func setup_timer(time : float) -> void:
	$Timers/Waves.set_wait_time(time)
	$Timers/Waves.start()

func spawn_wave() -> void:
	var wave : Dictionary = waves[current_wave]
	
	for i in range(wave["number"]):
		spawn_dinosaur(i)

	setup_next_wave()

func setup_next_wave() -> void:
	current_wave += 1
	if current_wave < waves.size():
		setup_timer(waves[current_wave]["time"])
	else:
		current_wave = END_OF_WAVES

func spawn_dinosaur(spawn_number : int) -> void:
	var line : int = random.draw_from_random_array()
	
	var dinosaur = dinosaur_scene.instance()
	dinosaur.scale = Vector2(0.35, 0.35)
	dinosaur.position.x = 1100 + 100 * spawn_number
	dinosaur.position.y = get_line_vertical_position(line)
	
	add_child(dinosaur)

func get_line_vertical_position(line : int) -> float:
	var vertical_position : float
	match line:
		1: vertical_position = $Game/Lines/Line01.position.y
		2: vertical_position = $Game/Lines/Line02.position.y
		3: vertical_position = $Game/Lines/Line03.position.y
		4: vertical_position = $Game/Lines/Line04.position.y
		_: vertical_position = $Game/Lines/Line05.position.y
	return vertical_position + 40

func _on_Waves_timeout():
	spawn_wave()
