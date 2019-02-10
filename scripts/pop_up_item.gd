extends Node2D

var rect_extends : = Vector2()
var motion : = Vector2()

enum STATUS {
	NOTHING,
	JUMPING,
	FLOATING
}
var status : int = STATUS.JUMPING setget set_status

onready var animation_steps : Dictionary = {}
onready var animation_current_steps : Dictionary = {}
onready var animation_loop : bool = false

func set_light_color(color : Color) -> void:
	$Light.modulate = color

func set_rect_extends(value : Vector2):
	rect_extends = value

func set_status(value : int):
	status = value

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