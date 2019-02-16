extends Node

var timers : Dictionary setget set_timers

func set_timers(value : Dictionary) -> void:
	timers = value

func start() -> void:
	return

func waves_concluded() -> bool:
	return false
