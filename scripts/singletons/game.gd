extends Node

signal item_selected_changed

enum ITEM_SELECTED {
	NOTHING = 0,
	CACTUS = 1,
	SCISSORS = 2,
}

var gui : GUI setget set_gui
var battleground : Node2D setget set_battleground, get_battleground
var slots : Array
var item_selected : int = ITEM_SELECTED.NOTHING setget set_item_selected, get_item_selected
var num_cacti : int = 0 setget set_num_cacti, get_num_cacti

func set_gui(value : GUI) -> void:
	gui = value

func set_battleground(value : Node2D) -> void:
	battleground = value

func get_battleground() -> Node2D:
	return battleground

func add_slot(slot : Node2D):
	self.connect("item_selected_changed", slot, "on_item_selected_changed")
	slots.append(slot)

func set_item_selected(value : int) -> void:
	if value == ITEM_SELECTED.CACTUS and num_cacti == 0:
		return
	
	if item_selected == value:
		item_selected = ITEM_SELECTED.NOTHING
	else:
		item_selected = value
	
	gui.set_item_selected(item_selected)
	emit_signal("item_selected_changed", item_selected)

func get_item_selected() -> int:
	return item_selected

func set_num_cacti(value : int) -> bool:
	if value < 0:
		return false
	
	num_cacti = value
	gui.set_cacti_number(num_cacti)
	return true

func add_cacti(value : int) -> void:
	var result : int = num_cacti + value
	if result < 0:
		result = 0
		print("Error: se intentaron sacar más cactus de los que había")
	set_num_cacti(result)

func get_num_cacti() -> int:
	return num_cacti