extends "../states.gd"

func start() -> void:
	.start()
	
	sprites["animation"].play("GettingUp")

func animation_finished() -> void:
	owner.set_status(owner.STATUS.TAKING_A_BREATH)
