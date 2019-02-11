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

onready var states : Dictionary = {
	STATUS.RUNNING : $States/Running,
	STATUS.FALLING : $States/Falling,
	STATUS.ON_GROUND : $States/OnGround,
	STATUS.GETTING_UP : $States/GettingUp,
	STATUS.TAKING_A_BREATH : $States/TakingABreath,
	STATUS.DYING : $States/Dying,
}

const EYE_PUPIL = preload("res://sprites/Dinosaur/EyePupil.png")

const SPEED = 50
var energy = 5
var status = STATUS.RUNNING
var default_eye = EYE_PUPIL

func _ready() -> void:
	setup_state_machine()
	
	set_status(STATUS.RUNNING)

func setup_state_machine() -> void:
	setup_state($States)
	for key in states:
		setup_state(states[key])

func setup_state(state : Node) -> void:
	state.set_sprites({
		"animation" : $Sprites/AnimationPlayer,
		"eye" : $Sprites/Body/Eye,
	})
	state.set_timers({
		"Idle" : $Timers/Idle,
		"OnGround" : $Timers/OnGround,
	})

func set_status(value : int) -> void:
	status = value
	states[status].start()

func damage(value : int) -> void:
	states[status].damage(value)

func _physics_process(delta : float) -> void:
	states[status].process(delta)

func _on_cactus_collision(area_id, area, area_shape, self_shape):
	area.owner.damage()
	set_status(STATUS.FALLING)

func _on_animation_finished(anim_name):
	states[status].animation_finished()

func _on_OnGround_timeout():
	set_status(STATUS.GETTING_UP)

func _on_Idle_timeout():
	set_status(STATUS.RUNNING)
