extends Node2D

func _ready():
	$ColorRect.show()

func _on_New_pressed():
	get_tree().change_scene("res://scenes/battleground.tscn")

func _on_Continue_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()

func _on_BlackTimer_timeout():
	$Tween.interpolate_property($ColorRect, ":modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	$ColorRect.hide()
