extends Node

var sprites : Dictionary setget set_sprites
var timers : Dictionary setget set_timers
var collision : CollisionShape2D setget set_collision

func set_sprites(value : Dictionary) -> void:
	sprites = value

func set_timers(value : Dictionary) -> void:
	timers = value

func set_collision(value : CollisionShape2D) -> void:
	collision = value

func start() -> void:
	setup_collision()

func setup_collision() -> void:
	collision.disabled = true

func damage(value : int) -> void:
	return

func process(delta : float) -> void:
	return

func cactus_collision(slot : Object) -> void:
	return

func animation_finished() -> void:
	return
