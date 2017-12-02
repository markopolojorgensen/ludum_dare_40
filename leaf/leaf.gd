extends Node2D

onready var leaf_sprite = get_node("leaf_sprite")
onready var shadow_sprite = get_node("shadow_sprite")
onready var shadow_area = get_node("shadow_area")

# timer for how long to fly when getting raked
onready var rake_timer = get_node("rake_timer")

var wind

var getting_raked = false
var falling = true
var dest = Vector2()
var dims

var velocity = Vector2(0, 50)

func _ready():
	pick_dest()
	
	get_node("shadow_area").connect("body_enter", self, "shadow_body_enter")
	get_node("leaf_area").connect("body_enter", self, "leaf_body_enter")
	
	get_node("rake_timer").connect("timeout", self, "done_getting_raked")
	
	var start = dest
	start.y -= 400
	set_global_pos(start)
	
	set_fixed_process(true)

func do_setpos_move(actual_velocity, delta):
	var pos = get_pos()
	pos += actual_velocity * delta
	set_pos(pos)

func done_getting_raked():
	getting_raked = false
	falling = true
	velocity.y += 80

func _fixed_process(delta):
	dest.x = get_global_pos().x
	shadow_sprite.set_global_pos(dest)
	shadow_area.set_global_pos(dest)
	
	if getting_raked:
		velocity *= 0.9
		do_setpos_move(velocity, delta)
	
	if falling:
		do_fall(delta)
	
	# hack to trigger collision detection -_-
	set_pos(get_pos())

func do_fall(delta):
	# randomize velocity a bit
	velocity.x += (randi() % 7) - 3
	velocity.y += (randi() % 11) - 5
	
	# don't allow too much upward movement
	velocity.y = max(velocity.y, -10)
	
	# don't allow too much horizontal movement
	if velocity.x > 100:
		velocity.x -= 2
		# print(velocity.x)
	elif velocity.x < -100:
		velocity.x += 2
		# print(velocity.x)
	
	# wrap position if leaf blows off the screen
	# (wrapping trigger is not actually currently off the screen)
	if dest.x > (dims.x - 50):
		set_pos(get_pos() - Vector2(dims.x - 100, 0))
	elif dest.x < 50:
		set_pos(get_pos() + Vector2(dims.x - 100, 0))
	
	# add windspeed for this frame
	var actual_velocity = velocity + Vector2(wind.get_windspeed(), 0)
	
	do_setpos_move(actual_velocity, delta)
	
	if get_pos().y >= dest.y:
		falling = false


func pick_dest():
	randomize()
	
	dest.x = randi() % int(dims.x - 100) + 50
	dest.y = randi() % int(dims.y - 150) + 100
	
	# print("dest: " + str(dest))

func set_dims(new_dims):
	dims = new_dims

func set_wind(new_wind):
	wind = new_wind

func get_raked(rake):
	if falling:
		# rake only works on grounded leaves
		# print("  still falling tho")
		return
	if getting_raked:
		# print("  still getting raked tho")
		return
	
	# print("getting raked...")
	getting_raked = true
	velocity = Vector2(400, -100)
	rake_timer.start()
	
	# todo:  handle rake orientation

func leaf_body_enter(body):
	# print("leaf detected a body: " + str(body))
	if body.get_parent().has_method("is_rake") and body.get_parent().is_rake():
		# print("got raked!")
		get_raked(body.get_parent())

func shadow_body_enter(body):
	# print("shadow detected a body: " + str(body))
	pass

