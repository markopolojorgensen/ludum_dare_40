extends Node2D

onready var rake_sprite = get_node("rake_sprite")
onready var rake_timer = get_node("rake_timer")
onready var static_body = get_node("static_body")
onready var anims = get_node("anims")
onready var laser = get_node("laser")

var raking
var charging

func _ready():
	disable_collision()
	laser.connect("finished_firing", self, "laser_end")

func _process(delta):
	if charging:
		laser.charge(delta)

func do_charge():
	if not charging:
		set_process(true)
		charging = true
		print("charging ma lazer")
		rake_sprite.play("charge")

func release_charge():
	if not charging:
		return
	else:
		set_process(false)
		laser.fire()

func laser_end():
	rake_sprite.play("idle")
	charging = false

func do_rake():
	if not raking and not charging:
		raking = true
		enable_collision()
		rake_sprite.play("swing")
		anims.play("collision_swing") # maybe need to reset static body position after swing?
		
		rake_timer.start()
		yield(rake_timer, "timeout")
		
		rake_sprite.play("idle")
		disable_collision()
		raking = false

func disable_collision():
	static_body.set_collision_mask_bit(0, false)
	static_body.set_layer_mask_bit(0, false)
	pass

func enable_collision():
	static_body.set_collision_mask_bit(0, true)
	static_body.set_layer_mask_bit(0, true)

func is_rake():
	return true
