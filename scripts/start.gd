extends Node2D

onready var game = get_node("/root/game")

enum FADE {EMPTY, IN, OUT}
var fade = FADE.EMPTY

func _ready():
	print(game.get_last_played_level())
	if not game.just_started():
		fade = FADE.OUT
		$ColorRect.show()
		$BlackTimer.start()
		if game.get_last_played_level() > game.LEVEL.TUTORIAL:
			$Control/Menu/Continue.disabled = false
			$Control/Menu/Continue/Label.set("custom_colors/font_color", Color("#ffffff"))

func _on_New_pressed():
	go_to_level(game.LEVEL.TUTORIAL)

func _on_Continue_pressed():
	go_to_level(game.get_last_played_level())

func _on_Quit_pressed():
	get_tree().quit()

func go_to_level(level : int):
	game.set_current_level(level)
	fade = FADE.IN
	$ColorRect.show()
	$Tween.interpolate_property($ColorRect, ":modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_BlackTimer_timeout():
	$Tween.interpolate_property($ColorRect, ":modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_completed(object, key):
	if fade == FADE.OUT:
		$ColorRect.hide()
	elif fade == FADE.IN:
		get_tree().change_scene("res://scenes/battleground.tscn")
