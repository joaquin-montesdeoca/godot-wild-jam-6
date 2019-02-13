extends Node2D

func _on_New_pressed():
	get_tree().change_scene("res://scenes/battleground.tscn")

func _on_Continue_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
