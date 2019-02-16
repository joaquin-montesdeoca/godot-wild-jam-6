extends Node

var timers : Dictionary setget set_timers
var sounds : Dictionary setget set_sounds

func set_timers(value : Dictionary) -> void:
	timers = value

func set_sounds(value : Dictionary) -> void:
	sounds = value

func start() -> void:
	return

func waves_concluded() -> bool:
	return false
