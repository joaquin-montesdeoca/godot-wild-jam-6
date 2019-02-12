extends "../states.gd"

func start(prev_status : int) -> void:
	.start(prev_status)
		
	owner.set_collision_disabled(true)

func mouse_clicked() -> void:
	if game.get_item_selected() == game.ITEM_SELECTED.CACTUS:
		plant()

func plant() -> void:
	game.add_cacti(-1)
	game.update_cacti_gui()
	owner.set_status(owner.STATUS.CACTUS_1)

func mouse_entered() -> void:
	if game.get_item_selected() == game.ITEM_SELECTED.CACTUS:
		show_transparent_cactus()
	else:
		hide_transparent_cactus()

func mouse_exited() -> void:
	hide_transparent_cactus()

func item_selected_changed() -> void:
	hide_transparent_cactus()

func show_transparent_cactus() -> void:
	var cactus1 = normal_sprites[owner.STATUS.CACTUS_1]
	cactus1.modulate = Color(1, 1, 1, 0.5)
	cactus1.show()

func hide_transparent_cactus():
	var cactus1 = normal_sprites[owner.STATUS.CACTUS_1]
	cactus1.hide()
	cactus1.modulate = Color(1, 1, 1, 1)