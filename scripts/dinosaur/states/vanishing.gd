extends "../states.gd"

func start() -> void:
	.start()
	
	sprites["Animation"].play("Vanishing")

func animation_finished() -> void:
	owner.die()
