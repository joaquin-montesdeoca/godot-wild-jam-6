extends "../states.gd"

func start() -> void:
	.start()
	
	sprites["Sprites"].modulate = Color("#ffffffff")
	sprites["Eye"].set_texture(owner.default_eye)
	sprites["Animation"].play("Running")

func setup_collision() -> void:
	collision.disabled = false

func damage(value : int) -> void:
	if value > 0:
		owner.energy -= value
		show_damage()
		if owner.energy <= 0:
			owner.set_status(owner.STATUS.DYING)
		else:
			owner.set_status(owner.STATUS.FALLING)

func show_damage() -> void:
	if owner.energy < 5:
		sprites["MiniCactus01"].show()
	if owner.energy < 4:
		sprites["MiniCactus02"].show()
	if owner.energy < 3:
		sprites["MiniCactus03"].show()
	if owner.energy < 2:
		sprites["MiniCactus04"].show()
	if owner.energy < 1:
		sprites["MiniCactus05"].show()

func cactus_collision(slot : Object) -> void:
	damage(slot.get_damage())
	slot.damage()

func process(delta : float) -> void:
	owner.position.x -= owner.SPEED * delta
