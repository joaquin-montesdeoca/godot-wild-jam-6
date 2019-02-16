extends Node

var timers : Dictionary setget set_timers
var sounds : Dictionary setget set_sounds

func set_timers(value : Dictionary) -> void:
	timers = value

func set_sounds(value : Dictionary) -> void:
	sounds = value

func start() -> void:
	return

func last_wave_was_deployed() -> bool:
	return false

func waves_concluded() -> bool:
	return false

func last_dinosaur_died() -> void:
	return