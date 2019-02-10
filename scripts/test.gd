extends Node2D

var pop_up_item = preload("res://scenes/pop_up_item.tscn")

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var pop_up = pop_up_item.instance()
			pop_up.set_position(event.position)
			pop_up.set_scale(Vector2(0.27, 0.27))
			pop_up.set_light_color(Color("#ffff00"))
			pop_up.set_rect_extends(Vector2(80, 100))
			add_child(pop_up)
			
			pop_up.jump()