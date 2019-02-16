extends Node

var normal_sprites : Dictionary setget set_normal_sprites
var broken_sprites : Dictionary setget set_broken_sprites
var timers : Dictionary setget set_timers
var sounds : Dictionary setget set_sounds
onready var game = get_node("/root/game")
onready var random = get_node("/root/random")

func set_normal_sprites(value : Dictionary):
	normal_sprites = value

func set_broken_sprites(value : Dictionary):
	broken_sprites = value

func set_timers(value : Dictionary):
	timers = value

func set_sounds(value : Dictionary):
	sounds = value

func start(prev_status : int) -> void:
	for key in normal_sprites:
		normal_sprites[key].hide()
	
	for key in broken_sprites:
		broken_sprites[key].hide()

func mouse_clicked() -> void:
	return

func plant() -> void:
	return

func cut() -> void:
	return

func grow_up() -> void:
	return

func damage() -> void:
	return

func get_damage() -> int:
	return 0

func mouse_entered() -> void:
	return

func mouse_exited() -> void:
	return

func item_selected_changed() -> void:
	return

func play_broken_sound() -> void:
	var break_sound = "BreakinWood0" + str(random.get_rand_int(1, 3))
	sounds[break_sound].play()
