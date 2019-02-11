extends Node

var normal_sprites : Dictionary setget set_normal_sprites
var broken_sprites : Dictionary setget set_broken_sprites
var timers : Dictionary setget set_timer
onready var game = get_node("/root/game")

func set_normal_sprites(value : Dictionary):
	normal_sprites = value

func set_broken_sprites(value : Dictionary):
	broken_sprites = value

func set_timer(value : Dictionary):
	timers = value

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
