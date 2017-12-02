extends KinematicBody2D

onready var rake = get_node("rake")

var movement_intentions = Vector2()
var velocity = Vector2()
var speed = 300

func _ready():
	set_process_unhandled_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	velocity = movement_intentions * speed
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)


func set_movement_intention(dir, amount):
	get_tree().set_input_as_handled()
	if dir == "horiz":
		movement_intentions.x = amount
	elif dir == "vert":
		movement_intentions.y = amount
	else:
		print("bogus movement direction: " + str(dir))


func _unhandled_input(event):
	if event.is_action_pressed("rake"):
		get_tree().set_input_as_handled()
		rake.do_rake()
	
	if event.is_action_pressed("ui_left"):
		set_movement_intention("horiz", -1)
	elif event.is_action_pressed("ui_right"):
		set_movement_intention("horiz", 1)
	elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		set_movement_intention("horiz", 0)
	
	if event.is_action_pressed("ui_up"):
		set_movement_intention("vert", -1)
	elif event.is_action_pressed("ui_down"):
		set_movement_intention("vert", 1)
	elif event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		set_movement_intention("vert", 0)


