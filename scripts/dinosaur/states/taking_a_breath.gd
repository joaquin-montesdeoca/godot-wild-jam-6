extends "../states.gd"

func start() -> void:
	.start()
	
	timers["Idle"].start()
	sprites["Animation"].play("Idle")