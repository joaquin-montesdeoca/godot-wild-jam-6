extends "../cactus.gd"

func grow_up() -> void:
	owner.set_status(owner.status + 1)