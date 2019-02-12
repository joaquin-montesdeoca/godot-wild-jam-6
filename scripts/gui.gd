extends CanvasLayer
class_name GUI

onready var game = get_node("/root/game")

func _ready():
	game.set_gui(self)

func _input(event : InputEvent) -> void:
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