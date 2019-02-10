extends Area2D

enum STATUS {
	EMPTY = 0,
	CACTUS_1 = 1,
	CACTUS_2 = 2,
	CACTUS_3 = 3,
	CACTUS_4 = 4,
	CACTUS_5 = 5,
}

onready var status : int = STATUS.EMPTY setget set_status
onready var cacti : Dictionary = {
	STATUS.CACTUS_1 : $Sprites/CactusPhase01,
	STATUS.CACTUS_2 : $Sprites/CactusPhase02,
	STATUS.CACTUS_3 : $Sprites/CactusPhase03,
	STATUS.CACTUS_4 : $Sprites/CactusPhase04,
	STATUS.CACTUS_5 : $Sprites/CactusPhase05,
}

onready var game = get_node("/root/game")
onready var hovering : bool = false
onready var pop_up_item = preload("res://scenes/pop_up_item.tscn")
onready var pop_up_texture = preload("res://sprites/CactusPhase01.png")

func _ready() -> void:
	game.add_slot(self)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton and hovering:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouse_clicked()

func set_status(value : int) -> void:
	status = value
	
	for i in cacti:
		cacti[i].visible = false
	
	if status != STATUS.EMPTY:
		cacti[status].modulate = Color(1, 1, 1, 1)
		cacti[status].visible = true
		if status != STATUS.CACTUS_5:
			$Timers/GrowUp.start()

func show_transparent_cactus():
	var cactus1 = cacti[STATUS.CACTUS_1]
	cactus1.modulate = Color(1, 1, 1, 0.5)
	cactus1.show()

func hide_transparent_cactus():
	var cactus1 = cacti[STATUS.CACTUS_1]
	cactus1.hide()
	cactus1.modulate = Color(1, 1, 1, 1)

func mouse_clicked() -> void:
	if status == STATUS.EMPTY:
		var item_selected : int = game.get_item_selected()
		
		if item_selected == game.ITEM_SELECTED.CACTUS:
			plant()
	else:
		var item_selected : int = game.get_item_selected()
		
		if item_selected == game.ITEM_SELECTED.SCISSORS:
			cut()

func plant() -> void:
	if status == STATUS.EMPTY:
		game.add_cacti(-1)
		set_status(STATUS.CACTUS_1)

func cut() -> void:
	if status != STATUS.EMPTY:
		var new_status : int
		new_status = status - 1
		
		set_status(new_status)
		pop_up_cactus()

func grow_up() -> void:
	if status != STATUS.EMPTY and status != STATUS.CACTUS_5:
		var new_status : int
		new_status = status + 1
		
		set_status(new_status)

func pop_up_cactus() -> void:
	var pop_up = pop_up_item.instance()
	pop_up.set_position(global_position + Vector2(40, 40))
	pop_up.set_scale(Vector2(0.27, 0.27))
	pop_up.set_light_color(Color("#ffff00"))
	pop_up.set_rect_extends(Vector2(80, 100))
	pop_up.set_item_texture(pop_up_texture)
	
	var go_to_point : Vector2 = game.get_gui().get_cactus_button_position()
	pop_up.on_click_go_to(go_to_point)
	
	game.get_gui().add_child(pop_up)
	
	pop_up.connect("collected", self, "on_collected_cactus")
	
	pop_up.jump()

func _on_Slot_mouse_entered():
	hovering = true
	if status == STATUS.EMPTY:
		if game.get_item_selected() == game.ITEM_SELECTED.CACTUS:
			show_transparent_cactus()
		else:
			hide_transparent_cactus()

func _on_Slot_mouse_exited():
	hovering = false
	if status == STATUS.EMPTY:
		hide_transparent_cactus()

func on_item_selected_changed(item_selected : int):
	if status == STATUS.EMPTY:
		hide_transparent_cactus()

func on_collected_cactus():
	game.add_cacti(1)

func _on_GrowUp_timeout():
	grow_up()
