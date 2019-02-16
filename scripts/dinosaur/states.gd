extends Node

onready var random = get_node("/root/random")

var sprites : Dictionary setget set_sprites
var timers : Dictionary setget set_timers
var sounds : Dictionary setget set_sounds
var collision : CollisionShape2D setget set_collision

func set_sprites(value : Dictionary) -> void:
	sprites = value

func set_timers(value : Dictionary) -> void:
	timers = value

func set_sounds(value : Dictionary) -> void:
	sounds = value

func set_collision(value : CollisionShape2D) -> void:
	collision = value

func start() -> void:
	setup_collision()
	sounds["SandWalk"].stop()

func setup_collision() -> void:
	collision.call_deferred("set_disabled", true)

func damage(value : int) -> void:
	return

func process(delta : float) -> void:
	return

func cactus_collision(slot : Object) -> void:
	return

func animation_finished() -> void:
	return

func play_fall_sound() -> void:
	var fall_sound = "Fall0" + str(random.get_rand_int(1, 3))
	sounds[fall_sound].play()
