extends "../cactus.gd"

func grow_up() -> void:
	owner.set_status(owner.status + 1)

func damage() -> void:
	owner.pop_up_item()
	owner.pop_up_item()
	owner.set_status(owner.STATUS.BROKEN)
