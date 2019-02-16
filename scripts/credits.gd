extends Node2D

enum STATUS {FADE_IN, FADE_OUT}
var status : int

onready var game = get_node("/root/game")

func _ready():
	status = STATUS.FADE_IN
	$Control/ColorRect.show()
	$Tween.interpolate_property($Control/ColorRect, ":modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_completed(object, key):
	if status == STATUS.FADE_IN:
		$Timer.start()
	elif status == STATUS.FADE_OUT:
		game.go_to_start()

func _on_Timer_timeout():
	status = STATUS.FADE_OUT
	$Tween.interpolate_property($Control/ColorRect, ":modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
