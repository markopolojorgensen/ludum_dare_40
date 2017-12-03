extends KinematicBody2D

onready var rake = get_node("rake")
onready var charge_proc_timer = get_node("charge_proc_timer")
onready var movement = get_node("movement")

var velocity = Vector2()
var speed = 300
var slow_speed = 100

func _ready():
	set_process_unhandled_input(true)
	set_fixed_process(true)
	
	charge_proc_timer.connect("timeout", self, "charge_proc")

func _fixed_process(delta):
	if rake.is_charging() or rake.is_raking():
		velocity = movement.get_movement_intentions() * slow_speed
	else:
		velocity = movement.get_movement_intentions() * speed
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func charge_proc():
	rake.do_charge()

func _unhandled_input(event):
	if event.is_action_pressed("rake"):
		get_tree().set_input_as_handled()
		rake.do_rake()
		charge_proc_timer.start()
	elif event.is_action_released("rake"):
		# print("%s / %s" % [str(charge_proc_timer.get_time_left()), str(charge_proc_timer.get_wait_time())])
		charge_proc_timer.stop()
		rake.release_charge()

