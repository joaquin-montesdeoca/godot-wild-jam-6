extends Node2D

onready var game = get_node("/root/game")
onready var random = get_node("/root/random")
var waves : Array
var current_wave = 0
var dinosaur_scene = preload("res://scenes/dinosaur.tscn")

func _ready():
	game.set_battleground(self)
	game.set_num_cacti(1)
	game.update_cacti_gui()

	random.set_random_array([1,2,3,4,5])
	setup_waves()
	setup_timer(20.0)

func setup_waves() -> void:
	waves = [
		{"time" : 20.0, "number" : 1},
		{"time" : 20.0, "number" : 2},
		{"time" : 20.0, "number" : 4},
		{"time" : 20.0, "number" : 6},
		{"time" : 20.0, "number" : 9},
		{"time" : 20.0, "number" : 12},
	]

func setup_timer(time : float) -> void:
	$Timers/Waves.set_wait_time(time)
	$Timers/Waves.start()

func spawn_wave() -> void:
	var wave : Dictionary = waves[current_wave]
	
	for i in range(wave["number"]):
		spawn_dinosaur()
	
	setup_timer(wave["time"])
	
	current_wave += 1

func spawn_dinosaur() -> void:
	var line : int = random.draw_from_random_array()
	
	var dinosaur = dinosaur_scene.instance()
	dinosaur.scale = Vector2(0.35, 0.35)
	dinosaur.position.x = 1100 + random.get_rand_int(0, 500)
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
