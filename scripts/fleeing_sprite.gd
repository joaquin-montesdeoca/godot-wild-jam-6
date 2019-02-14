extends Node2D

func duplicate_as_child(node : Node2D) -> void:
	var duplicated_node : Node2D = node.duplicate(0)
	duplicated_node.position = Vector2()
	global_position = node.global_position
	duplicated_node.visible = true
	add_child(duplicated_node)

func move_to_point(point : Vector2) -> void:
	var time = position.distance_to(point) * 0.25 / 200
	
	$Tween.interpolate_property(self, ":position", position, point, time, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_completed(object, key):
	queue_free()
