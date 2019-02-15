extends CanvasLayer
class_name GUI

signal start_level

onready var game = get_node("/root/game")
var its_game_over = false

enum TWEEN_ANIMATION {
	NOTHING,
	GAME_OVER,
	GAME_OVER_LABEL,
	LEVEL_START,
	TITLE_VANISH,
	LEVEL_FINISH,
}
var tween_animation : int = TWEEN_ANIMATION.NOTHING

var fleeing_sprite_scene = preload("res://scenes/fleeing_sprite.tscn")

func _ready():
	game.set_gui(self)
	
	$Center/Label.set_text(game.get_level_title())
	animate(TWEEN_ANIMATION.LEVEL_START)

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

func animate(animation : int) -> void:
	tween_animation = animation
	if tween_animation == TWEEN_ANIMATION.GAME_OVER:
		$Tween.interpolate_property($ColorRect, ":modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif tween_animation == TWEEN_ANIMATION.GAME_OVER_LABEL:
		$Tween.interpolate_property($ColorRect/Container/Label, ":modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif tween_animation == TWEEN_ANIMATION.LEVEL_START:
		$ColorRect.show()
		$Tween.interpolate_property($ColorRect, ":modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif tween_animation == TWEEN_ANIMATION.TITLE_VANISH:
		$Tween.interpolate_property($Center/Label, ":modulate:a", 1.0, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	elif tween_animation == TWEEN_ANIMATION.LEVEL_FINISH:
		$Tween.interpolate_property($ColorRect, ":modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

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

func set_title(value : String) -> void:
	$Center/Label.set_text(value)

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
	
	animate(TWEEN_ANIMATION.GAME_OVER)

func add_fleeing_sprite(node : Node2D) -> void:
	var fleeing_sprite = fleeing_sprite_scene.instance()
	$FleeingSprites.add_child(fleeing_sprite)
	fleeing_sprite.duplicate_as_child(node)
	fleeing_sprite.move_to_point(Vector2(-50, 650))

func _on_tween_completed(object, key):
	if tween_animation == TWEEN_ANIMATION.GAME_OVER:
		$Timers/GameOver.start()
	elif tween_animation == TWEEN_ANIMATION.GAME_OVER_LABEL:
		game.go_to_start()
	elif tween_animation == TWEEN_ANIMATION.LEVEL_START:
		$Timers/Title.start()
	elif tween_animation == TWEEN_ANIMATION.TITLE_VANISH:
		$ColorRect.hide()
		$Center.hide()
		emit_signal("start_level")
	tween_animation = TWEEN_ANIMATION.NOTHING

func _on_GameOver_timeout():
	animate(TWEEN_ANIMATION.GAME_OVER_LABEL)

func _on_Title_timeout():
	animate(TWEEN_ANIMATION.TITLE_VANISH)
