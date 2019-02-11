extends "../cactus.gd"

func start_growing() -> void:
	timers["GrowUp"].start()

func damage() -> void:
	owner.pop_up_item()
	owner.set_status(owner.STATUS.BROKEN)
