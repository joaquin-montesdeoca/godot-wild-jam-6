extends Node2D

func add_dinosaur(dinosaur : Node2D) -> void:
	$Dinosaurs.add_child(dinosaur)

func get_dinosaurs_count() -> int:
	return $Dinosaurs.get_child_count()