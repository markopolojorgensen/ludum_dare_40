extends Node2D

onready var leaf_sprite = get_node("leaf_sprite")
onready var shadow_sprite = get_node("shadow_sprite")

var wind

var falling = true
var dest = Vector2()
var dims

var velocity = Vector2(0, 50)

func _ready():
	pick_dest()
	
	get_node("shadow_area").connect("body_enter", self, "shadow_body_enter")
	get_node("leaf_area").connect("body_enter", self, "leaf_body_enter")
	
	var start = dest
	start.y -= 400
	set_global_pos(start)
	
	set_fixed_process(true)


func _fixed_process(delta):
	dest.x = get_global_pos().x
	shadow_sprite.set_global_pos(dest)
	if falling:
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
		
		var pos = get_pos()
		pos += actual_velocity * delta
		set_pos(pos)
		
		if pos.y >= dest.y:
			falling = false


func pick_dest():
	randomize()
	
	dest.x = randi() % int(dims.x - 100) + 50
	dest.y = randi() % int(dims.y - 150) + 100
	
	print("dest: " + str(dest))

func set_dims(new_dims):
	dims = new_dims

func set_wind(new_wind):
	wind = new_wind

func leaf_body_enter(body):
	print("leaf detected a body: " + str(body))

func shadow_body_enter(body):
	print("shadow detected a body: " + str(body))

