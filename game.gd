extends Node2D

# Fonts:
#   leaf counter is Godot's default label font
#   Game Start and Game Over banners are aseprite-rendered LiberationSansNarrow-Regular

var leaf_scene = preload("res://leaf/leaf.tscn")

var dims = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var wind = get_node("wind")

onready var ysort = get_node("YSort")

onready var game_over_banner = get_node("CanvasLayer/Panel/VBoxContainer/banner_panel/CenterContainer/Panel/game_over")
onready var game_start_banner = get_node("CanvasLayer/Panel/VBoxContainer/banner_panel/CenterContainer/Panel/game_start")

onready var leaf_spawn_timer = get_node("leaf_spawn_timer")
onready var respite_timer = get_node("respite_timer")
onready var leaf_counter = get_node("leaf_counter")
var total_leaves = 0
var in_respite = false
var game_lost = false

func _ready():
	get_node("leaf_spawn_timer").connect("timeout", self, "new_leaf")
	leaf_counter.connect("lose_game", self, "lose_game")
	
	get_node("CanvasLayer/AnimationPlayer").play("title_fade")
	
	set_process_unhandled_input(true)
	
	set_process(true)


func _process(delta):
	if total_leaves > 100 and not in_respite and not game_lost:
		in_respite = true
		leaf_spawn_timer.stop()
		print("starting respite")
		respite_timer.start()
		yield(respite_timer, "timeout")
		leaf_spawn_timer.start()
		total_leaves = 0
		in_respite = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

func new_leaf():
	var inst = leaf_scene.instance()
	inst.set_dims(dims)
	inst.set_wind(wind)
	ysort.add_child(inst)
	total_leaves += 1

func lose_game():
	if not game_lost:
		game_over_banner.show()
		game_lost = true
		in_respite = false
		leaf_spawn_timer.stop()
		leaf_spawn_timer.set_wait_time(0.05)
		leaf_spawn_timer.start()
		wind.lose_game()
