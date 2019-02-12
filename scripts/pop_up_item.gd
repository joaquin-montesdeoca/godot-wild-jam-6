extends Node2D

signal clicked
signal collected

var rect_extends : = Vector2()
var motion : = Vector2()

enum STATUS {
	NOTHING,
	JUMPING,
	FLOATING,
	DISSAPEAR,
	GO_TO_POINT
}
var status : int = STATUS.JUMPING setget set_status

var hovering : bool = false

onready var on_click_action : Dictionary
onready var game = get_node("/root/game")

onready var animation_steps : Dictionary = {}
onready var animation_current_steps : Dictionary = {}
onready var animation_loop : bool = false

func set_light_color(color : Color) -> void:
	$Light.modulate = color

func set_rect_extends(value : Vector2):
	rect_extends = value

func set_status(value : int):
	status = value

func set_item_texture(texture : Texture) -> void:
	$Item.set_texture(texture)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton and hovering:
		if event.button_index == BUTTON_LEFT and event.pressed:
			click()

func click() -> void:
	if status == STATUS.FLOATING:
		if game.get_item_selected() == game.ITEM_SELECTED.NOTHING:
			if not on_click_action.has("action"):
				emit_signal("clicked")
				emit_signal("collected")
				queue_free()
			elif on_click_action["action"] == "dissapear":
				emit_signal("clicked")
				dissapear()
			elif on_click_action["action"] == "go_to":
				emit_signal("clicked")
				go_to_point(on_click_action["point"])

func on_click_dissapear() -> void:
	on_click_action = {"action" : "dissapear"}

func on_click_go_to(point : Vector2) -> void:
	on_click_action = {"action" : "go_to", "point" : point}

func jump() -> void:
	var start : = Vector2()
	var end : = Vector2(
		rand_range(-rect_extends.x / 2,rect_extends.x / 2),
		rect_extends.y / 2
	)
	
	set_status(STATUS.JUMPING)
	
	reset_animation()
	add_animation_step(":position:x", {
		"object" : self,
		"start" : position.x + start.x, "end" : position.x + end.x,
		"time" : 0.4, "trans" : Tween.TRANS_LINEAR, "ease" : Tween.EASE_IN
	})
	add_animation_step(":position:y", {
		"object" : self,
		"start" : position.y + start.y, "end" : position.y + end.y * -0.5,
		"time" : 0.1, "trans" : Tween.TRANS_QUAD, "ease" : Tween.EASE_OUT
	})
	add_animation_step(":position:y", {
		"object" : self,
		"start" : position.y + end.y * -0.5, "end" : position.y + end.y,
		"time" : 0.3, "trans" : Tween.TRANS_QUAD, "ease" : Tween.EASE_IN
	})
	start_animation()

func start_floating() -> void:
	var start : = Vector2(1.0, 1.0)
	var end : = Vector2(1.2, 1.2)
	
	set_status(STATUS.FLOATING)
	
	reset_animation()
	add_animation_step(":scale", {
		"object" : $Light, "start" : start, "end" : end,
		"time" : 1, "trans" : Tween.TRANS_QUAD, "ease" : Tween.EASE_IN_OUT
	})
	add_animation_step(":scale", {
		"object" : $Light, "start" : end, "end" : start,
		"time" : 1, "trans" : Tween.TRANS_QUAD, "ease" : Tween.EASE_IN_OUT
	})
	start_animation()

func dissapear() -> void:
	var start : = Color("#ffffffff")
	var end : = Color("#00ffffff")
	
	set_status(STATUS.DISSAPEAR)
	
	reset_animation()
	add_animation_step(":modulate", {
		"object" : self, "start" : start, "end" : end,
		"time" : 0.25, "trans" : Tween.TRANS_LINEAR, "ease" : Tween.EASE_IN
	})
	start_animation()

func go_to_point(point : Vector2) -> void:
	var start_pos : = global_position
	var end_pos : = point
	
	var start_scale : = scale
	var end_scale : = Vector2(0.4, 0.4)
	
	var start_color : = Color("#ffffffff")
	var end_color : = Color("#00ffffff")
	
	set_status(STATUS.GO_TO_POINT)
	
	reset_animation()
	add_animation_step(":global_position", {
		"object" : self, "start" : start_pos, "end" : end_pos,
		"time" : 0.5, "trans" : Tween.TRANS_CUBIC, "ease" : Tween.EASE_OUT
	})
	add_animation_step(":scale", {
		"object" : self, "start" : start_scale, "end" : end_scale,
		"time" : 0.5, "trans" : Tween.TRANS_CUBIC, "ease" : Tween.EASE_OUT
	})
	add_animation_step(":modulate", {
		"object" : self, "start" : start_color, "end" : start_color,
		"time" : 0.3, "trans" : Tween.TRANS_LINEAR, "ease" : Tween.EASE_IN
	})
	add_animation_step(":modulate", {
		"object" : self, "start" : start_color, "end" : end_color,
		"time" : 0.2, "trans" : Tween.TRANS_LINEAR, "ease" : Tween.EASE_IN
	})
	start_animation()

func add_animation_step(key : NodePath, step : Dictionary) -> void:
	if animation_steps.has(key):
		animation_steps[key].append(step)
	else:
		animation_current_steps[key] = 0
		animation_steps[key] = [step]

func reset_animation() -> void:
	animation_steps = {}
	animation_current_steps = {}

func start_animation() -> void:
	for prop in animation_steps:
		animation_current_steps[prop] = 0
		interpolate_prop(prop, animation_steps[prop][0])
	$Tween.start()

func interpolate_prop(key : NodePath, step : Dictionary) -> void:
	$Tween.interpolate_property(
		step["object"], key, step["start"], step["end"],
		step["time"], step["trans"], step["ease"]
	)

func get_next_animation_step(key : NodePath):
	if animation_steps.has(key) and animation_current_steps.has(key):
		animation_current_steps[key] += 1
		if animation_current_steps[key] < animation_steps[key].size():
			var num_step : int = animation_current_steps[key]
			var step : Dictionary = animation_steps[key][num_step]
			
			return step
		else:
			return null
	else:
		return null

func animation_ended() -> bool:
	for key in animation_steps:
		if animation_current_steps[key] < animation_steps[key].size():
			return false
	return true

func _on_Tween_tween_completed(object : Object, key : NodePath):
	var step = get_next_animation_step(key)
	if step != null:
		interpolate_prop(key, step)
	elif animation_ended():
		if status == STATUS.JUMPING:
			start_floating()
		elif status == STATUS.FLOATING:
			start_animation()
		elif status == STATUS.DISSAPEAR or status == STATUS.GO_TO_POINT:
			emit_signal("collected")
			queue_free()

func _on_ClickableArea_mouse_entered():
	hovering = true

func _on_ClickableArea_mouse_exited():
	hovering = false
