extends Node

var sprites : Dictionary setget set_sprites
var timers : Dictionary setget set_timer
onready var game = get_node("/root/game")

func set_sprites(value : Dictionary):
	sprites = value

func set_timer(value : Dictionary):
	timers = value

func start() -> void:
	for key in sprites:
		sprites[key].hide()

func mouse_clicked() -> void:
	return

func plant() -> void:
	return

func cut() -> void:
	return

func grow_up() -> void:
	return

func mouse_entered() -> void:
	return

func mouse_exited() -> void:
	return

func item_selected_changed() -> void:
	return
