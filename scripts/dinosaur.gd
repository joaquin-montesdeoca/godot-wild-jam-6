extends Node2D
class_name Dinosaur

enum STATUS {
	RUNNING,
	FALLING,
	ON_GROUND,
	GETTING_UP,
	TAKING_A_BREATH,
	DYING
}

const EYE_PUPIL = preload("res://sprites/Dinosaur/EyePupil.png")

const SPEED = 50
var energy = 5
var status = STATUS.RUNNING
var default_eye = EYE_PUPIL

func _ready() -> void:
	set_status(STATUS.RUNNING)

func set_status(value : int) -> void:
	status = value
	if status == STATUS.RUNNING:
		$Sprites/Body/Eye.set_texture(default_eye)
		$Sprites/AnimationPlayer.play("Running")
	elif status == STATUS.FALLING:
		$Sprites/AnimationPlayer.play("Falling")
	elif status == STATUS.ON_GROUND:
		$Timers/OnGround.start()
	elif status == STATUS.GETTING_UP:
		$Sprites/AnimationPlayer.play("GettingUp")
	elif status == STATUS.TAKING_A_BREATH:
		$Timers/Idle.start()
		$Sprites/AnimationPlayer.play("Idle")

func damage(value : int) -> void:
	if status == STATUS.RUNNING:
		if value > 0:
			energy -= value
			if energy <= 0:
				energy = 0
			set_status(STATUS.FALLING)

func _physics_process(delta : float) -> void:
	if status == STATUS.RUNNING:
		position.x -= SPEED * delta
	elif status == STATUS.FALLING:
		position.x -= SPEED * delta

func _on_cactus_collision(area_id, area, area_shape, self_shape):
	area.owner.damage()
	set_status(STATUS.FALLING)

func _on_animation_finished(anim_name):
	if status == STATUS.FALLING:
		set_status(STATUS.ON_GROUND)
	elif status == STATUS.GETTING_UP:
		set_status(STATUS.TAKING_A_BREATH)

func _on_OnGround_timeout():
	set_status(STATUS.GETTING_UP)

func _on_Idle_timeout():
	set_status(STATUS.RUNNING)
