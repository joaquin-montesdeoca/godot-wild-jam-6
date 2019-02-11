extends "../states.gd"

func start(prev_status : int) -> void:
	.start(prev_status)
	
	owner.set_collision_disabled(false)
	normal_sprites[owner.status].modulate = Color(1, 1, 1, 1)
	normal_sprites[owner.status].visible = true
	start_growing()

func start_growing() -> void:
	return 

func mouse_clicked() -> void:
	if game.get_item_selected() == game.ITEM_SELECTED.SCISSORS:
		cut()

func cut():
	var new_status : int
	new_status = owner.status - 1
	
	owner.set_status(new_status)
	owner.pop_up_cactus()

func grow_up() -> void:
	owner.set_status(owner.status + 1)