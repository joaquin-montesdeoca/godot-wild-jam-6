extends "../states.gd"

func start() -> void:
	.start()
	
	sprites["eye"].set_texture(owner.default_eye)
	sprites["animation"].play("Running")

func damage(value : int) -> void:
	if value > 0:
		owner.energy -= value
		if owner.energy <= 0:
			owner.energy = 0
		owner.set_status(owner.STATUS.FALLING)

func process(delta : float) -> void:
	owner.position.x -= owner.SPEED * delta
