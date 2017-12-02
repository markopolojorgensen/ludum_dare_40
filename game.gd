extends Node2D

var leaf_scene = preload("res://leaf/leaf.tscn")

var dims = Vector2(Globals.get("display/width"), Globals.get("display/height"))


func _ready():
	new_leaf()
	get_node("leaf_spawn_timer").connect("timeout", self, "new_leaf")
	

func new_leaf():
	var inst = leaf_scene.instance()
	inst.set_dims(dims)
	add_child(inst)

