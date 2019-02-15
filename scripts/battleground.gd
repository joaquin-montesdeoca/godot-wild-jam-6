extends Node2D

onready var game = get_node("/root/game")

onready var lines = {
	1: $Game/Lines/Line01,
	2: $Game/Lines/Line02,
	3: $Game/Lines/Line03,
	4: $Game/Lines/Line04,
	5: $Game/Lines/Line05,
}
var dinosaur_scene = preload("res://scenes/dinosaur.tscn")
var levels : Dictionary
onready var current_level : int = game.get_current_level()

func _ready():
	game.set_battleground(self)
	game.set_num_cacti(1)
	game.update_cacti_gui()
	
	setup_levels()

func setup_levels() -> void:
	levels = {
		game.LEVEL.TUTORIAL : $Levels/Tutorial,
		game.LEVEL.LEVEL1 : $Levels/Level1,
		game.LEVEL.LEVEL2 : $Levels/Level2,
		game.LEVEL.LEVEL3 : $Levels/Level3,
		game.LEVEL.LEVEL4 : $Levels/Level4,
		game.LEVEL.LEVEL5 : $Levels/Level5,
	}
	
	for i in levels:
		levels[i].set_timers({
			"Waves" : $Timers/Waves
		})

func spawn_dinosaur(line_number : int, spawn_number : int) -> void:
	var dinosaur = dinosaur_scene.instance()
	dinosaur.scale = Vector2(0.35, 0.35)
	dinosaur.global_position.x = 1100 + 100 * spawn_number
	dinosaur.position.y = 40
	
	lines[line_number].add_child(dinosaur)

func _on_Waves_timeout():
	levels[current_level].spawn_wave()

func _on_dinosaur_reached_goal(area_id, area, area_shape, self_shape):
	$GUI.pre_game_over()
	
	var toZoom : Vector2 = Vector2(0.25,0.25)
	var toPos : Vector2 = Vector2(128.0, area.owner.global_position.y)
	
	$Camera.zoom = toZoom
	$Camera.position = toPos

func _on_dinosaur_left_goal(area_id, area, area_shape, self_shape):
	$GUI.game_over()

func _on_GUI_start_level():
	levels[current_level].start()
