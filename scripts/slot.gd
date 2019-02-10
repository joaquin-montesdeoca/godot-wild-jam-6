extends Area2D

enum STATUS {
	EMPTY = 0,
	CACTUS_1 = 1,
	CACTUS_2 = 2,
	CACTUS_3 = 3,
	CACTUS_4 = 4,
	CACTUS_5 = 5,
}

onready var status : int = STATUS.EMPTY
onready var cacti : Dictionary = {
	STATUS.CACTUS_1 : $Sprites/CactusPhase01,
	STATUS.CACTUS_2 : $Sprites/CactusPhase02,
	STATUS.CACTUS_3 : $Sprites/CactusPhase03,
	STATUS.CACTUS_4 : $Sprites/CactusPhase04,
	STATUS.CACTUS_5 : $Sprites/CactusPhase05,
}

onready var game = get_node("/root/game")
onready var mouse_on_slot : bool = false

func _ready() -> void:
	game.add_slot(self)

func show_transparent_cactus():
	var cactus1 = cacti[STATUS.CACTUS_1]
	cactus1.modulate = Color(1, 1, 1, 0.5)
	cactus1.show()

func hide_transparent_cactus():
	var cactus1 = cacti[STATUS.CACTUS_1]
	cactus1.hide()
	cactus1.modulate = Color(1, 1, 1, 1)

func mouse_entered() -> void:
	if status == STATUS.EMPTY:
		if game.get_item_selected() == game.ITEM_SELECTED.CACTUS:
			show_transparent_cactus()
		else:
			hide_transparent_cactus()

func mouse_exited() -> void:
	if status == STATUS.EMPTY:
		hide_transparent_cactus()

func _on_Slot_mouse_entered():
	mouse_on_slot = true
	mouse_entered()

func _on_Slot_mouse_exited():
	mouse_on_slot = false
	mouse_exited()

func on_item_selected_changed(item_selected : int):
	if status == STATUS.EMPTY:
		hide_transparent_cactus()