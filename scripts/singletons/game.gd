extends Node

signal item_selected_changed

enum ITEM_SELECTED {
	NOTHING = 0,
	CACTUS = 1,
	SCISSORS = 2,
}
enum LEVEL {
	TUTORIAL,
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
}
onready var level_titles : Dictionary = {
	LEVEL.TUTORIAL : "Tutorial",
	LEVEL.LEVEL_1 : "Level 1",
	LEVEL.LEVEL_2 : "Level 2",
	LEVEL.LEVEL_3 : "Level 3",
	LEVEL.LEVEL_4 : "Level 4",
	LEVEL.LEVEL_5 : "Level 5",
}
onready var current_level : int = LEVEL.TUTORIAL

var it_just_started : bool = true

var gui : GUI setget set_gui, get_gui
var battleground : Node2D setget set_battleground, get_battleground
var slots : Array
var item_selected : int = ITEM_SELECTED.NOTHING setget set_item_selected, get_item_selected
var num_cacti : int = 0 setget set_num_cacti, get_num_cacti

"""
Se llama a esta funcion para ver si el juego ya comenzo.
Al mismo tiempo, cuando se llama, se setea a false para marcar
que, la proxima vez que se llama, no acaba de comenzar.
"""
func just_started() -> bool:
	var it_just_started_value = it_just_started
	it_just_started = false
	
	return it_just_started_value

func set_gui(value : GUI) -> void:
	gui = value

func get_gui() -> GUI:
	return gui

func set_battleground(value : Node2D) -> void:
	battleground = value

func get_battleground() -> Node2D:
	return battleground

func get_level_title() -> String:
	return level_titles[current_level]

func go_to_start() -> void:
	battleground = null
	slots.clear()
	item_selected = ITEM_SELECTED.NOTHING
	num_cacti = 0
	
	get_tree().change_scene("res://scenes/start.tscn")

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
	if num_cacti == 0 and item_selected == ITEM_SELECTED.CACTUS:
		set_item_selected(ITEM_SELECTED.NOTHING)
	return true

func update_cacti_gui():
	gui.set_cacti_number(num_cacti)

func add_cacti(value : int) -> void:
	var result : int = num_cacti + value
	if result < 0:
		result = 0
		print("Error: se intentaron sacar más cactus de los que había")
	set_num_cacti(result)

func get_num_cacti() -> int:
	return num_cacti