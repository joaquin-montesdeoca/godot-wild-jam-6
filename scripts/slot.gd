extends Area2D

enum STATUS {
	EMPTY = 0,
	CACTUS_1 = 1,
	CACTUS_2 = 2,
	CACTUS_3 = 3,
	CACTUS_4 = 4,
	CACTUS_5 = 5,
	BROKEN = 6,
}

onready var status : int = STATUS.EMPTY setget set_status
onready var states : Dictionary = {
	STATUS.EMPTY : $States/Empty,
	STATUS.CACTUS_1 : $States/Cactus1,
	STATUS.CACTUS_2 : $States/Cactus2,
	STATUS.CACTUS_3 : $States/Cactus3,
	STATUS.CACTUS_4 : $States/Cactus4,
	STATUS.CACTUS_5 : $States/Cactus5,
	STATUS.BROKEN : $States/Broken,
}

onready var game = get_node("/root/game")
onready var hovering : bool = false
onready var pop_up_item = preload("res://scenes/pop_up_item.tscn")
onready var pop_up_texture = preload("res://sprites/CactusPhase01.png")

func _ready() -> void:
	game.add_slot(self)
	setup_state_machine()

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton and hovering:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouse_clicked()

func setup_state_machine() -> void:
	setup_state($States)
	for key in states:
		setup_state(states[key])

func setup_state(state : Node) -> void:
	state.set_normal_sprites({
		STATUS.CACTUS_1 : $Sprites/Normal/CactusPhase01,
		STATUS.CACTUS_2 : $Sprites/Normal/CactusPhase02,
		STATUS.CACTUS_3 : $Sprites/Normal/CactusPhase03,
		STATUS.CACTUS_4 : $Sprites/Normal/CactusPhase04,
		STATUS.CACTUS_5 : $Sprites/Normal/CactusPhase05,
	})
	state.set_broken_sprites({
		STATUS.CACTUS_1 : $Sprites/Broken/CactusPhase01,
		STATUS.CACTUS_2 : $Sprites/Broken/CactusPhase02,
		STATUS.CACTUS_3 : $Sprites/Broken/CactusPhase03,
		STATUS.CACTUS_4 : $Sprites/Broken/CactusPhase04,
		STATUS.CACTUS_5 : $Sprites/Broken/CactusPhase05,
	})
	state.set_timer({
		"GrowUp" : $Timers/GrowUp,
	})

func set_status(value : int) -> void:
	var prev_status : int = status
	status = value
	
	states[status].start(prev_status)

func mouse_clicked() -> void:
	states[status].mouse_clicked()

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

func damage() -> void:
	states[status].damage()

func get_damage() -> int:
	return states[status].get_damage()

func set_collision_disabled(value : bool) -> void:
	$AreaCactus/Collision.disabled = value

func _on_Slot_mouse_entered():
	hovering = true
	states[status].mouse_entered()

func _on_Slot_mouse_exited():
	hovering = false
	states[status].mouse_exited()

func on_item_selected_changed(item_selected : int):
	states[status].item_selected_changed()

func on_collected_cactus():
	game.add_cacti(1)

func _on_GrowUp_timeout():
	states[status].grow_up()
