extends "../cactus.gd"

func start_growing() -> void:
	timers["GrowUp"].start()

func damage() -> void:
	owner.pop_up_cactus()
	owner.set_status(owner.STATUS.BROKEN)

func get_damage() -> int:
	return 4
