extends CanvasLayer
class_name GUI

onready var game = get_node("/root/game")
var its_game_over = false

var fleeing_sprite_scene = preload("res://scenes/fleeing_sprite.tscn")

func _ready():
	game.set_gui(self)

func _input(event : InputEvent) -> void:
	if its_game_over:
		return
	
	if event is InputEventMouseMotion:
		$Cursor.position = event.position
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			game.set_item_selected(game.ITEM_SELECTED.NOTHING)
	else:
		if event.is_action_pressed("ui_cactus"):
			game.set_item_selected(game.ITEM_SELECTED.CACTUS)
		elif event.is_action_pressed("ui_scissors"):
			game.set_item_selected(game.ITEM_SELECTED.SCISSORS)

func set_cacti_number(value : int):
	$Buttons/Cactus.set_label_text(str(value))

func get_cactus_button_position() -> Vector2:
	return $Buttons/Cactus.global_position

func set_item_selected(item_selected : int) -> void:
	if item_selected == game.ITEM_SELECTED.NOTHING:
		$Cursor.texture = null
	elif item_selected == game.ITEM_SELECTED.CACTUS:
		$Cursor.texture = $Buttons/Cactus.get_icon()
		$Cursor.scale = Vector2(0.5, 0.5)
	elif item_selected == game.ITEM_SELECTED.SCISSORS:
		$Cursor.texture = $Buttons/Scissors.get_icon()
		$Cursor.scale = Vector2(0.5, 0.5)

func pre_game_over() -> void:
	its_game_over = true
	$FleeingSprites.visible = false
	$Buttons.visible = false
	$Cursor.visible = false

func game_over() -> void:
	$ColorRect.modulate = Color("#00ffffff")
	$ColorRect.show()
	$ColorRect/Container/Label.set_text("GAME OVER")
	$ColorRect/Container/Label.show()
	
	$Tween.interpolate_property($ColorRect, ":modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func add_fleeing_sprite(node : Node2D) -> void:
	var fleeing_sprite = fleeing_sprite_scene.instance()
	$FleeingSprites.add_child(fleeing_sprite)
	fleeing_sprite.duplicate_as_child(node)
	fleeing_sprite.move_to_point(Vector2(-50, 650))

func _on_tween_completed(object, key):
	if object is ColorRect:
		$GameOverTimer.start()
	elif object is Label:
		game.go_to_start()

func _on_GameOverTimer_timeout():
	$Tween.interpolate_property($ColorRect/Container/Label, ":modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
