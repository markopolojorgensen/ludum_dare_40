extends Node2D

signal finished_firing

var firing = false
var charge_amount = 0

onready var non_deformed_sprite = get_node("non_deformed")
onready var deformed_sprite = get_node("deformed")
onready var fire_timer = get_node("fire_timer")

onready var laser_body = get_node("laser_body")

func _ready():
	disable_collision()

func charge(delta):
	if not firing:
		charge_amount += delta * 5
		show()
		
		deformed_sprite.play("indicator")
		non_deformed_sprite.play("charge")
		
		var scale = deformed_sprite.get_scale()
		scale.y = charge_amount
		deformed_sprite.set_scale(scale)

func is_laser():
	return true

func size_laser():
	var height = deformed_sprite.get_sprite_frames().get_frame("indicator", 0).get_height()
	height *= deformed_sprite.get_scale().y
	height -= 10
	laser_body.get_shape(0).set_height(height)
	var pos = laser_body.get_pos()
	pos.y = height / 2
	laser_body.set_pos(pos)
	return height


func fire():
	if not firing:
		var height = size_laser()
		
		enable_collision()
		firing = true
		print("blam: %.2f" % height)
		non_deformed_sprite.play("ready")
		deformed_sprite.play("fire")
		
		fire_timer.start()
		yield(fire_timer, "timeout")
		
		
		charge_amount = 0
		hide()
		
		emit_signal("finished_firing")
		firing = false
		disable_collision()
		laser_body.get_shape(0).set_height(1)

func disable_collision():
	laser_body.set_collision_mask_bit(0, false)
	laser_body.set_layer_mask_bit(0, false)

func enable_collision():
	laser_body.set_collision_mask_bit(0, true)
	laser_body.set_layer_mask_bit(0, true)

