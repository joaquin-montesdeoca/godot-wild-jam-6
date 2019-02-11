extends Node2D

onready var game = get_node("/root/game")

func _ready():
	game.set_battleground(self)
	game.set_num_cacti(10)