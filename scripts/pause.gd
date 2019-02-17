extends Control

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var paused = not get_tree().paused
		get_tree().paused = paused
		visible = paused