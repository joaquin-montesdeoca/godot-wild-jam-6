extends "../levels.gd"

const END_OF_WAVES = -1

onready var random = get_node("/root/random")
var waves : Array
var current_wave : int = 0

func start() -> void:
	random.set_random_array([1,2,3,4,5])
	setup_waves()
	start_waves()

func setup_waves() -> void:
	return

func start_waves() -> void:
	current_wave = 0
	setup_timer(waves[0]["time"])

func setup_timer(time : float) -> void:
	timers["Waves"].set_wait_time(time)
	timers["Waves"].start()

func spawn_wave() -> void:
	var wave : Dictionary = waves[current_wave]
	
	var line_number : int
	for spawn_number in range(wave["number"]):
		line_number = random.draw_from_random_array()
		owner.spawn_dinosaur(line_number, spawn_number)

	setup_next_wave()

func setup_next_wave() -> void:
	current_wave += 1
	if current_wave < waves.size():
		setup_timer(waves[current_wave]["time"])
	else:
		current_wave = END_OF_WAVES
