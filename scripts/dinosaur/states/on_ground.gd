extends "../states.gd"

func start() -> void:
	.start()
	
	timers["OnGround"].start()