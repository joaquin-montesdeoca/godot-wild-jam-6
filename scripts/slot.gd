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

func _on_Slot_mouse_entered():
	if status == STATUS.EMPTY:
		var cactus1 = cacti[STATUS.CACTUS_1]
		
		cactus1.modulate = Color(1, 1, 1, 0.5)
		cactus1.show()

func _on_Slot_mouse_exited():
	if status == STATUS.EMPTY:
		var cactus1 = cacti[STATUS.CACTUS_1]
		
		cactus1.hide()
		cactus1.modulate = Color(1, 1, 1, 1)
