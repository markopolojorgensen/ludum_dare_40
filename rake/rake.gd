extends Node2D

onready var rake_sprite = get_node("rake_sprite")
onready var rake_timer = get_node("rake_timer")
onready var static_body = get_node("static_body")

func do_rake():
	enable_collision()
	rake_sprite.play("swing")
	rake_timer.start()
	yield(rake_timer, "timeout")
	rake_sprite.play("idle")
	disable_collision()

func _ready():
	disable_collision()

func disable_collision():
	static_body.set_collision_mask_bit(0, false)
	static_body.set_layer_mask_bit(0, false)

func enable_collision():
	static_body.set_collision_mask_bit(0, true)
	static_body.set_layer_mask_bit(0, true)

