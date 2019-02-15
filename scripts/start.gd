extends Node2D

onready var game = get_node("/root/game")

enum FADE {EMPTY, IN, OUT}
var fade = FADE.EMPTY

func _ready():
	if not game.just_started():
		fade = FADE.OUT
		$ColorRect.show()
		$BlackTimer.start()

func _on_New_pressed():
	game.set_current_level(game.LEVEL.LEVEL1)
	fade = FADE.IN
	$ColorRect.show()
	$Tween.interpolate_property($ColorRect, ":modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Continue_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()

func _on_BlackTimer_timeout():
	$Tween.interpolate_property($ColorRect, ":modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_completed(object, key):
	if fade == FADE.OUT:
		$ColorRect.hide()
	elif fade == FADE.IN:
		get_tree().change_scene("res://scenes/battleground.tscn")
