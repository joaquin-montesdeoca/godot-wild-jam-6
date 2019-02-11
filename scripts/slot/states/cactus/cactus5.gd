extends "../cactus.gd"

func grow_up() -> void:
	owner.set_status(owner.status + 1)

func damage() -> void:
	owner.pop_up_cactus()
	owner.pop_up_cactus()
	owner.set_status(owner.STATUS.BROKEN)

func get_damage() -> int:
	return 5
