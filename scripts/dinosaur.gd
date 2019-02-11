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