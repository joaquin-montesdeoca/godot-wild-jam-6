extends "../states.gd"

func start() -> void:
	.start()
	
	timers["Dead"].start()