extends Node2D

var leaf_scene = preload("res://leaf/leaf.tscn")

var dims = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var wind = get_node("wind")

func _ready():
	get_node("leaf_spawn_timer").connect("timeout", self, "new_leaf")
	
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

func new_leaf():
	var inst = leaf_scene.instance()
	inst.set_dims(dims)
	inst.set_wind(wind)
	add_child(inst)

