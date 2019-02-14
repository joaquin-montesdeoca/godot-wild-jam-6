extends "../states.gd"

var current_sprite : Sprite

func start(prev_status : int) -> void:
	.start(prev_status)
	
	current_sprite = broken_sprites[prev_status]
	
	owner.set_collision_disabled(true)
	current_sprite.visible = true

func mouse_clicked() -> void:
	if game.get_item_selected() == game.ITEM_SELECTED.SCISSORS:
		cut()

func cut():
	game.get_gui().add_fleeing_sprite(current_sprite)
	owner.set_status(owner.STATUS.EMPTY)
