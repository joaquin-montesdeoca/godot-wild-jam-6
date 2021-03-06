extends "../levels.gd"

func setup_waves() -> void:
	waves = [
		{"time" : 20.0, "number" : 1, "play_sound" : true},
		{"time" : 15.0, "number" : 1, "play_sound" : false},
		{"time" : 15.0, "number" : 1, "play_sound" : false},
		{"time" : 15.0, "number" : 2, "play_sound" : true},
		{"time" : 15.0, "number" : 2, "play_sound" : false},
		{"time" : 20.0, "number" : 3, "play_sound" : true},
		{"time" : 22.5, "number" : 3, "play_sound" : false},
		{"time" : 25.0, "number" : 3, "play_sound" : false},
		{"time" : 35.0, "number" : 5, "play_sound" : true},
	]
