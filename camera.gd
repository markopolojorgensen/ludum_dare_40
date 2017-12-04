extends Camera2D

var shaking = false

func _ready():
	add_to_group("laser_fire")

func laser_start():
	shaking = true
	set_process(true)

func laser_end():
	shaking = false
	set_process(false)

func _process(delta):
	if shaking:
		var offset = Vector2()
		offset.x = (randi() % 7) - 3
		offset.y = (randi() % 7) - 3
		set_offset(offset)
