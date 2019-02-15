extends Node2D

const END_OF_WAVES = -1

onready var game = get_node("/root/game")
onready var random = get_node("/root/random")
onready var lines = {
	1: $Game/Lines/Line01,
	2: $Game/Lines/Line02,
	3: $Game/Lines/Line03,
	4: $Game/Lines/Line04,
	5: $Game/Lines/Line05,
}
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
	dinosaur.position.x = 940 + 100 * spawn_number
	dinosaur.position.y = 40
	
	lines[line].add_child(dinosaur)

func _on_Waves_timeout():
	spawn_wave()

func _on_dinosaur_reached_goal(area_id, area, area_shape, self_shape):
	$GUI.pre_game_over()
	
	var toZoom : Vector2 = Vector2(0.25,0.25)
	var toPos : Vector2 = Vector2(128.0, area.owner.position.y)
	
	$Camera.zoom = toZoom
	$Camera.position = toPos

func _on_dinosaur_left_goal(area_id, area, area_shape, self_shape):
	$GUI.game_over()
