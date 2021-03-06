extends "../states.gd"

func start() -> void:
	.start()
	
	sprites["Animation"].play("Falling")
	play_fall_sound()

func process(delta : float) -> void:
	owner.position.x -= owner.SPEED * delta

func animation_finished() -> void:
	owner.set_status(owner.STATUS.ON_GROUND)
