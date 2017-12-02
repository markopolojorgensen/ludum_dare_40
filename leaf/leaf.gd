extends Node2D

onready var leaf_sprite = get_node("leaf_sprite")
onready var shadow_sprite = get_node("shadow_sprite")

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
		velocity.x += (randi() % 7) - 3
		velocity.y += (randi() % 11) - 5
		var pos = get_pos()
		pos += velocity * delta
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

func leaf_body_enter(body):
	print("leaf detected a body: " + str(body))

func shadow_body_enter(body):
	print("shadow detected a body: " + str(body))

