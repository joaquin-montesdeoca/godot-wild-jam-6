extends "../levels.gd"

enum TUTORIAL {
	CLICK_THE_CACTUS,
	PLANT_THE_CACTUS,
	WAIT_FOR_GROWTH,
	USE_THE_SCISSORS,
	WAIT_FOR_DINOSAUR,
	DINOSAUR_APPEARED,
	CACTUS_BROKEN,
	BROKEN_CACTUS_REMOVED,
	DEAD_DINOSAUR,
	SHORTCUT_FOR_CACTUS,
	SHORTCUT_FOR_SCISSORS,
	THATS_EVERYTHING,
	END_OF_TUTORIAL,
}
var tutorial_step : int
var have_dinosaurs_appeared : bool = false
var has_cactus_been_broken : bool = false

func start() -> void:
	.start()
	
	setup_connections()
	next_tutorial_step(TUTORIAL.CLICK_THE_CACTUS)

func setup_connections() -> void:
	game.connect("item_selected_changed", self, "_on_item_selected_changed")
	owner.connect("spawn_dinosaur", self, "_on_spawn_dinosaur")
	timers["Tutorial"].connect("timeout", self, "on_tutorial_timer_timeout")
	for slot in game.get_slots():
		slot.connect("plant", self, "_on_slot_plant")
		slot.connect("cut_cactus", self, "_on_slot_cut_cactus")
		slot.connect("cut_broken", self, "_on_slot_cut_broken")
		slot.connect("growth", self, "_on_slot_growth")
		slot.connect("broken", self, "_on_slot_broken")

func setup_waves() -> void:
	waves = [
		{"time" : 25.0, "number" : 1, "play_sound" : true},
	]

func next_tutorial_step(step : int):
	tutorial_step = step
	var text : String
	match step:
		TUTORIAL.CLICK_THE_CACTUS:
			text = "Click the cactus button or its shortcut."
		TUTORIAL.PLANT_THE_CACTUS:
			text = "Plant the cactus and wait for it to grow up."
		TUTORIAL.WAIT_FOR_GROWTH:
			text = ""
		TUTORIAL.USE_THE_SCISSORS:
			text = "The cactus has grown. Use the scissors to cut it."
		TUTORIAL.WAIT_FOR_DINOSAUR:
			text = "Use the cacti to create lines of defense."
		TUTORIAL.DINOSAUR_APPEARED:
			text = "A dinosaur has appeared. Block him with cacti."
		TUTORIAL.CACTUS_BROKEN:
			text = "Use the scissors to remove the broken cactus."
		TUTORIAL.BROKEN_CACTUS_REMOVED:
			text = ""
		TUTORIAL.DEAD_DINOSAUR:
			text = "Good. You have killed your first dinosaur."
			timers["Tutorial"].start()
		TUTORIAL.SHORTCUT_FOR_CACTUS:
			text = "Remember the shortcut for cactus is the Q key."
		TUTORIAL.SHORTCUT_FOR_SCISSORS:
			text = "And that the shortcut for scissors is the W key."
		TUTORIAL.THATS_EVERYTHING:
			text = "That is everything there is to know. Good luck!"
		TUTORIAL.END_OF_TUTORIAL:
			text = ""
			timers["Tutorial"].stop()
			owner.next_level()
	game.get_gui().set_tutorial_text(text)
			
func _on_item_selected_changed(item_selected):
	match tutorial_step:
		TUTORIAL.CLICK_THE_CACTUS:
			if item_selected == game.ITEM_SELECTED.CACTUS:
				next_tutorial_step(TUTORIAL.PLANT_THE_CACTUS)
		TUTORIAL.PLANT_THE_CACTUS:
			if item_selected != game.ITEM_SELECTED.CACTUS:
				if game.get_num_cacti() > 0:
					next_tutorial_step(TUTORIAL.CLICK_THE_CACTUS)

func _on_slot_plant():
	if tutorial_step == TUTORIAL.PLANT_THE_CACTUS:
		next_tutorial_step(TUTORIAL.WAIT_FOR_GROWTH)

func _on_slot_cut_cactus():
	if tutorial_step == TUTORIAL.USE_THE_SCISSORS:
		next_tutorial_step(TUTORIAL.WAIT_FOR_DINOSAUR)

func _on_slot_cut_broken():
	if tutorial_step == TUTORIAL.CACTUS_BROKEN:
		next_tutorial_step(TUTORIAL.BROKEN_CACTUS_REMOVED)

func _on_slot_growth():
	if tutorial_step == TUTORIAL.WAIT_FOR_GROWTH:
		next_tutorial_step(TUTORIAL.USE_THE_SCISSORS)

func _on_slot_broken():
	if not has_cactus_been_broken:
		has_cactus_been_broken = true
		next_tutorial_step(TUTORIAL.CACTUS_BROKEN)

func _on_spawn_dinosaur(dinosaur):
	if not have_dinosaurs_appeared:
		dinosaur.connect("dead", self, "_on_first_dinosaur_dead")
		have_dinosaurs_appeared = true
		next_tutorial_step(TUTORIAL.DINOSAUR_APPEARED)

func _on_first_dinosaur_dead():
	next_tutorial_step(TUTORIAL.DEAD_DINOSAUR)

func on_tutorial_timer_timeout():
	match tutorial_step:
		TUTORIAL.DEAD_DINOSAUR:
			next_tutorial_step(TUTORIAL.SHORTCUT_FOR_CACTUS)
		TUTORIAL.SHORTCUT_FOR_CACTUS:
			next_tutorial_step(TUTORIAL.SHORTCUT_FOR_SCISSORS)
		TUTORIAL.SHORTCUT_FOR_SCISSORS:
			next_tutorial_step(TUTORIAL.THATS_EVERYTHING)
		TUTORIAL.THATS_EVERYTHING:
			next_tutorial_step(TUTORIAL.END_OF_TUTORIAL)

func last_dinosaur_died() -> void:
	return
