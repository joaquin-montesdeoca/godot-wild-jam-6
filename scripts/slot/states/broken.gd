extends "../states.gd"

func start(prev_status : int) -> void:
	.start(prev_status)
		
	owner.set_collision_disabled(true)
	broken_sprites[prev_status].visible = true

func mouse_clicked() -> void:
	if game.get_item_selected() == game.ITEM_SELECTED.SCISSORS:
		cut()

func cut():
	owner.set_status(owner.STATUS.NOTHING)
