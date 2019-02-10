extends Area2D
tool

enum ITEM_TYPE {
	NOTHING = 0,
	CACTUS = 1,
	SCISSORS = 2,
}

export(Texture) var icon setget set_icon, get_icon
export(Vector2) var offset setget set_offset
export(bool) var label_enabled setget set_label_enabled
export(String) var label_text = "" setget set_label_text
export(ITEM_TYPE) var item_type = ITEM_TYPE.NOTHING setget set_item_type, get_item_type

onready var initial_scale : Vector2 = scale
onready var hovering : bool = false
onready var game = get_node("/root/game")

func set_icon(value : Texture) -> void:
	icon = value
	$Sprites/IconSprite.set_texture(icon)

func get_icon() -> Texture:
	return icon

func set_offset(value : Vector2) -> void:
	offset = value
	$Sprites/IconSprite.set_offset(offset)

func set_label_enabled(value : bool) -> void:
	label_enabled = value
	$Sprites/LabelSprite.visible = value

func set_label_text(value : String) -> void:
	label_text = value
	$Sprites/LabelSprite/CenterContainer/Label.set_text(label_text)

func set_item_type(value : int) -> void:
	item_type = value

func get_item_type() -> int:
	return item_type

func _input(event : InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if event is InputEventMouseButton and hovering:
		if event.button_index == BUTTON_LEFT and event.pressed:
			game.set_item_selected(item_type)

func _on_Button_mouse_entered():
	if Engine.is_editor_hint():
		return
	
	hovering = true

	var from : Vector2 = initial_scale
	var to : Vector2 = initial_scale * 1.2
	var time : float = 0.2
	
	if scale > from:
		var scale_2_to = scale.distance_to(to)
		var from_2_to = from.distance_to(to)
		time = scale_2_to * time / from_2_to # Regla de tres simple
		from = scale # Inicia desde la escala actual
	
	zoom_animation(from, to, time)

func _on_Button_mouse_exited():
	if Engine.is_editor_hint():
		return
	
	hovering = false
	
	var from : Vector2 = initial_scale * 1.2
	var to : Vector2 = initial_scale
	var time : float = 0.2
	if scale < from:
		var scale_2_to = scale.distance_to(to)
		var from_2_to = from.distance_to(to)
		time = scale_2_to * time / from_2_to # Regla de tres simple
		from = scale # Inicia desde la escala actual
	
	zoom_animation(from, to, time)

func zoom_animation(from : Vector2, to : Vector2, time : float) -> void:
	if Engine.is_editor_hint():
		return
	
	$Tween.stop(self, "scale")
	$Tween.interpolate_property(
		self,
		"scale",
		from,
		to,
		time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()
