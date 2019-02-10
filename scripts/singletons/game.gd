extends Node

enum ITEM_SELECTED {
	NOTHING = 0,
	CACTUS = 1,
	SCISSORS = 2,
}

var item_selected : int = ITEM_SELECTED.NOTHING setget set_item_selected, get_item_selected
var gui : GUI setget set_gui

func set_gui(value : GUI) -> void:
	gui = value

func set_item_selected(value : int) -> void:
	if item_selected == value:
		item_selected = ITEM_SELECTED.NOTHING
	else:
		item_selected = value
	
	gui.set_item_selected(item_selected)

func get_item_selected() -> int:
	return item_selected